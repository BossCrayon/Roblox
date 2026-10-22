# Mysteries — playable Roblox foundation

The six requested implementation phases are represented in this project: data, server progression/persistence, all 54 selected ability executors across Sequences 9–1, HUD/input, procedural NPCs/world, and a first balance pass. The roster remains **Seer/Fool, Marauder/Error, and Apprentice/Door only**, with no Sequence 0.

This is a playable foundation with bounded gameplay interpretations of the powers, not an exhaustive recreation of every canonical technique. All lore claims remain `[UNVERIFIED]` because source access was blocked. Audio hooks await original sound assets; disguises use original face masks, color/identity changes and R15 body scaling rather than arbitrary species or live voice cloning. See `docs/LORE_REVIEW.md`.

## Open and play

1. Open the supplied **`build/Mysteries.rbxlx`** in desktop Roblox Studio and press **Play**. The server generates the sanctuary, potion altar, archives, practice doors, flame anchors, six arenas, and 18 procedural enemies. The client creates its HUD in PlayerGui.
2. Open the **journal [B]**, drink one of the three starter potions, and aim at nearby enemies or ground when using abilities.
3. Use **Q, E, R, F, Z, X** for the six equipped abilities. **Left click** is a basic strike. Touch users have hotbar, journal, and strike buttons; touch targeting uses the center of the camera.
4. In the journal select a numbered slot, then select an unlocked ability to equip it. Earlier powers remain available as sequence numbers decrease.

Studio defaults to **session-only storage**, clearly marked in the HUD. No Studio API access is required for that demo and progress does not survive the server closing. Published servers always use real DataStoreService; they never silently fall back to volatile storage.

Three **Studio-only mastery stones** near the sanctuary grant Sequence 1 and unlock the selected pathway's 18 abilities for quick checks. These stones only exist when both Studio and session-only mode are active; they cannot overwrite a persistent save. They are not exposed as remote commands.

## Progression loop

Each successful current-sequence acting objective awards **5 digestion**, with a **30-second reward cooldown** and server event deduplication. Read the objective in the HUD. Normal advancement requires 100 digestion; unsafe attempts are rejected and drain sanity. Completing an objective also accumulates a wish credit for later miracles.

Enemy kills award 25 gold. Exchange 100 gold at the sanctuary's **Potion Altar** for your next potion, then drink it in the journal. The transaction requires the correct pathway, exactly the next sequence, inventory ownership, a living normal-state character, adequate sanity and full digestion. It consumes one potion atomically without yielding and resets digestion/acting progress. Sequence 1 has no next potion.

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
- **388 executor/target assertions:** all 54 abilities across 28 handlers, ownership/range/visibility checks, limited loot and recordings, safe teleport rejection, real adapter damage decisions, one-use substitutes, graft reflections, and high-tier resistance. Roblox engine dependencies are mocked.
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
