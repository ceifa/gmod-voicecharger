-- Player started using voip
hook.Add("PlayerStartVoice", "VoiceChargerStarted", function(ply)
    local cl = LocalPlayer()
    if not IsValid(cl) or ply ~= cl then return end
    net.Start("voice_state")
    net.WriteBit(true)
    net.SendToServer()
end)

-- Player stoped using voip
hook.Add("PlayerEndVoice", "VoiceChargerEnded", function(ply)
    local cl = LocalPlayer()
    if not IsValid(cl) or ply ~= cl then return end
    net.Start("voice_state")
    net.WriteBit(false)
    net.SendToServer()
end)

-- force user to stop talking
net.Receive("voice_force_stop", function(length, client)
    RunConsoleCommand("-voicerecord")
end)

local actual_voice_time = 0

-- refresh to current user voice time
net.Receive("voice_charger_time", function()
    actual_voice_time = net.ReadFloat()
end)

-- refresh to current maxtime in server-side
net.Receive("voice_refresh_max_time", function()
    voice_max_time = net.ReadFloat()
end)

-- print battery
hook.Add("HUDPaint", "VoiceChargerBattery", function()
    local cl = LocalPlayer()
    if not voice_max_time or actual_voice_time >= voice_max_time or cl:GetUserGroup() ~= "user" or (PS and cl:PS_HasItemEquipped("removebattery")) then return end
    local heigth = actual_voice_time / voice_max_time * 210
    local backgroundColor = cl:GetPlayerColor():ToColor() or team.GetColor(cl:Team())
    backgroundColor.a = 160
    surface.SetDrawColor(backgroundColor)
    surface.DrawRect(25, 25, 220, 30)
    surface.SetDrawColor(ColorAlpha(color_black, 160))
    surface.DrawRect(30, 30, heigth, 20)
end)