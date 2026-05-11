local resource_autoplace = require("resource-autoplace")
local item_sounds = require("__base__.prototypes.item_sounds")

-- TODO: Comment this out when the miner is implemented
data.raw.planet.mithras.map_gen_settings.autoplace_controls["coarse-sand"] =
    { freqency = 6767, size = 1, richness = 1 }
data.raw.planet.mithras.map_gen_settings.autoplace_settings.entity.settings["coarse-sand"] =
    { freqency = 6767, size = 1, richness = 1 }

data:extend({
    {
        type = "autoplace-control",
        category = "resource",
        name = "coarse-sand",
        richness = true,
        order = "a-t",
    },
    --{
    --  type = "noise-layer",
    --  name = "silicon-ore"
    --},
    {
        type = "resource",
        icon_size = 64,
        icon_mipmaps = 3,
        name = "coarse-sand",
        icon = "__factorio_planet_mod__/assets/silicia_ore.png",
        flags = { "placeable-neutral" },
        order = "a-b-a",
        map_color = { r = 1, g = 1, b = 1 },
        minable = {
            hardness = 1,
            mining_particle = "coarse-sand-particle",
            mining_time = 2,
            result = "coarse-sand",
        },
        collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
        selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },

        -- TODO: Comment this out when the miner is implemented
        autoplace = resource_autoplace.resource_autoplace_settings({
            name = "coarse-sand",
            order = "a-t",
            base_density = 8,
            frequency_multiplier = 2,
            has_starting_area_placement = false,
            regular_rq_factor_multiplier = 0.8,
        }),

        stage_counts = { 15000, 9500, 5500, 2900, 1300, 400, 150, 80 },
        stages = {
            sheet = {
                filename = "__factorio_planet_mod__/assets/silicia-ore-ground.png",
                priority = "extra-high",
                size = 128,
                frame_count = 8,
                variation_count = 8,
                scale = 0.45,
            },
        },
    },
    {
        type = "item",
        name = "coarse-sand",
        icon_size = 64,
        icon_mipmaps = 3,
        icon = "__factorio_planet_mod__/assets/silicia_ore.png",
        inventory_move_sound = item_sounds.resource_inventory_move,
        pick_sound = item_sounds.resource_inventory_pickup,
        drop_sound = item_sounds.resource_inventory_move,
        pictures = {
            {
                filename = "__factorio_planet_mod__/assets/silicia_ore.png",
                size = 64,
                scale = 0.5,
            },
        },
        subgroup = "raw-resource",
        order = "t-c-a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "silica-sand",
        icon_size = 64,
        icon_mipmaps = 4,
        icon = "__base__/graphics/icons/stone.png",
        inventory_move_sound = item_sounds.resource_inventory_move,
        pick_sound = item_sounds.resource_inventory_pickup,
        drop_sound = item_sounds.resource_inventory_move,
        pictures = {
            {
                filename = "__base__/graphics/icons/stone.png",
                size = 64,
                scale = 0.5,
            },
        },
        subgroup = "raw-resource",
        order = "t-c-b",
        stack_size = 50,
    },
})
