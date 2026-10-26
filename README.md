# Tingen map update

**City atlas:** press **M** to browse named locations. Door players can press **F**, select a destination and use **Travel**. [Controls and server validation](docs/CITY_MAP_TRAVEL.md).

The default world is now a Tingen city reconstruction with 1,204 unnamed street-front buildings surrounding the reference landmarks. See [scope, sources and Studio instructions](docs/TINGEN_MAP.md). Training-arena descriptions below describe the previous layout.

# Mysteries — playable Roblox foundation

> **[EXISTING] Through Phase I:** all **54** dedicated ability packages plus pathway HUD/Journal skins, confirmed potion/acting feedback, a larger Victorian sanctuary and six arenas, tiered R6/R15 outfits, six original enemy silhouettes/health widgets, scheduled threat cues, local atmosphere/lighting/labels and an authorized Studio stress harness. [Full source, classes and exact Explorer paths](docs/PHASE_FI_VISUALS_CODE.md) · [Phase F–I scope, Studio checklist and exact captures](docs/PHASE_FI_VISUALS.md). **[PROPOSED]** Rendered acceptance and measured device performance still need Studio; implementation is complete through I.

> **Admin powers:** `johnskie816` is configured in the server allowlist. Click **ADMIN**, choose a pathway and Sequence 9–1, then **Apply pathway & sequence**. [Setup, behavior and Studio checks](docs/ADMIN_POWERS.md). Published-server selections save to your profile; Studio session-only selections reset when you stop Play.

> **Animation/VFX — Phase A:** bounded client pools, 12 procedural animations, 11 reusable effect blocks, quality/120-stud LOD, reduced motion, low graphics and an authorized F8 Studio preview room. Phases B–E reuse these and add pooled stencil, card, paper, veil and contour compositions. [Framework code and script destinations](docs/PHASE_A_VFX_CODE.md) · [Numeric properties and framework tests](docs/PHASE_A_VFX.md).

> **Visual overhaul — Phase 1:** the current build includes a themed HUD, Journal/Pathway/Inventory tabs, confirmation-based potion UI, custom prompts, feedback and authorized developer diagnostics. [Full copy-ready code and script destinations](docs/PHASE1_UI_CODE.md) · [Studio checklist and exact screenshot requests](docs/PHASE1_UI.md). The F–I pass now includes world relayout, local landmark labels and zone cards.

The six requested implementation phases are represented in this project: data, server progression/persistence, all 54 selected ability executors across Sequences 9–1, HUD/input, procedural NPCs/world, and a first balance pass. The roster remains **Seer/Fool, Marauder/Error, and Apprentice/Door only**, with no Sequence 0.

This is a playable foundation with bounded gameplay interpretations of the powers, not an exhaustive recreation of every canonical technique. All lore claims remain `[UNVERIFIED]` because source access was blocked. Audio hooks await original sound assets; disguises use original face masks, color/identity changes and R15 body scaling rather than arbitrary species or live voice cloning. See `docs/LORE_REVIEW.md`.

## Open and play

1. Download **[studio/Mysteries.rbxlx](studio/Mysteries.rbxlx)** using GitHub's **Download raw file**, open it in desktop **Roblox Studio → File → Open from File**, and press **Play**. The server generates the sanctuary, potion altar, archives, practice doors, flame anchors, six arenas, and 18 procedural enemies. The client creates its HUD in PlayerGui from modules under StarterPlayerScripts/UI.
2. Open the **journal [B]**, drink one of the three starter potions, and aim at nearby enemies or ground when using abilities.
3. Use **Q, E, R, F, Z, X** for the six equipped abilities. **Left click** is a basic strike. Touch users have hotbar, journal, and strike buttons; touch targeting uses the center of the camera.
4. In the journal select a numbered slot, then select an unlocked ability to equip it. Earlier powers remain available as sequence numbers decrease.

Studio defaults to **session-only storage**, with storage diagnostics restricted to the authorized F8 developer panel. No Studio API access is required for that demo and progress does not survive the server closing. Published servers always use real DataStoreService; they never silently fall back to volatile storage.

The **ADMIN button** and **F8 shortcut** open pathway/sequence controls for the individual creator or a server-allowlisted account. `johnskie816` is configured by username and resolved to its numeric ID on the Roblox server; explicit numeric IDs also work. The server validates every change. The VFX test-room button remains Studio-only. See [admin setup](docs/ADMIN_POWERS.md).

## Progression loop

Each successful current-sequence acting objective awards **5 digestion**, with a **30-second reward cooldown** and server event deduplication. Read the objective in the HUD. Normal advancement requires 100 digestion; unsafe attempts are rejected and drain sanity. Completing an objective also accumulates a wish credit for later miracles.

