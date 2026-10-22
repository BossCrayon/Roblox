--!strict
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local Kit=require(script.Parent.Kit)
local Developer={}
function Developer.new(parent: Instance,send: any,testRoom: (() -> ())?): any
    local self: any={Allowed=false,State=nil}
    self.Root=Kit.Panel(parent,"DeveloperPanel");self.Root.ZIndex=T.Layers.Developer;self.Root.Visible=false
    local title=Kit.Text(self.Root,"DEVELOPER · F8",T.Type.Heading,T.Fonts.Heading)
    title.Position=UDim2.fromOffset(T.Layout.Developer.Pad,0);title.Size=UDim2.new(1,-T.Layout.Developer.Pad*2,0,T.Layout.Developer.Row)
    self.Scroll=Kit.New("ScrollingFrame",self.Root,{Name="DeveloperControls",BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=T.Style.Stroke,
        CanvasSize=UDim2.fromOffset(0,T.Layout.Developer.Height-T.Layout.Developer.Row),ScrollingDirection=Enum.ScrollingDirection.Y,
        Position=UDim2.fromOffset(0,T.Layout.Developer.Row),Size=UDim2.new(1,0,1,-T.Layout.Developer.Row)})
    self.Info=Kit.Text(self.Scroll,"",T.Type.Small,T.Fonts.Number)
    self.Info.Position=UDim2.fromOffset(T.Layout.Developer.Pad,0);self.Info.Size=UDim2.new(1,-T.Layout.Developer.Pad*2,0,T.Layout.Developer.Row*2)
    self.Buttons={}
    for i,id in ipairs({"Seer","Marauder","Apprentice"}) do
        local b=Kit.Button(self.Scroll,"Studio mastery: "..id,function()
            if self.Allowed then send("DevMastery",{PathwayId=id}) end
        end)
        b.Position=UDim2.fromOffset(T.Layout.Developer.Pad,T.Layout.Developer.Row*2+(i-1)*(T.Layout.Developer.Row+T.Layout.Developer.Gap))
        b.Size=UDim2.new(1,-T.Layout.Developer.Pad*2,0,T.Layout.Developer.Row);table.insert(self.Buttons,b)
    end
    if testRoom then
        self.TestButton=Kit.Button(self.Scroll,"Studio VFX test room",function()
            if self.Allowed then testRoom() end
        end)
        self.TestButton.Position=UDim2.fromOffset(T.Layout.Developer.Pad,T.Layout.Developer.Row*5+T.Layout.Developer.Gap*3)
        self.TestButton.Size=UDim2.new(1,-T.Layout.Developer.Pad*2,0,T.Layout.Developer.Row)
        self.Scroll.CanvasSize=UDim2.fromOffset(0,T.Layout.Developer.Row*6+T.Layout.Developer.Gap*4)
    end
    return setmetatable(self,{__index=Developer})
end
function Developer.Resize(self: any,layout: any)
    local width=math.min(T.Layout.Developer.Width,layout.Width-layout.Profile.Margin*2)
    self.Root.Size=UDim2.fromOffset(width,math.min(T.Layout.Developer.Height,layout.Height-layout.Profile.Margin*2))
    self.Root.Position=UDim2.fromOffset(layout.Width-layout.Profile.Margin-width,math.min(T.Layout.Developer.Top,layout.Profile.Margin))
end
function Developer.Update(self: any,state: any)
    self.State=state;self.Allowed=state and state.Developer==true
    if not self.Allowed then self.Root.Visible=false;return end
    local info=state.DeveloperInfo
    self.Info.Text=if info then (if info.SessionOnly then "Studio session · not saved" else "DataStore session").."\nMode: "..info.Mode.."\nReady: "..tostring(info.Ready) else "Loading developer diagnostics…"
    for _,b in ipairs(self.Buttons) do b.Interactable=info~=nil and info.SessionOnly==true and state.Ready end
end
function Developer.Toggle(self: any)
    if self.Allowed then self.Root.Visible=not self.Root.Visible end
end
return Developer
