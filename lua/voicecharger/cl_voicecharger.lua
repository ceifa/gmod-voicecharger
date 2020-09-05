local currentBattery = 1
local state = false

-- Player started using voip
hook.Add("PlayerStartVoice", "VoiceChargerStarted", function(ply)
    if ply == LocalPlayer() and not table.HasValue(VOICECHARGER.DisabledRanks, ply:GetUserGroup()) then
        state = true
    end
end)

-- Player stoped using voip
hook.Add("PlayerEndVoice", "VoiceChargerEnded", function(ply)
    if ply == LocalPlayer() then
        state = false
    end
end)

-- Force user to stop talking
hook.Add("Think", "VoiceChargerHandler", function()
    if currentBattery <= 0 then
        RunConsoleCommand("-voicerecord")
    end

    if state then
        currentBattery = currentBattery - VOICECHARGER.Drain:GetFloat() / 100

        if currentBattery <= 0 then
            currentBattery = 0
        end
    else
        currentBattery = currentBattery + VOICECHARGER.Regen:GetFloat() / 100

        if currentBattery >= 1 then
            currentBattery = 1
        end
    end
end)

local backgroundColor

-- Render
hook.Add("HUDPaint", "VoiceChargerBattery", function()
    if currentBattery >= 1 then return end

    if VOICECHARGER.RenderAsHotColors:GetBool() then
        backgroundColor = LerpColor(currentBattery, Color(255, 0, 0), Color(0, 255, 0))
    else
        backgroundColor = LocalPlayer():GetPlayerColor():ToColor() or team.GetColor(LocalPlayer():Team())
    end

    backgroundColor.a = 180

    surface.SetDrawColor(backgroundColor)
    surface.DrawRect(25, 25, 220, 30)

    surface.SetDrawColor(ColorAlpha(color_black, 180))
    surface.DrawRect(30, 30, currentBattery * 210, 20)
end)