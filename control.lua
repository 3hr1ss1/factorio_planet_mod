local sandstorm = require("scripts.sandstorm")

script.on_init(function()
  sandstorm.on_init()
end)

script.on_configuration_changed(function()
  sandstorm.on_configuration_changed()
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  sandstorm.on_runtime_mod_setting_changed(event)
end)

script.on_nth_tick(sandstorm.get_update_interval(), function()
  sandstorm.on_update()
end)
require("prototypes.dedicated-storage-chest-control")

script.on_event(defines.events.on_tick, function(event)
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
