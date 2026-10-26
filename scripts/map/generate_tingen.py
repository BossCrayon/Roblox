#!/usr/bin/env python3
"""Deterministic frontage reconstruction. Requires shapely. No network/assets.
The photographed map constrains geography, not individual unnamed building designs.
Exports one shared plan used by runtime construction, tests and review figures.
"""
from pathlib import Path
import math,json,re
from shapely.geometry import Polygon,LineString,Point,box
from shapely.ops import unary_union
ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'src/ReplicatedStorage/Shared/TingenPlan.lua'
landmarks=[]
for id,name,x,y,kind,approx in re.findall(r'Id=(\d+),Name="([^"]+)",X=(\d+),Y=(\d+),Kind="([^"]+)",Approximate=(\w+)',(ROOT/'src/ReplicatedStorage/Shared/TingenLayout.lua').read_text()):
 landmarks.append(dict(id=int(id),name=name,x=float(x),y=float(y),kind=kind))
# Silhouette digitized from the supplied photograph. Parks/cemetery are kept open.
boundary=[(276,262),(286,214),(325,166),(347,101),(363,67),(450,20),(578,18),(583,52),(716,63),(811,53),(813,122),(840,189),(881,238),(903,289),(938,304),(961,331),(951,409),(911,449),(857,466),(798,472),(777,516),(738,554),(630,553),(520,552),(491,510),(455,473),(394,445),(344,430),(299,412),(281,377),(287,343),(339,319),(336,288)]
urban=Polygon(boundary)
tussock=[(26,257),(42,281),(85,281),(132,304),(174,331),(217,370),(252,400),(303,420),(349,434),(402,457),(451,483),(487,514),(512,577),(551,598),(599,595),(645,594),(691,607),(737,604),(783,625),(819,665),(849,703),(875,764),(925,771),(906,719),(880,674),(837,630),(811,594),(786,564),(780,518),(751,547),(733,560),(685,562),(632,561),(577,562),(527,556),(509,514),(481,476),(425,445),(365,420),(312,411),(277,383),(254,350),(204,324),(160,295),(110,273),(60,258)]
# Only the visible northeastern reach is traced; no invented ring around eastern campus.
khoy=[(902,16),(893,50),(886,77),(875,105),(858,132),(848,157),(842,179),(847,199)]
riverpoly=Polygon(tussock).buffer(0);khoypoly=LineString(khoy).buffer(5)
# Principal streets traced approximately from visible white lines on the photo.
main=[
 [(346,109),(358,192),(381,259),(420,300),(514,326),(580,333),(649,351),(747,374),(833,408),(939,394)],
 [(582,13),(580,80),(574,151),(553,237),(545,310),(547,411),(538,550)],
 [(350,92),(448,76),(576,69),(688,94),(797,98)],
 [(327,177),(420,195),(504,223),(551,251),(647,221),(727,229),(796,235),(842,206)],
 [(291,350),(373,318),(425,282),(503,266),(552,255)],
 [(290,388),(389,346),(467,342),(550,348)],
 [(380,427),(454,416),(546,429),(648,436),(750,451),(797,472)],
 [(517,510),(614,514),(703,519),(760,525)],
 [(427,44),(450,126),(466,194),(478,271),(486,327),(491,416),(502,488)],
 [(615,74),(609,154),(598,223),(600,271),(625,318),(639,351),(650,438),(651,550)],
 [(695,95),(689,166),(683,231),(695,305),(721,358),(742,435),(748,515)],
 [(788,75),(778,167),(786,228),(797,276),(808,340),(820,408),(863,451)],
 [(838,209),(825,265),(841,306),(875,347),(936,369)],
 [(896,275),(889,323),(904,373),(925,414)],
]
roads=[]
for poly in main:
 for a,b in zip(poly,poly[1:]):roads.append((a,b,3.4,'Avenue'))
# Secondary streets follow the changing local grid direction in each district.
# Spacing is in map pixels, calibrated against the visible blocks (not named sites).
for xmin,ymin,xmax,ymax,angle,spacing in [(280,60,550,300,-10,23),(285,300,540,455,-3,21),(555,65,805,350,5,25),(545,350,785,550,2,25),(800,245,960,450,15,30)]:
 region=box(xmin,ymin,xmax,ymax).intersection(urban)
 cx,cy=(xmin+xmax)/2,(ymin+ymax)/2
 a=math.radians(angle);ux,uy=math.cos(a),math.sin(a);vx,vy=-uy,ux
 for axis in [0,1]:
  for offset in range(-350,351,spacing):
   dx,dy=(ux,uy) if axis==0 else (vx,vy);nx,ny=-dy,dx
   line=LineString([(cx+nx*offset-dx*500,cy+ny*offset-dy*500),(cx+nx*offset+dx*500,cy+ny*offset+dy*500)]).intersection(region)
   for seg in ([line] if line.geom_type=='LineString' else getattr(line,'geoms',[])):
    if seg.geom_type=='LineString' and seg.length>8:
     coords=list(seg.coords);roads.append((coords[0],coords[-1],2.0,'Street'))
