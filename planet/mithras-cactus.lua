local util = require("__core__.lualib.util")

local function make_cactus_variation(filename)
  return
  {
    filename = filename,
    width = 80,
    height = 80,
    frame_count = 1,
    shift = util.by_pixel(0, -8),
    scale = 1.25
  }
end

local source_tree = data.raw.tree["dead-dry-hairy-tree"] or data.raw.tree["dry-hairy-tree"]
if not source_tree then
  return
end

local mithras_cactus = table.deepcopy(source_tree)
mithras_cactus.name = "mithras-cactus"
mithras_cactus.localised_name = {"entity-name.mithras-cactus"}
mithras_cactus.minable =
{
  mining_particle = "wooden-particle",
  mining_time = 0.5,
  results = {{type = "item", name = "wood", amount_min = 3, amount_max = 5}}
}
mithras_cactus.autoplace =
{
  probability_expression = "control:trees:size * control:trees:frequency * (0.004 + 0.004 * clamp(noise_layer_noise(17) - 0.75, 0, 1))",
  richness_expression = "control:trees:richness"
}
mithras_cactus.pictures =
{
  make_cactus_variation("__factorio_planet_mod__/assets/cactus_plain_80x80.png"),
  make_cactus_variation("__factorio_planet_mod__/assets/cactus_onearm_80x80.png"),
  make_cactus_variation("__factorio_planet_mod__/assets/cactus_flower_80x80.png"),
  make_cactus_variation("__factorio_planet_mod__/assets/cactus_factorio_80x80.png")
}

data:extend({mithras_cactus})
