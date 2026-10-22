--!strict
-- Pure authorization and altar-ticket rules. No client-supplied developer flag is trusted.
local Access={}
function Access.IsDeveloper(userId: number,creatorId: number,individualCreator: boolean,admins: {number}): boolean
    if userId>0 and individualCreator and userId==creatorId then return true end
    for _,id in ipairs(admins) do if id>0 and id==userId then return true end end
    return false
end
function Access.AltarValid(ticket: any,now: number,distance: number,pathway: any,sequence: any,radius: number): boolean
    return type(ticket)=="table" and type(ticket.ExpiresAt)=="number" and now<=ticket.ExpiresAt and distance==distance and distance>=0 and distance<=radius
        and ticket.PathwayId==pathway and ticket.Sequence==sequence
end
return table.freeze(Access)
