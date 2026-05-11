-- nuclear artillery shell
local nuclear_artillery_projectile = table.deepcopy(data.raw["artillery-projectile"]["artillery-projectile"])
nuclear_artillery_projectile.name = "nuclear-artillery-projectile"

for k, v in pairs(data.raw["projectile"]["atomic-rocket"].action.action_delivery.target_effects) do
	table.insert(nuclear_artillery_projectile.action.action_delivery.target_effects, v)
    table.insert(nuclear_artillery_projectile.final_action.action_delivery.target_effects, v)
end

local nuclear_artillery_shell = table.deepcopy(data.raw["ammo"]["artillery-shell"])
nuclear_artillery_shell.name = "nuclear-artillery-shell"
nuclear_artillery_shell.ammo_type.action.action_delivery.projectile = "nuclear-artillery-projectile"


data:extend(
	{
		nuclear_artillery_projectile,
		nuclear_artillery_shell,
		{
			type = "recipe",
			name = "nuclear-artillery-shell",
			enabled = false,
			ingredients =
			{
				{type="item", name="artillery-shell", amount=1},
				{type="item", name="SiliconIngot", amount=30},
				{type="item", name="atomic-bomb", amount=1}
			},
			results = {
				{type="item", name="nuclear-artillery-shell", amount=1}
			}
		}
	}
)
