local planet_map_gen = require("__space-age__/prototypes/planet/planet-map-gen")

--PLANET MAP GEN
planet_map_gen.mithras = function()
  local tile_settings = {}
  local has_custom_mithras_tiles = false

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

  return
  {
    property_expression_names =
    {
      elevation = "fulgora_elevation",
      temperature = "temperature_basic",
      moisture = "moisture_basic",
      aux = "aux_basic",
      cliffiness = "fulgora_cliffiness",
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
      cliff_elevation_interval = 40,
      cliff_smoothing = 0, -- This is critical for correct cliff placement on the coast.
      richness = 0.95
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
        settings =
        {
          -- Mithras should feel like open desert, not a ruin scrapyard.
          ["big-fulgora-rock"] = {}
        }
      }
    }
  }
end

return planet_map_gen