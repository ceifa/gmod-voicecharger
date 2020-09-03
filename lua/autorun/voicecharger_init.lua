-- adding to download files
AddCSLuaFile("voicecharger/cl_voicecharger.lua")

VOICECHARGER = {}
VOICECHARGER.DisabledRanks = {
    "vip",
    "donator",
    "operator",
    "admin",
    "superadmin"
}

-- including files to execute
if CLIENT then
    include("voicecharger/cl_voicecharger.lua")
else
    -- creating server-side convars (caching values in client too)
    VOICECHARGER.MaxTime = CreateConVar("voicecharger_max_time", 5, FCVAR_NONE, "Max time with voice enable")
    VOICECHARGER.Drain = CreateConVar("voicecharger_drain", 0.1, FCVAR_NONE, "Value to drain off in voice charger")
    VOICECHARGER.Regen = CreateConVar("voicecharger_regen", 0.1, FCVAR_NONE, "Value to regen on voice charger")

    include("voicecharger/sv_voicecharger.lua")
end