--!strict
-- Server-owned visibility/exposure: observer facing, range and unobstructed sight.
-- Client camera claims cannot authorize damage. Character facing approximates gaze.
local Exposure={}
function Exposure.Step(world: any,domain: any,dt: number,now: number)
    local u=world.Data.Runtime.Ultimate
    for owner,s in pairs(world.States) do
        local form=s.Statuses and s.Statuses.MythicalForm
        local root=world:Root(owner)
        if not s.Ready or s.Dead or s.Mode~="Normal" or not form or form.ExpiresAt<=now or not root then continue end
        local head=owner.Character and owner.Character:FindFirstChild("Head")
        local target=if head and head:IsA("BasePart") then head.Position else root.Position
        local function visible(observer: BasePart,model: Model?): boolean
            local eye=observer.Position+Vector3.new(0,1.5,0)
            local delta=target-eye
            return delta.Magnitude<=u.ExposureRange and (delta.Magnitude<1 or observer.CFrame.LookVector:Dot(delta.Unit)>0.25)
                and world:LineOfSight(eye,target,model,owner.Character)
        end
        for player,victim in pairs(world.States) do
            if player==owner or not victim.Ready or victim.Dead then continue end
            local observer=world:Root(player)
            if not observer or not visible(observer,player.Character) then continue end
            local health,sanity=domain:MythicalExposure(s.Profile.Sequence,victim.Profile.Sequence or 10,victim.Stats.Health,dt,form.Stage=="Complete")
            if health>0 then
                local hum=world:Humanoid(player)
                if not hum or hum.Health<=0 or (player.Character and player.Character:FindFirstChildOfClass("ForceField")) then continue end
                world:DamagePlayer(player,health,{Serial="myth:"..owner.UserId,Statuses={}},now)
                domain:DrainSanity(victim,sanity,now)
                if now>=(victim.NextExposureNotice or 0) then
                    victim.NextExposureNotice=now+2
                    world.FX:FireClient(player,{Kind="MythicalExposure",Position=observer.Position,PathwayId=s.Profile.PathwayId})
                end
            end
        end
        for _,enemy in pairs(world.Entities) do
            if enemy.Owner==nil and enemy.Humanoid.Health>0 and visible(enemy.Root,enemy.Model) then
                local damage=domain:MythicalExposure(s.Profile.Sequence,enemy.Tier,enemy.Humanoid.MaxHealth,dt,form.Stage=="Complete")
                if damage>0 then world:Damage(enemy,damage,owner,now) end
            end
        end
    end
end
return Exposure
