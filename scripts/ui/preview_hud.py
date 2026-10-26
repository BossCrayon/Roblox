"""Render a schematic from actual Theme/VisualLayout output, not a Studio screenshot."""
from pathlib import Path
import subprocess
from PIL import Image,ImageDraw,ImageFont
r=Path(__file__).resolve().parents[2];w=r/'build/hud-preview';w.mkdir(parents=True,exist_ok=True)
source='''local enum=setmetatable({},{__index=function(_,k) return k end})
local env={Color3={fromRGB=function(r,g,b) return {R=r/255,G=g/255,B=b/255} end},Enum=setmetatable({},{__index=function() return enum end}),script={Parent={Freeze={}}},require=function() return function(v) return v end end}
'''
source+='local theme=assert(loadstring([====['+(r/'src/ReplicatedStorage/Shared/Theme.lua').read_text()+']====]));setfenv(theme,setmetatable(env,{__index=getfenv()}));local t=theme()\n'
source+='local l=assert(loadstring([====['+(r/'src/ReplicatedStorage/Shared/VisualLayout.lua').read_text()+']====]))()\n'
source+='''local layout=l.Resolve(t,1024,560,false)
for _,key in ipairs({"Resources","Pathway","Journal","Map","Admin","Hotbar","Ultimate","Dash","Sprint","Notice","Wordmark"}) do
 local v=layout[key];print(key.."|"..v.X.."|"..v.Y.."|"..v.W.."|"..(if key=="Pathway" then layout.Profile.PathwayCollapsed else v.H))
end
for _,name in ipairs({"Thread","Crown","Star","Hourglass"}) do
 for _,stroke in ipairs(t.Glyphs[name]) do
  local coords={};for _,point in ipairs(stroke) do table.insert(coords,tostring(point[1]));table.insert(coords,tostring(point[2])) end
  print("GLYPH:"..name.."|"..table.concat(coords,"|"))
 end
end
print("Slot|"..layout.Profile.Slot.."|"..layout.Profile.SlotGap.."|"..layout.Profile.BarPad.."|0")
'''
(w/'layout.luau').write_text(source)
out=subprocess.check_output(['/workspace/lotm-tools/luau/luau',str(w/'layout.luau')],text=True)
rect={line.split('|')[0]:[float(n) for n in line.split('|')[1:]] for line in out.splitlines() if not line.startswith('GLYPH:')}
glyphs={}
for line in out.splitlines():
 if line.startswith('GLYPH:'):
  key,*values=line.split('|');glyphs.setdefault(key[6:],[]).append([float(v) for v in values])
im=Image.new('RGB',(1024,560),'#1e2832');d=ImageDraw.Draw(im)
font='/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
def txt(x,y,text,size=12,color='#e5e5df'):
 d.text((x,y),text,font=ImageFont.truetype(font,size),fill=color)
def box(key):
 x,y,w,h=rect[key];d.rounded_rectangle((x,y,x+w,y+h),radius=8,fill='#161d25',outline='#414a54');return x,y,w,h
# Neutral background emphasizes actual HUD occupancy without suggesting engine capture.
for y in range(0,560,40):d.line((0,y,1024,y),fill='#202c36')
txt(370,220,'GAMEPLAY VIEW',20,'#566675');txt(359,253,'Layout preview · not a Studio capture',12,'#647584')
x,y,w,h=box('Resources')
for i,(name,value,color) in enumerate([('HP','2800 / 2800','#b94a61'),('SP','20743 / 20743','#71b9da'),('SAN','100 / 100','#ad96dd')]):
 yy=y+10+i*24;txt(x+10,yy,name,10,color);txt(x+w-118,yy,value,11)
 d.rounded_rectangle((x+34,yy+17,x+w-10,yy+21),radius=2,fill=color)
x,y,w,h=box('Pathway');txt(x+12,y+7,'Fool · Seq 1 · 0%',13);txt(x+w-24,y+6,'+',14)
for key,text in [('Journal','Journal [B]'),('Map','Map [M]'),('Admin','Admin'),('Dash','Dash [Q]'),('Sprint','Run [Ctrl]')]:
 x,y,w,h=box(key);txt(x+12,y+(h-14)/2,text,12)
x,y,w,h=box('Wordmark');txt(x+24,y+6,'65° · Outskirts',12)
x,y,w,h=box('Notice');txt(x+56,y+8,'Dash is cooling down',12)
x,y,w,h=box('Hotbar');slot,gap,pad,_=rect['Slot']
for i,(glyph,cost) in enumerate([('Thread','356'),('Crown','336'),('Star','216'),('Star','216'),('Hourglass','120'),('Hourglass','120')]):
 xx=x+pad+i*(slot+gap);yy=y+8
 d.rounded_rectangle((xx,yy,xx+slot,yy+slot),radius=6,fill='#202833',outline='#666457')
 txt(xx+5,yy+3,str(i+1),10);
 for stroke in glyphs[glyph]:
  d.line([(xx+slot*.29+stroke[k]*slot*.42,yy+slot*.29+stroke[k+1]*slot*.42) for k in range(0,len(stroke),2)],fill='#c6a56b',width=2)
 txt(xx+slot/2-10,yy+slot+3,cost,10,'#71b9da')
x,y,w,h=rect['Ultimate'];d.rounded_rectangle((x,y+8,x+slot,y+8+slot),radius=6,fill='#202833',outline='#666457')
txt(x+5,y+11,'R',10);txt(x+17,y+28,'19',15);txt(x+8,y+slot+11,'Angel',10,'#71b9da')
d.line((x+4,y+slot+5,x+slot-4,y+slot+5),fill='#c6a56b',width=2)
im.save(r/'docs/HUD_PREVIEW.png');print(out)
