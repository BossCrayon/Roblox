--!strict
-- Return deeply immutable configuration. Never put live player state in these tables.
local function freeze(value: any): any
    if type(value) == "table" and not table.isfrozen(value) then
        for _, child in pairs(value) do
            freeze(child)
        end
        table.freeze(value)
    end
    return value
end
return freeze
