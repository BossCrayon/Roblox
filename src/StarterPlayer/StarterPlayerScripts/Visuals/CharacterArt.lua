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
    if record then record.Model:Destroy();self.Records[character]=nil end
end
function Outfit.Build(self: any,character: Model,path: string,sequence: number,torso: BasePart,head: BasePart,myth: string?)
    self:Clear(character)
    local stage=if myth=="Incomplete" or myth=="Complete" then myth else ""
    local model=Instance.new("Model");model.Name="LocalMysteriesOutfit";model.Parent=character
    local count=0;local cloth=A.Cloth[path];local trim=A.Trim[path]
    local function piece(name: string,base: BasePart,size: {number},offset: CFrame,color: Color3,material: Enum.Material?,alpha: number?)
        if count>=A.MaxParts then return end;count+=1
        local part=Instance.new("Part");part.Name=name;part.Size=Vector3.new(table.unpack(size));part.CFrame=base.CFrame*offset
        part.Anchored=false;part.CanCollide=false;part.CanQuery=false;part.CanTouch=false;part.Massless=true;part.CastShadow=false
        part.Material=material or Enum.Material.Fabric;part.Color=color;part.Transparency=alpha or 0;part.Parent=model
        local weld=Instance.new("WeldConstraint");weld.Part0=base;weld.Part1=part;weld.Parent=part
    end
    local bodyScale=math.clamp(torso.Size.X/2,A.BodyScaleMin,A.BodyScaleMax)
    local coat={A.Coat[1]*bodyScale,math.max(A.Coat[2],torso.Size.Y),math.max(A.Coat[3],torso.Size.Z+A.CoatClearance)}
    if stage=="Complete" then
        if path=="Seer" then
            -- Complete Angel Mythical Creature Form: Worms of Spirit (dark translucent cloak + blank mask + tentacled spirit-worm collective)
            piece("Spirit cloak mantle",torso,{coat[1]*1.14,coat[2]*1.12,coat[3]*1.14},CFrame.identity,T.Colors.DeepPurple,Enum.Material.Glass,M.CloakAlpha)
            piece("Boiling fog shroud",torso,{coat[1]*1.22,coat[2]*0.95,coat[3]*1.2},CFrame.new(0,-0.15,0.12),T.Colors.Fog,Enum.Material.Neon,M.SpiritAlpha)
            piece("Cold blank mask",head,M.SeerMask,CFrame.new(0,0,-head.Size.Z/2-0.08),T.Colors.Text,Enum.Material.SmoothPlastic,0.08)
            piece("Antique spirit halo",head,A.Brim,CFrame.new(0,head.Size.Y/2+0.35,0.2)*CFrame.Angles(math.rad(72),0,0),T.Colors.Gold,Enum.Material.Neon,M.GlowAlpha)
            for idx,angle in ipairs({-52,-18,18,52}) do
                local rad=math.rad(angle)
                piece("Worm of Spirit tentacle "..tostring(idx),torso,M.SeerTentacle,
                    CFrame.new(math.sin(rad)*1.05,-coat[2]/2-0.55,math.cos(rad)*0.65)*CFrame.Angles(math.rad(24),rad,math.rad(angle*0.4)),
                    if idx%2==0 then T.Colors.Fog else T.Colors.DeepPurple,Enum.Material.Neon,M.GlowAlpha)
            end
            for _,side in ipairs({-1,1}) do
                piece("Spirit worm cluster",torso,M.SeerWorm,CFrame.new(side*0.95,0.25,0.25)*CFrame.Angles(math.rad(18),0,math.rad(side*32)),T.Colors.Gold,Enum.Material.Neon,M.GlowAlpha)
            end
        elseif path=="Marauder" then
            -- Complete Angel Mythical Creature Form: Worms of Time (12-section ancient stone clock phantom + ringed Worms of Time)
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
            -- Complete Angel Mythical Creature Form: Worms of Star ("Door of All Doors" — nested astral doorways of starlight & teal)
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
        -- Incomplete Saint Mythical Creature Manifestation (Sequence 4–3): Victorian attire fracturing into partial Worms
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
    self.Records[character]={Model=model,Path=path,Sequence=sequence,Mythical=stage,Torso=torso,Head=head}
end
function Outfit.Step(self: any,dt: number)
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
    if aura then self.AuraAt=now+A.AuraInterval end
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
        local profile=self.Service:Profile()
        if aura and (seq<=6 or myth~="") and not self.Service.LowGraphics and not self.Service.ReducedMotion and not profile.Low and self.Service:Visible(item.Root.Position) then
            local blockName=if myth=="Complete" then "SigilStencil" elseif myth=="Incomplete" or seq<=3 then "VeilRibbon" else "RisingMotes"
            local stencil=if path=="Seer" then "Worm" elseif path=="Marauder" then "Clock" else "Arch"
            self.Blocks:Compose({{Name=blockName,Position=torso.Position,Palette=path,Options={Scale=if myth~="" then A.AuraScale*1.18 else A.AuraScale,Stencil=stencil}}},1,0,A.AuraLife)
            aura=false -- one subtle nearby aura per interval; it shares the global effect cap.
        end
    end
    for character in pairs(self.Records) do if not wanted[character] then self:Clear(character) end end
end
function Outfit.Destroy(self: any)
    for character in pairs(self.Records) do self:Clear(character) end
end
return Outfit
