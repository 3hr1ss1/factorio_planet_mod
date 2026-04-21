-- TODO: SMELTING DOESNT WORK Somehow the ingredient isnt recognized correctly.
-- Titanium smelting

local util = require("__factorio_planet_mod__.util")
-- local item_sounds = require("__base__.prototypes.item_sounds")

data:extend({
    {
        type = "recipe",
        name = "SiliconIngot-recipe",
        main_product = "SiliconIngot",
        category = "smelting",
        order = "d[silicon-ingot]",
        icons = nil,
        --     {{
        --         icon = "__factorio_planet_mod__/assets/silicia_bar.png",
        --         icon_size = 64,
        --         icon_mipmaps = 3,
        --     },
        --     {
        --         icon = "__factorio_planet_mod__/assets/silicia_ore.png",
        --         icon_size = 64,
        --         icon_mipmaps = 3,
        --         scale = 0.25,
        --         shift = { -8, -8 },
        --     },
        -- },
        enabled = false,
        allow_productivity = true,
        energy_required = 8,
        ingredients = {
            util.item("silicon-ore", (mods["space-age"] and 10 or 5)),
        },
        results = {
            util.item("SiliconIngot"),
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
        name = "SiliconIngot",
        icon = "__factorio_planet_mod__/assets/silicia_bar.png",
        icon_size = 64,
        icon_mipmaps = 3,
        subgroup = "raw-material",
        order = "b[silicium-ingot]",
        stack_size = 100,
        weight = 1 * kg,
        -- inventory_move_sound = item_sounds.metal_small_inventory_move,
        -- pick_sound = item_sounds.metal_small_inventory_pickup,
        -- drop_sound = item_sounds.metal_small_inventory_move,
    },
    -- {
    --     type = "technology",
    --     name = "titanium-processing",
    --     icon_size = 256,
    --     icon_mipmaps = 4,
    --     icon = "__factorio_planet_mod__/assets/silicia_bar.png",
    --     effects = {
    --         -- TODO: Make this get the laser science pack if this is crafted and glass
    --         -- {
    --         --     type = "unlock-recipe",
    --         --     recipe = util.me.titanium_plate,
    --         -- },
    --     },
    --     research_trigger = { type = "mine-entity", entity = "silicon-ore" },
    --     prerequisites = {},
    --     order = "b-b",
    -- },
})
