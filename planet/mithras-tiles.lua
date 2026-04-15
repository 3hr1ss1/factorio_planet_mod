local function mithras_tile_variations(texture_file)
  return tile_variations_template(
    texture_file,
    "__base__/graphics/terrain/masks/transition-3.png",
    {
      max_size = 4,
      [1] = {weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045}},
      [2] = {probability = 1, weights = {0.070, 0.070, 0.025, 0.070, 0.070, 0.070, 0.007, 0.025, 0.070, 0.050, 0.015, 0.026, 0.030, 0.005, 0.070, 0.027}},
      [4] = {probability = 1, weights = {0.070, 0.070, 0.070, 0.070, 0.070, 0.070, 0.015, 0.070, 0.070, 0.070, 0.015, 0.050, 0.070, 0.070, 0.065, 0.070}},
    }
  )
end

local function create_mithras_tile(new_tile_name, texture_file, map_color, layer, noise_index)
  local source_tile = data.raw.tile["dry-dirt"] or data.raw.tile["sand-1"]
  if not source_tile then return nil end

  local tile = table.deepcopy(source_tile)
  tile.name = new_tile_name
  tile.localised_name = {"tile-name." .. new_tile_name}
  tile.map_color = map_color
  tile.variants = mithras_tile_variations(texture_file)
  tile.layer = layer or tile.layer
  tile.autoplace =
  {
    probability_expression = "expression_in_range_base(0.45, -10, 0.55, 0.35) + 0.25*noise_layer_noise(" .. tostring(noise_index or 1) .. ")"
  }
  tile.destroys_dropped_items = true

  return tile
end

local mithras_tiles = {
  create_mithras_tile("mithras-desert-0", "__factorio_planet_mod__/assets/mithras-desert-0.png", {r = 114, g = 100, b = 50}, 40, 1),
  create_mithras_tile("mithras-desert-1", "__factorio_planet_mod__/assets/mithras-desert-1.png", {r = 150, g = 136, b = 52}, 41, 2),
  create_mithras_tile("mithras-desert-2", "__factorio_planet_mod__/assets/mithras-desert-2.png", {r = 117, g = 114, b = 88}, 42, 3),
  create_mithras_tile("mithras-desert-3", "__factorio_planet_mod__/assets/mithras-desert-3.png", {r = 109, g = 102, b = 53}, 43, 4),
  create_mithras_tile("mithras-desert", "__factorio_planet_mod__/assets/mithras-desert-0.png", {r = 125, g = 112, b = 57}, 44, 5)
}

local filtered_tiles = {}
for _, tile in pairs(mithras_tiles) do
  if tile then table.insert(filtered_tiles, tile) end
end

if #filtered_tiles > 0 then
  data:extend(filtered_tiles)
end
