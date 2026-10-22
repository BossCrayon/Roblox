# Phase 1 — gothic UI overhaul

This phase implements UI only, plus the server hooks needed for purchase confirmation, developer authorization and damage-number evidence. The full map, lighting, permanent label replacement, cinematic zone entries and pathway VFX redesign remain later phases. Phase 3 is explicitly authorized to enlarge and relayout the map; current bounds are not a design limit. Spawn points, portal validation, enemy stats and server authority must remain working during that later change.

The referenced hub/HUD concept images were not present in the received attachments. This version follows `ART_BIBLE.md`; image-specific comparison remains pending their reattachment.

## Open the updated place

Download `studio/Mysteries.rbxlx` from GitHub using **Download raw file**, then **Roblox Studio → File → Open from File → Play**. Do not open an older downloaded copy. The same GitHub path is updated with the current build.

Source installation alternative: `PHASE1_UI_CODE.md` contains the **complete contents** of every added or changed production Luau file, with file name, class, and Explorer path. Create the matching folders and replace existing scripts with the same names. Do not add a second `Bootstrap` or `Mysteries` entrypoint. Stop Play mode while installing, and only start again once all modules are present.

No texture/icon upload is needed: bottle, ability, book and resource glyphs are original native UI geometry. Sound bindings initially use asset ID **0**, meaning disabled; hooks exist on every button click/hover. In `ReplicatedStorage.Shared.Theme`, replace `Sound.Hover.Id`, `Sound.Click.Id`, `Sound.Confirm.Id`, `Sound.Reject.Id`, `Sound.JournalOpen.Id`, `Sound.Advance.Id` and `Sound.Hit.Id` with IDs for original audio you own. Per-ability hooks go in `Theme.Sound.Abilities`. Use numeric IDs, not copied audio from another game. Restart Play after editing Theme because ModuleScripts are cached.

## What changes

- Slim animated vitals with original crests, an opaque readable backing and separate numbers.
- Collapsible pathway/digestion panel; constrained layouts open the Pathway tab instead of expanding over combat controls.
- Six tarot-like slots with original glyphs, key badges, spirituality costs and a 32-segment circular cooldown ring. Unequipped slots show dim dashed seals with no “Empty” label. Touch aiming uses the camera center with a small reticle.
- Journal, Pathway and Inventory tabs. The journal supports a six-slot picker and retained ability library; potion actions open a preview before consumption.
- Potion Altar preview with owned quantity, gold cost, sequence transition, digestion requirement and fixed Confirm/Cancel controls. Merely opening/canceling does not buy anything. Purchase can happen before digestion is complete; drinking still requires the original progression rules.
- The server issues a short-lived altar invitation from the actual nearby prompt, then rechecks distance, current pathway/sequence, currency, ownership and character state on confirmation. Double confirmation cannot charge twice. Preview expiration does not extend server validity.
- Compact custom prompt UI projects near the object, supports keyboard/controller/touch hold input, and yields to safe-area/HUD exclusions. While active, legacy floating signs are temporarily hidden and optional masthead/pathway UI yields space. Labels restore when the prompt ends. Phase 2 will replace the old signs globally rather than merely suppress them during interactions.
- Pooled damage numbers from server-confirmed damage, hit-edge flash, low-sanity edge treatment, reduced-motion control, cast progress and sequence-advance text.
- No player-facing storage/debug/mode banner. Diagnostics and Studio mastery are behind **F8 only**, with server-validated access. The old public test stones are removed. Studio still defaults to nonpersistent progress, as before; that technical status is visible in the developer panel and documented here.

Existing combat numbers, enemy stats, potion rules, digestion rewards, session locks, saves, spawning and portal behavior are unchanged. Server changes are confined to the hooks above. Existing world colors and labels are not restyled in this phase; all **Phase 1** visual constants and audio IDs are in Theme. World-art tokens will move there as those later phases are implemented.

## Creator / admin setup

An individual published experience creator is authorized by the server using `game.CreatorId` and `game.CreatorType`. Other users are authorized only by numeric ID in **ServerScriptService → AdminConfig → AdminUserIds**. Group membership by itself never grants access.

