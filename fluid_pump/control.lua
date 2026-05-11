require("__factorio_planet_mod__.util")

function spawn_dry_pump(event)
    local entity = event.entity
    local surface = entity.surface
    local position = entity.position
    local direction = entity.direction
    game.print("TEST 123")
    game.print(entity.name)
    game.print(surface)
    game.print(position)
    game.print(direction)

    if entity and entity.name == "fluid-pump-fake" then
        local dx, dy = 0, -1 -- default: north-facing pump

        if direction == defines.direction.east then
            dx, dy = 1, 0
        elseif direction == defines.direction.south then
            dx, dy = 0, 1
        elseif direction == defines.direction.west then
            dx, dy = -1, 0
        end

        -- place water in front of pump depending on orientation
        local water_pos = {
            x = position.x + dx,
            y = position.y + dy,
        }

        surface.set_tiles({
            { name = "water", position = water_pos },
        }, true)

        local thingy = surface.create_entity({
            name = "fluid-pump",
            position = position,
            direction = direction,
            -- force = entity.force,
            player = event.player,
            fast_replace = true,
            spill = false,
        })
        thingy.destructible = true
        thingy.minable = true
        entity.destroy()
    end
end