# Explicit frontage lanes for tightly spaced reference sites.
for a,b in [((415,363),(483,363)),((500,321),(536,321)),((576,78),(576,160)),((431,197),(431,238))]:roads.append((a,b,2.4,'Frontage'))
# Plot dimensions are conservative interpretations, not supposed official footprints.
dims={'House':(7,8),'Terrace':(7,9),'Tenement':(8,9),'Shop':(7,8),'Office':(8,8),'Blackthorn':(8,11),'Cathedral':(14,19),'Civic':(12,10),'College':(14,13),'Institution':(14,12),'Theatre':(13,12),'Estate':(13,12),'Factory':(12,11),'Station':(17,11),'Market':(16,13),'Square':(22,20)}
plots=[]
for s in landmarks:
 if s['kind']=='River':continue
 variants=[(-10,'Veterans Club'),(0,'Divination Club'),(10,'Harrods Department Store')] if s['id']==5 else [(0,s['name'])]
 for dy,name in variants:
  q=dict(s);q['name']=name;q['y']+=dy
  w,d=dims.get(q['kind'],(7,8));q.update(w=w,d=d,angle=0)
  q['shape']=box(q['x']-w/2-1,q['y']-d/2-1,q['x']+w/2+1,q['y']+d/2+1)
  plots.append(q)
# Preserve civic square, institution grounds, estate gardens and cemetery enclosure.
reserved=[p['shape'] for p in plots]
for p in plots:
 if p['kind'] in ['Estate','College'] or p['id'] in [2,16,18]:reserved.append(p['shape'].buffer(4))
# Retain gameplay service building envelopes at Civic Square.
services=[box(655+x/4-6,310+y/4-6,655+x/4+6,310+y/4+6) for x,y in [(-34,-64),(34,-64),(-34,64),(34,64)]]
reserved.extend(services)
# Gameplay encounters live inland, away from the river bank.
yards=[(590+i*29,535) for i in range(6)]
reserved.extend(box(x-10,y-9,x+10,y+9) for x,y in yards)
exclusion=unary_union(reserved)
# Bend streets around occupied plots instead of drawing roads through landmarks.
# Local lanes and primary avenues use the same exact collision-aware geometry.
solidplots=unary_union([p['shape'].buffer(1) for p in plots if p['kind']!='Square']+services)
final=[]
for a,b,width,kind in roads:
 line=LineString([a,b]);clipped=line.difference(solidplots.buffer(width/2+.5))
 for seg in ([clipped] if clipped.geom_type=='LineString' else getattr(clipped,'geoms',[])):
  if seg.geom_type=='LineString' and seg.length>2:
   c=list(seg.coords);final.append((c[0],c[-1],width,kind))
# Perimeter service lanes reconnect streets cut by landmark reservations.
for p in plots:
 if p['kind'] in ['River','Square']:continue
 coords=list(p['shape'].buffer(3,join_style=2).exterior.coords)
 for a,b in zip(coords,coords[1:]):
  lane=LineString([a,b])
  if not lane.buffer(.8).intersects(solidplots):final.append((a,b,1.6,'Lane'))
roads=final
road_union=unary_union([LineString([a,b]).buffer(w/2+0.7,cap_style=2) for a,b,w,k in roads])
water_union=unary_union([riverpoly,khoypoly])
# Sample lots along roads. Long facade edges are parallel to the road, doors face it.
# Residential parcels have 0.6–1.2 stud party-wall gaps; occasional alleys break rows.
occupied=[];houses=[]
from shapely.strtree import STRtree
fixed=unary_union([exclusion,road_union,water_union.buffer(2)])
for rid,(a,b,rw,kind) in enumerate(roads):
 dx,dy=b[0]-a[0],b[1]-a[1];length=math.hypot(dx,dy);ux,uy=dx/length,dy/length
 for side in [-1,1]:
  cursor=2
  while cursor<length-3:
   west=a[0]<540;industrial=a[1]>425 and a[0]>545 and a[0]<780
   w=5.4 if west else (10 if industrial else 6.5);d=7 if west else (11 if industrial else 8)
   gap=.2 if west else .3
   mid=cursor+w/2;cursor+=w+gap
   if cursor>length-2:break
   nx,ny=-uy*side,ux*side
   x=a[0]+ux*mid+nx*(rw/2+.9+d/2);y=a[1]+uy*mid+ny*(rw/2+.9+d/2)
   poly=Polygon([(x+ux*u+nx*v,y+uy*u+ny*v) for u,v in [(-w/2,-d/2),(w/2,-d/2),(w/2,d/2),(-w/2,d/2)]])
   if not urban.contains(poly) or fixed.intersects(poly):continue
   if any(poly.intersects(q) for q in occupied[-400:]):continue
   # Full spatial query needed across distant intersecting road groups too.
   if occupied and STRtree(occupied).query(poly,predicate='intersects').size:continue
   # local +Z is away from road, so -Z entrance faces road
   angle=math.degrees(math.atan2(nx,ny))
   style='Factory' if industrial else ('Tenement' if west and y>300 else 'Terrace')
   houses.append(dict(x=x,y=y,w=w,d=d,angle=angle,style=style,floors=2 if west else 3))
   occupied.append(poly)
