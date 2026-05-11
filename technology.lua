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
    },
    {
        type = "technology",
        name = "nuclear-artillery",
        icon = "__base__/graphics/icons/artillery-shell.png",
        icon_size = 64,
        icon_mipmaps = 4,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "nuclear-artillery-shell"
            }
        },
        prerequisites = {"atomic-bomb", "planet-discovery-mithras", "artillery"},
        unit =
        {
            count = 1000,
            ingredients =
            {
                { "automation-science-pack",      1 },
                { "logistic-science-pack",        1 },
                { "chemical-science-pack",        1 },
                { "military-science-pack",        1 },
                { "production-science-pack",      1 },
                { "utility-science-pack",         1 },
                { "space-science-pack",           1 }
            },
            time = 60
        }
    },
    {
        type = "technology",
        name = "silicon-processing",
        icon = "__factorio_planet_mod__/assets/silicia_bar.png",
        icon_size = 64,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "SiliconIngot-recipe"
            },
            {
                type = "unlock-recipe",
                recipe = "coarse-sand-centrifuging"
            },
             {
                type = "unlock-recipe",
                recipe = "coarse-sand-centrifuging"
            },
             {
                type = "unlock-recipe",
                 recipe = "stone-centrifuging"
            }
        },
        research_trigger =
        {
            type = "mine-entity",
            entity = "silicon-ore"
        },
        order = "b-b"
    },
    {
        type = "technology",
        name = "solar-oven",
        icon = "__factorio_planet_mod__/assets/solar-oven-icon.png",
        icon_size = 612,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "solar-oven"
            }
        },
        prerequisites = {"silicon-processing", "advanced-material-processing-2"},
        unit =
        {
            count = 250,
            ingredients =
            {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
                { "chemical-science-pack", 1 },
                { "production-science-pack", 1 },
                { "solar-science-pack", 1 }
            },
            time = 30
        },
        order = "c-a"
    },
})

