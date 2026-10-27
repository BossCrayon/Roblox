# Derived stat pipeline

`StatData.Calculate(pathwayId, sequence)` owns the base values for all three pathways and Sequences 9 through 1. Uninitiated characters use a separate base. Smaller sequence numbers have stronger base stats. These numbers are gameplay balance, not novel measurements.

`StatData.Resolve(pathwayId, sequence, modifiers)` returns final stats and a per-stat breakdown:

`final = (pathwaySequenceBase + sum(Flat)) * max(0, 1 + sum(Percent)) * product(Multiply)`

Values round to two decimals; health has a floor of 1, other attributes have a floor of 0, and attributes cap at 10 million. Sanity retains the existing 100-point scale. Ancestry is a named multiplier source. Unique source IDs and deterministic ordering prevent accidental repeated stacking. Invalid stat names, nonfinite values, negative multipliers and overflow are rejected.

Server integrations:

```lua
-- After the equipment service verifies ownership and the equipped slot:
domain:SetStatModifier(state, "Equipment:Coat", {
    Flat = {Health = 20}, Percent = {Resistance = 0.1},
})
-- After the consumable service atomically consumes a potion:
domain:SetStatModifier(state, "Potion:Vitality", {
    Multiply = {Health = 1.15}, ExpiresAt = os.clock() + 60,
})
domain:RemoveStatModifier(state, "Equipment:Coat")
```

The same ID replaces an existing source. Recompute from the base every time; never multiply a previously modified total. Resources are clamped to the new maximum without healing/refilling. The server tick expires timed sources and synchronizes Humanoid maxima. Existing advancement potions continue changing sequence and recomputing stats.

There is no client modifier remote. Persisted totals and injected modifiers are ignored on load. Runtime modifiers clear on respawn, advancement and admin attunement; future equipment persistence must store validated item IDs and reconstruct their definitions on those lifecycle events. This adds integration points, not new loot or consumable content.

The Character journal displays final values, pathway/sequence base values, and flat/percentage/multiplier breakdowns. Tests cover all 27 pathway/sequence bases, modifier composition, replacement, expiry, removal, lack of free healing, atomic rejection and saved-stat injection.
