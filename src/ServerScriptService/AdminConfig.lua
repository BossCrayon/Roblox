--!strict
-- Server-only allowlist. Roblox resolves these configured usernames to numeric IDs.
-- Add numeric IDs for stable access after a username change. Never accept client names.
return table.freeze({AdminUserIds=table.freeze({}),AdminUsernames=table.freeze({"johnskie816"}),
    LookupAttempts=3,LookupRetrySeconds=2})
