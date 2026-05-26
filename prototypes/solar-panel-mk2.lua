local solarPanel2Item = table.deepcopy(data.raw["item"]["solar-panel"])
solarPanel2Item.name = "solar-panel-mk2"
solarPanel2Item.order = "d[solar-panel]-b[solar-panel-mk2]"
solarPanel2Item.place_result = "solar-panel-mk2"

local solarPanel2Entity = table.deepcopy(data.raw["solar-panel"]["solar-panel"])
solarPanel2Entity.name = "solar-panel-mk2"
solarPanel2Entity.minable.result = "solar-panel-mk2"
solarPanel2Entity.production = "300kW"

local solarPanel2Recipe = {
    type = "recipe",
    name = "solar-panel-mk2",
    energy_required = 10,
    enabled = false,
    ingredients = {
        { type = "item", name = "glass", amount = 15 },
        { type = "item", name = "solar-panel", amount = 1 },
        { type = "item", name = "efficiency-module", amount = 2 }
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