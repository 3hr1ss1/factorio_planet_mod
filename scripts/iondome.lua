local iondome = {}

local ION_DOME_RADIUS = 24 -- tiles (= 48x48 Fläche)

function iondome.is_protected(surface, position)
  local domes = surface.find_entities_filtered({
    name = "ion-dome",
    area = {
      { position.x - ION_DOME_RADIUS, position.y - ION_DOME_RADIUS },
      { position.x + ION_DOME_RADIUS, position.y + ION_DOME_RADIUS },
    }
  })
  for _, dome in pairs(domes) do
    if dome.valid and dome.energy > 0 then
      local dx = position.x - dome.position.x
      local dy = position.y - dome.position.y
      if (dx * dx + dy * dy) <= ION_DOME_RADIUS * ION_DOME_RADIUS then
        return true
      end
    end
  end
  return false
end

return iondome
