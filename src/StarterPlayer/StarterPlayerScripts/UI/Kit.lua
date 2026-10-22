--!strict
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local T=require(ReplicatedStorage.Shared.Theme)
local Kit={}
local soundCount=0
local lastHover=-math.huge
function Kit.New(class: string,parent: Instance?,properties: any): any
    local object=Instance.new(class)
    for key,value in pairs(properties or {}) do (object :: any)[key]=value end
    object.Parent=parent
    return object
end
function Kit.Tween(object: Instance,duration: number,properties: any): Tween
    local tween=TweenService:Create(object,TweenInfo.new(duration,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),properties)
    tween:Play();return tween
end
function Kit.Sound(parent: Instance,key: string)
    local spec=T.Sound[key]
    if not spec or spec.Id<=0 or soundCount>=T.Sound.MaxPlaying then return end
    local now=os.clock()
    if key=="Hover" then
        if now-lastHover<T.Timing.SoundHoverGap then return end
        lastHover=now
    end
    soundCount+=1
    local sound=Kit.New("Sound",parent,{SoundId="rbxassetid://"..tostring(spec.Id),Volume=spec.Volume})
    local released=false
    local function release()
        if released then return end;released=true;sound:Destroy();soundCount-=1
    end
    sound.Ended:Once(release);sound:Play();task.delay(T.Timing.SoundLife,release)
end
function Kit.Corner(parent: Instance,radius: number?)
    return Kit.New("UICorner",parent,{CornerRadius=UDim.new(0,radius or T.Style.Corner)})
end
function Kit.Stroke(parent: Instance,color: Color3?,alpha: number?)
    return Kit.New("UIStroke",parent,{Color=color or T.Colors.Gold,Thickness=T.Style.Stroke,Transparency=alpha or T.Style.BorderAlpha,ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
end
function Kit.Panel(parent: Instance,name: string): Frame
    local f=Kit.New("Frame",parent,{Name=name,BorderSizePixel=0,BackgroundColor3=T.Colors.Ink,BackgroundTransparency=T.Style.PanelFade})
    Kit.Corner(f);Kit.Stroke(f)
    Kit.New("UIGradient",f,{Rotation=T.Style.PanelGradient,Color=ColorSequence.new(T.Colors.Ink,T.Colors.Ink:Lerp(T.Colors.Slate,T.Style.GradientEnd))})
    return f
end
function Kit.Text(parent: Instance,text: string,size: number?,font: Enum.Font?): TextLabel
    return Kit.New("TextLabel",parent,{BackgroundTransparency=1,BorderSizePixel=0,Text=text,TextColor3=T.Colors.Text,
        Font=font or T.Fonts.Body,TextSize=size or T.Type.Body,TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Center,TextWrapped=true,RichText=false})
end
function Kit.Button(parent: Instance,text: string,callback: ()->()): TextButton
    local b=Kit.New("TextButton",parent,{Text=text,BackgroundColor3=T.Colors.Slate,BorderSizePixel=0,
        TextColor3=T.Colors.Text,TextSize=T.Type.Number,Font=T.Fonts.Number,TextWrapped=true,AutoButtonColor=false})
    Kit.Corner(b);Kit.Stroke(b)
    local function enter() Kit.Sound(b,"Hover");Kit.Tween(b,T.Timing.Hover,{BackgroundColor3=T.Colors.Slate:Lerp(T.Colors.Gold,T.Style.HoverBlend)}) end
    local function leave() Kit.Tween(b,T.Timing.Return,{BackgroundColor3=T.Colors.Slate}) end
    b.MouseEnter:Connect(enter);b.SelectionGained:Connect(enter);b.MouseLeave:Connect(leave);b.SelectionLost:Connect(leave)
    b.Activated:Connect(function() Kit.Sound(b,"Click");callback() end)
    return b
end
function Kit.Padding(parent: Instance,pixels: number)
    return Kit.New("UIPadding",parent,{PaddingTop=UDim.new(0,pixels),PaddingBottom=UDim.new(0,pixels),PaddingLeft=UDim.new(0,pixels),PaddingRight=UDim.new(0,pixels)})
end
function Kit.List(parent: Instance,gap: number,horizontal: boolean?)
    return Kit.New("UIListLayout",parent,{Padding=UDim.new(0,gap),SortOrder=Enum.SortOrder.LayoutOrder,
        FillDirection=if horizontal then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical})
end
function Kit.Rect(object: GuiObject,r: any)
    object.Position=UDim2.fromOffset(r.X,r.Y);object.Size=UDim2.fromOffset(r.W,r.H)
end
function Kit.Glyph(parent: Instance,kind: string,pixels: number,color: Color3?): Frame
    local f=Kit.New("Frame",parent,{Name="Glyph_"..kind,BackgroundTransparency=1,Size=UDim2.fromOffset(pixels,pixels)})
    Kit.New("UIAspectRatioConstraint",f,{AspectRatio=1})
    for _,path in ipairs(T.Glyphs[kind] or T.Glyphs.Seal) do
        for i=1,#path-1 do
            local a,b=path[i],path[i+1]
            local dx,dy=(b[1]-a[1])*pixels,(b[2]-a[2])*pixels
            Kit.New("Frame",f,{BorderSizePixel=0,BackgroundColor3=color or T.Colors.Gold,
                AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale((a[1]+b[1])/2,(a[2]+b[2])/2),
                Size=UDim2.new(math.sqrt(dx*dx+dy*dy)/pixels,0,0,T.Style.IconStroke),Rotation=math.deg(math.atan2(dy,dx))})
        end
    end
    return f
end
function Kit.PathColor(id: any): Color3
    return if id=="Marauder" then T.Colors.Bronze elseif id=="Apprentice" then T.Colors.Teal else T.Colors.Gold
end
function Kit.Clear(parent: Instance)
    for _,child in ipairs(parent:GetChildren()) do child:Destroy() end
end
return Kit
