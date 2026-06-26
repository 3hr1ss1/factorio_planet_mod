-- Core Pumpjack
-- The fluid counterpart of the Core Miner. A late-game extraction building that
-- pumps the planet's "ground fluid" straight out of the core, with no surface
-- deposit required. Which fluid it produces depends on the planet it stands on
-- (gated through surface_conditions on gravity).
--
-- Graphics: uses the mod's own pump_down.png sprite (one of a 4-direction set
-- in assets/). Static single-direction sprite for now.

local pump_texture = "__factorio_planet_mod__/assets/pump_down.png"
local pump_texture_size = 146

local core_pumping_category = {
    type = "recipe-category",
    name = "core-pumping"
}

local core_pumpjack_entity = {
    type = "assembling-machine",
    name = "core-pumpjack",
    icon = pump_texture,
    icon_size = pump_texture_size,
    flags = { "placeable-neutral", "placeable-player", "player-creation" },
    minable = { mining_time = 1, result = "core-pumpjack" },
    fast_replaceable_group = "assembling-machine",
    max_health = 400,
    corpse = "medium-remnants",
    dying_explosion = "medium-explosion",
    resistances = {
        { type = "fire",   percent = 70 },
        { type = "impact", percent = 30 }
    },
    collision_box = { { -1.3, -1.3 }, { 1.3, 1.3 } },
    selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
    crafting_categories = { "core-pumping" },
    crafting_speed = 1,
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        emissions_per_minute = { pollution = 4 }
    },
    energy_usage = "100kW",
    -- Single output connection on the side opposite the pump's facing. Rotates
    -- with the entity, so when the north-facing sprite (pump_down) shows, the
    -- connection sits at the top.
    fluid_boxes = {
        {
            production_type = "output",
            volume = 1000,
            pipe_connections = {
                { flow_direction = "output", direction = defines.direction.north, position = { 0, -1 } },
            },
        },
    },
    -- 4-direction sprites. Each facing's connection (opposite the pump) lines up
    -- with the auto-rotated pipe connection above:
    --   north = pump_down  (connection top)    east = pump_left  (connection right)
    --   south = pump_up    (connection bottom)  west = pump_right (connection left)
    graphics_set = {
        animation = {
            north = { filename = "__factorio_planet_mod__/assets/pump_down.png",  width = pump_texture_size, height = pump_texture_size, frame_count = 1, scale = 0.85 },
            east  = { filename = "__factorio_planet_mod__/assets/pump_left.png",  width = pump_texture_size, height = pump_texture_size, frame_count = 1, scale = 0.85 },
            south = { filename = "__factorio_planet_mod__/assets/pump_up.png",    width = pump_texture_size, height = pump_texture_size, frame_count = 1, scale = 0.85 },
            west  = { filename = "__factorio_planet_mod__/assets/pump_right.png", width = pump_texture_size, height = pump_texture_size, frame_count = 1, scale = 0.85 },
        }
    },
    open_sound = { filename = "__base__/sound/open-close/electric-large-open.ogg", volume = 0.5 },
    close_sound = { filename = "__base__/sound/open-close/electric-large-close.ogg", volume = 0.5 }
}

local core_pumpjack_item = {
    type = "item",
    name = "core-pumpjack",
    icon = pump_texture,
    icon_size = pump_texture_size,
    subgroup = "extraction-machine",
    order = "a[items]-c[core-pumpjack]",
    place_result = "core-pumpjack",
    stack_size = 20
}

-- Recipe to craft the core-pumpjack item itself.
local core_pumpjack_build_recipe = {
    type = "recipe",
    name = "core-pumpjack",
    energy_required = 20,
    enabled = false,
    ingredients = {
        { type = "item", name = "pumpjack",         amount = 1  },
        { type = "item", name = "advanced-circuit", amount = 10 },
        { type = "item", name = "engine-unit",      amount = 10 },
        { type = "item", name = "SiliconIngot",     amount = 30 },
        { type = "item", name = "steel-plate",      amount = 50 }
    },
    results = {
        { type = "item", name = "core-pumpjack", amount = 1 }
    }
}

-- Helper: build a core-pumping recipe producing a fluid.
-- 120/s throughput = amount 120 over energy_required 1 at crafting_speed 1
-- (1/10 of the offshore pump, per the README).
local function core_pumping_recipe(name, gravity_min, gravity_max, fluid, icon, icon_size)
    return {
        type = "recipe",
        name = name,
        category = "core-pumping",
        enabled = false,
        energy_required = 1,
        ingredients = {},
        results = {
            { type = "fluid", name = fluid, amount = 120 }
        },
        surface_conditions = {
            { property = "gravity", min = gravity_min, max = gravity_max }
        },
        icon = icon,
        icon_size = icon_size or 64,
        allow_decomposition = false,
        allow_as_intermediate = false,
        hide_from_signal_gui = true,
        subgroup = "extraction-machine",
        order = "z[core-pumping]-" .. name,
        main_product = ""
    }
end

-- One recipe per planet. Gravity ranges match the Core Miner advanced recipes.
local core_pumping_recipes = {
    core_pumping_recipe("core-pumping-nauvis",    9.5, 10.5, "water",                "__base__/graphics/icons/fluid/water.png"),
    core_pumping_recipe("core-pumping-vulcanus", 39.5, 40.5, "lava",                 "__space-age__/graphics/icons/fluid/lava.png"),
    core_pumping_recipe("core-pumping-fulgora",   7.5,  8.5, "heavy-oil",            "__base__/graphics/icons/fluid/heavy-oil.png"),
    core_pumping_recipe("core-pumping-gleba",    19.5, 20.5, "water",                "__base__/graphics/icons/fluid/water.png"),
    core_pumping_recipe("core-pumping-aquilo",   14.5, 15.5, "ammoniacal-solution",  "__space-age__/graphics/icons/fluid/ammoniacal-solution.png"),
    core_pumping_recipe("core-pumping-mithras",   2.0,  2.8, "water",                "__base__/graphics/icons/fluid/water.png"),
}

local prototypes = {
    core_pumping_category,
    core_pumpjack_entity,
    core_pumpjack_item,
    core_pumpjack_build_recipe
}

for _, r in ipairs(core_pumping_recipes) do
    table.insert(prototypes, r)
end

data:extend(prototypes)
