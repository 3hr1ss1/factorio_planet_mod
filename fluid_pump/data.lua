-- TODO: So this wont work.
-- BUT... Its quite posible to generate a temporary entity, then create a miner or pump
-- at the position and spawn water or ore on the ground beneeth it. Unspawn the water or ore on destruction.

local realFluidPump = table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
realFluidPump.name = "fluid-pump"
realFluidPump.placeable_by = { item = "fluid-pump-fake", count = 1 }
realFluidPump.minable = {
    mining_time = 0.1,
    result = "fluid-pump-fake",
}
realFluidPump.flags = {
    "placeable-neutral",
    "player-creation",
}

local fluidPump = table.deepcopy(data.raw["pump"]["pump"])
fluidPump.name = "fluid-pump-fake"

-- ITEM
local fluidPumpItem = table.deepcopy(data.raw["item"]["pump"])
fluidPumpItem.name = "fluid-pump-fake"
fluidPumpItem.place_result = "fluid-pump-fake"
-- fluidPumpItem.icon.tint = { r = 0, g = 1, b = 0, a = 0.3 }

local recipe = {
    type = "recipe",
    name = "fluid-pump-fake",
    enabled = true,
    ingredients = {
        { type = "item", name = "copper-plate", amount = 200 },
        { type = "item", name = "steel-plate", amount = 50 },
    },
    results = { { type = "item", name = "fluid-pump-fake", amount = 1 } },
}

data:extend({ fluidPumpItem, fluidPump, realFluidPump, recipe })
