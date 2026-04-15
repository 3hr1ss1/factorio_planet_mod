-- TODO: SMELTING DOESNT WORK
-- Titanium smelting

-- local util = require("__bztitanium__.data-util")
-- local item_sounds = require("__base__.prototypes.item_sounds")

data:extend({
    {
        type = "recipe",
        name = util.me.silicon_ingot,
        main_product = util.me.silicon_ingot,
        category = "smelting",
        order = "d[silicon-ingot]",
        icons = (util.k2() and {
            {
                icon = "__factorio_planet_mod__/assets/silica_bar.png",
                icon_size = 64,
                icon_mipmaps = 3,
            },
            {
                icon = "__factorio_planet_mod__/assets/silica_bar.png",
                icon_size = 64,
                icon_mipmaps = 3,
                scale = 0.25,
                shift = { -8, -8 },
            },
        } or nil),
        enabled = false,
        allow_productivity = true,
        energy_required = util.k2() and 16 or 8,
        ingredients = {
            util.item("silicon-ore", util.k2() and 10 or (mods["space-age"] and 10 or 5)),
        },
        results = {
            util.k2() and {
                type = "item",
                name = util.me.silicon_ingot,
                amount_min = 2,
                amount_max = 3,
            } or util.item(util.me.silicon_ingot),
        },
        -- expensive =
        -- {
        --   energy_required = 16,
        --   ingredients = {{"titanium-ore", 10}},
        --   result = util.me.titanium_plate
        -- }
    },
    {
        type = "item",
        name = util.me.silicon_ingot,
        icon = "__factorio_planet_mod__/assets/silica_bar.png",
        icon_size = 64,
        icon_mipmaps = 3,
        subgroup = "raw-material",
        order = "b[silicium-ingot]",
        stack_size = util.get_stack_size(100),
        weight = 1 * kg,
        -- inventory_move_sound = item_sounds.metal_small_inventory_move,
        -- pick_sound = item_sounds.metal_small_inventory_pickup,
        -- drop_sound = item_sounds.metal_small_inventory_move,
    },
    {
        type = "technology",
        name = "titanium-processing",
        icon_size = 256,
        icon_mipmaps = 4,
        icon = "__factorio_planet_mod__/assets/silica_bar.png",
        effects = {
            {
                type = "unlock-recipe",
                recipe = util.me.titanium_plate,
            },
        },
        research_trigger = { type = "mine-entity", entity = "silicon-ore" },
        prerequisites = {},
        order = "b-b",
    },
})
