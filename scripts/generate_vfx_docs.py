#!/usr/bin/env python3
"""Export complete Phase A scripts and append the actual Studio test handoff."""
from pathlib import Path
import json

root = Path(__file__).resolve().parents[1]
files = [
    'src/ReplicatedStorage/Shared/Theme.lua',
    'src/ReplicatedStorage/Shared/AnimConfig.lua',
    'src/ReplicatedStorage/Shared/VfxConfig.lua',
    'src/ReplicatedStorage/Shared/VisualBudget.lua',
    'src/ServerScriptService/AdminConfig.lua',
    'src/ServerScriptService/Domain/AdminProgression.lua',
    'src/ServerScriptService/Bootstrap.server.lua',
    'src/ServerScriptService/Services/WorldService.lua',
]
files.extend(str(p.relative_to(root)) for p in sorted(
    (root / 'src/StarterPlayer/StarterPlayerScripts/Visuals').glob('*.lua')))
files.extend([
    'src/StarterPlayer/StarterPlayerScripts/UI/Feedback.lua',
    'src/StarterPlayer/StarterPlayerScripts/UI/Menus.lua',
    'src/StarterPlayer/StarterPlayerScripts/UI/Developer.lua',
    'src/StarterPlayer/StarterPlayerScripts/UI/Presentation.lua',
    'src/StarterPlayer/StarterPlayerScripts/Mysteries.client.lua',
])

manifest = []
for filename in dict.fromkeys(files):
    path = Path(filename)
    if not (root / path).is_file():
        raise SystemExit('Missing Phase A source: ' + filename)
    if path.name.endswith('.client.lua'):
        kind, name = 'LocalScript', path.name.removesuffix('.client.lua')
    elif path.name.endswith('.server.lua'):
        kind, name = 'Script', path.name.removesuffix('.server.lua')
    else:
        kind, name = 'ModuleScript', path.stem
    manifest.append({
        'file': filename,
        'script_class': kind,
        'explorer_path': str(path.relative_to('src').parent / name),
    })

parts = [
    '# Phase A — full animation and VFX framework code\n',
    f'The {len(manifest)} scripts below are supplied in full. Install with Play stopped. '
    'Create matching Folder parents and replace the existing same-name scripts. Keep '
    'the unchanged foundation modules; do not run duplicate Mysteries or Bootstrap '
    'entrypoints. Theme is listed first. The ready-to-open place is '
    '`studio/Mysteries.rbxlx`.\n',
    'This is Phase A only. The test room previews reusable building blocks; '
    'pathway-specific ability choreography starts in Phase B. Animation, texture '
    'and sound slots are empty/0 until original assets are supplied.\n',
    '| File name | Class | Exact Explorer path |\n|---|---|---|',
]
for entry in manifest:
    parts.append(f"| `{entry['file']}` | {entry['script_class']} | `{entry['explorer_path']}` |")
for entry in manifest:
    parts.extend([
        '\n## ' + entry['file'] + '\n',
        '**Class:** ' + entry['script_class'] + '\n\n**Explorer path:** `'
        + entry['explorer_path'] + '`\n',
        '```lua\n' + (root / entry['file']).read_text().rstrip() + '\n```\n',
    ])
qa = (root / 'docs/PHASE_A_VFX.md').read_text()
parts.extend(['\n---\n', qa[qa.index('## Studio checklist'):]])
(root / 'docs/PHASE_A_VFX_CODE.md').write_text('\n'.join(parts).rstrip() + '\n')
(root / 'docs/PHASE_A_SCRIPTS.json').write_text(json.dumps(manifest, indent=2) + '\n')
print(f'Generated {len(manifest)} complete Phase A scripts and post-code Studio checklist')
