#!/usr/bin/env python3
"""Write complete copy/paste UI-phase scripts, including replacement server hooks."""
from pathlib import Path
import json

root=Path(__file__).resolve().parents[1]
files=[
 'src/ReplicatedStorage/Shared/Theme.lua',
 'src/ReplicatedStorage/Shared/VisualLayout.lua',
 'src/ReplicatedStorage/Shared/VisualModel.lua',
 'src/ReplicatedStorage/Shared/RuntimeConfig.lua',
 'src/ServerScriptService/AdminConfig.lua',
 'src/ServerScriptService/Domain/VisualAccess.lua',
 'src/ServerScriptService/Domain/AdminProgression.lua',
 'src/StarterPlayer/StarterPlayerScripts/UI/Kit.lua',
 'src/StarterPlayer/StarterPlayerScripts/UI/Hud.lua',
 'src/StarterPlayer/StarterPlayerScripts/UI/Menus.lua',
 'src/StarterPlayer/StarterPlayerScripts/UI/Prompts.lua',
 'src/StarterPlayer/StarterPlayerScripts/UI/Feedback.lua',
 'src/StarterPlayer/StarterPlayerScripts/UI/Developer.lua',
 'src/StarterPlayer/StarterPlayerScripts/UI/Presentation.lua',
 'src/StarterPlayer/StarterPlayerScripts/Mysteries.client.lua',
 'src/ServerScriptService/Services/WorldService.lua',
 'src/ServerScriptService/Bootstrap.server.lua',
]
manifest=[]
for file in files:
    p=Path(file)
    if p.name.endswith('.client.lua'):
        kind='LocalScript';name=p.name.removesuffix('.client.lua')
    elif p.name.endswith('.server.lua'):
        kind='Script';name=p.name.removesuffix('.server.lua')
    else:kind='ModuleScript';name=p.stem
    path=(p.relative_to('src').parent/name).as_posix()
    manifest.append(dict(file=file,script_class=kind,explorer_path=path))
parts=['# Phase 1 — complete copy/paste code\n',
       f'All {len(files)} production Luau files are supplied in full, including later admin-control updates. Create Folder parents, keep every existing unchanged module, and **replace** same-name scripts rather than running duplicate Bootstrap/Mysteries entrypoints. Install while Play is stopped. Theme is deliberately first. The complete built place is `studio/Mysteries.rbxlx`.\n',
       'This UI source export includes later integrations. Install the current framework from docs/PHASE_FI_VISUALS_CODE.md, or use docs/FULL_SOURCE.md for a blank place. The reference concept images were not received; the UI follows the Art Bible. Permanent label replacement and map redesign remain later phases.\n',
       '| File | Class | Explorer path |\n|---|---|---|']
for entry in manifest:parts.append('| `'+entry['file']+'` | '+entry['script_class']+' | `'+entry['explorer_path']+'` |')
for entry in manifest:
    parts.extend(['\n## '+entry['file']+'\n',
                  '**Class:** '+entry['script_class']+'\n\n**Explorer:** `'+entry['explorer_path']+'`\n',
                  '```lua\n'+(root/entry['file']).read_text().rstrip()+'\n```\n'])
qa=(root/'docs/PHASE1_UI.md').read_text()
parts.extend(['\n---\n',qa[qa.index('## Studio checklist'):]])
(root/'docs/PHASE1_UI_CODE.md').write_text('\n'.join(parts).rstrip()+'\n')
(root/'docs/PHASE1_SCRIPTS.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('Generated full scripts/classes/Explorer paths and post-code Studio checklist')
