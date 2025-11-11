require("util")

data:extend({
--#region MARK: Core Mithras Progression
    {
        type = "technology",
        name = "planet-discovery-mithras",
        --icons = util.technology_icon_constant_planet("__space-age__/graphics/icons/vulcanus.png"),
        icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
        icon_size = 256,
        essential = true,
        effects =
        {
            {
                type = "unlock-space-location",
                space_location = "mithras",
                use_icon_overlay_constant = true
            },
        },
        prerequisites = { "space-platform-thruster", "energy-shield-equipment", 
            "electric-energy-distribution-1", "railway"},
        unit =
        {
            count = 1000,
            ingredients =
            {
                { "automation-science-pack",      1 },
                { "logistic-science-pack",        1 },
                { "chemical-science-pack",        1 },
                { "space-science-pack",           1 },
            },
            time = 60
        }
    }
})

