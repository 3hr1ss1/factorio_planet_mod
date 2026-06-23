-- Core Miner
-- A late-game extraction building that pulls ores directly from the planet's
-- core. The recipe a player can run depends on the planet the miner is placed
-- on (gated through surface_conditions on gravity). No ore deposit is required
-- on the surface.
--
-- Graphics: placeholder uses the vanilla big-mining-drill sheet. Replace the
-- graphics_set block once the dedicated texture is ready.

local big_drill_graphics = data.raw["mining-drill"]["big-mining-drill"]
    and table.deepcopy(data.raw["mining-drill"]["big-mining-drill"].graphics_set)
    or nil

local core_miner_icon = "__space-age__/graphics/icons/big-mining-drill.png"
local core_miner_icon_size = 64

local core_mining_category = {
    type = "recipe-category",
    name = "core-mining"
}

local core_miner_entity = {
    type = "assembling-machine",
    name = "core-miner",
    icon = core_miner_icon,
    icon_size = core_miner_icon_size,
    flags = { "placeable-neutral", "placeable-player", "player-creation" },
    minable = { mining_time = 1, result = "core-miner" },
    fast_replaceable_group = "assembling-machine",
    max_health = 600,
    corpse = "big-remnants",
    dying_explosion = "big-explosion",
    resistances = {
        { type = "fire",   percent = 70 },
        { type = "impact", percent = 30 }
    },
    collision_box = { { -2.4, -2.4 }, { 2.4, 2.4 } },
    selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } },
    damaged_trigger_effect = nil,
    crafting_categories = { "core-mining" },
    crafting_speed = 1,
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        emissions_per_minute = { pollution = 4 }
    },
    energy_usage = "500kW",
    module_slots = 3,
    allowed_effects = { "speed", "productivity", "consumption", "pollution", "quality" },
    graphics_set = big_drill_graphics or {
        animation = {
            filename = core_miner_icon,
            width = core_miner_icon_size,
            height = core_miner_icon_size,
            scale = 2.5,
            frame_count = 1
        }
    },
    working_visualisations = nil,
    water_reflection = nil,
    open_sound = { filename = "__base__/sound/open-close/electric-large-open.ogg", volume = 0.5 },
    close_sound = { filename = "__base__/sound/open-close/electric-large-close.ogg", volume = 0.5 }
}

local core_miner_item = {
    type = "item",
    name = "core-miner",
    icon = core_miner_icon,
    icon_size = core_miner_icon_size,
    subgroup = "extraction-machine",
    order = "a[items]-c[core-miner]",
    place_result = "core-miner",
    stack_size = 20
}

-- Recipe to craft the core-miner item itself.
local core_miner_build_recipe = {
    type = "recipe",
    name = "core-miner",
    energy_required = 20,
    enabled = false,
    ingredients = {
        { type = "item", name = "steel-plate",          amount = 20 },
        { type = "item", name = "electric-mining-drill", amount = 2 },
        { type = "item", name = "advanced-circuit",     amount = 10 },
        { type = "item", name = "engine-unit",          amount = 8 }
    },
    results = {
        { type = "item", name = "core-miner", amount = 1 }
    }
}

-- Helper: build a core-mining recipe.
-- energy_required is the crafting time (total energy = 500kW × energy_required).
local function core_mining_recipe(name, gravity_min, gravity_max, energy_required, results, icon, icon_size)
    return {
        type = "recipe",
        name = name,
        category = "core-mining",
        enabled = false,
        energy_required = energy_required,
        ingredients = {},
        results = results,
        surface_conditions = {
            { property = "gravity", min = gravity_min, max = gravity_max }
        },
        icon = icon,
        icon_size = icon_size or 64,
        allow_decomposition = false,
        allow_as_intermediate = false,
        hide_from_signal_gui = true,
        subgroup = "extraction-machine",
        order = "z[core-mining]-" .. name,
        main_product = ""
    }
end

-- Base recipes: 20s cycle (10 MJ), produce stone / coarse-sand on Mithras.
-- Throughput: 5 items / 20s = 0.25/s on all planets.
--
-- All non-Mithras planets share one recipe (gravity >= 4 excludes Mithras's 2.4).
-- Mithras keeps its own recipe producing coarse-sand.
local core_mining_recipes = {
    core_mining_recipe("core-mining-basic",   4.0, 99999, 20, {{ type="item", name="stone",       amount=5 }}, "__base__/graphics/icons/stone.png"),
    core_mining_recipe("core-mining-mithras", 2.0,   2.8, 20, {{ type="item", name="coarse-sand", amount=5 }}, "__factorio_planet_mod__/assets/coarse-sand.png", 256),
}

-- Advanced recipes: 30s cycle (15 MJ), produce planet-specific ores.
-- All yield < 0.25 items/s to stay below the base recipe throughput.
local advanced_core_mining_recipes = {
    core_mining_recipe("advanced-core-mining-nauvis",   9.5, 10.5, 30,
        { { type="item", name="stone", amount=5 }, { type="item", name="iron-ore", amount=2 }, { type="item", name="copper-ore", amount=1 }, { type="item", name="coal", amount=1 } },
        "__base__/graphics/icons/iron-ore.png"),
    core_mining_recipe("advanced-core-mining-mithras",  2.0,  2.8, 30,
        { { type="item", name="coarse-sand", amount=8 }, { type="item", name="silicon-ore", amount=1 }, { type="item", name="iron-ore", amount=1 }, { type="item", name="copper-ore", amount=1 } },
        "__factorio_planet_mod__/assets/coarse-sand.png", 256),
    core_mining_recipe("advanced-core-mining-vulcanus", 39.5, 40.5, 30,
        { { type="item", name="stone", amount=5 }, { type="item", name="calcite", amount=3 }, { type="item", name="tungsten-ore", amount=1 } },
        "__space-age__/graphics/icons/tungsten-ore.png"),
    core_mining_recipe("advanced-core-mining-fulgora",   7.5,  8.5, 30,
        { { type="item", name="stone", amount=5 }, { type="item", name="scrap", amount=3 } },
        "__space-age__/graphics/icons/scrap.png"),
    core_mining_recipe("advanced-core-mining-gleba",    19.5, 20.5, 30,
        { { type="item", name="stone", amount=5 }, { type="item", name="sulfur", amount=2 } },
        "__base__/graphics/icons/sulfur.png"),
    core_mining_recipe("advanced-core-mining-aquilo",   14.5, 15.5, 30,
        { { type="item", name="stone", amount=5 }, { type="item", name="lithium", amount=2 } },
        "__space-age__/graphics/icons/lithium.png"),
}

local prototypes = {
    core_mining_category,
    core_miner_entity,
    core_miner_item,
    core_miner_build_recipe
}

for _, r in ipairs(core_mining_recipes) do
    table.insert(prototypes, r)
end
for _, r in ipairs(advanced_core_mining_recipes) do
    table.insert(prototypes, r)
end

data:extend(prototypes)
