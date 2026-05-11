local chest_name = "dedicated-storage-chest"
local tick_interval = 10

local function ensure_global()
    if not global then
        global = {}
    end
    global.dedicated_storage = global.dedicated_storage or {}
end

local function spill_stack(surface, stack)
    if not (surface and stack and stack.valid_for_read) then return end
    local ok = pcall(function() surface.spill_item_stack(stack) end)
    if not ok then
        pcall(function() surface.spill_item_stack(surface, stack) end)
    end
end

local function rebuild_index()
    ensure_global()
    global.dedicated_storage = {}
    for _, surface in pairs(game.surfaces) do
        local entities = surface.find_entities_filtered({ name = chest_name })
        for _, entity in pairs(entities) do
            global.dedicated_storage[entity.unit_number] = {
                entity = entity,
                item_name = nil,
            }
        end
    end
end

local function track_entity(entity)
    if not (entity and entity.valid) then return end
    if entity.name ~= chest_name then return end
    ensure_global()
    global.dedicated_storage[entity.unit_number] = {
        entity = entity,
        item_name = nil,
    }
end

local function untrack_entity(entity)
    if not (entity and entity.valid) then return end
    if entity.name ~= chest_name then return end
    ensure_global()
    global.dedicated_storage[entity.unit_number] = nil
end

local function manage_chest(entry)
    local entity = entry.entity
    if not (entity and entity.valid) then return false end

    local inv = entity.get_inventory(defines.inventory.chest)
    if not (inv and inv.valid) then return true end

    local locked_item = entry.item_name
    local is_empty = true

    if not locked_item then
        -- Find the first item to lock it
        for i = 1, #inv do
            local stack = inv[i]
            if stack.valid_for_read then
                locked_item = stack.name
                entry.item_name = locked_item
                is_empty = false
                break
            end
        end
    end

    if locked_item then
        for i = 1, #inv do
            local stack = inv[i]
            if stack.valid_for_read then
                is_empty = false
                if stack.name ~= locked_item then
                    spill_stack(entity.surface, stack)
                    stack.clear()
                end
            end
        end
    end

    if is_empty then
        entry.item_name = nil
    end

    return true
end

script.on_init(rebuild_index)
script.on_configuration_changed(rebuild_index)

script.on_event({
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.script_raised_built,
    defines.events.script_raised_revive,
}, function(event)
    track_entity(event.created_entity or event.entity)
end)

script.on_event({
    defines.events.on_pre_player_mined_item,
    defines.events.on_robot_pre_mined,
    defines.events.on_entity_died,
    defines.events.script_raised_destroy,
}, function(event)
    untrack_entity(event.entity)
end)

script.on_event(defines.events.on_tick, function(event)
    if (event.tick % tick_interval) ~= 0 then return end
    ensure_global()
    for unit, entry in pairs(global.dedicated_storage) do
        if not manage_chest(entry) then
            global.dedicated_storage[unit] = nil
        end
    end
end)