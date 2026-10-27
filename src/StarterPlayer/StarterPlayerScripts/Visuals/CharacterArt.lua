--!strict
-- Cosmetic, locally welded clothing and procedural Mythical Creature Form manifestations.
-- Never writes body colors/scales or Humanoid state.
local Players=game:GetService("Players")
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local A=T.CharacterArt
local M=A.Mythical
local Outfit={}
function Outfit.new(service: any,blocks: any): any
    return setmetatable({Service=service,Blocks=blocks,Records={},Elapsed=0,AuraAt=0},{__index=Outfit})
end
function Outfit.Clear(self: any,character: Model)
    local record=self.Records[character]
    if record then
        for _,entry in ipairs(record.Hidden or {}) do
            if entry.Part.Parent and entry.Part.LocalTransparencyModifier==1 then entry.Part.LocalTransparencyModifier=entry.Previous end
        end
        record.Model:Destroy();self.Records[character]=nil
    end
end
function Outfit.Build(self: any,character: Model,path: string,sequence: number,torso: BasePart,head: BasePart,myth: string?)
    local previous=self.Records[character]
    if previous and previous.Mythical~="" and (not myth or myth=="") and self.Service:Visible(torso.Position) then
        local endingPosition=torso.Position+Vector3.yAxis*(previous.Lift or 0)
        local ending: {any}={
            {Name="VeilRibbon",Position=endingPosition,Palette=previous.Path,Options={Scale=M.AuraScale*(previous.Scale or 1),Coil=true}},
            {Name="RisingMotes",Position=endingPosition,Palette=previous.Path,Options={Scale=M.AuraScale*(previous.Scale or 1),Intake=true}},
            {Name="SigilStencil",Position=endingPosition,Palette=previous.Path,Options={Glyph=if previous.Path=="Seer" then "Worm" elseif previous.Path=="Marauder" then "Clock" else "Arch",LowGlyph=if previous.Path=="Seer" then "WormLow" elseif previous.Path=="Marauder" then "Clock" else "Arch",Scale=M.AuraScale*(previous.Scale or 1)}},
        }
        self.Blocks:Compose(ending,1,2,M.FoolEndLife)
    end
    self:Clear(character)
    local stage=if myth=="Incomplete" or myth=="Complete" then myth else ""
    local formScale=if stage=="Complete" then M.CompleteScale elseif stage=="Incomplete" then M.IncompleteScale else 1
    local lift=if stage=="Complete" then M.CompleteLift elseif stage=="Incomplete" then M.IncompleteLift else 0
    local model=Instance.new("Model");model.Name="LocalMysteriesOutfit";model.Parent=character
    local count=0;local cloth=A.Cloth[path];local trim=A.Trim[path]
    local motions: {any}={};local faces: {any}={};local ornaments: {any}={}
    local function piece(name: string,base: BasePart,size: {number},offset: CFrame,color: Color3,material: Enum.Material?,alpha: number?): any
        if count>=A.MaxParts then return end;count+=1
        local part: any=Instance.new(if string.find(name,"Hood fold") or string.find(name,"Cloak fold") then "WedgePart" else "Part");part.Name=name;part.Size=Vector3.new(table.unpack(size));part.CFrame=base.CFrame*offset
        part.Anchored=false;part.CanCollide=false;part.CanQuery=false;part.CanTouch=false;part.Massless=true;part.CastShadow=false
        part.Material=material or Enum.Material.Fabric;part.Color=color;part.Transparency=alpha or 0;part.Parent=model
        local pose=offset
        local lower=string.lower(name)
        local clock=string.find(lower,"clock wheel") or string.find(lower,"bezel") or string.find(lower,"clock arc")
        local halo=string.find(lower,"halo") or string.find(lower,"crown ring") or string.find(lower,"key-seal") or string.find(lower,"time ring")
        local worm=string.find(lower,"worm") or string.find(lower,"tentacle")
        local hand=string.find(lower,"hand")
        if stage~="" and clock then
            part.Shape=Enum.PartType.Cylinder
            part.Size=Vector3.new(M.ClockDepth,size[1],size[2])
            pose=offset*CFrame.Angles(0,math.pi/2,0)
            if string.find(lower,"clock wheel") then
                -- Two fixed, occluded faces: 12 radial sections, no extra Parts or unpooled Beams.
                for _,face in ipairs({Enum.NormalId.Left,Enum.NormalId.Right}) do
                    local gui=Instance.new("SurfaceGui");gui.Name="Twelve temporal sections";gui.Face=face
                    gui.CanvasSize=Vector2.new(M.ClockCanvas,M.ClockCanvas);gui.AlwaysOnTop=false
                    gui.LightInfluence=1;gui.MaxDistance=M.ClockMaxDistance;gui.Enabled=false;gui.Parent=part
                    table.insert(faces,gui)
                    for i=1,M.ClockSegments do
                        local angle=(i-1)*math.pi*2/M.ClockSegments
                        local tick=Instance.new("Frame");tick.Name="Clock sector "..i
                        tick.AnchorPoint=Vector2.new(0.5,0.5)
                        tick.Position=UDim2.fromScale(0.5+math.sin(angle)*M.ClockRadius,0.5-math.cos(angle)*M.ClockRadius)
                        tick.Size=UDim2.fromScale(M.ClockTickWidth,M.ClockTickHeight);tick.Rotation=math.deg(angle)
                        tick.BorderSizePixel=0;tick.BackgroundColor3=T.Colors.Bronze
                        tick.BackgroundTransparency=M.ClockTickAlpha;tick.Parent=gui
                    end
                end
            end
        elseif stage~="" and halo then
            part.Shape=Enum.PartType.Cylinder;part.Size=Vector3.new(size[2],size[1],size[3])
            pose=offset*CFrame.Angles(0,0,math.pi/2)
            part.Transparency=math.max(part.Transparency,M.SpiritAlpha)
            for _,face in ipairs({Enum.NormalId.Left,Enum.NormalId.Right}) do
                local gui=Instance.new("SurfaceGui");gui.Name="Spirit halo engraving";gui.Face=face
                gui.CanvasSize=Vector2.new(M.ClockCanvas,M.ClockCanvas);gui.AlwaysOnTop=false
                gui.LightInfluence=1;gui.MaxDistance=M.ClockMaxDistance;gui.Enabled=false;gui.Parent=part
                table.insert(ornaments,gui)
                local ring=Instance.new("Frame");ring.BackgroundTransparency=1
                ring.Position=UDim2.fromScale(M.HaloInset,M.HaloInset)
                ring.Size=UDim2.fromScale(1-M.HaloInset*2,1-M.HaloInset*2);ring.Parent=gui
                local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0.5,0);corner.Parent=ring
                local stroke=Instance.new("UIStroke");stroke.Color=color;stroke.Thickness=M.HaloStroke;stroke.Transparency=M.GlowAlpha;stroke.Parent=ring
            end
        elseif stage~="" and worm then
            part.Shape=Enum.PartType.Ball
        end
        local rootPiece=not base:IsDescendantOf(model)
        if stage~="" then
            part.Size*=formScale
            local position=pose.Position*formScale
            if rootPiece then position-=base.CFrame:PointToObjectSpace(torso.Position)*(formScale-1);position+=Vector3.yAxis*lift end
            pose=CFrame.new(position)*pose.Rotation
        end
        local weld=Instance.new("Weld");weld.Part0=base;weld.Part1=part;weld.C0=pose;weld.Parent=part
        table.insert(motions,{Part=part,Weld=weld,Base=pose,Alpha=part.Transparency,
            RootPiece=rootPiece,Phase=count,Kind=if hand then "Hand" elseif halo then "Halo" elseif worm then "Worm" else "Float",
            Sign=if string.find(lower,"minute") then -1 else 1})
        if stage~="" and not self.Service.ReducedMotion and not self.Service.LowGraphics then part.Transparency=1 end
        return part
    end
    local bodyScale=math.clamp(torso.Size.X/2,A.BodyScaleMin,A.BodyScaleMax)
    local coat={A.Coat[1]*bodyScale,math.max(A.Coat[2],torso.Size.Y),math.max(A.Coat[3],torso.Size.Z+A.CoatClearance)}
    if stage=="Complete" then
        if path=="Seer" then
            -- User-supplied pinnacle reference adapted cosmetically to the existing Angel stage.
            -- Five folds + blank mask + four articulated worm segments = ten Parts.
            for _,side in ipairs({-1,1}) do
                piece("Hood fold",head,{0.75,2.1,1.5},CFrame.new(side*0.6,0.22,0.12)*CFrame.Angles(0,0,math.rad(side*-18)),T.Colors.Fog,Enum.Material.Glass,M.FoolCloakAlpha)
                piece("Cloak fold",torso,{1.55,4.5,1.4},CFrame.new(side*1.05,-0.6,0.35)*CFrame.Angles(0,0,math.rad(side*15)),T.Colors.Fog,Enum.Material.Glass,M.FoolCloakAlpha)
            end
            piece("Cloak fold back",torso,{2.5,4.8,0.5},CFrame.new(0,-0.65,0.85),T.Colors.DeepPurple,Enum.Material.Glass,M.FoolCloakAlpha)
            piece("Cold blank mask",head,{0.85,1.25,0.2},CFrame.new(0,0,-0.65),T.Colors.Silver,Enum.Material.SmoothPlastic,0.12)
            for _,side in ipairs({-1,1}) do
                local first=piece("Worm of Spirit tentacle",torso,{0.5,1.8,0.5},CFrame.new(side*0.45,-1.15,-0.3)*CFrame.Angles(0,0,math.rad(side*24)),T.Colors.DeepPurple,Enum.Material.Glass,M.WormAlpha)
                if first then piece("Spirit tentacle tip",first,{0.3,1.7,0.3},CFrame.new(0,-1.4,0)*CFrame.Angles(math.rad(28),0,math.rad(side*-40)),T.Colors.Silver,Enum.Material.Glass,M.WormAlpha) end
            end
        elseif path=="Marauder" then
            -- Original cinematic Angel interpretation: Worms of Time (12-section ancient stone clock phantom + ringed Worms of Time)
            piece("Chronos dark shroud",torso,{coat[1]*1.1,coat[2]*1.06,coat[3]*1.1},CFrame.identity,T.Colors.Black,Enum.Material.SmoothPlastic,0.12)
            piece("Ancient stone clock wheel",torso,M.MarauderClockRim,CFrame.new(0,0.45,coat[3]/2+0.55),T.Colors.Stone,Enum.Material.Slate,0.08)
            piece("Clockwork bronze bezel",torso,{M.MarauderClockRim[1]*0.86,M.MarauderClockRim[2]*0.86,0.18},CFrame.new(0,0.45,coat[3]/2+0.48),T.Colors.Bronze,Enum.Material.Metal,0.05)
            piece("Crimson hour hand",torso,M.MarauderHand,CFrame.new(0.28,0.85,coat[3]/2+0.42)*CFrame.Angles(0,0,math.rad(-36)),T.Colors.Crimson,Enum.Material.Neon,M.GlowAlpha)
            piece("Bronze minute hand",torso,{M.MarauderHand[1]*0.85,M.MarauderHand[2]*1.28,M.MarauderHand[3]},CFrame.new(-0.35,1.05,coat[3]/2+0.4)*CFrame.Angles(0,0,math.rad(28)),T.Colors.Bronze,Enum.Material.Neon,M.GlowAlpha)
            for idx,side in ipairs({-1,1}) do
                piece("Ringed Worm of Time "..tostring(idx),torso,M.MarauderRing,CFrame.new(side*1.05,0.15,-0.1)*CFrame.Angles(math.rad(32),0,math.rad(side*38)),T.Colors.Silver,Enum.Material.Glass,M.GlowAlpha)
                piece("Time pattern ring "..tostring(idx),torso,{0.85,0.14,0.85},CFrame.new(side*1.05,-0.45,0.15)*CFrame.Angles(math.rad(-22),0,math.rad(side*-28)),T.Colors.Crimson,Enum.Material.Neon,M.GlowAlpha)
            end
            piece("Temporal crown ring",head,{1.65,0.14,1.65},CFrame.new(0,head.Size.Y/2+0.28,0)*CFrame.Angles(math.rad(14),0,math.rad(-16)),T.Colors.Bronze,Enum.Material.Neon,M.GlowAlpha)
        else
            -- Original cinematic Angel interpretation: Worms of Star ("Door of All Doors" — nested astral doorways of starlight & teal)
            piece("Astral light core",torso,{coat[1]*1.08,coat[2]*1.06,coat[3]*1.08},CFrame.identity,T.Colors.Starlight,Enum.Material.Neon,M.GlowAlpha)
            for _,side in ipairs({-1,1}) do
                piece("Outer astral door jamb",torso,M.ApprenticeJamb,CFrame.new(side*1.55,0.35,coat[3]/2+0.42),T.Colors.Teal,Enum.Material.Neon,M.GlowAlpha)
                piece("Inner silver door jamb",torso,{M.ApprenticeJamb[1]*0.85,M.ApprenticeJamb[2]*0.78,M.ApprenticeJamb[3]},CFrame.new(side*1.05,0.2,coat[3]/2+0.24),T.Colors.Silver,Enum.Material.Metal,0.08)
                piece("Worm of Star arc",torso,M.ApprenticeWorm,CFrame.new(side*1.25,0.65,-0.15)*CFrame.Angles(0,math.rad(side*24),math.rad(side*35)),T.Colors.Starlight,Enum.Material.Neon,M.GlowAlpha)
            end
            piece("Outer astral door lintel",torso,M.ApprenticeLintel,CFrame.new(0,2.25,coat[3]/2+0.42),T.Colors.Teal,Enum.Material.Neon,M.GlowAlpha)
            piece("Inner silver door lintel",torso,{M.ApprenticeLintel[1]*0.72,M.ApprenticeLintel[2]*0.85,M.ApprenticeLintel[3]},CFrame.new(0,1.68,coat[3]/2+0.24),T.Colors.Silver,Enum.Material.Metal,0.08)
            piece("Threshold starlight key-seal",head,{1.45,0.2,1.45},CFrame.new(0,head.Size.Y/2+0.36,0),T.Colors.Starlight,Enum.Material.Neon,M.GlowAlpha)
        end
    elseif stage=="Incomplete" then
        -- Original incomplete Saint visual manifestation (Sequence 4–3): Victorian attire fracturing into partial Worms
        piece("Victorian waistcoat",torso,coat,CFrame.identity,cloth)
        if path=="Seer" then
            piece("Top hat brim",head,A.Brim,CFrame.new(0,head.Size.Y/2+0.08,0),cloth)
            piece("Top hat crown",head,A.Crown,CFrame.new(0,head.Size.Y/2+A.Crown[2]/2+0.1,0),cloth)
            piece("Spirit vortex shroud",torso,{coat[1]*1.14,coat[2]*0.82,coat[3]*1.14},CFrame.new(0,-0.1,0.06),T.Colors.Fog,Enum.Material.Glass,M.SpiritAlpha)
            for idx,side in ipairs({-1,1}) do
                piece("Worm of Spirit tendril "..tostring(idx),torso,M.SeerWorm,CFrame.new(side*0.92,-0.35,0.22)*CFrame.Angles(math.rad(24),0,math.rad(side*30)),T.Colors.Fog,Enum.Material.Neon,M.GlowAlpha)
                piece("Spirit tentacle coil "..tostring(idx),torso,M.SeerWorm,CFrame.new(side*0.76,0.35,-0.2)*CFrame.Angles(math.rad(-18),0,math.rad(side*-26)),T.Colors.DeepPurple,Enum.Material.Neon,M.GlowAlpha)
            end
            piece("Unstable spirit-worm core",torso,A.Pendant,CFrame.new(0,0.25,-coat[3]/2-0.16),T.Colors.Gold,Enum.Material.Neon,0.08)
        elseif path=="Marauder" then
            piece("Offset bronze pin",torso,A.Pendant,CFrame.new(0.65,0.55,-coat[3]/2-0.1)*CFrame.Angles(0,0,math.rad(45)),trim)
            piece("Short shoulder mantle",torso,A.Collar,CFrame.new(0,coat[2]/2,0.2),cloth)
            piece("Phantom clock arc",torso,{2.2,2.2,0.16},CFrame.new(0,0.35,coat[3]/2+0.36),T.Colors.Bronze,Enum.Material.Metal,0.18)
            for idx,side in ipairs({-1,1}) do
                piece("Worm of Time coil "..tostring(idx),torso,M.MarauderRing,CFrame.new(side*0.95,0.2,0.1)*CFrame.Angles(math.rad(28),0,math.rad(side*34)),T.Colors.Silver,Enum.Material.Glass,M.GlowAlpha)
                piece("Etched time ring "..tostring(idx),torso,{0.78,0.14,0.78},CFrame.new(side*0.82,-0.35,-0.12)*CFrame.Angles(math.rad(-20),0,math.rad(side*-24)),T.Colors.Crimson,Enum.Material.Neon,M.GlowAlpha)
            end
        else
            piece("Travel cloak collar",torso,A.Collar,CFrame.new(0,coat[2]/2,0.2),trim)
            piece("Traveller cape",torso,{coat[1],coat[2]+A.CapeExtra,A.CapeDepth},CFrame.new(0,-0.25,coat[3]/2+0.12),cloth)
            piece("Threshold arch lintel",torso,{2.45,0.26,0.24},CFrame.new(0,1.55,coat[3]/2+0.34),T.Colors.Teal,Enum.Material.Neon,M.GlowAlpha)
            for idx,side in ipairs({-1,1}) do
                piece("Worm of Star door-arc "..tostring(idx),torso,M.ApprenticeWorm,CFrame.new(side*1.05,0.45,0.22)*CFrame.Angles(0,math.rad(side*18),math.rad(side*32)),T.Colors.Starlight,Enum.Material.Neon,M.GlowAlpha)
                piece("Astral pillar shard "..tostring(idx),torso,{0.24,2.1,0.24},CFrame.new(side*1.12,0.15,coat[3]/2+0.34),T.Colors.Silver,Enum.Material.Neon,M.GlowAlpha)
            end
        end
    else
        piece("Victorian waistcoat",torso,coat,CFrame.identity,cloth)
        for _,side in ipairs({-1,1}) do
            piece("Split coat tail",torso,A.Tail,CFrame.new(side*0.48,-coat[2]/2-0.45,0.35),cloth)
            piece("Lapel",torso,{A.LapelWidth,coat[2]*A.LapelFraction,A.LapelDepth},CFrame.new(side*0.4,0,-coat[3]/2-0.06)*CFrame.Angles(0,0,math.rad(side*A.LapelAngle)),trim)
        end
        if path=="Seer" then
            piece("Top hat brim",head,A.Brim,CFrame.new(0,head.Size.Y/2+0.08,0),cloth)
            piece("Top hat crown",head,A.Crown,CFrame.new(0,head.Size.Y/2+A.Crown[2]/2+0.1,0),cloth)
        elseif path=="Marauder" then
            piece("Offset bronze pin",torso,A.Pendant,CFrame.new(0.65,0.55,-coat[3]/2-0.1)*CFrame.Angles(0,0,math.rad(45)),trim)
            piece("Short shoulder mantle",torso,A.Collar,CFrame.new(0,coat[2]/2,0.2),cloth)
        else
            piece("Travel cloak collar",torso,A.Collar,CFrame.new(0,coat[2]/2,0.2),trim)
            piece("Traveller cape",torso,{coat[1],coat[2]+A.CapeExtra,A.CapeDepth},CFrame.new(0,-0.25,coat[3]/2+0.12),cloth)
        end
        if sequence<=4 then piece("Sequence crest",torso,A.Pendant,CFrame.new(0,0.2,-coat[3]/2-0.15),trim) end
        if sequence<=2 then piece("Silvered collar seal",torso,A.CollarSeal,CFrame.new(0,coat[2]/2,-coat[3]/2-0.08),trim) end
    end
    local hidden={}
    if stage=="Complete" then
        for _,part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(model) then
                table.insert(hidden,{Part=part,Previous=part.LocalTransparencyModifier})
                part.LocalTransparencyModifier=1
            end
        end
    end
    self.Records[character]={Hidden=hidden,Model=model,Path=path,Sequence=sequence,Mythical=stage,Torso=torso,Head=head,
        Motions=motions,Faces=faces,Ornaments=ornaments,Scale=formScale,Lift=lift,Age=0,Time=0}
