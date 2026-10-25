#!/usr/bin/env python3
"""Export the complete current production code with paths/classes and post-code QA."""
from pathlib import Path
import json

root=Path(__file__).resolve().parents[1]
theme=root/'src/ReplicatedStorage/Shared/Theme.lua'
files=[theme]+[p for p in sorted((root/'src').rglob('*.lua')) if p!=theme]
manifest=[]
for file in files:
    if file.name.endswith('.server.lua'): kind,name='Script',file.name.removesuffix('.server.lua')
    elif file.name.endswith('.client.lua'): kind,name='LocalScript',file.name.removesuffix('.client.lua')
    else: kind,name='ModuleScript',file.stem
    manifest.append({'file':file.relative_to(root).as_posix(),'script_class':kind,'explorer_path':(file.relative_to(root/'src').parent/name).as_posix()})
parts=['# Phases F–I — full copy-ready source\n',
       f'[EXISTING] All {len(manifest)} production scripts are supplied in full, Theme first. '
       'Create matching Folder parents, replace same-name scripts with Play stopped and do not run duplicate Bootstrap/Mysteries entrypoints. '
       'The built studio/Mysteries.rbxlx contains the same source. No toolbox assets or extra incoming remotes are required.\n',
       '[EXISTING] Phases F–I code and cloud checks are complete. [PROPOSED] Roblox Studio rendering, engine acceptance and measured real-device performance remain pending the checklist **after the code**. '
       '[NEEDS NEW ASSET] Optional original audio/animation/texture/sky polish; all supplied IDs remain 0/empty. Lore metadata remains [UNVERIFIED]; new named environments/enemies are original game fiction.\n',
       '| File | Class | Exact Explorer path |\n|---|---|---|']
for entry in manifest:
    parts.append(f"| `{entry['file']}` | {entry['script_class']} | `{entry['explorer_path']}` |")
for entry in manifest:
    parts.extend(['\n## '+entry['file']+'\n',
                  '**Class:** '+entry['script_class']+'\n\n**Explorer path:** `'+entry['explorer_path']+'`\n',
                  '```lua\n'+(root/entry['file']).read_text().rstrip()+'\n```\n'])
qa=(root/'docs/PHASE_FI_VISUALS.md').read_text()
parts.extend(['\n---\n',qa[qa.index('## Studio checklist'):]])
(root/'docs/PHASE_FI_VISUALS_CODE.md').write_text('\n'.join(parts).rstrip()+'\n')
(root/'docs/PHASE_FI_SCRIPTS.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(f'Generated {len(manifest)} full current scripts/classes/Explorer paths and post-code F–I Studio checklist')
