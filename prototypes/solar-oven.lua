-- Solar Oven
-- Dependant on the time of day, like solar panels.
-- Has a base productivity of 50% and 4 module slots.

local solar_oven = table.deepcopy(data.raw["furnace"]["electric-furnace"])

solar_oven.name = "solar-oven"
solar_oven.icon = nil
solar_oven.icons = {
    {
        icon = "__factorio_planet_mod__/assets/solar-oven-icon.png",
        icon_size = 612 -- using height to square it off roughly
    }
}
solar_oven.crafting_speed = 4
solar_oven.effect_receiver = {
    base_effect = {
        productivity = 0.5
    }
}
solar_oven.module_slots = 4
solar_oven.allowed_effects = {"speed", "productivity", "consumption", "pollution", "quality"}

solar_oven.energy_source = {
    type = "void",
}
solar_oven.energy_usage = "1W"

local oven_sprite_on = {
    filename = "__factorio_planet_mod__/assets/solar-oven.png",
    priority = "high",
    width = 669,
    height = 612,
    frame_count = 1,
    shift = {0, 0.05},
    scale = 0.175,
}

local oven_sprite_off = {
    filename = "__factorio_planet_mod__/assets/solar-oven-off.png",
    priority = "high",
    width = 669,
    height = 612,
    frame_count = 1,
    shift = {0, 0.05},
    scale = 0.175,
}

solar_oven.graphics_set = {
    animation = {
        layers = { oven_sprite_on }
    },
    idle_animation = {
        layers = { oven_sprite_off }
    },
}

solar_oven.working_visualisations = nil
solar_oven.water_reflection = nil

local solar_oven_item = {
    type = "item",
    name = "solar-oven",
    icon = "__factorio_planet_mod__/assets/solar-oven-icon.png",
    icon_size = 612,
    subgroup = "smelting-machine",
    order = "b[furnace]-b[solar-oven]",
    place_result = "solar-oven",
    stack_size = 50
}

local solar_oven_recipe = {
    type = "recipe",
    name = "solar-oven",
    ingredients = {
        {type="item", name="electric-furnace", amount=2},
        {type="item", name="speed-module", amount=2},
        {type="item", name="glass", amount=10},
        {type="item", name="SiliconIngot", amount=5}
    },
    results = {
        {type="item", name="solar-oven", amount=1}
    },
    enabled = false
}

data:extend({solar_oven, solar_oven_item, solar_oven_recipe})
