require("util")

data:extend({
--#region MARK: Core Mithras Progression
    {
        type = "technology",
        name = "planet-discovery-mithras",
        icons = {
            {
                icon = "__factorio_planet_mod__/assets/starmap-planet-mithras.png",
                icon_size = 512,
                scale = 256/512,
            },
            {
                icon = "__core__/graphics/icons/technology/constants/constant-planet.png",
                icon_size = 128,
                shift = {100, 100},
                floating = true
            }
        },
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
            { type = "unlock-recipe", recipe = "core-mining-mithras" },
            { type = "unlock-recipe", recipe = "core-pumpjack" },
            { type = "unlock-recipe", recipe = "core-pumping-nauvis" },
            { type = "unlock-recipe", recipe = "core-pumping-vulcanus" },
            { type = "unlock-recipe", recipe = "core-pumping-fulgora" },
            { type = "unlock-recipe", recipe = "core-pumping-gleba" },
            { type = "unlock-recipe", recipe = "core-pumping-aquilo" },
            { type = "unlock-recipe", recipe = "core-pumping-mithras" }
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
        icon = "__factorio_planet_mod__/assets/nuclear-artillery-shell.png",
        icon_size = 64,
        icon_mipmaps = 4,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "nuclear-artillery-shell"
            }
        },
        prerequisites = { "planet-discovery-mithras", "atomic-bomb", "artillery", "laser-science-pack" },
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
                { "laser-science-pack",           1 }
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
        prerequisites = { "planet-discovery-mithras", "automation", "laser-science-pack" },
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
                { "laser-science-pack",           1 }
            },
            time = 60
        },
        order = "c-d"
    },
    {
        type = "technology",
        name = "solar-energy-mk2",
        icon = "__factorio_planet_mod__/assets/solar_panel_mk2.png",
        icon_size = 512,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "solar-panel-mk2"
            }
        },
        prerequisites = { "solar-energy", "laser-science-pack" },
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
                { "laser-science-pack",           1 }
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
                { "laser-science-pack",           1 }
            },
            time = 30
        },
        order = "c-e"
    },
    {
        type = "technology",
        name = "laser-science-pack",
        icon = "__factorio_planet_mod__/assets/laser-science-pack.png",
        icon_size = 64,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "laser-science-pack"
            }
        },
        prerequisites = { "planet-discovery-mithras", "solar-precision-plant" },
        research_trigger =
        {
            type = "craft-item",
            item = "solar-precision-plant",
            count = 1
        },
        order = "c-b"
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
        prerequisites = { "planet-discovery-mithras" },
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
        prerequisites = { "planet-discovery-mithras" },
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
        prerequisites = { "silicon-processing", "sand-processing", "advanced-material-processing-2", "laser-science-pack" },
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
                { "laser-science-pack",      1 }
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
                { "laser-science-pack",      1 }
            },
            time = 30
        },
        order = "c-c"
    },
})

-- Solar Precision Plant technology.
-- Unlocks the plant plus the plant-exclusive science recipes created in
-- prototypes/solar-precision-plant.lua. The duplicate recipe names are derived
-- the same way ("solar-precision-" .. pack) and guarded on the vanilla original,
-- so the two files stay in sync even if a science pack is absent.
local solar_precision_effects = {
    { type = "unlock-recipe", recipe = "solar-precision-plant" }
}

local solar_precision_pack_recipes = {
    "automation-science-pack",
    "logistic-science-pack",
    "military-science-pack",
    "chemical-science-pack",
    "production-science-pack",
    "utility-science-pack",
    "space-science-pack",
    "metallurgic-science-pack",
    "electromagnetic-science-pack",
    "agricultural-science-pack",
    "cryogenic-science-pack",
    "promethium-science-pack"
}

for _, pack in ipairs(solar_precision_pack_recipes) do
    if data.raw.recipe[pack] then
        solar_precision_effects[#solar_precision_effects + 1] =
            { type = "unlock-recipe", recipe = "solar-precision-" .. pack }
    end
end

data:extend({
    {
        type = "technology",
        name = "solar-precision-plant",
        icon = "__factorio_planet_mod__/assets/SolarAssembler.png",
        icon_size = 1228,
        effects = solar_precision_effects,
        prerequisites = { "silicon-processing", "sand-processing" },
        research_trigger =
        {
            type = "craft-item",
            item = "SiliconIngot",
            count = 10
        },
        order = "c-a"
    }
})
