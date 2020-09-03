util.AddNetworkString("voice_state")
util.AddNetworkString("voice_charger_time")
util.AddNetworkString("voice_force_stop")
util.AddNetworkString("voice_refresh_max_time")

net.Receive("voice_state", function(length, ply)
    ply.isTalking = net.ReadBit()
end)

local next_think = CurTime() + 60

-- TODO: This think hook can be optimized
hook.Add("Think", "VoiceChargerDrain", function()
    if CurTime() < next_think then return end

    -- caching some convar variables (i know that it will be cached internally)
    local drain = VOICECHARGER.Drain:GetFloat()
    local maxtime = VOICECHARGER.MaxTime:GetFloat()
    local regen = VOICECHARGER.Regen:GetFloat()

    for _, v in ipairs(player.GetAll()) do
        if table.HasValue(VOICECHARGER.DisabledRanks, v:GetUserGroup()) then
            return
        end

        v.talkTime = v.talkTime or maxtime
        v.isTalking = v.isTalking or false
        local time = maxtime

        if v.isTalking == 1 then
            time = v.talkTime - drain
        elseif v.isTalking == 0 and v.talkTime < maxtime then
            time = v.talkTime + regen
        end

        local talkTime = math.Clamp(time, 0, maxtime)

        if talkTime ~= v.talkTime then
            v.talkTime = talkTime
            net.Start("voice_charger_time")
                net.WriteFloat(v.talkTime)
            net.Send(v)
        end

        if v.talkTime <= 0 and v.isTalking then
            net.Start("voice_force_stop")
            net.Send(v)
        end
    end

    next_think = CurTime() + 0.3
end)

hook.Add("PlayerInitialSpawn", "SendVoiceMaxTime", function()
    timer.Simple(5, function()
        -- send current voice_max_time
        net.Start("voice_refresh_max_time")
            net.WriteFloat(VOICECHARGER.MaxTime:GetFloat())
        net.Broadcast()
    end)
end)