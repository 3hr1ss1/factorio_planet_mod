local sandstorm = {}

local UPDATE_INTERVAL_TICKS = 2
local SECONDS_PER_TICK = 1 / 60
local SPAWN_SEARCH_RADIUS = 256
local SPAWN_ATTEMPTS = 48
local PARTICLES_PER_UPDATE = 16
local PERSIST = storage
local MOD_SCRIPT_NAME = script.mod_name

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

local function clamp(value, min_value, max_value)
  if value < min_value then
    return min_value
  end
  if value > max_value then
    return max_value
  end
  return value
end

local function is_desert_tile(tile_name)
  return string.find(tile_name, "sand", 1, true) ~= nil
    or string.find(tile_name, "dunes", 1, true) ~= nil
    or string.find(tile_name, "dust", 1, true) ~= nil
end

local function has_player_on_surface(surface)
  local connected_players = game.connected_players
  for _, player in pairs(connected_players) do
    if player.valid and player.surface.index == surface.index then
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
    if player.valid and player.surface.index == surface.index then
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

local function sample_desert_position_near(rng, surface, anchor, max_radius)
  local anchor_tile = surface.get_tile(anchor)
  if anchor_tile.valid and is_desert_tile(anchor_tile.name) then
    return {x = anchor.x, y = anchor.y}
  end

  for _ = 1, SPAWN_ATTEMPTS do
    local angle = random_float(rng, 0, math.pi * 2)
    local distance = random_float(rng, 2, max_radius)
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
  local rng = PERSIST.sandstorm.rng
  local min_minutes = get_global_setting("mithras-sandstorm-spawn-min-minutes") or 15
  local max_minutes = get_global_setting("mithras-sandstorm-spawn-max-minutes") or 45
  if max_minutes < min_minutes then
    max_minutes = min_minutes
  end

  local delay_minutes = random_float(rng, min_minutes, max_minutes)
  PERSIST.sandstorm.next_spawn_tick = game.tick + math.floor(delay_minutes * 60 * 60)
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

  local min_speed = get_global_setting("mithras-sandstorm-speed-min") or 1.0
  local max_speed = get_global_setting("mithras-sandstorm-speed-max") or 5.0
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

  PERSIST.sandstorm.id_counter = PERSIST.sandstorm.id_counter + 1
  return {
    id = PERSIST.sandstorm.id_counter,
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

local function replace_with_single_active_storm(storm)
  PERSIST.sandstorm.active_storms = {storm}
end

local function try_spawn_storm()
  local rng = PERSIST.sandstorm.rng
  local surface = pick_surface_for_spawn(rng)
  if surface == nil then
    return
  end

  local position = sample_desert_position(rng, surface)
  if position == nil then
    return
  end

  local storm = make_storm(rng, surface, position)
  replace_with_single_active_storm(storm)
end

local function try_spawn_storm_on_surface(rng, surface, anchor_position)
  if surface == nil or not surface.valid then
    return false
  end

  local position = nil
  if anchor_position ~= nil then
    position = sample_desert_position_near(rng, surface, anchor_position, 40)
  end
  if position == nil then
    position = sample_desert_position(rng, surface)
  end

  if position == nil then
    return false
  end

  local storm = make_storm(rng, surface, position)
  replace_with_single_active_storm(storm)
  return true
end

local function update_storm_movement(storm)
  local delta = storm.speed_tiles_per_second * SECONDS_PER_TICK * UPDATE_INTERVAL_TICKS
  storm.position.x = storm.position.x + storm.direction.x * delta
  storm.position.y = storm.position.y + storm.direction.y * delta
end

local function point_in_storm(storm, position)
  local dx = position.x - storm.position.x
  local dy = position.y - storm.position.y
  local norm_x = dx / storm.radius_x
  local norm_y = dy / storm.radius_y
  return (norm_x * norm_x + norm_y * norm_y) <= 1
end

local function emit_storm_particles(rng, storm, surface)
  for _ = 1, PARTICLES_PER_UPDATE do
    local angle = random_float(rng, 0, math.pi * 2)
    local edge_bias = math.sqrt(random_float(rng, 0.05, 1))
    local px = storm.position.x + math.cos(angle) * storm.radius_x * edge_bias
    local py = storm.position.y + math.sin(angle) * storm.radius_y * edge_bias
    local position = {x = px, y = py}
    local movement = {
      x = storm.direction.x * 0.006 + random_float(rng, -0.002, 0.002),
      y = storm.direction.y * 0.006 + random_float(rng, -0.002, 0.002),
      z = 0.008
    }

    pcall(surface.create_particle, surface, {
      name = "stone-particle",
      position = position,
      movement = movement,
      vertical_speed = 0.01,
      height = random_float(rng, 0.1, 0.8),
      frame_speed = 0.8
    })

    if random_float(rng, 0, 1) < 0.25 then
      surface.create_trivial_smoke({
        name = "smoke-fast",
        position = position
      })
    end
  end
end

local function draw_storm_outline(storm, surface)
  local storm_radius = math.max(storm.radius_x, storm.radius_y)
  rendering.draw_circle({
    color = {r = 0.88, g = 0.72, b = 0.4, a = 0.22},
    radius = storm_radius,
    filled = true,
    target = storm.position,
    surface = surface,
    draw_on_ground = true,
    width = 1,
    time_to_live = UPDATE_INTERVAL_TICKS + 1
  })

  rendering.draw_circle({
    color = {r = 0.88, g = 0.72, b = 0.4, a = 0.08},
    radius = storm_radius,
    filled = true,
    target = storm.position,
    surface = surface,
    draw_on_ground = false,
    width = 1,
    time_to_live = UPDATE_INTERVAL_TICKS + 1
  })

  rendering.draw_circle({
    color = {r = 0.93, g = 0.77, b = 0.45, a = 0.85},
    radius = storm_radius,
    filled = false,
    target = storm.position,
    surface = surface,
    draw_on_ground = true,
    width = 2,
    time_to_live = UPDATE_INTERVAL_TICKS + 1
  })
end

local function remove_expired_storms()
  for index = #PERSIST.sandstorm.active_storms, 1, -1 do
    local storm = PERSIST.sandstorm.active_storms[index]
    local surface = game.surfaces[storm.surface_index]
    if game.tick >= storm.expire_tick or surface == nil or not surface.valid then
      table.remove(PERSIST.sandstorm.active_storms, index)
    end
  end
end

local function run_one_time_visual_cleanup()
  if PERSIST.sandstorm.did_global_visual_cleanup then
    return
  end

  -- Remove any stale rendering objects left from older script versions.
  pcall(rendering.clear, MOD_SCRIPT_NAME)
  PERSIST.sandstorm.did_global_visual_cleanup = true
end

local function ensure_state()
  PERSIST.sandstorm = PERSIST.sandstorm or {}
  PERSIST.sandstorm.active_storms = PERSIST.sandstorm.active_storms or {}
  PERSIST.sandstorm.id_counter = PERSIST.sandstorm.id_counter or 0
  PERSIST.sandstorm.rng = PERSIST.sandstorm.rng or game.create_random_generator()
  PERSIST.sandstorm.did_global_visual_cleanup = PERSIST.sandstorm.did_global_visual_cleanup or false
  if PERSIST.sandstorm.next_spawn_tick == nil then
    schedule_next_spawn()
  end
end

function sandstorm.on_init()
  ensure_state()
end

function sandstorm.on_configuration_changed()
  ensure_state()
  -- Force one-time visual cleanup again after migrations/updates.
  PERSIST.sandstorm.did_global_visual_cleanup = false
end

function sandstorm.on_runtime_mod_setting_changed(event)
  local name = event.setting
  if string.find(name, "mithras-sandstorm-", 1, true) then
    schedule_next_spawn()
  end
end

function sandstorm.on_update()
  ensure_state()
  run_one_time_visual_cleanup()

  -- Ensure stale frames are removed; only this update's storm visuals remain.
  pcall(rendering.clear, MOD_SCRIPT_NAME)

  remove_expired_storms()
  local rng = PERSIST.sandstorm.rng
  for _, storm in pairs(PERSIST.sandstorm.active_storms) do
    update_storm_movement(storm)
    local surface = game.surfaces[storm.surface_index]
    if surface and surface.valid then
      draw_storm_outline(storm, surface)
      emit_storm_particles(rng, storm, surface)
    end
  end

  if game.tick >= PERSIST.sandstorm.next_spawn_tick then
    try_spawn_storm()
    schedule_next_spawn()
  end
end

function sandstorm.force_spawn_for_player(player)
  ensure_state()
  if player == nil or not player.valid then
    return false, "Player is not valid."
  end

  local rng = PERSIST.sandstorm.rng
  local ok = try_spawn_storm_on_surface(rng, player.surface, player.position)
  if ok then
    local storm = PERSIST.sandstorm.active_storms[#PERSIST.sandstorm.active_storms]
    local dx = storm.position.x - player.position.x
    local dy = storm.position.y - player.position.y
    local distance = math.floor(math.sqrt(dx * dx + dy * dy))
    local message = string.format(
      "Sandstorm spawned at (%.1f, %.1f), distance %d, radius %.1f.",
      storm.position.x,
      storm.position.y,
      distance,
      math.max(storm.radius_x, storm.radius_y)
    )
    return true, message
  end
  return false, "No valid desert tile found near player."
end

function sandstorm.get_update_interval()
  return UPDATE_INTERVAL_TICKS
end

return sandstorm
