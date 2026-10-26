"""Original model inspired by the user's cloak/mask/worm reference; no copied assets."""
import bpy, math, pathlib
from mathutils import Vector
out=pathlib.Path(__file__).resolve().parents[2]/'art/fool_form'
bpy.ops.object.select_all(action='SELECT');bpy.ops.object.delete(use_global=False)
def material(name,color,metal=0):
 m=bpy.data.materials.new(name);m.diffuse_color=(*color,1);m.use_nodes=True
 p=m.node_tree.nodes.get('Principled BSDF');p.inputs['Base Color'].default_value=(*color,1);p.inputs['Metallic'].default_value=metal;p.inputs['Roughness'].default_value=.32
 return m
fog=material('Fog silver cloak',(.36,.39,.44),.3);dark=material('Dark liquid worms',(.10,.08,.15),.4);silver=material('Cold blank mask',(.66,.70,.75),.1)
# Open-front hooded shell; ragged folded hem and narrow hood apex.
verts=[];faces=[];rows=24;cols=48
for j in range(rows+1):
 t=j/rows;z=4.2-t*5.6;radius=.12+1.8*math.sin(t*math.pi*.57)
 for i in range(cols+1):
  a=.58+(math.pi*2-1.16)*i/cols
  ripple=(.06+.11*t)*math.sin(a*17+t*5)
  r=radius+ripple
  verts.append((math.sin(a)*r,math.cos(a)*r*.66,z+(t**6)*.25*math.sin(a*13)))
for j in range(rows):
 for i in range(cols):
  n=j*(cols+1)+i;faces.append((n,n+1,n+cols+2,n+cols+1))
mesh=bpy.data.meshes.new('Folded shell');mesh.from_pydata(verts,[],faces);mesh.update()
cloak=bpy.data.objects.new('Fool_Cloak',mesh);bpy.context.collection.objects.link(cloak);cloak.data.materials.append(fog)
solid=cloak.modifiers.new('Cloth thickness','SOLIDIFY');solid.thickness=.025
bpy.ops.mesh.primitive_uv_sphere_add(segments=20,ring_count=12,location=(0,.55,2.9));mask=bpy.context.object;mask.name='Fool_BlankMask';mask.scale=(.32,.12,.52);mask.data.materials.append(silver)
worms=[]
for k in range(12):
 curve=bpy.data.curves.new('Spirit worm','CURVE');curve.dimensions='3D';curve.resolution_u=2;curve.bevel_depth=.055+(k%3)*.012;curve.bevel_resolution=2
 spline=curve.splines.new('POLY');spline.points.add(47)
 for i,point in enumerate(spline.points):
  t=i/47;a=k*math.pi/6+t*math.pi*3;r=.22+t*.65
  point.co=(math.sin(a)*r,.5+math.cos(a)*.2,2.3-t*4.5+math.sin(a)*.14,1);point.radius=1-.8*t
 obj=bpy.data.objects.new('SpiritWorm',curve);bpy.context.collection.objects.link(obj);obj.data.materials.append(dark);worms.append(obj)
bpy.ops.object.select_all(action='DESELECT')
for obj in worms: obj.select_set(True)
bpy.context.view_layer.objects.active=worms[0];bpy.ops.object.convert(target='MESH');bpy.ops.object.join();bpy.context.object.name='Fool_SpiritWorms'
for obj in bpy.context.scene.objects:
 if obj.type=='MESH':
  for poly in obj.data.polygons: poly.use_smooth=True
bpy.ops.wm.save_as_mainfile(filepath=str(out/'FoolForm.blend'))
bpy.ops.export_scene.fbx(filepath=str(out/'FoolForm.fbx'),object_types={'MESH'},add_leaf_bones=False,bake_anim=False)
