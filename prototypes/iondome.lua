-- Ion Dome: Roboport als Basis, schützt Gebäude und Spieler vor Sandstürmen.
-- Roboter-Logik ist deaktiviert (Radien auf 0). Schutzradius wird in scripts/iondome.lua definiert.

local roboport = table.deepcopy(data.raw["roboport"]["roboport"])

roboport.name = "ion-dome"
roboport.minable = { mining_time = 1, result = "ion-dome" }

-- Keine Roboter
roboport.logistics_radius = 24  -- Schutzradius (24 tiles = 48x48 Fläche)
roboport.construction_radius = 0
roboport.robot_slots_count = 1
roboport.material_slots_count = 0
roboport.spawn_and_station_height = 0
roboport.spawn_and_station_shadow_height_offset = 0
roboport.stationing_offset = { 0, 0 }
roboport.recharge_minimum = "10MJ"
roboport.request_to_open_door_timeout = 0
roboport.draw_logistic_radius_visualization = true    -- zeigt Radius beim Hovern und Platzieren
roboport.draw_construction_radius_visualization = false

-- Höherer Energieverbrauch als normaler Roboport
roboport.energy_usage = "500kW"
roboport.energy_source = {
  type = "electric",
  usage_priority = "secondary-input",
  buffer_capacity = "10MJ",
  input_flow_limit = "1MW",
}

-- Icons
roboport.icons = {
  {
    icon = data.raw["roboport"]["roboport"].icon,
    icon_size = data.raw["roboport"]["roboport"].icon_size,
    tint = { r = 0.2, g = 0.6, b = 1.0, a = 1.0 },
  }
}
roboport.icon = nil
roboport.icon_size = nil

local item = {
  type = "item",
  name = "ion-dome",
  icons = roboport.icons,
  icon_size = roboport.icons[1].icon_size,
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
    { type = "item", name = "roboport",         amount = 1 },
    { type = "item", name = "processing-unit",  amount = 10 },
    { type = "item", name = "steel-plate",      amount = 20 },
    { type = "item", name = "glass",            amount = 10 },
  },
  results = { { type = "item", name = "ion-dome", amount = 1 } },
}

data:extend({ roboport, item, recipe })
