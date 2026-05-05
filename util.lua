local util = {}

function util.item(item, quantity, probability)
    if not quantity then
        quantity = 1
    end
    if probability then
        return { type = "item", name = item, amount = quantity, probability = probability }
    else
        return { type = "item", name = item, amount = quantity }
    end
end

return util
