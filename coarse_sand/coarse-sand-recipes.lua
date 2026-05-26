-- Silicon smelting

local util = require("__factorio_planet_mod__.util")
local item_sounds = require("__base__.prototypes.item_sounds")

data:extend({
    {
        type = "recipe",
        name = "coarse-sand-centrifuging",
        category = "centrifuging",
        subgroup = "raw-resource",
        order = "a[coarse-sand-centrifuging]",
        enabled = false,
        energy_required = 8,
        ingredients = {
            { type = "item", name = "coarse-sand", amount = 10 },
        },
        results = {
            { type = "item", name = "stone", amount_min = 5, amount_max = 7 },
            { type = "item", name = "silica-sand", amount_min = 1, amount_max = 3 }
        },
        icon = "__factorio_planet_mod__/assets/coarse-sand.png",
        icon_size = 256,
        icon_mipmaps = 4,
        allow_productivity = true,
    },
    {
        type = "recipe",
        name = "stone-centrifuging",
        category = "centrifuging",
        subgroup = "raw-resource",
        order = "a[stone-centrifuging]",
        enabled = false,
        energy_required = 8,
        ingredients = {
            { type = "item", name = "stone", amount = 10 },
        },
        results = {
            { type = "item", name = "stone", amount_min = 7, amount_max = 8 },
            { type = "item", name = "iron-ore", amount_min = 1, amount_max = 2 },
            { type = "item", name = "copper-ore", amount = 1 },
        },
        icon = "__factorio_planet_mod__/assets/coarse-sand.png",
        icon_size = 256,
        icon_mipmaps = 4,
        allow_productivity = true,
    },
    {
        type = "item",
        name = "glass",
        icon = "__factorio_planet_mod__/assets/glass.png",
        icon_size = 256,
        subgroup = "raw-material",
        order = "a[glass]",
        stack_size = 100
    },
    {
        type = "recipe",
        name = "glass",
        category = "smelting",
        subgroup = "raw-material",
        order = "a[glass]",
        enabled = true,
        energy_required = 3.2,
        ingredients = {
            { type = "item", name = "silica-sand", amount = 1 },
        },
        results = {
            { type = "item", name = "glass", amount = 1 }
        },
        allow_productivity = true
    }
})
