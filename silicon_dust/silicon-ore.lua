local resource_autoplace = require("resource-autoplace")
local item_sounds = require("__base__.prototypes.item_sounds")

data.raw.planet.mithras.map_gen_settings.autoplace_controls["silicon-ore"] = {}
data.raw.planet.mithras.map_gen_settings.autoplace_settings.entity.settings["silicon-ore"] = {}

data:extend({
    {
        type = "autoplace-control",
        category = "resource",
        name = "silicon-ore",
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
        name = "silicon-ore",
        icon = "__factorio_planet_mod__/assets/silicia_ore.png",
        flags = { "placeable-neutral" },
        order = "a-b-a",
        map_color = { r = 1, g = 1, b = 1 },
        minable = {
            hardness = 1,
            mining_particle = "silicon-ore-particle",
            mining_time = 2,
            result = "silicon-ore",
        },
        collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
        selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },

        autoplace = resource_autoplace.resource_autoplace_settings({
            name = "silicon-ore",
            order = "a-t",
            base_density = mods["space-age"] and 5 or 3,
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
        name = "silicon-ore",
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
})