# Exhaustive validation of frontage placement before writing any output.
assert len(houses)>600,len(houses)
tree=STRtree(occupied)
for i,poly in enumerate(occupied):
 assert len(tree.query(poly,predicate='intersects'))==1,('overlap',i)
 assert not fixed.intersects(poly)
# Nearest-building edge gap summarizes density without pretending to be canon measurements.
near=[]
for i,p in enumerate(occupied):
 candidates=tree.query(p.buffer(3))
 ds=[p.distance(occupied[j])*4 for j in candidates if j!=i]
 if ds:near.append(min(ds))
report={'unnamedBuildings':len(houses),'landmarkBuildings':len(plots),'roadSegments':len(roads),'medianNearestFacadeGapStuds':round(sorted(near)[len(near)//2],2),'source':'user supplied 1080x809 settings-book photograph','allInfillClearOfRoadsWaterAndLandmarks':True}
# Numbers rounded only after validation; reserve an extra .01px clearance in rendering sizes.
def lua(v):
 if isinstance(v,str):return json.dumps(v)
 if isinstance(v,(float,int)):return str(round(v,4))
 if isinstance(v,list) or isinstance(v,tuple):return '{'+','.join(lua(x) for x in v)+'}'
 if isinstance(v,dict):return '{'+','.join(str(k)+'='+lua(x) for k,x in v.items())+'}'
ground=[];waters=[]
for y in range(-50,810,2):
 scan=LineString([(0,y+1),(1080,y+1)])
 for wet,geom in [(True,scan.intersection(water_union)),(False,scan.difference(water_union))]:
  for seg in ([geom] if geom.geom_type=='LineString' else getattr(geom,'geoms',[])):
   if seg.geom_type!='LineString' or seg.length<.01:continue
   x0,x1=seg.bounds[0],seg.bounds[2]
   while x0<x1:
    end=min(x0+400,x1)
    (waters if wet else ground).append([(x0+end)/2,y+1,end-x0,2])
    x0=end
plan={'Ground':ground,'Water':waters,'Roads':[[*a,*b,w,k] for a,b,w,k in roads],'Buildings':[[p['x'],p['y'],p['w']-.02,p['d']-.02,p['angle'],p['style'],p['floors']] for p in houses],'Plots':[[p['id'],p['name'],p['x'],p['y'],p['w'],p['d'],p['kind']] for p in plots],'Tussock':tussock,'Khoy':khoy,'Yards':yards,'Boundary':boundary}
OUT.write_text('--!strict\n-- Generated by scripts/map/generate_tingen.py; infill and local lanes are reconstructed.\nlocal plan: {[string]: {{any}}} = {\n'+',\n'.join(k+'={\n'+',\n'.join(lua(row) for row in v)+'\n}' for k,v in plan.items())+'\n}\nreturn require(script.Parent.Freeze)(plan)\n')
(ROOT/'docs/TINGEN_METRICS.json').write_text(json.dumps(report,indent=2)+'\n')
# Reproducible review plot: plan data, not an AI illustration or a Studio screenshot.
import matplotlib;matplotlib.use('Agg')
import matplotlib.pyplot as plt
fig,ax=plt.subplots(figsize=(16,12));fig.patch.set_facecolor('#eee8da');ax.set_facecolor('#eee8da')
ax.fill(*zip(*tussock),color='#527a89');ax.plot(*zip(*khoy),color='#527a89',linewidth=7)
for a,b,w,k in roads:ax.plot([a[0],b[0]],[a[1],b[1]],color='#b6af9f',linewidth=w*.5)
for p in occupied:ax.fill(*p.exterior.xy,color='#6f6860',linewidth=0)
for p in plots:
 ax.fill(*p['shape'].exterior.xy,color='#8e4434',alpha=.8)
 ax.text(p['x'],p['y'],str(p['id']),fontsize=5,ha='center',va='center',color='white')
ax.set_xlim(240,995);ax.set_ylim(620,0);ax.set_aspect('equal');ax.set_title('TINGEN — runtime footprint plan | numbered landmarks + unnamed street frontage',fontsize=14)
ax.text(250,602,f"{len(houses):,} unnamed buildings • streets / yards / water excluded • reconstructed footprints",fontsize=10)
ax.axis('off');fig.tight_layout();fig.savefig(ROOT/'docs/TINGEN_PLAN.png',dpi=160);plt.close(fig)
print(json.dumps(report))
