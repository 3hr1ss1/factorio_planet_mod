local solarPanel2Texture = "__factorio_planet_mod__/assets/solar_panel_mk2.png"

local solarPanel2Item = table.deepcopy(data.raw["item"]["solar-panel"])
solarPanel2Item.name = "solar-panel-mk2"
solarPanel2Item.order = "d[solar-panel]-b[solar-panel-mk2]"
solarPanel2Item.place_result = "solar-panel-mk2"
solarPanel2Item.icon = solarPanel2Texture
solarPanel2Item.icon_size = 512
solarPanel2Item.icons = nil

local solarPanel2Entity = table.deepcopy(data.raw["solar-panel"]["solar-panel"])
solarPanel2Entity.name = "solar-panel-mk2"
solarPanel2Entity.minable.result = "solar-panel-mk2"
solarPanel2Entity.production = "300kW"
solarPanel2Entity.icon = solarPanel2Texture
solarPanel2Entity.icon_size = 512
solarPanel2Entity.icons = nil
solarPanel2Entity.picture = {
    layers = {
        {
            filename = solarPanel2Texture,
            priority = "high",
            width = 512,
            height = 512,
            scale = 0.24,
            shift = { -0.4, -0.4 },
        }
    }
}
-- New texture bakes in its own shading, so drop the inherited overlay/shadow layers.
solarPanel2Entity.overlay = nil

local solarPanel2Recipe = {
    type = "recipe",
    name = "solar-panel-mk2",
    energy_required = 10,
    enabled = false,
    ingredients = {
        { type = "item", name = "solar-panel", amount = 5 },
        { type = "item", name = "efficiency-module", amount = 5 },
        { type = "item", name = "glass", amount = 25 },
        { type = "item", name = "SiliconIngot", amount = 5 }
    },
    results = {
        { type = "item", name = "solar-panel-mk2", amount = 1 }
    }
}

data:extend({
    solarPanel2Item,
    solarPanel2Entity,
    solarPanel2Recipe
})