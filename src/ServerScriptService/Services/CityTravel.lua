--!strict
local Registry=require(game:GetService("ReplicatedStorage").Shared.CityDestinations)
local Layout=require(game:GetService("ReplicatedStorage").Shared.TingenLayout)
local Travel={}
function Travel.Check(domain: any,s: any,id: any,now: number): (boolean,string)
    if type(id)~="string" or #id>20 or not Registry.ById[id] then return false,"Choose a named city destination" end
    if not s or not s.Profile or s.Profile.PathwayId~="Apprentice" then return false,"City travel requires the Door pathway" end
    local ok,message=domain:CanMove(s,now)
    if not ok then return false,message or "Cannot travel now" end
    for key,st in pairs(s.Statuses or {}) do
        local def=domain.Data.StatusEffects[key]
        if st.ExpiresAt>now and def and (def.BlocksCasting or def.BlocksAbilities) then return false,"Travel is blocked by "..key end
    end
    if now<(s.Cooldowns.CityTravel or 0) then return false,"City travel is cooling down" end
    if s.Spirituality<Registry.Cost then return false,"Not enough spirituality" end
    return true,""
end
function Travel.Go(world: any,domain: any,player: Player,s: any,id: any,now: number): (boolean,string)
    local ok,message=Travel.Check(domain,s,id,now)
    if not ok then return false,message end
    local root=world:Root(player);local hum=world:Humanoid(player)
    if not root or not hum or hum.Health<=0 or not player.Character then return false,"Wait for your character" end
    local entry=Registry.ById[id]
    local anchor=Vector3.new((entry.LandingX-Layout.OriginX)*Layout.Scale,0,(entry.LandingY-Layout.OriginY)*Layout.Scale)
    local destination: Vector3?=nil
    -- Ground-level, collision-checked arrival; never choose roofs or riverbeds.
    for _,offset in ipairs({Vector3.zero,Vector3.new(0,0,-8),Vector3.new(8,0,0),Vector3.new(-8,0,0),Vector3.new(0,0,8),Vector3.new(0,0,-16),Vector3.new(16,0,0),Vector3.new(-16,0,0)}) do
        local safe=world:SafeDestination(player,anchor+offset)
        if safe and safe.Y>=2 and safe.Y<=7 then destination=safe;break end
    end
    if not destination then return false,"That arrival point is blocked. Try again shortly." end
    local origin=root.Position
    player.Character:PivotTo(CFrame.new(destination)*root.CFrame.Rotation)
    root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
    s.Spirituality-=Registry.Cost;s.Cooldowns.CityTravel=now+Registry.Cooldown
    s.TeleportGraceUntil=now+3;s.LastPosition=destination;s.LastPositionAt=now
    -- Native, short-lived portal rims are visible to everyone, without granting other players travel.
    for _,at in ipairs({origin,destination}) do
        for _,edge in ipairs({{-3,0,1,8},{3,0,1,8},{0,4,7,1}}) do
            local p=Instance.new("Part");p.Name="City travel threshold";p.Size=Vector3.new(edge[3],edge[4],.5)
            p.CFrame=CFrame.new(at+Vector3.new(edge[1],edge[2],0));p.Anchored=true;p.CanCollide=false;p.CanQuery=false;p.CanTouch=false
            p.Material=Enum.Material.Neon;p.Color=Color3.fromRGB(92,220,220);p.Transparency=.25;p.Parent=world.Transient
            game:GetService("Debris"):AddItem(p,1)
        end
    end
    return true,"Arrived at "..entry.Name
end
return Travel
