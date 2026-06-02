local sandstorm = {}

local UPDATE_INTERVAL_TICKS = 2
local SECONDS_PER_TICK = 1 / 60
local SPAWN_SEARCH_RADIUS = 256
local SPAWN_ATTEMPTS = 128
local BUILDING_ANCHOR_SEARCH_RADIUS = 96
local MAX_BUILDING_ANCHORS_PER_PLAYER = 24
local PARTICLES_PER_UPDATE = 16
local CHUNK_SIZE = 32
local STORM_DAMAGE_AMOUNT = 3
local STORM_DAMAGE_INTERVAL_TICKS = 60
local STORM_DAMAGE_TYPE = "physical"
local STORM_DAMAGE_FORCE_NAME = "neutral"
local STORM_BITER_SPAWN_INTERVAL_TICKS = 180
local STORM_BITERS_PER_SPAWN = 3
local STORM_BITER_BY_EVOLUTION = {
  {threshold = 0.9, name = "behemoth-biter"},
  {threshold = 0.6, name = "large-biter"},
  {threshold = 0.3, name = "medium-biter"},
  {threshold = 0.0, name = "small-biter"},
}
local STORM_MITHRAS_GRACE_MIN_HOURS = 1
local STORM_MITHRAS_GRACE_MAX_HOURS = 2
local TICKS_PER_HOUR = 216000  -- 60 ticks/s * 60 s/min * 60 min/h
local PERSIST = storage
local MOD_SCRIPT_NAME = script.mod_name
local TWO_PI = math.pi * 2

-- Module-level flags reset on save-load; re-set by ensure_state / run_one_time_visual_cleanup.
local _state_ready = false
local _visual_cleanup_done = false
local _mithras_grace_set = false

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

local function is_desert_tile(surface, tile_name)
  if tile_name == nil then
    return false
  end

  -- On Mithras we prefer all custom surface tiles and fulgoran desert fallbacks.
  if surface ~= nil and surface.valid and surface.name == "mithras" then
    if string.find(tile_name, "mithras-", 1, true) == 1 then
      return true
    end
    if string.find(tile_name, "fulgoran-", 1, true) == 1 then
      return true
    end
  end

  return string.find(tile_name, "desert", 1, true) ~= nil
    or string.find(tile_name, "sand", 1, true) ~= nil
    or string.find(tile_name, "dunes", 1, true) ~= nil
    or string.find(tile_name, "dust", 1, true) ~= nil
    or string.find(tile_name, "rock", 1, true) ~= nil
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

