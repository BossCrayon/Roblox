#!/usr/bin/env python3
"""Fail on test/compiler/analyzer/build errors; inspect the actual generated place."""
from pathlib import Path
import subprocess
import xml.etree.ElementTree as ET

root=Path(__file__).resolve().parents[1]
tools=Path('/workspace/lotm-tools')
build=root/'build';build.mkdir(exist_ok=True)
def run(args): subprocess.run([str(x) for x in args],cwd=root,check=True)
run(['python3','tests/run.py',tools/'luau/luau'])
files=sorted((root/'src').rglob('*.lua'))+sorted((root/'tests').glob('*.luau'))
for file in files:
    subprocess.run([str(tools/'luau/luau-compile'),str(file)],stdout=subprocess.DEVNULL,check=True)
print('PASS: compilation of '+str(len(files))+' Luau files',flush=True)
run([tools/'rojo/rojo','sourcemap','default.project.json','--output','build/sourcemap.json'])
run([tools/'luau-lsp/luau-lsp','analyze','--platform','roblox','--definitions',tools/'luau-lsp/roblox.d.luau','--sourcemap','build/sourcemap.json','src'])
print('PASS: strict Roblox API/type analysis',flush=True)
run([tools/'rojo/rojo','build','default.project.json','-o','build/Mysteries.rbxlx'])
place=ET.parse(build/'Mysteries.rbxlx')
scripts=place.findall('.//Item[@class="Script"]')
clients=place.findall('.//Item[@class="LocalScript"]')
modules=place.findall('.//Item[@class="ModuleScript"]')
assert len(scripts)==1 and len(clients)==1,(len(scripts),len(clients))
assert len(modules)==len(list((root/'src').rglob('*.lua')))-2,'Missing ModuleScripts in generated place'
for element in [*scripts,*clients,*modules]:
    source=element.find('./Properties/*[@name="Source"]')
    assert source is not None and source.text and source.text.startswith('--!strict'), 'Missing source/strict directive'
expected={str(p.relative_to(root/'src').parent/p.name.removesuffix('.lua').removesuffix('.server').removesuffix('.client')):p.read_text()
          for p in (root/'src').rglob('*.lua')}
seen=set()
def inspect(element,parent=''):
    name=element.find('./Properties/string[@name="Name"]').text
    path=parent+'/'+name if parent else name
    if element.get('class') in {'Script','LocalScript','ModuleScript'}:
        source=element.find('./Properties/*[@name="Source"]').text
        assert path in expected and source==expected[path], 'Stale or mismatched source: '+path
        seen.add(path)
    for child in element.findall('./Item'): inspect(child,path)
for element in place.findall('./Item'): inspect(element)
assert seen==set(expected),'Missing Explorer paths in generated place'
print('PASS: generated place contains server/client entrypoints and all '+str(len(modules))+' ModuleScripts',flush=True)
