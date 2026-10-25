#!/usr/bin/env python3
"""Export current Phase B full source, script classes/Explorer paths, then Studio QA."""
from pathlib import Path
import json

root=Path(__file__).resolve().parents[1]
files=[
    'src/ReplicatedStorage/Shared/Theme.lua',
    'src/ReplicatedStorage/Shared/AnimConfig.lua',
    'src/ReplicatedStorage/Shared/VfxConfig.lua',
    'src/ReplicatedStorage/Shared/VisualBudget.lua',
    'src/ServerScriptService/Bootstrap.server.lua',
    'src/ServerScriptService/Services/WorldService.lua',
    'src/ServerScriptService/Services/EffectService.lua',
    'src/ServerScriptService/Services/VisualEventService.lua',
    'src/StarterPlayer/StarterPlayerScripts/Mysteries.client.lua',
    'src/StarterPlayer/StarterPlayerScripts/UI/Hud.lua',
    'src/StarterPlayer/StarterPlayerScripts/UI/Menus.lua',
    'src/StarterPlayer/StarterPlayerScripts/UI/Presentation.lua',
]
files.extend(p.relative_to(root).as_posix() for p in sorted((root/'src/StarterPlayer/StarterPlayerScripts/Visuals').rglob('*.lua')))
manifest=[]
for filename in dict.fromkeys(files):
    file=Path(filename)
    if file.name.endswith('.server.lua'): kind,name='Script',file.name.removesuffix('.server.lua')
    elif file.name.endswith('.client.lua'): kind,name='LocalScript',file.name.removesuffix('.client.lua')
    else: kind,name='ModuleScript',file.stem
    manifest.append({'file':filename,'script_class':kind,'explorer_path':(file.relative_to('src').parent/name).as_posix()})
parts=['# Phase B — full copy-ready code\n',
       f'[EXISTING] These {len(manifest)} complete scripts include new modules, changed integrations and reused framework dependencies. '
       'Apply to the existing Mysteries foundation with Play stopped; replace matching scripts and create Folder parents. '
       'For a blank place use docs/FULL_SOURCE.md. The built studio/Mysteries.rbxlx already contains everything.\n',
       '[EXISTING] This historical Phase B export includes current C–E integration updates. All 54 abilities now have dedicated recipes; '
       'use docs/PHASE_FI_VISUALS_CODE.md for the current handoff. Studio rendering and engine/device performance remain unverified. '
       '[NEEDS NEW ASSET] Optional original uploaded audio/animation polish; every supplied slot remains 0/empty.\n',
       '| File | Class | Exact Explorer path |\n|---|---|---|']
for entry in manifest:
    parts.append(f"| `{entry['file']}` | {entry['script_class']} | `{entry['explorer_path']}` |")
for entry in manifest:
    parts.extend(['\n## '+entry['file']+'\n',
        '**Class:** '+entry['script_class']+'\n\n**Explorer path:** `'+entry['explorer_path']+'`\n',
        '```lua\n'+(root/entry['file']).read_text().rstrip()+'\n```\n'])
qa=(root/'docs/PHASE_B_VFX.md').read_text()
parts.extend(['\n---\n',qa[qa.index('## Studio checklist'):]])
(root/'docs/PHASE_B_VFX_CODE.md').write_text('\n'.join(parts).rstrip()+'\n')
(root/'docs/PHASE_B_SCRIPTS.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(f'Generated {len(manifest)} complete Phase B scripts/classes/Explorer paths and post-code Studio checklist')