end
function Outfit.Step(self: any,dt: number)
    local profile=self.Service:Profile()
    local reduced=self.Service.ReducedMotion or profile.ReducedMotion
    local low=self.Service.LowGraphics or profile.Low
    for _,record in pairs(self.Records) do
        for _,entry in ipairs(record.Hidden or {}) do
            if entry.Part.Parent then entry.Part.LocalTransparencyModifier=1 end
        end
        if record.Mythical~="" and record.Torso.Parent and self.Service:Visible(record.Torso.Position) then
            record.Age+=math.min(dt,A.Scan);record.Time+=math.min(dt,A.Scan)
            local reveal=if reduced or low then 1 else math.clamp(record.Age/M.RevealTime,0,1)
            for _,motion in ipairs(record.Motions) do
                local wave=if reduced or low then 0 else math.sin(record.Time*math.pi*2/M.IdlePeriod+motion.Phase)
                local spin=if reduced or low then 0 else record.Time
                local offset=CFrame.identity
                if motion.Kind=="Hand" then
                    -- Rotate around the clock hub, not the hand's midpoint.
                    local center=Vector3.new(0,record.Lift+0.45*record.Scale,motion.Base.Position.Z)
                    offset=CFrame.new(center)*CFrame.Angles(0,0,spin*M.HandSpeed*motion.Sign)*CFrame.new(-center)
                    motion.Weld.C0=offset*motion.Base
                else
                    offset=CFrame.new(0,wave*M.IdleRise,0)*CFrame.Angles(
                        if motion.Kind=="Worm" then wave*math.rad(M.IdleDegrees) else 0,
                        if motion.Kind=="Halo" then spin*M.HaloSpeed else 0,
                        if motion.Kind=="Worm" then math.sin(spin*M.WormSpeed+motion.Phase)*math.rad(M.IdleDegrees) else 0)
                    if reduced or low then offset=CFrame.identity end
                    motion.Weld.C0=motion.Base*offset
                end
                if motion.RootPiece and not reduced and not low then
                    motion.Weld.C0=CFrame.new(0,math.sin(record.Time*math.pi*2/M.IdlePeriod)*M.FloatHeight,0)*motion.Weld.C0
                end
                motion.Part.Transparency=math.clamp(1-(1-motion.Alpha)*reveal+math.abs(wave)*M.AlphaPulse,0,1)
            end
            for _,face in ipairs(record.Faces) do face.Enabled=not low and reveal>=M.HaloReveal end
            for _,face in ipairs(record.Ornaments) do face.Enabled=not low and reveal>=M.HaloReveal end
        end
    end
    self.Elapsed+=dt;if self.Elapsed<A.Scan then return end;self.Elapsed=0
    local camera=workspace.CurrentCamera;if not camera then return end
    local candidates={};local wanted={}
    for _,player in ipairs(Players:GetPlayers()) do
        local character=player.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        local hum=character and character:FindFirstChildOfClass("Humanoid")
        if root and root:IsA("BasePart") and hum and hum.Health>0 then
            local distance=(root.Position-camera.CFrame.Position).Magnitude
            if distance<=A.Distance then table.insert(candidates,{Character=character,Distance=distance,Root=root}) end
        end
    end
    table.sort(candidates,function(a,b) return a.Distance<b.Distance end)
    local now=os.clock();local aura=now>=self.AuraAt
    if aura then self.AuraAt=now+M.FoolAuraInterval end
    for i,item in ipairs(candidates) do
        if i>A.MaxPlayers then break end
        local character=item.Character;local path=character:GetAttribute("MysteriesPathway");local seq=character:GetAttribute("MysteriesSequence")
        local mythAttr=character:GetAttribute("MysteriesMythicalForm")
        local myth=if mythAttr=="Incomplete" or mythAttr=="Complete" then mythAttr else ""
        local torso=character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso");local head=character:FindFirstChild("Head")
        if not A.Cloth[path] or type(seq)~="number" or character:GetAttribute("MysteriesDisguised")==true
            or not torso or not torso:IsA("BasePart") or not head or not head:IsA("BasePart") then continue end
        wanted[character]=true
        local record=self.Records[character]
        if not record or record.Path~=path or record.Sequence~=seq or record.Mythical~=myth or record.Torso~=torso or record.Head~=head then
            self:Build(character,path,seq,torso,head,myth)
        end
        if aura and (seq<=6 or myth~="") and not self.Service.LowGraphics and not self.Service.ReducedMotion and not profile.Low and self.Service:Visible(item.Root.Position) then
            local blockName=if myth=="Complete" then "SigilStencil" elseif myth=="Incomplete" or seq<=3 then "VeilRibbon" else "RisingMotes"
            local stencil=if path=="Seer" and myth=="Complete" then "SpiritVortex" elseif path=="Seer" then "Worm" elseif path=="Marauder" then "Clock" else "Arch"
            local layers: {any}={{Name=blockName,Position=torso.Position,Palette=path,
                Options={Scale=if myth=="Complete" then M.AuraScale*M.CompleteScale elseif myth~="" then M.AuraScale*M.IncompleteScale else A.AuraScale,Glyph=stencil,LowGlyph=if path=="Seer" then "WormLow" else stencil,Follow=torso,Offset=Vector3.new(0,if myth=="Complete" then M.CompleteLift elseif myth~="" then M.IncompleteLift else 0,-0.8)}}}
            if myth~="" then
                table.insert(layers,{Name="VeilRibbon",Position=torso.Position,Palette=path,
                    Options={Scale=M.AuraScale*(if myth=="Complete" then M.CompleteScale else M.IncompleteScale),Height=M.ApprenticeJamb[2],Coil=true,Follow=torso,Offset=Vector3.yAxis*(if myth=="Complete" then M.CompleteLift else M.IncompleteLift)}})
            end
            self.Blocks:Compose(layers,1,0,if myth~="" then M.FoolAuraLife else A.AuraLife)
            aura=false -- one subtle nearby aura per interval; it shares the global effect cap.
        end
    end
    for character in pairs(self.Records) do if not wanted[character] then self:Clear(character) end end
end
function Outfit.Destroy(self: any)
    for character in pairs(self.Records) do self:Clear(character) end
end
return Outfit
