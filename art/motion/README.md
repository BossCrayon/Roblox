# Mysteries motion studies

[EXISTING] `MysteriesMotionStudies.blend` contains five editable seven-bone motion studies: Seer, Marauder, Apprentice, MeleeRight and MeleeLeft. Each has anticipation, projection, recoil and settle keys. Open in Blender and play frames 1–61 at 60 fps.

[EXISTING] The matching `tracks.json` data generates `ReplicatedStorage.Shared.MotionTracks`. AnimConfig layers these accents onto the existing ability-specific poses and ultimate profiles. Existing effects remain cosmetic and server-confirmed. Reduced Motion remains handled by AnimationController.

These are reference rigs, not Roblox R15 FBX exports. No animation uploads or asset IDs are needed for the integrated procedural version. The .blend itself is an editing/reference artifact, not a Roblox runtime dependency.

Regenerate with `blender --background --python scripts/art/build_motion_studies.py`, then run `python scripts/check.py` and `python scripts/package.py`.

## Lore boundary

All authored gestures and M1 effects are original gameplay choreography. They do not imply that every pathway canonically has supernatural punches. Worms of Spirit, Time and Star remain the respective pathway motifs. Existing giant clock, regal cloak and Door of All Doors silhouettes are artistic interpretations; their exact suitability at Sequence 2–1 remains [UNVERIFIED]. No new lore powers or mechanics were added. External reference verification was blocked by the network on this pass.

## Studio review

Test all 54 skills, both M1 swings, and R at Sequences 4, 3, 2 and 1 on all pathways. Compare R6/R15, moving and stationary casts, death/cancellation, Reduced Motion and Low Graphics. Watch for shoulder clipping and overlay conflicts with the default Animate script. Use desktop, phone and tablet emulation. Send short front/side video clips of each pathway's R, M1 combo, and a low/high-sequence skill; static screenshots cannot verify timing. Cloud tests do not certify rendered quality or FPS.
