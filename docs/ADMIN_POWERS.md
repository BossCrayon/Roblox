# Admin powers button

`johnskie816` is configured in `ServerScriptService.AdminConfig.AdminUsernames`. The Roblox server calls `Players:GetUserIdFromNameAsync` to resolve this configured username and checks the joining player's numeric UserId. A client cannot grant access by supplying a username, UserId or developer flag. The experience's individual creator and explicit numeric IDs in `AdminUserIds` also receive access. Group membership alone does not grant it.

1. Download the latest [studio/Mysteries.rbxlx](../studio/Mysteries.rbxlx), then open it in Roblox Studio using **File → Open from File**.
2. Log into Studio as **johnskie816** and press **Play**.
3. Click **ADMIN** beneath the Journal button, or press **F8**.
4. Choose **Seer**, **Marauder** or **Apprentice**, then **Seq 9–1** and **Apply pathway & sequence**.
5. Repeat whenever you want a different selection. Earlier unlocked abilities remain available in Journal for equipping.

Only your own character changes. The server checks creator/allowlist access for every request and uses the existing intent rate limiter. You must be loaded and alive. The selector works in Studio and published servers; ordinary players cannot access the button or override potion progression by sending `AdminSet` themselves.

Switching derives stats from the selected sequence, refills health/spirituality/sanity, resets digestion and acting objectives, clears pending casts/cooldowns/statuses/recorded and stolen powers, invalidates an open altar purchase, and equips up to six valid unlocked abilities. It releases old summons/control/portals and lets existing disguise restoration finish. It preserves gold, inventory, earned wish credits, the state table, autosave scheduling and movement bookkeeping. It does not change normal ability costs or grant currencies.

**Published servers save the chosen pathway and sequence to your normal profile.** Studio's default session-only mode discards its changes when Play stops. The panel displays which storage mode applies. Nothing is published to Roblox automatically by downloading the place; use Studio's normal publish action when ready.

## Scripts and complete code

| File | Class | Exact Explorer path |
|---|---|---|
| `Theme.lua` | ModuleScript | `ReplicatedStorage/Shared/Theme` |
| `AdminConfig.lua` | ModuleScript | `ServerScriptService/AdminConfig` |
| `AdminProgression.lua` | ModuleScript | `ServerScriptService/Domain/AdminProgression` |
| `Bootstrap.server.lua` | Script | `ServerScriptService/Bootstrap` |
| `Developer.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Developer` |
| `Mysteries.client.lua` | LocalScript | `StarterPlayer/StarterPlayerScripts/Mysteries` |

The [current full code handoff](PHASE_A_VFX_CODE.md) contains all six scripts above, their framework dependencies, and the Studio checklist after the code. [FULL_SOURCE.md](FULL_SOURCE.md) contains the entire project. Replace same-name scripts with Play stopped; the downloadable place already includes everything.

## Studio checks

- **Desktop:** log in as johnskie816, wait for the server lookup, confirm ADMIN appears, and open it with both the button and F8. Select Apprentice/4 and apply. Verify the pathway name, sequence, resource maxima and equipped abilities update. Repeat Seer/9, Marauder/1, then each remaining choice. Selecting buttons alone must not change the character before Apply.
- **Phone/tablet emulators:** confirm ADMIN clears the vitals and Journal, every choice and Apply remain reachable by scrolling, and the button hides while Journal or the VFX test room is open. Test portrait and landscape. Studio keyboard F8 remains an alternative.
- **Existing effects:** begin a cast or disguise, change pathway, then verify the old cast does not execute, the disguise restores, and old control/summons/gates disappear. Gold/inventory must stay unchanged. Respawn normally before changing again if you die.
- **Access:** with an unlisted, noncreator account, ADMIN and F8 controls must stay hidden. Sending `AdminSet` directly must leave its progression unchanged. Never add general group membership or all players to the allowlist.
- **Persistence:** Studio session-only changes disappear after stopping Play. On a published development place, change sequence, leave normally, rejoin and verify the selected progression survives the normal save process.

Send **`admin-desktop.png`** with the panel and HUD after applying **Apprentice/4**, plus **`admin-phone.png`** showing the scrolled Apply button in portrait. If a change fails, send the complete Output error text and the account/Play mode used.

## If ADMIN does not appear

Give Roblox's lookup a few seconds. The cloud could not reach Roblox's public user API, so no numeric ID was guessed or hardcoded; the place resolves `johnskie816` through Roblox at runtime. It retries three times and denies username access if resolution fails. Look in Output for `Admin username could not be resolved`. No HTTP-service toggle is needed for the built-in Players lookup.

For an account rename or a failed lookup, add your actual positive numeric Roblox UserId to `AdminConfig.AdminUserIds` and restart Play. Studio's synthetic negative Player1/Player2 IDs are not your real account and are intentionally denied. The account that owns an individually owned published experience also receives creator access automatically.
