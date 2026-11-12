-- Fills each openable with the defaults from Config.Defaults so client and
-- server can read every field directly.
local defaults = Config.Defaults

for name, entry in pairs(Config.Openables) do
    local prop = type(entry.prop) == 'string' and { model = entry.prop } or entry.prop or {}

    if not prop.model then
        lib.print.warn(('openable "%s" has no prop model'):format(name))
    end

    entry.prop = {
        model = prop.model,
        bone = prop.bone or defaults.prop.bone,
        pos = prop.pos or defaults.prop.pos,
        rot = prop.rot or defaults.prop.rot,
    }
    entry.anim = entry.anim or defaults.anim
    entry.duration = entry.duration or defaults.duration
    entry.rewards = entry.rewards or {}
end
