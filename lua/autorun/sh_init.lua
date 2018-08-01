-- adding to download files
AddCSLuaFile()
AddCSLuaFile("voicecharger/cl_voicecharger.lua")

-- creating server-side convars (caching values in client too)
local defaultFlags = FCVAR_SERVER_CAN_EXECUTE + FCVAR_NOTIFY + FCVAR_ARCHIVE
CreateConVar("voicecharger_max_time", 5, defaultFlags, "Max time with voice enable")
CreateConVar("voicecharger_drain", 0.1, defaultFlags, "Value to drain off in voice charger")
CreateConVar("voicecharger_regen", 0.1, defaultFlags, "Value to regen on voice charger")

-- including files to execute
if CLIENT then
    include ("voicecharger/cl_voicecharger.lua")
else
    include ("voicecharger/sv_voicecharger.lua")
end