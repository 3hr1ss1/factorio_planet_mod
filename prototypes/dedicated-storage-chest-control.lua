-- Dedicated storage chest runtime logic (single-item-type enforcement).
-- Exposed as a module and wired through control.lua's central event handlers so it
-- coexists with the sandstorm and solar-oven handlers instead of overwriting them.
local dedicated_storage = {}

local chest_name = "dedicated-storage-chest"
local tick_interval = 10

local function ensure_state()
    storage.dedicated_storage = storage.dedicated_storage or {}
end

-- Eject a mismatched stack onto the ground without destroying its contents.
local function eject_stack(entity, stack)
    local surface = entity.surface
    if not (surface and stack and stack.valid_for_read) then return end
    surface.spill_item_stack({
        position = entity.position,
        stack = stack,
        enable_looted = false,
        force = entity.force,
    })
end

-- Keep the logistic storage filter in sync with the locked item so robots only
-- deposit the matching item (instead of dumping wrong items we then eject in a loop).
-- Pass nil to clear the filter when the chest empties.
local function set_storage_filter(entity, item_name)
    pcall(function() entity.storage_filter = item_name end)
end

local function track(entity)
    if not (entity and entity.valid) then return end
    if entity.name ~= chest_name then return end
    ensure_state()
    storage.dedicated_storage[entity.unit_number] = {
        entity = entity,
        item_name = nil,
    }
end

local function untrack(entity)
    if not (entity and entity.valid) then return end
    if entity.name ~= chest_name then return end
    ensure_state()
    storage.dedicated_storage[entity.unit_number] = nil
end

local function manage_chest(entry)
    local entity = entry.entity
    if not (entity and entity.valid) then return false end

    local inv = entity.get_inventory(defines.inventory.chest)
    if not (inv and inv.valid) then return true end

    local locked_item = entry.item_name
    local is_empty = true

    if not locked_item then
        -- First item to arrive becomes the locked type.
        for i = 1, #inv do
            local stack = inv[i]
            if stack.valid_for_read then
                locked_item = stack.name
                entry.item_name = locked_item
                set_storage_filter(entity, locked_item)
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
                    eject_stack(entity, stack)
                    stack.clear()
                end
            end
        end
    end

    if is_empty and entry.item_name then
        -- Chest emptied: release the lock and filter so it can be repurposed.
        entry.item_name = nil
        set_storage_filter(entity, nil)
    end

    return true
end

function dedicated_storage.on_init()
    ensure_state()
    for _, surface in pairs(game.surfaces) do
        for _, entity in pairs(surface.find_entities_filtered({ name = chest_name })) do
            track(entity)
        end
    end
end

-- Rebuild the index on config changes so existing chests survive mod updates.
dedicated_storage.on_configuration_changed = dedicated_storage.on_init

function dedicated_storage.on_built(entity)
    track(entity)
end

function dedicated_storage.on_removed(entity)
    untrack(entity)
end

function dedicated_storage.on_tick(tick)
    if (tick % tick_interval) ~= 0 then return end
    ensure_state()
    for unit, entry in pairs(storage.dedicated_storage) do
        if not manage_chest(entry) then
            storage.dedicated_storage[unit] = nil
        end
    end
end

return dedicated_storage