An unpublished local place may have CreatorId 0, so F8 will correctly do nothing until you configure an allowlist entry. Open your Roblox profile in a browser, take the numeric ID from `/users/NUMBER/profile`, and enter that number in `AdminConfig`'s list. Do not use your username, GitHub ID or group ID. Keep the list empty for everyone else. Studio's synthetic negative test-player IDs have no implicit access.

F8 shows the diagnostics panel only for an authorized user. The three mastery buttons also require **Studio + session-only storage** on the server; they remain disabled against persistent saves. They grant Sequence 1 for testing using the existing test capability, not a new public progression remote. For early-sequence tests, stop and restart a session-only Play session to get fresh progress.

## Automated evidence

Run `python3 scripts/check.py` from the project root. It executes:

- 1,306 shared-data assertions.
- 2,163 server-domain assertions.
- 388 executor/target assertions with engine adapters mocked.
- 221 visual model/layout/access and UI lifecycle assertions, including actual component constructors with GUI stand-ins.
- Compilation of 39 production/test Luau files, strict Roblox API/type analysis, a Rojo place build, and exact source inspection inside the generated place.

The visual checks cover nine usable viewport sizes, contrast for six opaque text/background pairs, 44-pixel minimum slot targets, sparse loadouts, vacant seals, ring updates, nonmutating previews, pending confirmations, stale invites, creator/group/admin decisions and custom prompt visibility. **They do not render fonts, emulate Roblox controls or certify appearance, real safe-area behavior, input routing, physics or live networking.** Those need the checks below.

## Studio checklist — run after installing all code

### Desktop

1. Open a fresh copy of the updated place; use a viewport close to **1920×1080**, then **1280×720**. In **View → Output**, check there are no red errors. Verify there is no storage/session/“Normal” banner.
2. Before drinking, all six slots should show dashed seals. No slot may show “Empty.” Press B, open Inventory, select a starter potion and cancel. Quantity and pathway must not change. Repeat and confirm: one potion is consumed, the server advances, two powers appear, and the sequence text animates once.
3. Open Journal, choose a slot, equip a power and hover it. Check glyph, name, spirituality cost, keyboard badge and 32-segment cooldown. Re-equip across slots to produce gaps; no menu errors or blank-scroll failures should occur.
4. Fight a nearby enemy: verify server damage numbers, health flash, resource tween and cast feedback. The presentation must not alter damage or cooldowns. Turn on Reduced motion in Journal; breathing/flash should stop, while numeric feedback remains readable.
5. Approach Potion Altar: only one compact custom prompt should show; old floating labels should be hidden during its presentation. Hold its displayed key. Check preview and Confirm/Cancel are visible. Cancel: no gold deducted. Earn 100 gold, reopen and confirm: one next potion, one charge. Buying does not itself advance you.
6. Open the altar, walk away before confirming, and try confirmation. It must not charge. Reopen, wait over 15 seconds, then check the button is disabled. Reopen again for a valid purchase. While a menu is open, ability/strike inputs and background prompts must not fire; walking is not a pause of the server simulation.
7. Verify E uses the active interaction prompt without also casting hotbar slot 2. Leave the prompt's range and confirm labels restore. Test an existing spatial gate's custom prompt after unlocking a Traveler power.
8. Press F8 as the creator/allowlisted account, then close it with F8. Check diagnostics stay inside that panel. In a two-client test, unprivileged synthetic/other accounts must not open it or gain mastery. Group ownership alone must not authorize arbitrary group members.

### Phone emulator

Use Studio's **Test → Device Emulator** (device controls may appear in the Test toolbar), select a phone around **390×844**, and test both portrait and landscape around **844×390**. Keep default Roblox touch controls enabled.