local function add_anchor_position(anchors, seen, position)
  local key = string.format("%d:%d", math.floor(position.x), math.floor(position.y))
  if seen[key] then
    return
  end
  seen[key] = true
  anchors[#anchors + 1] = {x = position.x, y = position.y}
end

local function get_spawn_anchors(rng, surface)
  local anchors = {}
  local seen = {}
  local players = get_surface_players(surface)
  if #players == 0 then
    return anchors
  end

  for _, player in pairs(players) do
    add_anchor_position(anchors, seen, player.position)

    local area = {
      {
        player.position.x - BUILDING_ANCHOR_SEARCH_RADIUS,
        player.position.y - BUILDING_ANCHOR_SEARCH_RADIUS
      },
      {
        player.position.x + BUILDING_ANCHOR_SEARCH_RADIUS,
        player.position.y + BUILDING_ANCHOR_SEARCH_RADIUS
      }
    }
    local entities = surface.find_entities_filtered({
      area = area,
      force = player.force,
      type = {
        "assembling-machine", "furnace", "mining-drill", "container", "logistic-container",
        "turret", "ammo-turret", "electric-turret", "fluid-turret", "artillery-turret",
        "lab", "reactor", "boiler", "generator", "solar-panel", "accumulator",
        "roboport", "radar", "rocket-silo"
      }
    })

    if #entities > 0 then
      local limit = math.min(MAX_BUILDING_ANCHORS_PER_PLAYER, #entities)
      for _ = 1, limit do
        local entity = entities[random_int(rng, 1, #entities)]
        if entity.valid then
          add_anchor_position(anchors, seen, entity.position)
        end
      end
    end
  end

  return anchors
end

local function sample_desert_position(rng, surface)
  local anchors = get_spawn_anchors(rng, surface)
  if #anchors == 0 then
    return nil
  end

  for _ = 1, SPAWN_ATTEMPTS do
    local anchor = anchors[random_int(rng, 1, #anchors)]
    local angle = random_float(rng, 0, TWO_PI)
    local distance = random_float(rng, 24, SPAWN_SEARCH_RADIUS)
    local position = {
      x = anchor.x + math.cos(angle) * distance,
      y = anchor.y + math.sin(angle) * distance
    }

    local tile = surface.get_tile(position)
    if tile.valid and is_desert_tile(surface, tile.name) then
      return position
    end
  end

  return nil
end

local function sample_desert_position_near(rng, surface, anchor, max_radius)
  local anchor_tile = surface.get_tile(anchor)
  if anchor_tile.valid and is_desert_tile(surface, anchor_tile.name) then
    return {x = anchor.x, y = anchor.y}
  end

  for _ = 1, SPAWN_ATTEMPTS do
    local angle = random_float(rng, 0, TWO_PI)
    local distance = random_float(rng, 2, max_radius)
    local position = {
      x = anchor.x + math.cos(angle) * distance,
      y = anchor.y + math.sin(angle) * distance
    }

    local tile = surface.get_tile(position)
    if tile.valid and is_desert_tile(surface, tile.name) then
      return position
    end
  end

  return nil
end

local function schedule_next_spawn()
  local rng = PERSIST.sandstorm.rng
  local min_minutes = get_global_setting("mithras-sandstorm-spawn-min-minutes") or 1
  local max_minutes = get_global_setting("mithras-sandstorm-spawn-max-minutes") or 5
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

  local direction_angle = random_float(rng, 0, TWO_PI)
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

local function get_storm_damage_force()
  local force = game.forces[STORM_DAMAGE_FORCE_NAME]
  if force ~= nil and force.valid then
    return force
  end
  return game.forces.player
end

local function entity_can_be_damaged(entity)
  if not entity.valid or not entity.is_entity_with_health then
    return false
  end
  local health = entity.health
  return health ~= nil and health > 0
end

local function entity_in_storm(storm, entity)
  if point_in_storm(storm, entity.position) then
    return true
  end

  local bbox = entity.bounding_box
  if bbox == nil then
    return false
  end

  -- entity.position is the center for all standard entities, so skip a
  -- redundant center check and go straight to the corners.
  return point_in_storm(storm, bbox.left_top)
    or point_in_storm(storm, bbox.right_bottom)
end

local function damage_entity(entity, damage_force)
  -- Factorio 2.0: damage(amount, force, type) — force is required.
  entity.damage(STORM_DAMAGE_AMOUNT, damage_force, STORM_DAMAGE_TYPE)
end

local function apply_storm_damage(storm, surface, damage_force)
  local search_radius = math.max(storm.radius_x, storm.radius_y)
  local left_top = {
    x = storm.position.x - search_radius,
    y = storm.position.y - search_radius
  }
  local right_bottom = {
    x = storm.position.x + search_radius,
    y = storm.position.y + search_radius
  }

  for _, entity in pairs(surface.find_entities_filtered({area = {left_top, right_bottom}})) do
    if entity_can_be_damaged(entity) and entity_in_storm(storm, entity) then
      damage_entity(entity, damage_force)
    end
  end
end

local function get_storm_biter_name(surface)
  local enemy_force = game.forces.enemy
  local evolution = (enemy_force and enemy_force.valid) and enemy_force.get_evolution_factor(surface) or 0
  for _, entry in ipairs(STORM_BITER_BY_EVOLUTION) do
    if evolution >= entry.threshold then
      return entry.name
    end
  end
  return "small-biter"
end

local function spawn_biters_in_storm(rng, storm, surface)
  local enemy_force = game.forces.enemy
  if not enemy_force or not enemy_force.valid then return end

  local biter_name = get_storm_biter_name(surface)
  for _ = 1, STORM_BITERS_PER_SPAWN do
    -- Uniform random point inside the storm ellipse.
    local angle = random_float(rng, 0, TWO_PI)
    local r = math.sqrt(random_float(rng, 0, 1))
    local px = storm.position.x + math.cos(angle) * storm.radius_x * r
    local py = storm.position.y + math.sin(angle) * storm.radius_y * r
    local pos = surface.find_non_colliding_position(biter_name, {x = px, y = py}, 5, 0.5)
    if pos then
      surface.create_entity({name = biter_name, position = pos, force = enemy_force})
    end
  end
end

local function get_forces_with_players_on_surface(surface)
  local forces = {}
  local seen = {}
  for _, player in pairs(game.connected_players) do
    if player.valid and player.surface.index == surface.index then
      local force = player.force
      if force.valid and not seen[force.index] then
        seen[force.index] = true
        forces[#forces + 1] = force
      end
    end
  end
  return forces
end

local function storm_visible_on_chart_for_force(force, storm, surface)
  local radius = math.max(storm.radius_x, storm.radius_y)
  local cx = math.floor(storm.position.x / CHUNK_SIZE)
  local cy = math.floor(storm.position.y / CHUNK_SIZE)

  -- Center chunk is the most likely to be explored; check it first for early exit.
  if force.is_chunk_visible(surface, {x = cx, y = cy}) then
    return true
  end

  local min_chunk_x = math.floor((storm.position.x - radius) / CHUNK_SIZE)
  local max_chunk_x = math.floor((storm.position.x + radius) / CHUNK_SIZE)
  local min_chunk_y = math.floor((storm.position.y - radius) / CHUNK_SIZE)
  local max_chunk_y = math.floor((storm.position.y + radius) / CHUNK_SIZE)

  for chunk_x = min_chunk_x, max_chunk_x do
    for chunk_y = min_chunk_y, max_chunk_y do
      if chunk_x ~= cx or chunk_y ~= cy then
        if force.is_chunk_visible(surface, {x = chunk_x, y = chunk_y}) then
          return true
        end
      end
    end
  end

  return false
end

local function emit_storm_particles(rng, storm, surface)
  for _ = 1, PARTICLES_PER_UPDATE do
    local angle = random_float(rng, 0, TWO_PI)
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

local function draw_storm_outline(storm, surface, visible_forces)
  local storm_radius = math.max(storm.radius_x, storm.radius_y)
  rendering.draw_circle({
    color = {r = 0.44, g = 0.38, b = 0.24, a = 0.03},
    radius = storm_radius,
    filled = true,
    target = storm.position,
    surface = surface,
    draw_on_ground = true,
    width = 1,
    time_to_live = UPDATE_INTERVAL_TICKS + 1,
    forces = visible_forces,
  })

  rendering.draw_circle({
    color = {r = 0.44, g = 0.38, b = 0.24, a = 0.01},
    radius = storm_radius,
    filled = true,
    target = storm.position,
    surface = surface,
    draw_on_ground = false,
    width = 1,
    time_to_live = UPDATE_INTERVAL_TICKS + 1,
    forces = visible_forces,
  })

  rendering.draw_circle({
    color = {r = 0.52, g = 0.43, b = 0.27, a = 0.14},
    radius = storm_radius,
    filled = false,
    target = storm.position,
    surface = surface,
    draw_on_ground = true,
    width = 2,
    time_to_live = UPDATE_INTERVAL_TICKS + 1,
    forces = visible_forces,
  })
end

local function draw_storm_on_chart_for_force(storm, surface, force)
  local storm_radius = math.max(storm.radius_x, storm.radius_y)
  local chart_forces = {force}

  rendering.draw_circle({
    color = {r = 0.44, g = 0.38, b = 0.24, a = 0.06},
    radius = storm_radius,
    filled = true,
    target = storm.position,
    surface = surface,
    forces = chart_forces,
    width = 1,
    time_to_live = UPDATE_INTERVAL_TICKS + 1,
    render_mode = "chart"
  })

  rendering.draw_circle({
    color = {r = 0.52, g = 0.43, b = 0.27, a = 0.20},
    radius = storm_radius,
    filled = false,
    target = storm.position,
    surface = surface,
    forces = chart_forces,
    width = 2,
    time_to_live = UPDATE_INTERVAL_TICKS + 1,
    render_mode = "chart"
  })
end

local function get_visible_forces_for_storm(storm, surface)
  local forces = {}
  for _, force in ipairs(get_forces_with_players_on_surface(surface)) do
    if storm_visible_on_chart_for_force(force, storm, surface) then
      forces[#forces + 1] = force
    end
  end
  return forces
end

local function draw_storm_on_chart(storm, surface, visible_forces)
  for _, force in ipairs(visible_forces) do
    draw_storm_on_chart_for_force(storm, surface, force)
  end
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
  if _visual_cleanup_done then return end
  if PERSIST.sandstorm.did_global_visual_cleanup then
    _visual_cleanup_done = true
    return
  end
  -- Remove any stale rendering objects left from older script versions.
  pcall(rendering.clear, MOD_SCRIPT_NAME)
  PERSIST.sandstorm.did_global_visual_cleanup = true
  _visual_cleanup_done = true
end

local function ensure_state()
  if _state_ready then return end
  PERSIST.sandstorm = PERSIST.sandstorm or {}
  PERSIST.sandstorm.active_storms = PERSIST.sandstorm.active_storms or {}
  PERSIST.sandstorm.id_counter = PERSIST.sandstorm.id_counter or 0
  PERSIST.sandstorm.rng = PERSIST.sandstorm.rng or game.create_random_generator()
  PERSIST.sandstorm.did_global_visual_cleanup = PERSIST.sandstorm.did_global_visual_cleanup or false
  if PERSIST.sandstorm.next_spawn_tick == nil then
    schedule_next_spawn()
  end
  _state_ready = true
end

function sandstorm.on_init()
  ensure_state()
end

function sandstorm.on_configuration_changed()
  _state_ready = false
  _visual_cleanup_done = false
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
  local ss = PERSIST.sandstorm
  local rng = ss.rng
  local tick = game.tick
  local apply_damage = false
  if tick - (ss.last_damage_tick or 0) >= STORM_DAMAGE_INTERVAL_TICKS then
    ss.last_damage_tick = tick
    apply_damage = true
  end
  local apply_biters = false
  if tick - (ss.last_biter_spawn_tick or 0) >= STORM_BITER_SPAWN_INTERVAL_TICKS then
    ss.last_biter_spawn_tick = tick
    apply_biters = true
  end
  local damage_force = apply_damage and get_storm_damage_force() or nil
  for _, storm in pairs(ss.active_storms) do
    update_storm_movement(storm)
    local surface = game.surfaces[storm.surface_index]
    if surface and surface.valid then
      local visible_forces = get_visible_forces_for_storm(storm, surface)
      if #visible_forces > 0 then
        draw_storm_outline(storm, surface, visible_forces)
        draw_storm_on_chart(storm, surface, visible_forces)
        emit_storm_particles(rng, storm, surface)
      end
      if apply_damage then
        apply_storm_damage(storm, surface, damage_force)
      end
      if apply_biters then
        spawn_biters_in_storm(rng, storm, surface)
      end
    end
  end

  if not _mithras_grace_set then
    if ss.mithras_grace_applied then
      _mithras_grace_set = true
    else
      for _, player in pairs(game.connected_players) do
        if player.valid and player.surface.valid and player.surface.name == "mithras" then
          local grace_ticks = math.floor(
            random_float(rng, STORM_MITHRAS_GRACE_MIN_HOURS, STORM_MITHRAS_GRACE_MAX_HOURS) * TICKS_PER_HOUR
          )
          ss.next_spawn_tick = tick + grace_ticks
          ss.mithras_grace_applied = true
          _mithras_grace_set = true
          break
        end
      end
    end
  end

  if tick >= ss.next_spawn_tick then
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
