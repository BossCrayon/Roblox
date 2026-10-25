#!/usr/bin/env python3
"""Produce a standalone place/source bundle. Run scripts/check.py first."""
from pathlib import Path
import subprocess
import zipfile
import json
import hashlib
import shutil

root=Path(__file__).resolve().parents[1]
build=root/'build';build.mkdir(exist_ok=True)
place=build/'Mysteries.rbxlx'
if not place.is_file(): raise SystemExit('Run scripts/check.py to build/validate the place first')
(root/'studio').mkdir(exist_ok=True)
shutil.copyfile(place,root/'studio/Mysteries.rbxlx')
subprocess.run(['python3','scripts/generate_ui_docs.py'],cwd=root,check=True)
subprocess.run(['python3','scripts/generate_vfx_docs.py'],cwd=root,check=True)
subprocess.run(['python3','scripts/generate_phase_b_docs.py'],cwd=root,check=True)
subprocess.run(['python3','scripts/generate_phase_cde_docs.py'],cwd=root,check=True)
for flag,target in [('--stats','STATS.md'),('--catalog','ABILITY_GUIDE.md')]:
    result=subprocess.run(['python3','tests/run.py','/workspace/lotm-tools/luau/luau',flag],cwd=root,check=True,capture_output=True,text=True)
    (root/'docs'/target).write_text(result.stdout.rstrip()+'\n')
parts=['# Full source — Mysteries Roblox foundation\n',(root/'README.md').read_text()]
for file in sorted((root/'src').rglob('*.lua')):
    relative=file.relative_to(root/'src')
    if file.name.endswith('.server.lua'):
        kind='Script';name=file.name.removesuffix('.server.lua')
    elif file.name.endswith('.client.lua'):
        kind='LocalScript';name=file.name.removesuffix('.client.lua')
    else:
        kind='ModuleScript';name=file.stem
    destination=relative.parent/name
    parts.extend(['\n## '+str(file.relative_to(root))+'\n',
                  '**'+kind+'** at `'+str(destination)+'`. Create matching Folder parents.\n',
                  '```lua\n'+file.read_text()+'```\n'])
parts.extend(['\n## default.project.json\n','```json\n'+(root/'default.project.json').read_text()+'```\n'])
(root/'docs/FULL_SOURCE.md').write_text('\n'.join(parts))
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
