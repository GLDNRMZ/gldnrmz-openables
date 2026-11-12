-- The server asks for the opening animation; the answer (finished or
-- cancelled) decides whether the item is consumed.
lib.callback.register('gldnrmz-openables:open', function(itemName, label)
    local openable = Config.Openables[itemName]
    if not openable then return false end

    local prop = openable.prop

    return lib.progressBar({
        duration = openable.duration or Config.Defaults.duration,
        label = Config.Defaults.label:format(label),
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, combat = true, car = false },
        anim = { dict = openable.anim.dict, clip = openable.anim.clip, flag = openable.anim.flag },
        prop = prop.model and { model = prop.model, bone = prop.bone, pos = prop.pos, rot = prop.rot } or nil,
    })
end)
