# City atlas and Door travel

- **M** or the **MAP** button opens/closes the city atlas for any pathway.
- The atlas uses the same roads, river surfaces and building footprints as the runtime city. The cyan marker tracks the player.
- Select a named location from the map or searchable list. Hover reveals its label; zooming in shows labels throughout the map. Use **+**, **−**, **Fit**, right-drag with a mouse or touch-drag to navigate. **Escape** closes the atlas.
- **F** also opens/closes the atlas for the Door pathway (stored internally as `Apprentice`). Select a destination and press **Travel**. This works at every sequence, as requested, and does not replace existing numbered abilities.
- Travel costs **10 spirituality**, with a **5-second cooldown**. Blue threshold frames briefly appear at departure and arrival. This is direct destination travel, not a shared portal other players can enter.

All 70 named destinations are selectable: the original 67 entries, the two extra businesses grouped under entry 5, and River and Sea Cathedral. Rivers use bank arrivals. The cathedral's site remains approximate.

The client sends only a destination ID. The server verifies the whitelist, live character, Door pathway, normal state, casting/movement restrictions, silence, resources and cooldown. It selects a clear ground-level arrival close to the named site. Blocked arrivals consume no spirituality or cooldown. Successful travel resets velocity and updates movement-validation grace. Existing remote rate limiting remains active.

Validation runs the actual server module and UI controller with explicit engine stand-ins. It covers pathway and sequence access, malformed IDs, death, casting/control effects, resources, blocked arrivals, successful relocation, repeat requests, search, selection, duplicate click prevention, zoom limits and modal cleanup. Luau compilation, Roblox type analysis, Rojo build and source verification pass. Live streaming, real arrival collisions and rendered UI still need Studio play-testing.