- Check top/device insets: resource icons and numbers, book button and all six slots must be visible. No text under a notch/top bar; no hotbar under joystick/jump. Smallest slot hit area stays at least 44×44.
- Tap the journal icon. All three tabs, slot-picker horizontal scroll, ability-list vertical scroll, close control and Inventory preview must work. Confirm/Cancel stay fixed while preview content scrolls.
- Tap ability/Strike buttons while aiming the camera at an NPC; the target uses the center reticle, not the tapped button's screen position.
- Approach altar and tap/hold the custom prompt. Check readability, hold progress, menu opening and no collision with vitals/hotbar/remaining labels. Rotate while open and while casting; card bounds and scroll controls must recalculate.
- Check toast, touch Strike button, casting strip and cooldown rings do not stack over one another. In cramped landscape, masthead/pathway content may yield to active feedback or prompts.

### Tablet emulator

Use approximately **768×1024 portrait** and **1024×768 landscape** with touch controls enabled.

- Verify vitals and masthead do not touch, all six slots remain tappable, and the collapsed pathway can expand without covering combat controls.
- Verify Journal/Pathway/Inventory tabs, slot selection, modal centering, potion preview and fixed actions in both orientations. Check long names such as “Attendant of Mysteries” and “Trojan Horse of Destiny.”
- Repeat one cast, one prompt interaction, one cancellation and one legitimate purchase. Watch Output for errors during resize, respawn, repeated open/close and device rotation.

### Finishing checks

At graphics quality 1 and again at a higher quality, text must stay readable on opaque dark panels. Check at 100% OS scaling and your normal OS scaling. After several respawns there must still be one MysteriesHUD and one MysteriesSanity effect. If low sanity is reached naturally, capture the vignette with resource numbers readable; do not weaken server rules merely for the screenshot. Audio is intentionally silent until IDs are configured; after setting originals, verify hover/click/confirm/reject sounds with no asset permission errors.

Do not delete script errors, suppress assertions, turn on DataStore access, or change enemy/progression balance just to make a visual check pass. Report the exact error and device size instead.

## Exactly which screenshots to send

Send full **game viewport** images at 100% image scale, keeping every HUD edge and default touch control visible. Include the emulator's device/resolution in the filename or message; a second wider Studio-window image is useful if an inset/device issue occurs. Do not crop away the hotbar, top bar, notch or bottom controls.

1. **`01-desktop-idle.png`** — fresh uninitiated desktop HUD; all six dashed seals, masthead and pathway row visible; developer panel closed.
2. **`02-desktop-combat.png`** — after drinking a starter potion, with at least one cooldown ring/countdown and spirituality cost visible. Include cast feedback or a damage number if you can catch it.
3. **`03-journal.png`** — Journal tab open, selected slot and ability rows visible. Choose a long ability name if available.
4. **`04-altar-confirm.png`** — Potion Altar preview showing current/target sequence, owned count, gold cost, digestion requirements and both Confirm/Cancel. Capture before confirming.
5. **`05-phone-portrait.png`** — 390×844 or closest phone, normal gameplay with default joystick/jump, touch Strike and all six slots visible.
6. **`06-phone-inventory.png`** — same phone, potion preview with fixed actions visible after scrolling; include the entire modal and safe edges.
7. **`07-phone-landscape.png`** — 844×390 or closest landscape phone during a cooldown or cast, showing touch controls and compact HUD.
8. **`08-tablet-portrait.png`** — 768×1024 or closest tablet, expanded pathway/digestion panel plus hotbar and touch controls.
9. **`09-tablet-landscape.png`** — 1024×768 or closest tablet, Journal or Altar menu open with its bottom actions visible.
10. **`10-developer-f8.png`** — authorized F8 panel open. Also state whether an unprivileged client stayed unchanged when pressing F8; do not include personal identifiers you do not wish to share.

If errors occur, add **`output-errors.png`** with the full red error and script/line number; also paste its text so it is searchable. If sanity becomes low during testing, add **`sanity-low.png`** with the full HUD. Short recordings are optional for hover sounds, collapse animation, cooldown movement, hit flash and the advance title; still screenshots cannot verify timing or audio.

Please also reattach the original hub and HUD concept images; they did not arrive with the request. Those are references, separate from the verification screenshots.

Stop after Phase 1. Phase 2 starts only after “continue.”
