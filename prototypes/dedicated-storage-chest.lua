-- Dedicated storage chest: a logistic "storage" chest (bots deposit/withdraw) that the
-- runtime locks to a single item type with near-infinite capacity.
local base_chest = (data.raw["logistic-container"] or {})["storage-chest"]
if not base_chest then
    error("dedicated-storage-chest: missing base storage-chest prototype")
end

local chest = table.deepcopy(base_chest)
chest.name = "dedicated-storage-chest"
chest.icon = "__base__/graphics/icons/storage-chest.png"
chest.icon_size = 64
chest.icons = {
    {
        icon = chest.icon,
        icon_size = chest.icon_size,
        tint = { r = 0.2, g = 0.8, b = 0.2, a = 1.0 },
    },
}
chest.minable = { mining_time = 0.2, result = "dedicated-storage-chest" }
chest.inventory_size = 2000
chest.max_health = 350

local item = {
    type = "item",
    name = "dedicated-storage-chest",
    icons = chest.icons,
    icon_size = chest.icon_size,
    subgroup = "storage",
    order = "b[storage]-d[dedicated-storage-chest]",
    place_result = "dedicated-storage-chest",
    stack_size = 50,
}

local recipe = {
    type = "recipe",
    name = "dedicated-storage-chest",
    enabled = true,
    ingredients = {
        { type = "item", name = "steel-chest", amount = 1 },
        { type = "item", name = "advanced-circuit", amount = 5 },
    },
    results = { { type = "item", name = "dedicated-storage-chest", amount = 1 } },
}

data:extend({ chest, item, recipe })
