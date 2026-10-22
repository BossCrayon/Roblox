--!strict
return function(data: any,Domain: any,Admin: any)
    local checks=0
    local function check(value: any,message: string) assert(value,message);checks+=1 end
    local domain=Domain.new(data)
    local state=domain:NewState(domain:Default(),0)
    state.NextSave=45;state.LastPosition={Sentinel=true};state.DisguiseUntil=500;state.OriginalDisplayName="Original"
    state.Profile.Gold=73;state.Profile.WishCredits=12;state.Profile.Inventory.Seer_Potion_8=2
    local profile=state.Profile
    check(not Admin.Apply(domain,state,"Seer",1,10,false),"Unauthorized requests fail")
    check(state.Profile==profile and state.Profile.PathwayId==false,"Unauthorized request never mutates profile")
    for _,input in ipairs({{"Unknown",1},{"Seer",0},{"Seer",10},{"Seer",1.5},{"Seer",0/0},{"Seer",math.huge},{"Seer","1"},{false,1},{{},1}}) do
        check(not Admin.Apply(domain,state,input[1],input[2],10,true),"Malformed/admin-invalid selection denied")
        check(state.Profile==profile,"Invalid selection is atomic")
    end
    state.Ready=false;check(not Admin.Apply(domain,state,"Seer",1,10,true),"Loading states denied")
    state.Ready=true;state.Dead=true;check(not Admin.Apply(domain,state,"Seer",1,10,true),"Dead states denied")
    state.Dead=false
    for _,pathway in ipairs({"Seer","Marauder","Apprentice"}) do
        for sequence=9,1,-1 do
            state.Pending={Id="OldCast",Cost=1};state.RecordedPower={Id="OldRecord"};state.StolenPower={Id="OldTheft"}
            state.Statuses={Disguised={ExpiresAt=100}};state.Cooldowns={OldAbility=100};state.GlobalUntil=100
            state.Profile.Digestion=80;state.Profile.ActingProgress=50;state.Profile.ObjectiveProgress={Old=1}
            state.AltarTicket={};state.ArchiveRead=true;state.SecretUntil=50;state.Mode="Madness";state.Sanity=0
            local serial=state.CastSerial
            check(Admin.Apply(domain,state,pathway,sequence,10,true),"All 27 pathway/sequence selections work")
            check(state.Profile.PathwayId==pathway and state.Profile.Sequence==sequence,"Exact pathway and sequence applied")
            check(state.Stats.Health==data.Pathways[pathway].Sequences[sequence].BaseStats.Health,"Stats derived from chosen sequence")
            check(state.Health==state.Stats.Health and state.Spirituality==state.Stats.Spirituality,"Vitals refill")
            check(state.Mode=="Normal" and state.Sanity==100 and not state.FailureApplied,"Admin override clears loss-of-control state")
            check(state.Profile.Digestion==0 and state.Profile.ActingProgress==0 and state.Profile.ObjectiveProgress.Old==nil,"New acting/digestion progress starts fresh")
            for _,count in pairs(state.Profile.ObjectiveProgress) do check(count==0,"Current acting objective starts at zero") end
            check(state.Pending==nil and next(state.Statuses)==nil and next(state.Cooldowns)==nil and state.GlobalUntil==0,"Old cast/statuses/cooldowns cleared")
            check(state.RecordedPower==nil and state.StolenPower==nil and state.AltarTicket==nil and state.ArchiveRead==nil and state.SecretUntil==nil,"Old power and altar invitations invalidated")
            check(state.CastSerial==serial+1,"Old cast token invalidated")
            check(state.NextSave==45 and state.LastPosition.Sentinel,"Autosave and movement bookkeeping retained")
            check(state.DisguiseUntil==500 and state.OriginalDisplayName=="Original","Disguise restoration metadata survives until executor cleanup")
            check(state.Profile.Gold==73 and state.Profile.WishCredits==12 and state.Profile.Inventory.Seer_Potion_8==2,"Gold inventory and earned wish credits preserved")
            local equipped=0
            for slot,id in pairs(state.Profile.AbilityLoadout) do
                equipped+=1;check(domain:Unlocked(state.Profile,id) and slot>=1 and slot<=6,"Auto-equipped powers match selected progression")
            end
            check(equipped==math.min(6,(10-sequence)*2),"Valid loadout fills available slots")
            check(domain:Validate(domain:Snapshot(state))~=nil,"Selected progression remains save-compatible")
        end
    end
    -- Normal players still have the existing one-pathway potion restriction.
    check(not domain:Drink(state,"Seer_Potion_9",100),"Admin override does not weaken normal potion progression")
    print("PASS: "..checks.." admin authorization/progression assertions (pure server rules)")
end
