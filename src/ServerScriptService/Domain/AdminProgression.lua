--!strict
-- Only Bootstrap supplies authorization, derived from the creator/server allowlist.
-- This explicit admin override never runs through normal potion advancement.
local Admin={}
function Admin.Apply(domain: any,state: any,pathway: any,sequence: any,now: number,authorized: boolean): (boolean,string)
    if authorized~=true then return false,"Admin access required" end
    if not state or not state.Ready or state.Dead then return false,"Wait until your character is alive and loaded" end
    if type(pathway)~="string" or #pathway>80 or not domain.Data.Pathways[pathway]
        or not domain.Finite(sequence) or sequence%1~=0 or not domain.Data.Pathways[pathway].Sequences[sequence] then
        return false,"Choose a valid pathway and Sequence 9–1"
    end
    local profile=domain:Snapshot(state)
    profile.PathwayId=pathway;profile.Sequence=sequence
    profile.Digestion=domain.Data.Progression.Digestion.Default
    profile.ActingProgress=domain.Data.Progression.Acting.Default
    profile.ObjectiveProgress={};profile.AbilityLoadout={};profile.Sanity=domain.Data.Progression.Sanity.Max
    local replacement=domain:NewState(profile,now)
    domain:AutoEquip(replacement)
    local serial=state.CastSerial
    -- Keep this state table and its save/movement bookkeeping: autosave callbacks
    -- and Humanoid callbacks can already reference it. Appearance restoration
    -- metadata is retained for EffectService.Step after statuses are cleared.
    for key,value in pairs(replacement) do state[key]=value end
    state.Pending=nil;state.RecordedPower=nil;state.StolenPower=nil;state.AltarTicket=nil
    state.ArchiveRead=nil;state.SecretUntil=nil;state.FailureApplied=false
    state.CastSerial=serial+1
    return true,"Admin: "..pathway.." · Sequence "..sequence.." · "..domain.Data.Pathways[pathway].Sequences[sequence].Name
end
return table.freeze(Admin)
