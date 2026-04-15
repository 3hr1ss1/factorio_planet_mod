local planet_map_gen = require("__space-age__/prototypes/planet/planet-map-gen")

--PLANET MAP GEN
planet_map_gen.mithras = function()
  local tile_settings = {}
  local has_custom_mithras_tiles = false
  local entity_settings = {}

  -- Prefer custom Mithras desert tiles when they exist.
  -- Only fall back to Fulgora tiles if none of the custom tiles are present.
  if data and data.raw and data.raw.tile then
    local function add_custom_tile(tile_name)
      if data.raw.tile[tile_name] then
        tile_settings[tile_name] = {}
        has_custom_mithras_tiles = true
      end
    end

    add_custom_tile("mithras-desert")
    add_custom_tile("mithras-desert-0")
    add_custom_tile("mithras-desert-1")
    add_custom_tile("mithras-desert-2")
    add_custom_tile("mithras-desert-3")
    add_custom_tile("mithras-dunes")
    add_custom_tile("mithras-rock")
  end

  if not has_custom_mithras_tiles then
    tile_settings["fulgoran-sand"] = {}
    tile_settings["fulgoran-dunes"] = {}
    tile_settings["fulgoran-dust"] = {}
    tile_settings["fulgoran-rock"] = {}
  end

  entity_settings["big-fulgora-rock"] = {}

  -- Follow Muluna's guarded autoplace style: only include tree entities that exist.
  if data and data.raw and data.raw.tree then
    local dead_tree_candidates =
    {
      "dead-dry-hairy-tree",
      "dry-hairy-tree",
      "dead-grey-trunk",
      "dead-tree-desert"
    }

    for _, tree_name in pairs(dead_tree_candidates) do
      if data.raw.tree[tree_name] then
        entity_settings[tree_name] =
        {
          frequency = 0.25,
          size = 0.4,
          richness = 0.3
        }
      end
    end
  end

  return
  {
    property_expression_names =
    {
      elevation = "fulgora_elevation",
      temperature = "temperature_basic",
      moisture = "moisture_basic",
      aux = "aux_basic",
      cliffiness = "fulgora_cliffiness * 0.55",
      cliff_elevation = "cliff_elevation_from_elevation",
    },
    cliff_settings =
    {
      name = "cliff-fulgora",
      control = "fulgora_cliff",
      cliff_elevation_0 = 80,
      -- Ideally the first cliff would be at elevation 0 on the coastline, but that doesn't work,
      -- so instead the coastline is moved to elevation 80.
      -- Also there needs to be a large cliff drop at the coast to avoid the janky cliff smoothing
      -- but it also fails if a corner goes below zero, so we need an extra buffer of 40.
      -- So the first cliff is at 80, and terrain near the cliff shouln't go close to 0 (usually above 40).
      cliff_elevation_interval = 60,
      cliff_smoothing = 0, -- This is critical for correct cliff placement on the coast.
      richness = 0.45
    },
    autoplace_controls =
    {
      -- Keep this for compatibility with Fulgora cliff control.
      ["fulgora_cliff"] = {},
    },
    autoplace_settings =
    {
      ["tile"] =
      {
        settings = tile_settings
      },
      ["decorative"] =
      {
        settings =
        {
          -- Keep sparse, natural desert clutter.
          ["urchin-cactus"] = {},
          ["medium-fulgora-rock"] = {},
          ["small-fulgora-rock"] = {},
          ["tiny-fulgora-rock"] = {},
        }
      },
      ["entity"] =
      {
        settings = entity_settings
      }
    }
  }
end

return planet_map_gen