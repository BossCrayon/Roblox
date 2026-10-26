# Tingen city map

Open studio/Mysteries.rbxlx in Roblox Studio and press Play. The city generates at runtime. This update has not been published to Roblox.

The supplied settings-book photograph supplies positions for entries 1–67. Entry 5 has three businesses ordered north to south. River and Sea Cathedral is added as entry 68 with an explicitly approximate location in North Tingen. North is negative Z; Civic Square is the origin. Four studs per image pixel is a gameplay scale, not an official scale.

Sources checked: https://lordofthemysteries.fandom.com/wiki/Tingen_City and https://lordofthemysteries.fandom.com/wiki/Church_of_the_Lord_of_Storms confirm the cathedral's northern region, not a precise site.

This is a landmark blockout with enterable building shells, towers, chimneys, cemetery, railway tracks, streets, lamps and labels. Architecture, roads and access paths are interpretive. Water uses flat collidable visual surfaces, not swimming Terrain. Dense city infill and furnished interiors remain future work. Photograph perspective limits coordinate accuracy.

Four existing gameplay services remain near Civic Square; eighteen enemy spawns retain their existing tiers in southern gameplay yards. Services and combat-yard placement are gameplay additions.

Validation passed: existing gameplay tests, new map construction checks using engine stand-ins (1507 parts, all map IDs, four service prompts, bounds), Luau compilation, strict Roblox API/type analysis, Rojo build and exact source-to-place verification. Studio rendering, navigation/collisions, multiplayer and device performance still require Play testing.

Shared/TingenLayout stores coordinates. Services/TingenWorld constructs the map. WorldService selects the new builder. WorldArt retains reusable service architecture.
