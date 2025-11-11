--data.lua
require("__test-mod__.planet.planet")
require("__test-mod__.technology")




local assemblingMachine4 = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"]) -- copy the table that defines the heavy armor item into the fireArmor variable

assemblingMachine4.name = "assembling-machine-4" -- change the name of the new item
assemblingMachine4.icon = nil
assemblingMachine4.icon_size = nil
assemblingMachine4.icons = {
  {
    icon = data.raw["assembling-machine"]["assembling-machine-3"].icon,
    icon_size = data.raw["assembling-machine"]["assembling-machine-3"].icon_size,
    tint = {r = 1, g = 0, b = 0, a = 1},  -- reines Rot
  },
}


-- edit properties like crafting speed etc of the new item
assemblingMachine4.crafting_speed = 2.0

-- create the recipe prototype from scratch
local recipe = {
  type = "recipe",
  name = "assembling-machine-4",
  enabled = true,
  energy_required = 8, -- time to craft in seconds (at crafting speed 1)
  ingredients = {
    {type = "item", name = "assembling-machine-3", amount = 1},
    {type = "item", name = "speed-module-2", amount = 2}
  },
  results = {{type = "item", name = "assembling-machine-4", amount = 1}}
}

-- add the item for the machine 4
local item = {
  type = "item",
  name = "assembling-machine-4",
  icons = assemblingMachine4.icons,           -- kopiert die Tabelle direkt
  icon_size = assemblingMachine4.icons[1].icon_size,  -- wichtig!
  subgroup = "production-machine",
  order = "a[assembling-machine-4]",
  place_result = "assembling-machine-4",
  stack_size = 50
}


data:extend{assemblingMachine4, item, recipe}
