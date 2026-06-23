local item_sounds

if require and table.deepcopy then
    -- basic fallback for sounds if item_sounds isn't globally available here
end

data:extend(
{
  {
    type = "tool",
    name = "laser-science-pack",
    icon = "__factorio_planet_mod__/assets/laser-science-pack.png",
    icon_size = 64,
    subgroup = "science-pack",
    order = "s[laser-science-pack]",
    stack_size = 200,
    weight = 1000, -- 1 kg
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount-key",
    factoriopedia_durability_description_key = "description.factoriopedia-science-pack-remaining-amount-key",
    durability_description_value = "description.science-pack-remaining-amount-value"
  },
  {
    type = "recipe",
    name = "laser-science-pack",
    enabled = false,
    energy_required = 10,
    ingredients =
    {
      { type = "item", name = "glass",       amount = 5 },
      { type = "item", name = "SiliconIngot", amount = 2 }
    },
    results = {{ type = "item", name = "laser-science-pack", amount = 1 }},
    allow_productivity = true
  }
}
)