Enemy kills award 25 gold. Open the sanctuary's **Potion Altar**, review and confirm the 100-gold purchase, then drink the next potion through Inventory's confirmation card. The transaction requires the correct pathway, exactly the next sequence, inventory ownership, a living normal-state character, adequate sanity and full digestion. It consumes one potion atomically without yielding and resets digestion/acting progress. Sequence 1 has no next potion.

The **Stabilization** pillar restores sanity and ends madness/loss of control at a cost of 20 digestion. Zero sanity enters 10 seconds of madness, followed by death and loss of control. After respawning, use Stabilization before casting again. High-tier arenas cause mystical exposure and whispers; mental resistance reduces sanity damage. Spirituality regenerates on a fixed scheduler, more slowly in combat.

Some acting objectives require interactions rather than simply pressing an ability:

| Sequence | How to complete the objective |
|---|---|
| Seer 8 | Let an actual hostile strike land during Acrobatic Evasion's invulnerability window. |
| Seer 7 | Flame-jump away from a nearby pursuing enemy using an orange anchor. |
| Seer 6 | Use Disguise, then interact with the Hidden Archive. |
| Seer 5 | Apply Spirit Body Threads three times to one eligible NPC before threads expire. |
| Seer 4 | Exchange with your own marionette while another enemy threatens the original position. |
| Seer 3 | Read the Hidden Archive, then invoke a historical echo. |
| Seer 2 | Fulfill a real recovery need, spending an accumulated wish credit. |
| Seer 1 | Graft an enemy, then let its actual attack reflect back to it. |
| Marauder 7 | Cast Decipher, then interact with the Cipher Archive while Cipher Sight lasts. |
| Apprentice 6 | Observe an eligible enemy casting, then Record its allowlisted power. |
| Apprentice 4 | Use Concealment, then protect the Hidden Archive by interacting while concealed. |
| Apprentice 2 | Equip retained Record and Replication; record a witnessed power, then release it. |

Other objectives complete on the corresponding successful server-validated theft, deception, divination, hostile influence, travel, or gate creation. Divination can fail; Intuition improves its accuracy. Targets that are too strong resist longer control/debuff effects. Direct marionette control and parasitism reject stronger-sequence NPCs. There is no PvP or player mind control.

## Studio persistence verification

To test actual persistence, publish a development place you control, set `RuntimeConfig.StudioSessionOnly=false`, and enable **Game Settings → Security → Enable Studio Access to API Services**. Use a separate development DataStore name rather than a production save. Restart the test server and confirm saved state returns. These real Roblox API checks were **not run** in the Linux cloud environment.

The store uses owner tokens and expiring leases acquired via UpdateAsync, bounded exponential backoff with jitter, owner-checked save/refresh/release, 45-second lease refresh/full saves, and PlayerRemoving/BindToClose handling. Failed loads never become default saves; malformed or future schemas are rejected. Schema version 1 is supported. Sanity, pathway, sequence, digestion, acting counts, computed stat snapshots, inventory, currency, credits and loadout are saved. Max stats are recomputed from data on load; health/spirituality refill on spawn. Runtime statuses, temporary copied powers and cooldowns are not persisted.

## Project layout and Studio placement

```text
ReplicatedStorage/Shared                  ModuleScripts: immutable data/types/config
  Pathways/{Seer,Marauder,Apprentice}      ModuleScripts: each pathway's 9 rows
ServerScriptService
  Bootstrap                              Script: Bootstrap.server.lua
  Domain/{PlayerDomain,SessionStore,RateLimiter}  ModuleScripts: pure server rules
  Services/{WorldService,EffectService}   ModuleScripts: Roblox engine adapters
StarterPlayer/StarterPlayerScripts
  Mysteries                              LocalScript: Mysteries.client.lua
StarterGui                               Reserved; HUD is created in PlayerGui
```

For manual copy/paste, `docs/FULL_SOURCE.md` includes every production script, its exact Studio destination and class, and the Rojo configuration. Folders must match the hierarchy. Do not insert server modules under ReplicatedStorage. No extra toolbox assets, packages, remotes, or prebuilt GUIs are needed; the server creates its remotes.

Rojo 7.5.1 can synchronize this layout using `default.project.json`. You can build the standalone place with:

```sh
cd /workspace/Roblox
/workspace/lotm-tools/rojo/rojo build default.project.json -o build/Mysteries.rbxlx
```

Use the existing isolated checkout for cloud tasks; do not create a worktree unless explicitly requested.

## Validation and reusable tooling

