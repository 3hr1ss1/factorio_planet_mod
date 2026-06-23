local sandstorm = require("scripts.sandstorm")
local dedicated_storage = require("prototypes.dedicated-storage-chest-control")
local iondome = require("scripts.iondome")

local dome_renders = {}  -- [player_index] = { render_obj, render_obj }

script.on_event(defines.events.on_selected_entity_changed, function(event)
  local player = game.get_player(event.player_index)
  if not player or not player.valid then return end

  if dome_renders[event.player_index] then
    for _, r in pairs(dome_renders[event.player_index]) do
      if r.valid then r.destroy() end
    end
    dome_renders[event.player_index] = nil
  end

  local entity = player.selected
  if entity and entity.valid and entity.name == "ion-dome" then
    local x, y = entity.position.x, entity.position.y
    local area = {
      left_top     = { x = x - 24, y = y - 24 },
      right_bottom = { x = x + 24, y = y + 24 },
    }
    local r1 = rendering.draw_rectangle({
      color = { r = 0.2, g = 0.6, b = 1.0, a = 0.15 },
      filled = true,
      left_top = area.left_top,
      right_bottom = area.right_bottom,
      surface = entity.surface,
      draw_on_ground = true,
    })
    local r2 = rendering.draw_rectangle({
      color = { r = 0.2, g = 0.6, b = 1.0, a = 0.6 },
      filled = false,
      width = 2,
      left_top = area.left_top,
      right_bottom = area.right_bottom,
      surface = entity.surface,
      draw_on_ground = true,
    })
    dome_renders[event.player_index] = { r1, r2 }
  end
end)

script.on_init(function()
  sandstorm.on_init()
  dedicated_storage.on_init()
end)

script.on_configuration_changed(function()
  sandstorm.on_configuration_changed()
  dedicated_storage.on_configuration_changed()
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  sandstorm.on_runtime_mod_setting_changed(event)
end)

script.on_nth_tick(sandstorm.get_update_interval(), function()
  sandstorm.on_update()
end)

-- Keep the dedicated storage index in sync as chests are placed/removed.
script.on_event({
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.script_raised_built,
    defines.events.script_raised_revive,
}, function(event)
    dedicated_storage.on_built(event.entity)
end)

script.on_event({
    defines.events.on_pre_player_mined_item,
    defines.events.on_robot_pre_mined,
    defines.events.on_entity_died,
    defines.events.script_raised_destroy,
}, function(event)
    dedicated_storage.on_removed(event.entity)
end)

script.on_event(defines.events.on_tick, function(event)
    dedicated_storage.on_tick(event.tick)

    if game.tick % 60 == 0 then -- Run every second
        for _, surface in pairs(game.surfaces) do
            for _, entity in pairs(surface.find_entities_filtered({name = "solar-oven"})) do
                -- 0.0 to 0.25 is dawn
                -- 0.25 to 0.75 is day
                -- 0.75 to 1.0 is dusk
                local daytime = surface.daytime

                if daytime > 0.25 and daytime < 0.75 then
                    entity.active = false
                else
                    entity.active = true
                end
            end
        end
    end
end)


commands.add_command("mithras-storm-now", "Spawn a sandstorm near your position.", function(command)
  local player = game.get_player(command.player_index)
  if player == nil then
    return
  end

  local ok, message = sandstorm.force_spawn_for_player(player)
  if ok then
    player.print("[Mithras] " .. message)
  else
    player.print("[Mithras] Spawn failed: " .. message)
  end
end)
