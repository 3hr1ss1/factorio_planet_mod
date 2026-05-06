local shortInserter = table.deepcopy(data.raw["inserter"]["long-handed-inserter"])

-- ENTITY
local shortInserter = table.deepcopy(data.raw["inserter"]["long-handed-inserter"])
shortInserter.name = "short-handed-inserter"
shortInserter.pickup_position = { 0, -1 }
shortInserter.insert_position = { 0, 0.8 }
shortInserter.minable = { mining_time = 0.1, result = "short-handed-inserter" }
shortInserter.placeable_by = { item = "short-handed-inserter", count = 1 }
shortInserter.icon =
    "__factorio_planet_mod__/assets/short-handed-inserter/short-handed-inserter_icon.png"
shortInserter.hand_base_picture.filename =
    "__factorio_planet_mod__/assets/short-handed-inserter/short-handed-inserter-hand-base.png"
shortInserter.hand_closed_picture.filename =
    "__factorio_planet_mod__/assets/short-handed-inserter/short-handed-inserter-hand-closed.png"
shortInserter.hand_open_picture.filename =
    "__factorio_planet_mod__/assets/short-handed-inserter/short-handed-inserter-hand-open.png"
-- shortInserter.hand_base_shadow.filename =
--     "__factorio_planet_mod__/assets/short-handed-inserter/short-handed-inserter-hand-open.png"
-- shortInserter.hand_closed_shadow.filename =
--     "__factorio_planet_mod__/assets/short-handed-inserter/short-handed-inserter-hand-closed.png"
-- shortInserter.hand_open_shadow.filename =
--     "__factorio_planet_mod__/assets/short-handed-inserter/short-handed-inserter-hand-open.png"
shortInserter.platform_picture.sheet.filename =
    "__factorio_planet_mod__/assets/short-handed-inserter/short-handed-inserter-platform.png"

-- ITEM
local shortInserterItem = table.deepcopy(data.raw["item"]["long-handed-inserter"])
shortInserterItem.name = "short-handed-inserter"
shortInserterItem.place_result = "short-handed-inserter"

shortInserterItem.icons = {
    {
        icon = shortInserterItem.icon,
        icon_size = shortInserterItem.icon_size,
        -- tint = { r = 0, g = 1, b = 0, a = 0.3 },
    },
}

local recipe = {
    type = "recipe",
    name = "short-handed-inserter",
    enabled = true,
    ingredients = {
        { type = "item", name = "copper-plate", amount = 200 },
        { type = "item", name = "steel-plate", amount = 50 },
    },
    results = { { type = "item", name = "short-handed-inserter", amount = 1 } },
}

data:extend({ shortInserterItem, shortInserter, recipe })
