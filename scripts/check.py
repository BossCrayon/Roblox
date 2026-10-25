#!/usr/bin/env python3
"""Fail on test/compiler/analyzer/build errors; inspect the actual generated place."""
from pathlib import Path
import os
import subprocess
import sys
import xml.etree.ElementTree as ET

root=Path(__file__).resolve().parents[1]
tools=Path(os.environ.get('LOTM_TOOLS_DIR','/workspace/lotm-tools'))
exe='.exe' if sys.platform=='win32' else ''
luau_bin=tools/('bin/luau'+exe) if (tools/('bin/luau'+exe)).is_file() else tools/('luau/luau'+exe)
luau_compile_bin=tools/('bin/luau-compile'+exe) if (tools/('bin/luau-compile'+exe)).is_file() else tools/('luau/luau-compile'+exe)
rojo_bin=tools/('bin/rojo'+exe) if (tools/('bin/rojo'+exe)).is_file() else tools/('rojo/rojo'+exe)
luau_lsp_bin=tools/('bin/luau-lsp'+exe) if (tools/('bin/luau-lsp'+exe)).is_file() else tools/('luau-lsp/luau-lsp'+exe)
roblox_defs=tools/'types/roblox.d.luau' if (tools/'types/roblox.d.luau').is_file() else tools/'luau-lsp/roblox.d.luau'
build=root/'build';build.mkdir(exist_ok=True)
def run(args): subprocess.run([str(x) for x in args],cwd=root,check=True)
run([sys.executable,'-X','utf8','tests/run.py',luau_bin])
files=sorted((root/'src').rglob('*.lua'))+sorted((root/'tests').glob('*.luau'))
for file in files:
    subprocess.run([str(luau_compile_bin),str(file)],stdout=subprocess.DEVNULL,check=True)
print('PASS: compilation of '+str(len(files))+' Luau files',flush=True)
run([rojo_bin,'sourcemap','default.project.json','--output','build/sourcemap.json'])
run([luau_lsp_bin,'analyze','--platform','roblox','--definitions',roblox_defs,'--sourcemap','build/sourcemap.json','src'])
print('PASS: strict Roblox API/type analysis',flush=True)
run([rojo_bin,'build','default.project.json','-o','build/Mysteries.rbxlx'])
place=ET.parse(build/'Mysteries.rbxlx')
scripts=place.findall('.//Item[@class="Script"]')
clients=place.findall('.//Item[@class="LocalScript"]')
modules=place.findall('.//Item[@class="ModuleScript"]')
assert len(scripts)==1 and len(clients)==1,(len(scripts),len(clients))
assert len(modules)==len(list((root/'src').rglob('*.lua')))-2,'Missing ModuleScripts in generated place'
for element in [*scripts,*clients,*modules]:
    source=element.find('./Properties/*[@name="Source"]')
    assert source is not None and source.text and source.text.startswith('--!strict'), 'Missing source/strict directive'
expected={(p.relative_to(root/'src').parent/p.name.removesuffix('.lua').removesuffix('.server').removesuffix('.client')).as_posix():p.read_text(encoding='utf-8').replace('\r\n','\n')
          for p in (root/'src').rglob('*.lua')}
seen=set()
def inspect(element,parent=''):
    name=element.find('./Properties/string[@name="Name"]').text
    path=parent+'/'+name if parent else name
    if element.get('class') in {'Script','LocalScript','ModuleScript'}:
        source=element.find('./Properties/*[@name="Source"]').text.replace('\r\n','\n')
        assert path in expected and source==expected[path], 'Stale or mismatched source: '+path
        seen.add(path)
    for child in element.findall('./Item'): inspect(child,path)
for element in place.findall('./Item'): inspect(element)
assert seen==set(expected),'Missing Explorer paths in generated place'
print('PASS: generated place contains server/client entrypoints and all '+str(len(modules))+' ModuleScripts',flush=True)
