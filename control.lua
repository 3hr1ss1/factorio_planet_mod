require("prototypes.dedicated-storage-chest-control")

script.on_event(defines.events.on_tick, function(event)
    if game.tick % 60 == 0 then -- Run every second
        for _, surface in pairs(game.surfaces) do
            for _, entity in pairs(surface.find_entities_filtered({ name = "solar-oven" })) do
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

require("__factorio_planet_mod__.fluid_pump.control")

local build_events = {
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.script_raised_built,
    defines.events.script_raised_revive,
}
script.on_event(build_events, spawn_dry_pump)
