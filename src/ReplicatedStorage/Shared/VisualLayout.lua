--!strict
-- Pure responsive geometry; measured in the ScreenGui's usable safe area.
local Layout={}
local function rectangle(x: number,y: number,w: number,h: number): any return {X=x,Y=y,W=w,H=h} end
function Layout.Intersects(a: any,b: any,pad: number?): boolean
    local p=pad or 0
    return a.W>0 and a.H>0 and b.W>0 and b.H>0 and a.X<b.X+b.W+p and b.X<a.X+a.W+p and a.Y<b.Y+b.H+p and b.Y<a.Y+a.H+p
end
function Layout.Resolve(theme: any,width: number,height: number,touch: boolean): any
    local l=theme.Layout
    local name=if touch and height<l.CompactHeight then "Landscape" elseif width<l.TabletWidth then "Phone" elseif width<l.DesktopWidth then "Tablet" else "Desktop"
    local p=l[name]
    local barW=l.Hotbar.Slots*p.Slot+(l.Hotbar.Slots-1)*p.SlotGap+p.BarPad*2
    local bx=(width-barW)/2
    local resources=rectangle(p.Margin,p.ResourceTop,p.Resources[1],p.Resources[2])
    if name=="Landscape" and bx<resources.X+resources.W+l.Modal.Gap then
        bx=math.min(width-p.Margin-barW,resources.X+resources.W+l.Modal.Gap)
    end
    local bar=rectangle(bx,height-p.HotbarBottom-p.HotbarHeight,barW,p.HotbarHeight)
    local pathway=rectangle(p.Margin,p.PathwayTop,p.PathwayWidth,p.PathwayHeight)
    local expandedFits=height>=l.CompactHeight and pathway.Y+pathway.H<=height-p.Margin and not Layout.Intersects(pathway,bar,l.Modal.Gap)
    local modalW=math.min(p.Modal[1],width-p.ModalMargin)
    local modalH=math.min(p.Modal[2],height-p.ModalMargin)
    local confirmW=math.min(l.Modal.CardWidth,width-p.ModalMargin)
    local confirmH=math.min(l.Modal.CardHeight,height-p.ModalMargin)
    local wordmark=rectangle((width-p.Wordmark[1])/2,p.WordmarkTop,p.Wordmark[1],p.Wordmark[2])
    if Layout.Intersects(resources,wordmark,l.Modal.Gap) then
        wordmark.W=math.max(1,math.min(wordmark.W,width-2*(resources.X+resources.W+l.Modal.Gap)))
        wordmark.X=(width-wordmark.W)/2
    end
    local action=rectangle(width-p.Margin-l.Actions.Width,bar.Y-l.Actions.Gap-l.Actions.Height,l.Actions.Width,l.Actions.Height)
    local noticeW=math.min(l.Notice.Width,width-p.Margin*2)
    local notice=rectangle((width-noticeW)/2,bar.Y-l.Notice.BottomGap-l.Notice.Height-(if touch then l.Actions.Height+l.Actions.Gap else 0),noticeW,l.Notice.Height)
    if name=="Landscape" then
        notice=rectangle(bar.X,math.max(0,bar.Y-l.Notice.CompactHeight-l.Modal.Gap),math.min(bar.W,action.X-l.Actions.Gap-bar.X),l.Notice.CompactHeight)
    end
    return {Name=name,Profile=p,Width=width,Height=height,Resources=resources,Hotbar=bar,Pathway=pathway,
        CanExpand=expandedFits,DefaultCollapsed=touch or name=="Phone" or not expandedFits,
        Wordmark=wordmark,
        Journal=rectangle(width-p.Margin-p.JournalButton[1],p.Margin,p.JournalButton[1],p.JournalButton[2]),
        Modal=rectangle((width-modalW)/2,(height-modalH)/2,modalW,modalH),
        Confirm=rectangle((width-confirmW)/2,(height-confirmH)/2,confirmW,confirmH),
        Notice=notice,Action=action,
        Cast=rectangle(bar.X+(bar.W-l.Cast.Width)/2,math.max(0,math.min(height/2+l.Cast.CenterOffset,bar.Y-l.Cast.Height-l.Modal.Gap)),l.Cast.Width,l.Cast.Height),
        Advance=rectangle(p.Margin,l.Advance.Top,width-p.Margin*2,l.Advance.Height)}
end
return table.freeze(Layout)
