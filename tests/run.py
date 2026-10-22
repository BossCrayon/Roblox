#!/usr/bin/env python3
"""Execute unmodified Roblox modules in Luau using only a ModuleScript tree shim.
Domain rules and actual executors run here; Roblox engine APIs use explicit stand-ins.
Physics, rendering, live remotes and real DataStoreService are not validated.
Usage: python tests/run.py /absolute/path/to/luau
"""
from pathlib import Path
import json
import subprocess
import sys
import tempfile

root = Path(__file__).resolve().parents[1]
shared = root / 'src/ReplicatedStorage/Shared'
def literal(text):
    for n in range(1, 20):
        marker = '=' * n
        if ']' + marker + ']' not in text:
            return '[' + marker + '[' + text + ']' + marker + ']'
    raise ValueError('Cannot quote source')

sources = {str(p.relative_to(shared).with_suffix('')): p.read_text()
           for p in sorted(shared.rglob('*.lua'))}
sources.update({'Server/'+str(p.relative_to(root/'src/ServerScriptService').with_suffix('')): p.read_text() for p in sorted((root/'src/ServerScriptService').rglob('*.lua')) if not p.name.endswith('.server.lua')})
sources.update({'Client/'+str(p.relative_to(root/'src/StarterPlayer/StarterPlayerScripts').with_suffix('')): p.read_text() for p in sorted((root/'src/StarterPlayer/StarterPlayerScripts').rglob('*.lua')) if not p.name.endswith('.client.lua')})
lines = ['local sources = {']
lines += ['[' + json.dumps(k) + '] = ' + literal(v) + ',' for k, v in sources.items()]
lines += ['}', '''
local nodes = {}
local function node(path, class)
    if nodes[path] then return nodes[path] end
    local name=string.match(path,"[^/]+$") or "Shared"
    local value={Name=name, ClassName=class, _children={}}
    function value:IsA(wanted) return self.ClassName==wanted end
    function value:GetChildren() return table.clone(self._children) end
    function value:FindFirstChild(wanted) return self[wanted] end
    nodes[path]=value
    if path~="" then
        local parentPath=string.match(path,"^(.*)/[^/]+$") or ""
        value.Parent=node(parentPath,"Folder")
        value.Parent[name]=value
        table.insert(value.Parent._children,value)
    end
    return value
end
for path in pairs(sources) do node(path,"ModuleScript") end
local cache={}
local moduleOverrides={}
local function moduleRequire(module)
    if cache[module]~=nil then return cache[module] end
    local path=nil
    for key,value in pairs(nodes) do if value==module then path=key; break end end
    assert(path and sources[path],"Unknown module")
    local chunk,err=loadstring(sources[path],path)
    assert(chunk,err)
    local environment={script=module,require=moduleRequire}
    for k,v in pairs(moduleOverrides[path] or {}) do environment[k]=v end
    setfenv(chunk,setmetatable(environment,{__index=getfenv()}))
    local result=chunk()
    cache[module]=result
    return result
end
local data=moduleRequire(nodes.GameData)
''', 'local validate = assert(loadstring(' + literal((root/('tests/stats.luau' if '--stats' in sys.argv else ('tests/catalog.luau' if '--catalog' in sys.argv else 'tests/validate.luau'))).read_text()) + ', "validate"))()', 'validate(data)']
if '--stats' not in sys.argv and '--catalog' not in sys.argv:
    lines += ['local coreTests=assert(loadstring(' + literal((root/'tests/core.luau').read_text()) + ', "core"))()',
              'coreTests(data,moduleRequire(nodes["Server/Domain/PlayerDomain"]),moduleRequire(nodes["Server/Domain/SessionStore"]),moduleRequire(nodes["Server/Domain/RateLimiter"]))']
    lines += ['local effectTests=assert(loadstring(' + literal((root/'tests/effects.luau').read_text()) + ', "effects"))()',
              '''effectTests(data,moduleRequire(nodes["Server/Domain/PlayerDomain"]),function(environment)
                  moduleOverrides["Server/Services/EffectService"]=environment
                  cache[nodes["Server/Services/EffectService"]]=nil
                  return moduleRequire(nodes["Server/Services/EffectService"])
              end,function(environment)
                  moduleOverrides["Server/Services/WorldService"]=environment
                  cache[nodes["Server/Services/WorldService"]]=nil
                  return moduleRequire(nodes["Server/Services/WorldService"])
              end)''']
    lines += ['local uiTests=assert(loadstring(' + literal((root/'tests/ui.luau').read_text()) + ', "ui"))()',
              '''uiTests(data,function(path,environment)
                  moduleOverrides[path]=environment
                  cache[nodes[path]]=nil
                  return moduleRequire(nodes[path])
              end,nodes[""])''']
    lines += ['local vfxTests=assert(loadstring(' + literal((root/'tests/vfx.luau').read_text()) + ', "vfx"))()',
              '''vfxTests(function(path,environment)
                  moduleOverrides[path]=environment
                  cache[nodes[path]]=nil
                  return moduleRequire(nodes[path])
              end,nodes[""])''']
    lines += ['local effectBlockTests=assert(loadstring(' + literal((root/'tests/effect_blocks.luau').read_text()) + ', "effect_blocks"))()',
              '''effectBlockTests(function(path,environment)
                  moduleOverrides[path]=environment
                  cache[nodes[path]]=nil
                  return moduleRequire(nodes[path])
              end,nodes[""])''']
    lines += ['local animationTests=assert(loadstring(' + literal((root/'tests/animation_controller.luau').read_text()) + ', "animation_controller"))()',
              '''animationTests(function(path,environment)
                  moduleOverrides[path]=environment
                  cache[nodes[path]]=nil
                  return moduleRequire(nodes[path])
              end,nodes[""])''']
with tempfile.TemporaryDirectory(prefix='lotm-tests-') as directory:
    runner = Path(directory)/'run.luau'
    runner.write_text('\n'.join(lines))
    result = subprocess.run([sys.argv[1] if len(sys.argv)>1 else 'luau', str(runner)])
    raise SystemExit(result.returncode)
