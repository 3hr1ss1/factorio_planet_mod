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
            { type = "unlock-recipe", recipe = "core-miner" },
            { type = "unlock-recipe", recipe = "core-mining-basic" },
            { type = "unlock-recipe", recipe = "core-mining-mithras" }
        },
        prerequisites = { "space-platform-thruster", "solar-energy", "uranium-processing" },
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
        prerequisites = { "planet-discovery-mithras", "atomic-bomb", "artillery", "solar-science-pack" },
        unit =
        {
            count = 1500,
            ingredients =
            {
                { "automation-science-pack",      1 },
                { "logistic-science-pack",        1 },
                { "military-science-pack",        1 },
                { "chemical-science-pack",        1 },
                { "utility-science-pack",         1 },
                { "space-science-pack",           1 },
                { "solar-science-pack",           1 }
            },
            time = 30
        }
    },
    {
        type = "technology",
        name = "short-handed-inserter",
        icon = "__base__/graphics/icons/long-handed-inserter.png",
        icon_size = 64,
        icon_mipmaps = 4,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "short-handed-inserter"
            }
        },
        prerequisites = { "planet-discovery-mithras", "automation", "solar-science-pack" },
        unit =
        {
            count = 1000,
            ingredients =
            {
                { "automation-science-pack",      1 },
                { "logistic-science-pack",        1 },
                { "chemical-science-pack",        1 },
                { "production-science-pack",      1 },
                { "utility-science-pack",         1 },
                { "space-science-pack",           1 },
                { "solar-science-pack",           1 }
            },
            time = 60
        },
        order = "c-d"
    },
    {
        type = "technology",
        name = "solar-energy-mk2",
        icon = "__base__/graphics/technology/solar-energy.png",
        icon_size = 256,
        icon_mipmaps = 4,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "solar-panel-mk2"
            }
        },
        prerequisites = { "solar-energy", "solar-science-pack" },
        unit =
        {
            count = 1000,
            ingredients =
            {
                { "automation-science-pack",      1 },
                { "logistic-science-pack",        1 },
                { "chemical-science-pack",        1 },
                { "production-science-pack",      1 },
                { "utility-science-pack",         1 },
                { "space-science-pack",           1 },
                { "solar-science-pack",           1 }
            },
            time = 60
        },
        order = "a-h-b"
    },
    {
        type = "technology",
        name = "dedicated-storage-chest",
        icon = "__base__/graphics/icons/storage-chest.png",
        icon_size = 64,
        icon_mipmaps = 4,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "dedicated-storage-chest"
            }
        },
        prerequisites = { "logistic-system" },
        unit =
        {
            count = 500,
            ingredients =
            {
                { "automation-science-pack",      1 },
                { "logistic-science-pack",        1 },
                { "chemical-science-pack",        1 },
                { "production-science-pack",      1 },
                { "utility-science-pack",         1 },
                { "space-science-pack",           1 },
                { "solar-science-pack",           1 }
            },
            time = 30
        },
        order = "c-e"
    },
    {
        type = "technology",
        name = "solar-science-pack",
        icon = "__factorio_planet_mod__/assets/solar-science-pack.png",
        icon_size = 64,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "solar-science-pack"
            }
        },
        prerequisites = { "planet-discovery-mithras" },
        unit =
        {
            count = 50,
            ingredients =
            {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 }
            },
            time = 30
        },
        order = "c-a"
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
            }
        },
        research_trigger =
        {
            type = "mine-entity",
            entity = "silicon-ore",
            count = 10
        },
        order = "b-b"
    },
    {
        type = "technology",
        name = "sand-processing",
        icon = "__factorio_planet_mod__/assets/coarse-sand.png",
        icon_size = 256,
        icon_mipmaps = 4,
        effects =
        {
            { type = "unlock-recipe", recipe = "coarse-sand-centrifuging" },
            { type = "unlock-recipe", recipe = "stone-centrifuging" },
            { type = "unlock-recipe", recipe = "glass" }
        },
        research_trigger =
        {
            type = "mine-entity",
            entity = "coarse-sand",
            count = 10
        },
        order = "b-a"
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
        prerequisites = { "silicon-processing", "sand-processing", "advanced-material-processing-2", "solar-science-pack" },
        unit =
        {
            count = 100,
            ingredients =
            {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 },
                { "utility-science-pack",    1 },
                { "space-science-pack",      1 },
                { "solar-science-pack",      1 }
            },
            time = 30
        },
        order = "c-a"
    },
    {
        type = "technology",
        name = "advanced-core-mining",
        icon = "__space-age__/graphics/icons/big-mining-drill.png",
        icon_size = 64,
        effects =
        {
            { type = "unlock-recipe", recipe = "advanced-core-mining-nauvis"   },
            { type = "unlock-recipe", recipe = "advanced-core-mining-mithras"  },
            { type = "unlock-recipe", recipe = "advanced-core-mining-vulcanus" },
            { type = "unlock-recipe", recipe = "advanced-core-mining-fulgora"  },
            { type = "unlock-recipe", recipe = "advanced-core-mining-gleba"    },
            { type = "unlock-recipe", recipe = "advanced-core-mining-aquilo"   }
        },
        prerequisites = { "planet-discovery-mithras" },
        unit =
        {
            count = 100,
            ingredients =
            {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 },
                { "utility-science-pack",    1 },
                { "space-science-pack",      1 },
                { "solar-science-pack",      1 }
            },
            time = 30
        },
        order = "c-c"
    },
})
