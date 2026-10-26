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
    local floors=spec.Floors or (if factory then 1 else 2)
    local h=if cathedral then 44 elseif factory then 23 else floors*10
    local color=if spec.Id==11 then Color3.fromRGB(111,127,148) elseif cathedral then Color3.fromRGB(77,81,88) else palettes[(spec.Seed or 0)%#palettes+1]
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
        local rise=if cathedral then 20 else 5
        if hipped then
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
            b("Upper floor",Vector3.new(w-8,1,d-2),Vector3.new(-4,10,0),wood,true)
            for step=1,16 do b("Stair tread",Vector3.new(6,.625,1.2),Vector3.new(w/2-4,step*.625,-d/2+3+step*1.2),wood,true) end
        end
    end
    b("Stone cornice",Vector3.new(w,.7,d),Vector3.new(0,h-.3,0),stone,false)
    roof(h,spec.Kind=="Terrace" or spec.Id==11)
    for floor=1,floors-1 do
        b("Storey stringcourse",Vector3.new(w,.45,.45),Vector3.new(0,floor*10,-d/2-.2),stone,false)
    end
    if detailed then
        for _,side in ipairs({-1,1}) do
            b("Corner stonework",Vector3.new(1,h,1),Vector3.new(side*(w/2-.5),h/2,-d/2+.5),stone,false)
        end
    end
    if not cathedral then
        b("Brick chimney",Vector3.new(2.5,if factory then 38 else 7,3),Vector3.new(w/2-3,if factory then 19 else h+4,d/2-4),palettes[4],true).Material=Enum.Material.Brick
    end
    if not detailed then b("Front door",Vector3.new(4,8,.2),Vector3.new(0,4,-d/2-.1),wood,false) end
    local windowColor=if cathedral then Color3.fromRGB(56,69,106) else Color3.fromRGB(114,143,151)
    for floor=1,(if cathedral then 2 else floors) do
        for _,side in ipairs({-1,1}) do
            local x=side*w*.28;local y=(floor-1)*10+6
            b("Window sash",Vector3.new(4.6,6,.3),Vector3.new(x,y,-d/2-.1),stone,false)
            b("Window glass",Vector3.new(3.8,5,.35),Vector3.new(x,y,-d/2-.15),windowColor,false).Material=Enum.Material.Glass
            if detailed then
                b("Window mullion",Vector3.new(.2,5,.4),Vector3.new(x,y,-d/2-.2),wood,false)
                b("Window sill",Vector3.new(5,.5,.7),Vector3.new(x,y-3,-d/2-.2),stone,false)
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
