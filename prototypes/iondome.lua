local dome = table.deepcopy(data.raw["accumulator"]["accumulator"])

dome.name = "ion-dome"
dome.minable = { mining_time = 1, result = "ion-dome" }
dome.max_health = 500

-- Nur Energieverbrauch, kein Output
dome.energy_source = {
  type = "electric",
  usage_priority = "secondary-input",
  buffer_capacity = "10MJ",
  input_flow_limit = "500kW",
  output_flow_limit = "0W",
}
dome.charge_cooldown = 30
dome.discharge_cooldown = 0

dome.radius_visualisation_specification = {
  sprite = {
    filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
    size = 10,
  },
  distance = 24,
  draw_in_cursor = true,
  draw_on_selection = true,
}

-- Grafik
dome.icon = "__factorio_planet_mod__/assets/ion_dome_icon.png"
dome.icon_size = 318
dome.icons = nil

dome.chargable_graphics = {
  picture = {
    filename = "__factorio_planet_mod__/assets/ion_dome.png",
    width = 458,
    height = 458,
    scale = 0.22,
    shift = { 0.31, 0 },
  },
  charge_animation = nil,
  discharge_animation = nil,
  charge_cooldown = 30,
  discharge_cooldown = 0,
}

local item = {
  type = "item",
  name = "ion-dome",
  icon = "__factorio_planet_mod__/assets/ion_dome_icon.png",
  icon_size = 318,
  subgroup = "defensive-structure",
  order = "b[ion-dome]",
  place_result = "ion-dome",
  stack_size = 5,
}

local recipe = {
  type = "recipe",
  name = "ion-dome",
  enabled = true,
  energy_required = 10,
  ingredients = {
    { type = "item", name = "processing-unit",  amount = 10 },
    { type = "item", name = "SiliconIngot",     amount = 20 },
    { type = "item", name = "glass",            amount = 15 },
    { type = "item", name = "concrete",         amount = 5  },
    { type = "item", name = "steel-plate",      amount = 50 },
  },
  results = { { type = "item", name = "ion-dome", amount = 1 } },
}

data:extend({ dome, item, recipe })
