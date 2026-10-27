return function(data,Domain,load)
    local checks=0
    local function check(ok,message) checks+=1;assert(ok,message) end
    local mt={}
    local function v(x,y,z)
        local a={X=x,Y=y,Z=z}
        a.Magnitude=math.sqrt(x*x+y*y+z*z)
        return setmetatable(a,mt)
    end
    mt.__add=function(a,b) return v(a.X+b.X,a.Y+b.Y,a.Z+b.Z) end
    mt.__sub=function(a,b) return v(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
    mt.__index=function(a,k)
        if k=="Unit" then return v(a.X/a.Magnitude,a.Y/a.Magnitude,a.Z/a.Magnitude) end
        if k=="Dot" then return function(b,c) return b.X*c.X+b.Y*c.Y+b.Z*c.Z end end
    end
    local Exposure=load({Vector3={new=v}})
    local domain=Domain.new(data)
    local function player(id,seq,x,look)
        local profile=domain:Default();profile.PathwayId="Seer";profile.Sequence=seq
        local state=domain:NewState(profile,0)
        local character={FindFirstChild=function() return nil end,FindFirstChildOfClass=function() return nil end}
        return {UserId=id,Character=character,Root={Position=v(x,0,0),CFrame={LookVector=v(look,0,0)}}},state
    end
    local owner,s=player(1,2,0,1)
    local victim,t=player(2,9,10,-1)
    domain:ActivateUltimate(s,0)
    local healthDamage,sanityBefore,notices=0,t.Sanity,0
    local wall=false
    local world={Data=data,States={[owner]=s,[victim]=t},Entities={},
        Root=function(_,p) return p.Root end,
        Humanoid=function() return {Health=100} end,
        LineOfSight=function() return not wall end,
        DamagePlayer=function(_,_,amount) healthDamage+=amount end,
        FX={FireClient=function() notices+=1 end},
    }
    Exposure.Step(world,domain,0.25,1)
    check(healthDamage>0 and t.Sanity<sanityBefore and notices==1,"Visible weaker observer suffers health/sanity exposure")
    local before=healthDamage
    wall=true;Exposure.Step(world,domain,0.25,1.25)
    check(healthDamage==before,"Walls block exposure")
    wall=false;victim.Root.CFrame.LookVector=v(1,0,0);Exposure.Step(world,domain,0.25,1.5)
    check(healthDamage==before,"Looking away blocks exposure")
    victim.Root.CFrame.LookVector=v(-1,0,0);victim.Root.Position=v(200,0,0);Exposure.Step(world,domain,0.25,1.75)
    check(healthDamage==before,"Out of range blocks exposure")
    victim.Root.Position=v(10,0,0);t.Profile.Sequence=1;Exposure.Step(world,domain,0.25,2)
    check(healthDamage==before,"Stronger observer unaffected")
    t.Profile.Sequence=9;s.Statuses.MythicalForm.ExpiresAt=2;Exposure.Step(world,domain,0.25,2)
    check(healthDamage==before,"Expired forms stop damaging immediately")
    print("PASS: "..checks.." mythical visibility/exposure assertions (server adapters mocked)")
end
