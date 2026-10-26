#!/usr/bin/env python3
"""Export the actual architecture module through a math/Instance adapter for offline review.
This is not a Roblox Studio render or a physics test. Needs Luau and Blender.
"""
from pathlib import Path
import subprocess,json
root=Path(__file__).resolve().parents[2]
work=root/'build/tingen-preview';work.mkdir(parents=True,exist_ok=True)
mathshim=(root/'tests/phase_b.luau').read_text().split('    local VM={}',1)[1].split('    local CM={}',1)[0]
prefix='local VM={}'+mathshim+'''
local CM={};CM.__index=CM
local function cf(p,r,u,b) return setmetatable({Position=p or v(0,0,0),R=r or v(1,0,0),U=u or v(0,1,0),B=b or v(0,0,1)},CM) end
local function transform(f,p) return f.R*p.X+f.U*p.Y+f.B*p.Z end
CM.__mul=function(a,b) return cf(a.Position+transform(a,b.Position),transform(a,b.R),transform(a,b.U),transform(a,b.B)) end
local CFrame={}
CFrame.new=function(x,y,z) return cf(if type(x)=="table" then x else v(x or 0,y or 0,z or 0)) end
CFrame.fromMatrix=cf
CFrame.lookAt=function(p,target) local back=(p-target).Unit;local right=v(0,1,0):Cross(back).Unit;return cf(p,right,back:Cross(right),back) end
CFrame.Angles=function(x,y,z)
 local cx,sx,cy,sy,cz,sz=math.cos(x),math.sin(x),math.cos(y),math.sin(y),math.cos(z),math.sin(z)
 return cf(nil,v(cy*cz,cx*sz+sx*sy*cz,sx*sz-cx*sy*cz),v(-cy*sz,cx*cz-sx*sy*sz,sx*cz+cx*sy*sz),v(sy,-sx*cy,cx*cy))
end
local Vector3={new=v,zero=v(0,0,0)}
local Color3={fromRGB=function(r,g,b) return {r/255,g/255,b/255} end}
local all={}
local Instance={new=function(class)
 local o={ClassName=class,CFrame=cf(),Size=v(1,1,1),Color={1,1,1}}
 function o:SetAttribute() end
 table.insert(all,o);return o
end}
local Art={Part=function(parent,name,size,frame,color,solid)
 local p=Instance.new("Part");p.Parent=parent;p.Name=name;p.Size=size;p.CFrame=frame;p.Color=color;p.CanCollide=solid;return p
end}
local enums=setmetatable({},{__index=function(_,k) return k end})
local Enum=setmetatable({},{__index=function() return enums end})
local env={Vector3=Vector3,Vector2={new=function() return {} end},CFrame=CFrame,Color3=Color3,Instance=Instance,Enum=Enum,UDim2={fromScale=function() return {} end},script={Parent={WorldArt={}}},require=function() return Art end}
'''
source=(root/'src/ServerScriptService/Services/TingenArchitecture.lua').read_text()
tail='''
local A=fn()
local parent=Instance.new("Folder")
for i,s in ipairs({{11,"Daffodil terrace","Terrace",28,36},{10,"Iron Cross lodging","Tenement",32,36},{20,"Blackthorn","Blackthorn",32,44},{18,"Saint Selena","Cathedral",56,76},{28,"Industrial works","Factory",48,44}}) do
 A.Build(parent,{Id=s[1],Name=s[2],Kind=s[3],Width=s[4],Depth=s[5],Position=v((i-3)*85,0,0),Seed=s[1]})
end
for _,p in ipairs(all) do
 if p.ClassName=="Part" or p.ClassName=="WedgePart" then
 local f=p.CFrame;local c=p.Color
 print(string.format("%s|%s|%.5f,%.5f,%.5f|%.5f,%.5f,%.5f|%.5f,%.5f,%.5f,%.5f,%.5f,%.5f,%.5f,%.5f,%.5f|%.5f,%.5f,%.5f",p.ClassName,p.Name,p.Size.X,p.Size.Y,p.Size.Z,f.Position.X,f.Position.Y,f.Position.Z,f.R.X,f.U.X,f.B.X,f.R.Y,f.U.Y,f.B.Y,f.R.Z,f.U.Z,f.B.Z,c[1],c[2],c[3]))
 end
end
'''
runner=prefix+'\nlocal fn=assert(loadstring([====['+source+']====]));setfenv(fn,setmetatable(env,{__index=getfenv()}))\n'+tail
(work/'export.luau').write_text(runner)
result=subprocess.run(['/workspace/lotm-tools/luau/luau',str(work/'export.luau')],capture_output=True,text=True,check=True)
parts=[]
for line in result.stdout.splitlines():
 kind,name,size,pos,rot,color=line.split('|');parts.append(dict(kind=kind,name=name,size=[float(x) for x in size.split(',')],pos=[float(x) for x in pos.split(',')],rot=[float(x) for x in rot.split(',')],color=[float(x) for x in color.split(',')]))
(work/'geometry.json').write_text(json.dumps(parts))
print('Exported',len(parts),'parts from actual architecture module')
subprocess.run(['blender','-b','--python',str(root/'scripts/map/render_preview.py'),'--',str(work/'geometry.json'),str(root/'docs/TINGEN_ARCHITECTURE.png')],check=True,stdout=subprocess.DEVNULL)
