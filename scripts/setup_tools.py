#!/usr/bin/env python3
"""Pinned, TLS/checksum-verified cloud tools; installs only under /workspace/lotm-tools."""
from pathlib import Path
import hashlib
import io
import json
import os
import subprocess
import urllib.request
import zipfile

root = Path(__file__).resolve().parents[1]
tools = Path('/workspace/lotm-tools')
manifest = json.loads((root/'scripts/tools.json').read_text())
tools.mkdir(exist_ok=True)
for artifact in manifest['artifacts']:
    target = tools/artifact['target']
    if target.is_file() and hashlib.sha256(target.read_bytes()).hexdigest() == artifact['file_sha256']:
        if artifact.get('executable'): target.chmod(target.stat().st_mode | 0o111)
        continue
    with urllib.request.urlopen(artifact['url'], timeout=60) as response:
        downloaded = response.read(64*1024*1024+1)
    if len(downloaded)>64*1024*1024 or hashlib.sha256(downloaded).hexdigest()!=artifact['download_sha256']:
        raise SystemExit('Artifact checksum mismatch: '+artifact['url'])
    if artifact.get('zip_member'):
        with zipfile.ZipFile(io.BytesIO(downloaded)) as archive:
            contents = archive.read(artifact['zip_member'])
    else:
        contents = downloaded
    if hashlib.sha256(contents).hexdigest()!=artifact['file_sha256']:
        raise SystemExit('Extracted checksum mismatch: '+artifact['target'])
    target.parent.mkdir(parents=True,exist_ok=True)
    temporary=target.with_suffix('.download')
    temporary.write_bytes(contents)
    if artifact.get('executable'): temporary.chmod(0o755)
    os.replace(temporary,target)
luau=tools/'luau'
if not luau.exists():
    subprocess.run(['git','clone','--depth','1','--branch',manifest['luau_tag'],manifest['luau_repository'],str(luau)],check=True)
commit=subprocess.check_output(['git','-C',str(luau),'rev-parse','HEAD'],text=True).strip()
if commit!=manifest['luau_commit']:
    raise SystemExit('Existing Luau checkout differs from the pin; preserve it and investigate')
if subprocess.check_output(['git','-C',str(luau),'status','--porcelain','--untracked-files=no'],text=True).strip():
    raise SystemExit('Existing Luau tool source has local modifications; refusing to build')
subprocess.run(['make','-s','-C',str(luau),'config=release','luau','luau-compile','-j2'],check=True)
print('Toolchain ready: Luau '+manifest['luau_tag']+', Rojo 7.5.1, luau-lsp 1.70.1')
