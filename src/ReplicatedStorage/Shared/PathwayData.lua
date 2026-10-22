--!strict
local freeze = require(script.Parent.Freeze)
local Types = require(script.Parent.Types)
local byId: {[string]: Types.Pathway} = {}
-- Adding a pathway requires only a ModuleScript in Pathways with this schema.
for _, module in ipairs(script.Parent.Pathways:GetChildren()) do
    if module:IsA("ModuleScript") then
        local pathway = require(module) :: Types.Pathway
        assert(type(pathway.Id) == "string" and byId[pathway.Id] == nil, "Invalid or duplicate pathway ID")
        assert(pathway.Sequences[0] == nil, "Sequence 0 is unavailable")
        for n=1,9 do
            assert(pathway.Sequences[n] and pathway.Sequences[n].Number == n, "Missing sequence")
        end
        byId[pathway.Id] = pathway
    end
end
return freeze(byId)
