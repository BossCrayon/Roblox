--!strict
-- Native-part interpretation of documented Victorian forms; see docs/TINGEN_SOURCES.md.
local Art=require(script.Parent.WorldArt)
local A={}
local stone=Color3.fromRGB(164,157,143)
local slate=Color3.fromRGB(53,60,70)
local wood=Color3.fromRGB(68,48,39)
local palettes={Color3.fromRGB(127,105,91),Color3.fromRGB(144,132,114),Color3.fromRGB(117,127,139),Color3.fromRGB(111,84,74)}
function A.Build(parent: Instance,spec: any): Model
    local model=Instance.new("Model");model.Name=spec.Name;model.Parent=parent
    model:SetAttribute("Architecture",spec.Kind);model:SetAttribute("Reconstructed",true)
    local frame=CFrame.new(spec.Position)*CFrame.Angles(0,math.rad(spec.Angle or 0),0)
    local w,d=spec.Width,spec.Depth
    local detailed=spec.Id~=nil
    local cathedral=spec.Kind=="Cathedral"
    local factory=spec.Kind=="Factory"
    local worker=spec.Kind=="Tenement" or spec.Id==15 or spec.Id==55
    local middle=not worker and (spec.Kind=="Terrace" or spec.Kind=="House") and spec.Id~=5
    local estate=spec.Kind=="Estate"
    local ornament=detailed or (spec.Seed or 0)%3==0
    model:SetAttribute("HousingClass",if worker then "Workers" elseif middle then "MiddleClass" elseif estate then "Estate" else "NonResidential")
    model:SetAttribute("ClassEvidence",if spec.Id==10 or spec.Id==14 then "Iron Cross Street" elseif spec.Id==11 then "Daffodil Street" elseif spec.Id==35 or spec.Id==52 then "Affluent named estate" else "Inferred architectural treatment")
    local floors=if worker then 2 elseif middle then (if spec.Id==11 then 2 else 3) else spec.Floors or (if factory then 1 else 2)
    local storey=if worker or middle then 12 else 10
    local h=if cathedral then 44 elseif factory then 23 else floors*storey
    local color=if spec.Id==11 then Color3.fromRGB(111,127,148) elseif cathedral then Color3.fromRGB(77,81,88) elseif worker then Color3.fromRGB(91,59,51) elseif middle then Color3.fromRGB(122,90,67) else palettes[(spec.Seed or 0)%#palettes+1]
    local function b(name: string,size: Vector3,pos: Vector3,c: Color3,solid: boolean?): Part
        return Art.Part(model,name,size,frame*CFrame.new(pos),c,solid)
    end
    local function beam(name: string,a: Vector3,z: Vector3,thickness: number,c: Color3)
        local mid=(a+z)/2
        return Art.Part(model,name,Vector3.new(thickness,thickness,(z-a).Magnitude),frame*CFrame.lookAt(mid,z),c,false)
    end
    local function triangle(a: Vector3,bp: Vector3,c: Vector3,tint: Color3?)
        local ab,ac,bc=bp-a,c-a,c-bp
        if ab:Dot(ab)>ac:Dot(ac) and ab:Dot(ab)>bc:Dot(bc) then c,a=a,c
        elseif ac:Dot(ac)>bc:Dot(bc) then a,bp=bp,a end
        ab,ac,bc=bp-a,c-a,c-bp
        local right=ac:Cross(ab).Unit;local up=bc:Cross(right).Unit;local back=bc.Unit
        local height=math.abs(ab:Dot(up))
        for index,entry in ipairs({{At=(a+bp)/2,Right=right,Back=back,Length=math.abs(ab:Dot(back))},
            {At=(a+c)/2,Right=-right,Back=-back,Length=math.abs(ac:Dot(back))}}) do
            if entry.Length>.01 then
                local wedge=Instance.new("WedgePart");wedge.Name="Roof face "..index
                wedge.Size=Vector3.new(.2,height,entry.Length);wedge.CFrame=frame*CFrame.fromMatrix(entry.At,entry.Right,up,entry.Back)
                wedge.Color=tint or slate;wedge.Material=Enum.Material.Slate;wedge.Anchored=true
                wedge.CanCollide=false;wedge.CanTouch=false;wedge.CanQuery=false;wedge.Parent=model
            end
        end
    end

    local function roof(height: number,hipped: boolean)
        -- Four slopes form a hipped roof; no flat slab or roof overhang into adjacent plots.
        local rise=if cathedral then 20 elseif worker then 8 elseif middle then 10 else 5
        if middle and spec.Id~=11 then
            -- Steep four-sided mansard with a flat upper deck. Slopes stay inside
            -- the original parcel, so denser streets keep their clearance.
            local inset=math.min(w,d)*.2
            local corners={Vector3.new(-w/2,height,-d/2),Vector3.new(w/2,height,-d/2),Vector3.new(w/2,height,d/2),Vector3.new(-w/2,height,d/2)}
            local upper={Vector3.new(-w/2+inset,height+rise,-d/2+inset),Vector3.new(w/2-inset,height+rise,-d/2+inset),Vector3.new(w/2-inset,height+rise,d/2-inset),Vector3.new(-w/2+inset,height+rise,d/2-inset)}
            for i=1,4 do
                local j=i%4+1
                triangle(corners[i],corners[j],upper[j]);triangle(corners[i],upper[j],upper[i])
            end
            b("Mansard deck",Vector3.new(w-2*inset,.4,d-2*inset),Vector3.new(0,height+rise,0),slate,false).Material=Enum.Material.Slate
        elseif hipped then
            local front=Vector3.new(0,height+rise,-math.max(0,(d-w)/2))
            local rear=Vector3.new(0,height+rise,math.max(0,(d-w)/2))
            local a=Vector3.new(-w/2,height,-d/2);local bp=Vector3.new(w/2,height,-d/2)
            local c=Vector3.new(w/2,height,d/2);local e=Vector3.new(-w/2,height,d/2)
            triangle(a,bp,front);triangle(c,e,rear)
            triangle(bp,c,rear);if (front-rear).Magnitude>.01 then triangle(bp,rear,front) end
            triangle(e,a,front);if (front-rear).Magnitude>.01 then triangle(e,front,rear) end
        else
            for _,side in ipairs({-1,1}) do
                local pitch=math.atan2(rise,w/2)
                Art.Part(model,"Pitched slate roof",Vector3.new(math.sqrt((w/2)^2+rise^2),1,d),frame*CFrame.new(side*w/4,height+rise/2,0)*CFrame.Angles(0,0,-side*pitch),slate,false).Material=Enum.Material.Slate
            end
            triangle(Vector3.new(-w/2,height,-d/2),Vector3.new(w/2,height,-d/2),Vector3.new(0,height+rise,-d/2),color)
            triangle(Vector3.new(w/2,height,d/2),Vector3.new(-w/2,height,d/2),Vector3.new(0,height+rise,d/2),color)
        end
    end
    if estate then
        local pale=Color3.fromRGB(167,159,140);local metal=Color3.fromRGB(79,124,107)
        local gold=Color3.fromRGB(201,162,77);local dark=Color3.fromRGB(27,29,34)
        local warm=Color3.fromRGB(232,166,74)
        local cw=w*.375;local wing=w*.3125;local facade=-d*.2
        local top=if spec.Id==36 then 28 else 42
        -- Three joined masses, leaving a front garden and open central doorway.
        for _,section in ipairs({{0,cw,top},{-(cw+wing)/2,wing,28},{(cw+wing)/2,wing,28}}) do
            local x,sw,sh=section[1],section[2],section[3]
            b("Estate rear wall",Vector3.new(sw,sh,1),Vector3.new(x,sh/2,d/2-.5),pale,true).Material=Enum.Material.Limestone
            for _,side in ipairs({-1,1}) do
                b("Estate side wall",Vector3.new(1,sh,d*.7),Vector3.new(x+side*(sw/2-.5),sh/2,d*.15),pale,true).Material=Enum.Material.Limestone
            end
            if x==0 then
                for _,side in ipairs({-1,1}) do b("Estate entry surround",Vector3.new((sw-6)/2,sh,1),Vector3.new(side*(sw+6)/4,sh/2,facade),pale,true).Material=Enum.Material.Limestone end
                b("Estate entry lintel",Vector3.new(6,sh-10,1),Vector3.new(0,(sh+10)/2,facade),pale,true).Material=Enum.Material.Limestone
            else b("Estate facade",Vector3.new(sw,sh,1),Vector3.new(x,sh/2,facade),pale,true).Material=Enum.Material.Limestone end
            b("Estate floor",Vector3.new(sw,1,d*.7),Vector3.new(x,0,d*.15),pale,true)
            for _,side in ipairs({-1,1}) do
                Art.Part(model,"Estate mansard slope",Vector3.new(sw/2+1,1,d*.7),frame*CFrame.new(x+side*sw/4,sh+3,d*.15)*CFrame.Angles(0,0,-side*math.atan2(6,sw/2)),slate,false).Material=Enum.Material.Slate
            end
            triangle(Vector3.new(x-sw/2,sh,facade),Vector3.new(x+sw/2,sh,facade),Vector3.new(x,sh+6,facade),slate)
            b("Estate cornice",Vector3.new(sw,.7,d*.7),Vector3.new(x,sh,d*.15),pale,false)
            for floor=1,sh/14 do for _,side in ipairs({-1,1}) do
                local wx=x+side*sw*.28;local wy=(floor-1)*14+7
                b("Estate window surround",Vector3.new(4.6,8,.4),Vector3.new(wx,wy,facade-.5),dark,false)
                b("Estate window glass",Vector3.new(4,7,.5),Vector3.new(wx,wy,facade-.6),if (floor+(spec.Seed or 0))%3==0 then slate else warm,false).Material=Enum.Material.Glass
                b("Estate window mullion",Vector3.new(.2,7,.6),Vector3.new(wx,wy,facade-.7),dark,false)
                b("Estate window crossbar",Vector3.new(4,.2,.6),Vector3.new(wx,wy,facade-.7),dark,false)
            end end
        end
        for _,x in ipairs({-cw*.45,-cw*.3,cw*.3,cw*.45}) do
            b("Marble portico column",Vector3.new(1,12,1),Vector3.new(x,6,-d*.34),pale,true).Material=Enum.Material.Marble
        end
        b("Portico entablature",Vector3.new(cw,1,d*.18),Vector3.new(0,12,-d*.3),pale,false)
        triangle(Vector3.new(-cw/2,12,-d*.4),Vector3.new(cw/2,12,-d*.4),Vector3.new(0,17,-d*.4),pale)
        b("Verdigris roof cap",Vector3.new(cw*.35,.7,2),Vector3.new(0,top+6.5,d*.15),metal,false).Material=Enum.Material.Metal
        for _,side in ipairs({-1,1}) do
            b("Garden bed",Vector3.new(w*.34,.4,d*.18),Vector3.new(side*w*.31,.2,-d*.38),Color3.fromRGB(69,88,59),false).Material=Enum.Material.Grass
            b("Wrought iron fence rail",Vector3.new((w-8)/2,.2,.2),Vector3.new(side*(w+8)/4,3,-d/2+.4),dark,false)
            for x=4,w/2-1,2 do
                b("Fence upright",Vector3.new(.16,4,.16),Vector3.new(side*x,2,-d/2+.4),dark,false).Material=Enum.Material.Metal
            end
            local post=b("Gate pier",Vector3.new(.6,5,.6),Vector3.new(side*4,2.5,-d/2+.4),metal,false);post.Material=Enum.Material.Metal
            b("Brass gate finial",Vector3.new(.8,.8,.8),Vector3.new(side*4,5.4,-d/2+.4),gold,false).Shape=Enum.PartType.Ball
        end
        model:SetAttribute("VisualName",spec.Name)
        return model
    end
    if not detailed then
        b("Street frontage",Vector3.new(w,h,d),Vector3.new(0,h/2,0),color,true).Material=Enum.Material.Brick
    else
        b("Ground floor",Vector3.new(w,1,d),Vector3.zero,stone,true)
        for _,side in ipairs({-1,1}) do
            b("Masonry side",Vector3.new(1,h,d),Vector3.new(side*(w/2-.5),h/2,0),color,true).Material=Enum.Material.Brick
            b("Door surround",Vector3.new((w-8)/2,h,1),Vector3.new(side*(w+8)/4,h/2,-d/2+.5),color,true).Material=Enum.Material.Brick
        end
        b("Entrance lintel",Vector3.new(8,h-10,1),Vector3.new(0,(h+10)/2,-d/2+.5),color,true)
        b("Rear masonry",Vector3.new(w,h,1),Vector3.new(0,h/2,d/2-.5),color,true).Material=Enum.Material.Brick
        if not cathedral and not factory then
            -- Upper floor leaves a stairwell along the right wall.
            for level=1,floors-1 do
                b("Upper floor",Vector3.new(w-8,1,d-2),Vector3.new(-4,level*storey,0),wood,true)
                for step=1,16 do b("Stair tread",Vector3.new(6,storey/16,1.2),Vector3.new(w/2-4,(level-1)*storey+step*storey/16,-d/2+3+step*1.2),wood,true) end
            end
        end
    end
    b("Stone cornice",Vector3.new(w,.7,d),Vector3.new(0,h-.3,0),stone,false)
    roof(h,middle or spec.Id==11)
    for floor=1,floors-1 do
        b("Storey stringcourse",Vector3.new(w,.45,.45),Vector3.new(0,floor*storey,-d/2-.2),stone,false)
    end
    if detailed then
        for _,side in ipairs({-1,1}) do
            b("Corner stonework",Vector3.new(1,h,1),Vector3.new(side*(w/2-.5),h/2,-d/2+.5),stone,false)
        end
    end
    if not cathedral then
        local chimney=b("Brick chimney",Vector3.new(2.5,if factory then 38 else 7,3),Vector3.new(w/2-3,if factory then 19 else h+4,d/2-4),palettes[4],true);chimney.Material=Enum.Material.Brick
        if worker and (spec.Seed or 0)%12==0 then
            local smoke=Instance.new("Smoke");smoke.Name="Coal smoke";smoke.Color=Color3.fromRGB(47,53,68)
            smoke.Opacity=.12;smoke.RiseVelocity=3;smoke.Size=4;smoke.Parent=chimney
        end
    end
    if not detailed then b("Front door",Vector3.new(4,8,.2),Vector3.new(0,4,-d/2-.1),wood,false) end
    local warm=Color3.fromRGB(232,166,74)
    local iron=Color3.fromRGB(27,29,34)
    local windowColor=if cathedral then Color3.fromRGB(56,69,106) elseif worker or middle then (if (spec.Seed or 0)%2==0 then warm else Color3.fromRGB(47,53,68)) else Color3.fromRGB(114,143,151)
    for floor=1,(if cathedral then 2 else floors) do
        for _,side in ipairs({-1,1}) do
            local x=side*w*.28;local y=(floor-1)*storey+6
            b("Window sash",Vector3.new(4.6,6,.3),Vector3.new(x,y,-d/2-.1),stone,false)
            b("Window glass",Vector3.new(3.8,5,.35),Vector3.new(x,y,-d/2-.15),windowColor,false).Material=Enum.Material.Glass
            if detailed or ornament and worker then
                b("Window crossbar",Vector3.new(3.8,.18,.4),Vector3.new(x,y,-d/2-.3),iron,false)
                b("Window mullion",Vector3.new(.2,5,.4),Vector3.new(x,y,-d/2-.2),wood,false)
                b("Window sill",Vector3.new(5,.5,.7),Vector3.new(x,y-3,-d/2-.2),stone,false)
            end
        end
    end
    if worker or middle then
        b("Door transom",Vector3.new(3.6,1,.25),Vector3.new(0,8.8,-d/2-.16),windowColor,false).Material=Enum.Material.Glass
        b("Stone doorstep",Vector3.new(5,.5,1),Vector3.new(0,.25,-d/2+.5),stone,true).Material=Enum.Material.Limestone
        for _,dx in ipairs({-.65,.65}) do
            b("Paired chimney pot",Vector3.new(.65,2,.65),Vector3.new(w/2-3+dx,h+8,d/2-4),color,false).Material=Enum.Material.Brick
        end
        if middle and ornament and spec.Id~=11 then
            local bay=b("Projecting bay stonework",Vector3.new(6,7,1),Vector3.new(-w*.28,5,-d/2),stone,false);bay.Material=Enum.Material.Limestone
            b("Bay window",Vector3.new(5,6,.3),Vector3.new(-w*.28,5,-d/2-.55),windowColor,false).Material=Enum.Material.Glass
            b("Bay mullion",Vector3.new(.2,6,.4),Vector3.new(-w*.28,5,-d/2-.6),iron,false)
            b("Dormer",Vector3.new(4,4,3),Vector3.new(0,h+3,-d*.22),stone,false)
            b("Dormer glass",Vector3.new(2.8,2.8,.2),Vector3.new(0,h+3,-d*.22-1.6),windowColor,false).Material=Enum.Material.Glass
            triangle(Vector3.new(-2.5,h+5,-d*.22-1.7),Vector3.new(2.5,h+5,-d*.22-1.7),Vector3.new(0,h+7,-d*.22-1.7),stone)
            for step=1,3 do b("Stoop step",Vector3.new(5,step*.3,1),Vector3.new(0,step*.15,-d/2+(step-1)),stone,true) end
            for _,side in ipairs({-1,1}) do
                b("Iron stoop rail",Vector3.new(.18,3,2.5),Vector3.new(side*2.6,1.8,-d/2+1.25),iron,false).Material=Enum.Material.Metal
            end
        end
    end
    if spec.Kind=="Shop" or spec.Id==5 then
        local canopy=b("Shop awning",Vector3.new(w-2,.4,3),Vector3.new(0,9,-d/2-1),Color3.fromRGB(93,110,92),false)
        canopy.CFrame*=CFrame.Angles(math.rad(10),0,0)
    end
    if spec.Id==11 then
        -- Balcony and blue-grey street terrace exterior documented in chapter 30.
        b("Balcony floor",Vector3.new(w/2,.6,2),Vector3.new(0,10,-d/2-.6),stone,false)
        b("Balcony rail",Vector3.new(w/2,.3,.3),Vector3.new(0,13,-d/2-1.5),slate,false)
        for x=-w/4,w/4,2 do b("Balustrade",Vector3.new(.2,3,.2),Vector3.new(x,11.5,-d/2-1.5),slate,false) end
    end
    if spec.Kind=="Blackthorn" then
        -- Paired arched upper windows; second-floor office, before reconstruction.
        for _,side in ipairs({-1,1}) do
            local x=side*w*.28
            for j=0,7 do
                local a=j*math.pi/8;local z=(j+1)*math.pi/8
                beam("Arched window frame",Vector3.new(x+2.5*math.cos(a),18+2.5*math.sin(a),-d/2-.4),Vector3.new(x+2.5*math.cos(z),18+2.5*math.sin(z),-d/2-.4),.5,stone)
            end
        end
        b("Reception desk",Vector3.new(10,3,4),Vector3.new(-4,12,-3),wood,true)
        b("Office partition",Vector3.new(w-10,7,.5),Vector3.new(-4,14,4),stone,true)
    elseif cathedral then
        -- Saint Selena's central black clock tower replaces the unsupported twin towers.
        local tower=b(if spec.Id==18 then "Black clock tower" else "Reconstructed bell tower",Vector3.new(12,86,12),Vector3.new(0,43,-d/2+7),slate,true);tower.Material=Enum.Material.Brick
        -- Tower is raised above the doorway so the entrance is physically traversable.
        tower.Size=Vector3.new(12,70,12);tower.CFrame=frame*CFrame.new(0,51,-d/2+7)
        local apex=Vector3.new(0,106,-d/2+7)
        local corners={Vector3.new(-6,86,-d/2+1),Vector3.new(6,86,-d/2+1),Vector3.new(6,86,-d/2+13),Vector3.new(-6,86,-d/2+13)}
        for i=1,4 do triangle(corners[i],corners[i%4+1],apex) end
        b("Tower cornice",Vector3.new(13,1,13),Vector3.new(0,86,-d/2+7),stone,false)
        if spec.Id==18 then
        local clock=b("Clock face",Vector3.new(8,8,.4),Vector3.new(0,76,-d/2+.7),stone,false)
        beam("Hour hand",Vector3.new(0,76,-d/2+.4),Vector3.new(-2,78,-d/2+.4),.3,wood)
        beam("Minute hand",Vector3.new(0,76,-d/2+.4),Vector3.new(0,79,-d/2+.4),.2,wood)
        clock:SetAttribute("Clock",true)
        end
        for _,side in ipairs({-1,1}) do
            for row=0,5 do for col=0,2 do
                b("Stained glass",Vector3.new(2,3,.3),Vector3.new(side*w*.3+(col-1)*2,23+row*3,-d/2-.3),if (row+col)%2==0 then Color3.fromRGB(102,35,52) else Color3.fromRGB(29,43,83),false).Material=Enum.Material.Glass
            end end
            for z=-d/2+12,d/2-6,14 do
                b("Gothic buttress",Vector3.new(2,30,3),Vector3.new(side*(w/2-1),15,z),stone,true)
            end
        end
        for _,side in ipairs({-1,1}) do
            beam("Pointed entrance arch",Vector3.new(side*5,10,-d/2-.5),Vector3.new(0,15,-d/2-.5),1,stone)
        end
        b("Altar",Vector3.new(16,3,6),Vector3.new(0,2,d/2-8),stone,true)
        for row=0,4 do for _,side in ipairs({-1,1}) do b("Pew",Vector3.new(w/2-8,2,3),Vector3.new(side*w/4,1,-d/2+15+row*8),wood,true) end end
    elseif spec.Kind=="Civic" or spec.Kind=="College" or spec.Kind=="Theatre" then
        for _,side in ipairs({-1,1}) do b("Stone pilaster",Vector3.new(1.4,h,1),Vector3.new(side*(w/2-2),h/2,-d/2-.3),stone,false) end
    elseif spec.Kind=="Station" then
        b("Platform canopy",Vector3.new(w-2,.6,d/2),Vector3.new(0,14,0),slate,false)
    end
    if detailed then
        local sign=b("Address",Vector3.new(math.min(w-2,22),2,.3),Vector3.new(0,if spec.Kind=="Blackthorn" then 20 else 11,-d/2-.5),wood,false)
        sign:SetAttribute("VisualName",spec.Name)
        local gui=Instance.new("SurfaceGui");gui.Name="Street sign";gui.Face=Enum.NormalId.Front;gui.CanvasSize=Vector2.new(600,70);gui.Parent=sign
        local text=Instance.new("TextLabel");text.Size=UDim2.fromScale(1,1);text.BackgroundTransparency=1;text.TextColor3=Color3.fromRGB(235,220,190)
        text.Font=Enum.Font.Garamond;text.TextSize=28;text.TextWrapped=true;text.Text=spec.Name;text.Parent=gui
    end
    return model
end
return A
