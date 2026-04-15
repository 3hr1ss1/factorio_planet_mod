local sandstorm = {}

local UPDATE_INTERVAL_TICKS = 10
local SECONDS_PER_TICK = 1 / 60
local SPAWN_SEARCH_RADIUS = 256
local SPAWN_ATTEMPTS = 48

local function get_global_setting(name)
  local setting = settings.global[name]
  if setting == nil then
    return nil
  end
  return setting.value
end

local function random_float(rng, min_value, max_value)
  return min_value + (max_value - min_value) * rng()
end

local function random_int(rng, min_value, max_value)
  if max_value <= min_value then
    return min_value
  end
  return math.floor(random_float(rng, min_value, max_value + 1))
end

local function is_desert_tile(tile_name)
  return string.find(tile_name, "sand", 1, true) ~= nil
end

local function has_player_on_surface(surface)
  local connected_players = game.connected_players
  for _, player in pairs(connected_players) do
    if player.valid and player.character and player.surface.index == surface.index then
      return true
    end
  end
  return false
end

local function pick_surface_for_spawn(rng)
  local candidates = {}
  for _, surface in pairs(game.surfaces) do
    if surface.valid and not surface.platform and has_player_on_surface(surface) then
      candidates[#candidates + 1] = surface
    end
  end

  if #candidates == 0 then
    return nil
  end

  return candidates[random_int(rng, 1, #candidates)]
end

local function get_surface_players(surface)
  local players = {}
  for _, player in pairs(game.connected_players) do
    if player.valid and player.character and player.surface.index == surface.index then
      players[#players + 1] = player
    end
  end
  return players
end

local function sample_desert_position(rng, surface)
  local players = get_surface_players(surface)
  if #players == 0 then
    return nil
  end

  for _ = 1, SPAWN_ATTEMPTS do
    local anchor = players[random_int(rng, 1, #players)].position
    local angle = random_float(rng, 0, math.pi * 2)
    local distance = random_float(rng, 24, SPAWN_SEARCH_RADIUS)
    local position = {
      x = anchor.x + math.cos(angle) * distance,
      y = anchor.y + math.sin(angle) * distance
    }

    local tile = surface.get_tile(position)
    if tile.valid and is_desert_tile(tile.name) then
      return position
    end
  end

  return nil
end

local function schedule_next_spawn()
  local rng = global.sandstorm.rng
  local min_minutes = get_global_setting("mithras-sandstorm-spawn-min-minutes") or 15
  local max_minutes = get_global_setting("mithras-sandstorm-spawn-max-minutes") or 45
  if max_minutes < min_minutes then
    max_minutes = min_minutes
  end

  local delay_minutes = random_float(rng, min_minutes, max_minutes)
  global.sandstorm.next_spawn_tick = game.tick + math.floor(delay_minutes * 60 * 60)
end

local function make_storm(rng, surface, position)
  local min_size = get_global_setting("mithras-sandstorm-size-min-tiles") or 10
  local max_size = get_global_setting("mithras-sandstorm-size-max-tiles") or 100
  if max_size < min_size then
    max_size = min_size
  end

  local min_duration = get_global_setting("mithras-sandstorm-duration-min-seconds") or 60
  local max_duration = get_global_setting("mithras-sandstorm-duration-max-seconds") or 300
  if max_duration < min_duration then
    max_duration = min_duration
  end

  local min_speed = get_global_setting("mithras-sandstorm-speed-min") or 0.1
  local max_speed = get_global_setting("mithras-sandstorm-speed-max") or 0.3
  if max_speed < min_speed then
    max_speed = min_speed
  end

  local direction_angle = random_float(rng, 0, math.pi * 2)
  local speed_tiles_per_second = random_float(rng, min_speed, max_speed)
  local base_radius = random_float(rng, min_size, max_size)
  local aspect = random_float(rng, 0.7, 1.3)
  local radius_x = base_radius * aspect
  local radius_y = base_radius / aspect
  local duration_seconds = random_float(rng, min_duration, max_duration)

  global.sandstorm.id_counter = global.sandstorm.id_counter + 1
  return {
    id = global.sandstorm.id_counter,
    surface_index = surface.index,
    position = {x = position.x, y = position.y},
    direction = {x = math.cos(direction_angle), y = math.sin(direction_angle)},
    speed_tiles_per_second = speed_tiles_per_second,
    radius_x = radius_x,
    radius_y = radius_y,
    created_tick = game.tick,
    expire_tick = game.tick + math.floor(duration_seconds * 60)
  }
end

local function try_spawn_storm()
  local rng = global.sandstorm.rng
  local surface = pick_surface_for_spawn(rng)
  if surface == nil then
    return
  end

  local position = sample_desert_position(rng, surface)
  if position == nil then
    return
  end

  local storm = make_storm(rng, surface, position)
  table.insert(global.sandstorm.active_storms, storm)
end

local function update_storm_movement(storm)
  local delta = storm.speed_tiles_per_second * SECONDS_PER_TICK * UPDATE_INTERVAL_TICKS
  storm.position.x = storm.position.x + storm.direction.x * delta
  storm.position.y = storm.position.y + storm.direction.y * delta
end

local function remove_expired_storms()
  for index = #global.sandstorm.active_storms, 1, -1 do
    local storm = global.sandstorm.active_storms[index]
    local surface = game.surfaces[storm.surface_index]
    if game.tick >= storm.expire_tick or surface == nil or not surface.valid then
      table.remove(global.sandstorm.active_storms, index)
    end
  end
end

local function ensure_state()
  global.sandstorm = global.sandstorm or {}
  global.sandstorm.active_storms = global.sandstorm.active_storms or {}
  global.sandstorm.id_counter = global.sandstorm.id_counter or 0
  global.sandstorm.rng = global.sandstorm.rng or game.create_random_generator()
  if global.sandstorm.next_spawn_tick == nil then
    schedule_next_spawn()
  end
end

function sandstorm.on_init()
  ensure_state()
end

function sandstorm.on_configuration_changed()
  ensure_state()
end

function sandstorm.on_runtime_mod_setting_changed(event)
  local name = event.setting
  if string.find(name, "mithras-sandstorm-", 1, true) then
    schedule_next_spawn()
  end
end

function sandstorm.on_update()
  ensure_state()

  remove_expired_storms()
  for _, storm in pairs(global.sandstorm.active_storms) do
    update_storm_movement(storm)
  end

  if game.tick >= global.sandstorm.next_spawn_tick then
    try_spawn_storm()
    schedule_next_spawn()
  end
end

function sandstorm.get_update_interval()
  return UPDATE_INTERVAL_TICKS
end

return sandstorm
