import bpy,json,sys,math
from mathutils import Vector,Matrix
src,out=sys.argv[sys.argv.index('--')+1:]
bpy.ops.object.select_all(action='SELECT');bpy.ops.object.delete(use_global=False)
matcache={}
for p in json.load(open(src)):
 key=tuple(p['color'])
 if key not in matcache:
  m=bpy.data.materials.new('Masonry');m.diffuse_color=(*key,1);matcache[key]=m
 w,h,d=[n/2 for n in p['size']]
 if p['kind']=='WedgePart':
  verts=[(-w,-h,-d),(w,-h,-d),(-w,-h,d),(w,-h,d),(-w,h,d),(w,h,d)]
  faces=[(0,1,3,2),(2,3,5,4),(0,2,4),(1,5,3),(0,4,5,1)]
 else:
  verts=[(-w,-h,-d),(w,-h,-d),(w,h,-d),(-w,h,-d),(-w,-h,d),(w,-h,d),(w,h,d),(-w,h,d)]
  faces=[(0,3,2,1),(4,5,6,7),(0,1,5,4),(3,7,6,2),(1,2,6,5),(0,4,7,3)]
 r=Matrix([p['rot'][i:i+3] for i in [0,3,6]]);pos=Vector(p['pos']);vv=[]
 for v in verts:
  q=r@Vector(v)+pos;vv.append((q.x,-q.z,q.y))
 mesh=bpy.data.meshes.new(p['name']);mesh.from_pydata(vv,[],faces);mesh.update()
 obj=bpy.data.objects.new(p['name'],mesh);bpy.context.collection.objects.link(obj);obj.data.materials.append(matcache[key])
bpy.ops.mesh.primitive_plane_add(size=1800);plane=bpy.context.object
m=bpy.data.materials.new('Ground');m.diffuse_color=(.25,.27,.26,1);plane.data.materials.append(m);plane.location.z=-1
bpy.ops.object.light_add(type='AREA',location=(-100,80,180));bpy.context.object.data.energy=250000;bpy.context.object.data.shape='DISK';bpy.context.object.data.size=200
bpy.ops.object.light_add(type='SUN');bpy.context.object.rotation_euler=(.4,-.5,-.5);bpy.context.object.data.energy=2
bpy.ops.object.camera_add(location=(290,390,220));camera=bpy.context.object;camera.rotation_euler=(Vector((0,0,25))-camera.location).to_track_quat('-Z','Y').to_euler();camera.data.type='ORTHO';camera.data.ortho_scale=530
scene=bpy.context.scene;scene.camera=camera;scene.render.engine='CYCLES';scene.cycles.samples=24;scene.cycles.use_denoising=False
scene.render.resolution_x=1800;scene.render.resolution_y=900;scene.render.resolution_percentage=100
scene.world.color=(.3,.3,.3);scene.render.filepath=out;bpy.ops.render.render(write_still=True)
