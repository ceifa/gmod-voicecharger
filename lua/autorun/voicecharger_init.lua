-- Adding to download files
AddCSLuaFile("voicecharger/cl_voicecharger.lua")

VOICECHARGER = {}

-- Creating convars
VOICECHARGER.RenderAsHotColors = CreateConVar("voicecharger_hot_color", 1, FCVAR_REPLICATED, "Should render as hot colors")
VOICECHARGER.DisabledRanks = CreateConVar("voicecharger_disabled_ranks", "vip,donator", FCVAR_REPLICATED, "Disabled ranks")
VOICECHARGER.Drain = CreateConVar("voicecharger_drain", .1, FCVAR_REPLICATED, "Value to drain off in voice charger")
VOICECHARGER.Regen = CreateConVar("voicecharger_regen", .1, FCVAR_REPLICATED, "Value to regen on voice charger")

-- Including files to execute
if CLIENT then
    include("voicecharger/cl_voicecharger.lua")
end