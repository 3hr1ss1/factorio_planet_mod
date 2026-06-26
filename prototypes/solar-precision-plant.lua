-- Solar Precision Plant
-- A late-game, solar-powered science assembler. Runs on free (void) energy but
-- only works during the day (handled in control.lua, like the Solar Oven).
--
-- Crafting is restricted to science: the plant uses a dedicated
-- "solar-precision-crafting" category. Plant-exclusive duplicate recipes for the
-- 12 base + Space Age science packs are deep-copied into that category, and the
-- custom Laser Science Pack recipe is moved into it too (see laser-science-pack.lua),
-- making this the only machine able to craft the laser pack.

local PLANT_NAME = "solar-precision-plant"
local CRAFTING_CATEGORY = "solar-precision-crafting"
local PLANT_ICON = "__factorio_planet_mod__/assets/SolarAssembler.png"
local PLANT_ICON_SIZE = 1228
local PLANT_TEXTURE_SCALE = 0.19 -- scaled so the base fills the 3x3 footprint (art has transparent margins)
local PLANT_TEXTURE_SHIFT = {0.4, 0} -- nudge right to center the base on the hitbox

local solar_precision_category = {
    type = "recipe-category",
    name = CRAFTING_CATEGORY
}

-- Entity: deep copy of assembling-machine-3 so we inherit its fluid_boxes
-- (some science packs require fluids) and standard assembler behaviour.
local plant_entity = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
plant_entity.name = PLANT_NAME
plant_entity.minable = { mining_time = 0.5, result = PLANT_NAME }
plant_entity.crafting_categories = { CRAFTING_CATEGORY }
plant_entity.crafting_speed = 4
plant_entity.effect_receiver = {
    base_effect = {
        productivity = 0.5
    }
}
plant_entity.module_slots = 4
plant_entity.allowed_effects = { "speed", "productivity", "consumption", "pollution", "quality" }
plant_entity.energy_source = { type = "void" }
plant_entity.energy_usage = "1W"
plant_entity.icon = nil
plant_entity.icons = {
    {
        icon = PLANT_ICON,
        icon_size = PLANT_ICON_SIZE
    }
}
plant_entity.graphics_set = {
    animation = {
        layers = {
            {
                filename = PLANT_ICON,
                priority = "high",
                width = PLANT_ICON_SIZE,
                height = PLANT_ICON_SIZE,
                frame_count = 1,
                scale = PLANT_TEXTURE_SCALE,
                shift = PLANT_TEXTURE_SHIFT
            }
        }
    }
}
plant_entity.working_visualisations = nil
plant_entity.water_reflection = nil

local plant_item = {
    type = "item",
    name = PLANT_NAME,
    icon = PLANT_ICON,
    icon_size = PLANT_ICON_SIZE,
    subgroup = "production-machine",
    order = "z[solar-precision-plant]",
    place_result = PLANT_NAME,
    stack_size = 20
}

local plant_recipe = {
    type = "recipe",
    name = PLANT_NAME,
    enabled = false,
    energy_required = 30,
    ingredients = {
        { type = "item", name = "advanced-circuit",  amount = 50 },
        { type = "item", name = "refined-concrete",  amount = 20 },
        { type = "item", name = "glass",             amount = 50 },
        { type = "item", name = "SiliconIngot",      amount = 15 }
    },
    results = {
        { type = "item", name = PLANT_NAME, amount = 1 }
    }
}

local prototypes = {
    solar_precision_category,
    plant_entity,
    plant_item,
    plant_recipe
}

-- Plant-exclusive duplicate recipes for every base + Space Age science pack.
-- Deep-copying preserves the vanilla ingredients/results; we only re-home them in
-- the dedicated category so they can be crafted in the plant (and nowhere else).
local SCIENCE_PACK_RECIPES = {
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

-- Names of the duplicate recipes, exported so technology.lua can unlock them.
local solar_precision_science_recipes = {}

for _, recipe_name in ipairs(SCIENCE_PACK_RECIPES) do
    local source = data.raw.recipe[recipe_name]
    if source then
        local copy = table.deepcopy(source)
        copy.name = "solar-precision-" .. recipe_name
        copy.category = CRAFTING_CATEGORY
        copy.enabled = false
        copy.allow_productivity = true
        -- The duplicate recipe name has no locale entry of its own; point it at the
        -- produced science pack's item name so it shows correctly in every language.
        copy.localised_name = { "item-name." .. recipe_name }
        prototypes[#prototypes + 1] = copy
        solar_precision_science_recipes[#solar_precision_science_recipes + 1] = copy.name
    end
end

data:extend(prototypes)

return {
    plant_name = PLANT_NAME,
    category = CRAFTING_CATEGORY,
    science_recipes = solar_precision_science_recipes
}
