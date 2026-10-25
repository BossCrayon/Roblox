#!/usr/bin/env python3
"""Produce a standalone place/source bundle. Run scripts/check.py first."""
from pathlib import Path
import os
import subprocess
import sys
import zipfile
import json
import hashlib
import shutil

root=Path(__file__).resolve().parents[1]
tools=Path(os.environ.get('LOTM_TOOLS_DIR','/workspace/lotm-tools'))
exe='.exe' if sys.platform=='win32' else ''
luau_bin=tools/('bin/luau'+exe) if (tools/('bin/luau'+exe)).is_file() else tools/('luau/luau'+exe)
build=root/'build';build.mkdir(exist_ok=True)
place=build/'Mysteries.rbxlx'
if not place.is_file(): raise SystemExit('Run scripts/check.py to build/validate the place first')
(root/'studio').mkdir(exist_ok=True)
shutil.copyfile(place,root/'studio/Mysteries.rbxlx')
subprocess.run([sys.executable,'-X','utf8','scripts/generate_ui_docs.py'],cwd=root,check=True)
subprocess.run([sys.executable,'-X','utf8','scripts/generate_vfx_docs.py'],cwd=root,check=True)
subprocess.run([sys.executable,'-X','utf8','scripts/generate_phase_b_docs.py'],cwd=root,check=True)
subprocess.run([sys.executable,'-X','utf8','scripts/generate_phase_cde_docs.py'],cwd=root,check=True)
subprocess.run([sys.executable,'-X','utf8','scripts/generate_phase_fi_docs.py'],cwd=root,check=True)
for flag,target in [('--stats','STATS.md'),('--catalog','ABILITY_GUIDE.md')]:
    result=subprocess.run([sys.executable,'-X','utf8','tests/run.py',str(luau_bin),flag],cwd=root,check=True,capture_output=True,text=True,encoding='utf-8')
    (root/'docs'/target).write_text(result.stdout.rstrip()+'\n',encoding='utf-8')
parts=['# Full source — Mysteries Roblox foundation\n',(root/'README.md').read_text(encoding='utf-8')]
for file in sorted((root/'src').rglob('*.lua')):
    relative=file.relative_to(root/'src')
    if file.name.endswith('.server.lua'):
        kind='Script';name=file.name.removesuffix('.server.lua')
    elif file.name.endswith('.client.lua'):
        kind='LocalScript';name=file.name.removesuffix('.client.lua')
    else:
        kind='ModuleScript';name=file.stem
    destination=(relative.parent/name).as_posix()
    parts.extend(['\n## '+file.relative_to(root).as_posix()+'\n',
                  '**'+kind+'** at `'+destination+'`. Create matching Folder parents.\n',
                  '```lua\n'+file.read_text(encoding='utf-8')+'```\n'])
parts.extend(['\n## default.project.json\n','```json\n'+(root/'default.project.json').read_text(encoding='utf-8')+'```\n'])
(root/'docs/FULL_SOURCE.md').write_text('\n'.join(parts),encoding='utf-8')
output=build/'Mysteries-Complete.zip'
with zipfile.ZipFile(output,'w',zipfile.ZIP_DEFLATED) as archive:
    for file in sorted(root.rglob('*')):
        rel=file.relative_to(root)
        if file.is_file() and not any(p in {'.git','build','__pycache__'} for p in rel.parts): archive.write(file,rel)
    archive.write(place,'Mysteries.rbxlx')
with zipfile.ZipFile(output) as archive:
    assert archive.testzip() is None
    assert archive.read('Mysteries.rbxlx')==place.read_bytes()
manifest={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in (place,output)}
(build/'SHA256SUMS.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('Packaged '+str(output)+' ('+str(output.stat().st_size)+' bytes)')
print('Full code and exact Studio destinations: '+str(root/'docs/FULL_SOURCE.md'))
