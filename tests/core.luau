--!strict
return function(data: any,Domain: any,SessionStore: any,RateLimiter: any)
    local checks=0
    local function check(value: any,message: string)
        assert(value,message);checks+=1
    end
    local domain=Domain.new(data,function() return 0 end)
    local default=domain:Default()
    check(default.PathwayId==false and default.Inventory.Seer_Potion_9==1,"Starter potions")
    local a,b=domain:Default(),domain:Default();a.Inventory.Seer_Potion_9=8
    check(b.Inventory.Seer_Potion_9==1,"Profiles have independent nested tables")
    for _,path in ipairs({"Seer","Marauder","Apprentice"}) do
        local s=domain:NewState(domain:Default(),0)
        local now=0
        for seq=9,1,-1 do
            s.Profile.Inventory[path.."_Potion_"..seq]=1
            now+=40
            local ok=domain:Drink(s,path.."_Potion_"..seq,now)
            check(ok and s.Profile.Sequence==seq,"Advance downward: "..path..seq)
            check(s.Profile.Digestion==0 and s.Profile.ActingProgress==0,"Progress reset")
            check(s.Profile.Inventory[path.."_Potion_"..seq]==0,"Consume exactly once")
            check(not domain:Drink(s,path.."_Potion_"..seq,now+3),"Reject duplicate potion")
            check(s.Stats.Health==data.Pathways[path].Sequences[seq].BaseStats.Health,"Recompute stats")
            check(not domain:Drink(s,(if path=="Seer" then "Marauder" else "Seer").."_Potion_9",now+4),"No pathway switching")
            local objective=data.Pathways[path].Sequences[seq].ActingObjectives[1]
            check(not domain:Act(s,"FakeClientSignal","fake",now),"Wrong objective rejected")
            for i=1,20 do
                now+=31
                local event=path..seq..":"..i
                check(domain:Act(s,objective.ServerSignal,event,now),"Server objective accepted")
                check(not domain:Act(s,objective.ServerSignal,event,now+31),"Replay rejected")
                check(not domain:Act(s,objective.ServerSignal,event.."fast",now+1),"Objective cooldown")
            end
            check(s.Profile.Digestion==100 and s.Profile.ActingProgress==20,"Digestion bounded and earned")
            domain:Act(s,objective.ServerSignal,"extra:"..seq,now+31)
            check(s.Profile.Digestion==100,"Digestion never exceeds 100")
            for _,id in ipairs(data.Pathways[path].Sequences[seq].AbilityIds) do
                domain:Equip(s,1,id)
                s.Spirituality=s.Stats.Spirituality
                now+=100
                local pending=domain:BeginCast(s,id,now)
                check(pending and s.Spirituality==s.Stats.Spirituality-data.Abilities[id].SpiritualityCost,"Reserve spirituality")
                check(not domain:BeginCast(s,id,now),"No concurrent cast")
                domain:CancelCast(s,true)
                check(s.Spirituality==s.Stats.Spirituality,"Failed cast refund capped")
                check(not domain:BeginCast(s,id,now+1),"Cooldown survives refund")
            end
            local clean=domain:Validate(domain:Snapshot(s))
            check(clean~=nil and clean.Sequence==seq,"Round-trip persistence")
        end
        check(not domain:BuyNextPotion(s),"No Sequence 0 potion")
        check(s.Profile.Sequence==1,"Highest tier stays 1")
    end
    local s=domain:NewState(domain:Default(),0)
    domain:Drink(s,"Seer_Potion_9",0);s.Profile.Inventory.Seer_Potion_8=1
    s.Profile.Inventory.Seer_Potion_7=1
    check(not domain:Drink(s,"Seer_Potion_7",40),"No skipping")
    check(not domain:Drink(s,"Seer_Potion_8",40),"Early ritual rejected")
    check(s.Sanity<100 and s.Profile.Inventory.Seer_Potion_8==1,"Risk damages sanity without consuming")
    s.Sanity=0.1
    domain:DrainSanity(s,1000,50)
    check(s.Mode=="Madness","Zero sanity starts madness")
    domain:Tick(s,1,59);check(s.Mode=="Madness","Madness has a timed phase")
    domain:Tick(s,1,61);check(s.Mode=="LostControl" and s.Health==0,"Madness transitions to failure")
    check(not domain:BeginCast(s,"Seer_9",100),"Lost control blocks casting")
    s.Profile.Digestion=70
    domain:Recover(s)
    check(s.Mode=="Normal" and s.Sanity==100 and s.Profile.Digestion==50,"Recovery has a progression cost")
    s.Spirituality=0;s.LastCast=0;s.LastCombat=100
    domain:Tick(s,1,101)
    check(s.Spirituality==s.Stats.SpiritualityRegen*0.5,"Combat regeneration reduced")
    s.Spirituality=s.Stats.Spirituality-0.1;domain:Tick(s,100,200)
    check(s.Spirituality==s.Stats.Spirituality,"Regeneration clamped")
    check(not domain:Equip(s,0,"Seer_9"),"Invalid slot")
    check(not domain:Equip(s,1,"Marauder_9"),"Foreign ability rejected")
    check(not domain:Equip(s,1,"Seer_1"),"Locked tier rejected")
    s.Profile.Gold=100
    check(domain:BuyNextPotion(s)==false,"No duplicate next potion purchase")
    s.Profile.Inventory.Seer_Potion_8=0
    check(domain:BuyNextPotion(s) and s.Profile.Gold==0,"Potion purchase charges once")
    check(not domain:BuyNextPotion(s),"Duplicate purchase blocked")
    local raw=domain:Default();raw.Sanity=0/0
    check(not domain:Validate(raw),"NaN persisted resource rejected")
    raw=domain:Default();raw.Inventory.Fake=1
    check(not domain:Validate(raw),"Unknown inventory key rejected")
    raw=domain:Default();raw.SchemaVersion=99
    check(not domain:Validate(raw),"Future schema never overwritten")
    raw=domain:Default();raw.PathwayId="Seer";raw.Sequence=0
    check(not domain:Validate(raw),"Invalid persisted sequence")
    local limiter=RateLimiter.new(2,3)
    check(limiter:Allow("p",0) and limiter:Allow("p",0) and limiter:Allow("p",0),"Burst allowance")
    check(not limiter:Allow("p",0),"Excess requests rejected")
    check(limiter:Allow("p",0.5),"Tokens replenish")
    limiter:Remove("p");check(limiter:Allow("p",0.5,3),"Buckets cleaned")
    -- Real locking algorithm with a fake atomic DataStore, including transient failures.
    local records={};local clock=1000;local failures=0;local sleeps=0;local commitThenFail=false
    local backend={UpdateAsync=function(_self,key,transform)
        if failures>0 then failures-=1;error("network unavailable") end
        local result=transform(Domain.Copy(records[key]))
        if result~=nil then records[key]=Domain.Copy(result) end
        if commitThenFail then commitThenFail=false;error("response lost after commit") end
        return Domain.Copy(result)
    end}
    local sessions=SessionStore.new(backend,domain,data.Progression.Persistence,function() return clock end,function(t) sleeps+=1;clock+=t end,function() return 0 end)
    failures=2
    local h=sessions:Acquire(7,"serverA")
    check(h and sleeps==2,"Retry/backoff recovers load")
    check(not sessions:Acquire(7,"serverB"),"Two servers cannot hold a live session")
    h.Data.Gold=45
    check(sessions:Save(h,h.Data,false),"Owner saves and refreshes lease")
    check(records.Player_7.Data.Gold==45,"Saved profile retained")
    local lockedExpiry=records.Player_7.ExpiresAt
    clock=lockedExpiry+1
    local second=sessions:Acquire(7,"serverB")
    check(second and second.Data.Gold==45,"Expired lease can be acquired with old data")
    check(not sessions:Save(h,h.Data,false),"Expired owner cannot overwrite")
    second.Data.Gold=80
    check(sessions:Save(second,second.Data,true),"Release saves final data")
    check(records.Player_7.Owner==nil and records.Player_7.Data.Gold==80,"Release clears ownership")
    local third=sessions:Acquire(7,"serverC")
    check(third and third.Data.Gold==80,"Rejoin restores progress")
    local stolen=sessions:Acquire(8,"serverA")
    records.Player_8.Owner="differentOwner"
    check(not sessions:Save(stolen,stolen.Data,false) and stolen.Closed,"Ownership loss stops all saves")
    check(records.Player_8.Owner=="differentOwner","Never replace another lock")
    failures=8
    check(not sessions:Acquire(9,"serverA"),"Permanent DataStore failure rejects load")
    check(records.Player_9==nil,"Failed load never writes defaults")
    failures=0
    records.Player_10={Version=1,Owner=nil,ExpiresAt=0,Data={SchemaVersion=99}}
    check(not sessions:Acquire(10,"serverA"),"Corrupt/future profile blocked")
    check(records.Player_10.Data.SchemaVersion==99,"Corrupt profile left untouched")
    commitThenFail=true
    local uncertain=sessions:Acquire(11,"sameRequestOwner")
    check(uncertain~=nil,"Ambiguous committed acquire retries idempotently")
    check(not sessions:Acquire(11,"otherOwner"),"Ambiguous acquire still locked")
    uncertain.Busy=true
    check(not sessions:Save(uncertain,uncertain.Data,false),"Concurrent saves serialized")
    uncertain.Busy=false
    local bad=Domain.Copy(uncertain.Data);bad.Inventory.Fake=1
    check(not sessions:Save(uncertain,bad,false),"Invalid profile never saved")
    check(records.Player_11.Data.Inventory.Fake==nil,"Bad save did not mutate backend")
    commitThenFail=true
    check(sessions:Save(uncertain,uncertain.Data,true),"Ambiguous release is acknowledged idempotently")
    check(records.Player_11.Owner==nil and uncertain.Closed,"Ambiguous release stays safely released")
    records.Player_12={Version=1,Owner=nil,ExpiresAt=0/0,Data=domain:Default()}
    check(not sessions:Acquire(12,"serverA"),"NaN envelope lease rejected")
    check(records.Player_12.ExpiresAt~=records.Player_12.ExpiresAt,"Corrupt envelope is untouched")
    local high=domain:Default();high.PathwayId="Seer";high.Sequence=1
    local highState=domain:NewState(high,0)
    local lowState=domain:NewState(domain:Default(),0)
    domain:DrainSanity(highState,50,0);domain:DrainSanity(lowState,50,0)
    check(highState.Sanity>lowState.Sanity,"Resistance reduces mental damage")
    print("PASS: "..checks.." server-domain assertions (all pathways 9→1, resources, cast rules, locks, retries, corrupt saves)")
end