The tools install outside the repository under `/workspace/lotm-tools`. The installer pins Luau 0.693 to its full Git commit, Rojo 7.5.1, luau-lsp 1.70.1, and the matching Roblox API definitions. Download and extracted-file hashes are checked using `scripts/tools.json`; these are reproducibility pins from the TLS-verified upstream downloads, not upstream signature claims. Existing modified Luau sources are preserved and rejected for builds.

```sh
cd /workspace/Roblox
python3 scripts/setup_tools.py
python3 scripts/check.py
python3 scripts/package.py
```

Validation covers:

- **1,306 data assertions:** roster, references, stats, jumps, bounds and immutability.
- **2,163 domain assertions:** complete 9→1 advancement, acting deduplication, sanity, resources, cast reservations, lease contention/expiry, corrupt saves, retries and ambiguous committed responses.
- **701 executor/target assertions:** all 54 abilities across 28 handlers, with the production visual-event adapter and unchanged ownership/range/visibility checks, limited loot/recordings, safe teleports, damage decisions, substitutes, graft reflections and resistance. Roblox engine dependencies are mocked.
- **299 UI assertions:** responsive geometry, confirmation/cancellation, prompt lifecycle, role/admin controls, stored-power badge and synchronized cast-bar lifecycle with engine stand-ins.
- **572 admin progression assertions:** authorization denial, malformed inputs, all 27 pathway/sequence choices, valid loadouts/stats, persistence compatibility and cleanup bookkeeping.
- Animation/VFX assertions cover atomic budgets, seven pooled classes, culling/quality, all eleven blocks, animation blending/cleanup, camera caps/restoration and server-confirmed death presentation with engine stand-ins.
- **1,336 ability/status assertions:** all 54 dedicated recipes at three qualities with/without Reduced Motion, mobile packages, atomic multi-anchor admission/culling, private reveals/statuses, monotonic tokens, cancellation/stale-event rejection, bounded status labels, gate fallback/cleanup and late-join gate/echo snapshots. [Details](docs/PHASE_CDE_VFX.md).
- **1,476 F–I assertions:** native world construction/bounds/tags, all R6/R15 outfit choices and disguise cleanup, six enemy silhouettes/health pools, unchanged threat clocks, local lighting/labels/accessibility and actual stress overfill/drain adapters.
- **11,114 assertions total**, followed by compilation of **68 Luau files** and source verification of **54 ModuleScripts, one Script and one LocalScript** in the built place.
- Compilation of production and test Luau, strict Roblox API/type analysis, a real Rojo place build, and inspection that every script in the place exactly matches its source.

The domain and adapter boundaries deliberately accept validated dynamic profile/config/entity tables (`any`); strict mode does not replace runtime checks. No errors are suppressed with `--!nocheck`.

Roblox rendering, physics, live multiplayer remotes, actual DataStore access, and Studio import/play remain unverified here. `docs/STUDIO_TESTS.md` supplies the engine verification checklist. Neither Roblox publication nor cloud environment publication has been performed.

## Data and extension points

`GameData` provides deeply frozen registries. Each sequence exports base stats, absolute multipliers, two selected powers, passive descriptions and an acting objective. See `docs/STATS.md` for all 27 numeric rows. Digestion is separate progression state; sanity remains capped at 100. Perception is Spirit Vision range in studs; Resistance is a rating.

Add a ModuleScript under `Shared/Pathways` returning the `Types.Pathway` schema or calling `PathwayFactory`. Discovery, potion generation and ability registries require no central roster edits. A factory module supplies nine rows ordered **9 → 1**, a source URL, and optional custom base stats as the fifth argument. Row structure:

```lua
{sequenceName, primaryName, actingLabel, serverSignal, primaryDescription,
 passiveDescription, primaryTarget,
 {secondaryName, secondaryTarget, secondaryDescription},
 {Primary={Kind="Buff", Status="Shielded", Duration=10},
  Secondary={Kind="Sense", Status="Vision", Duration=20}}}
```

Targets are `Self`, `NPC`, or `Position`. Existing operation kinds can be composed through data; a genuinely new mechanic requires a server handler. The current release's tests intentionally assert three pathways and 54 selected abilities and must be expanded with the roster. Reuse documented internal signals for event-based acting, never client-claimed completions. Keep stable IDs when persistence exists.

Generic cooldown/cost/range/scaling lives in `AbilityData`/`StatData`; per-power operation options live in the pathway modules. NPC, exposure, purchase, hit and resource settings live in the shared configuration modules. Clients may read this public balance data but cannot authorize mutations. See `docs/SERVER_CONTRACTS.md` for the implementation boundaries.
