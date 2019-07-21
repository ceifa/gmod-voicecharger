util.AddNetworkString("voice_state")
util.AddNetworkString("voice_charger_time")
util.AddNetworkString("voice_force_stop")
util.AddNetworkString("voice_refresh_max_time")

net.Receive("voice_state", function(length, ply)
    ply.isTalking = net.ReadBit()
end)

hook.Add("Think", "VoiceChargerDrain", function()
    next_think = next_think or CurTime()
    if CurTime() < next_think then return end
    -- caching some convar variables (i know that it will be cached internally)
    local drain = GetConVar("voicecharger_drain"):GetFloat()
    local maxtime = GetConVar("voicecharger_max_time"):GetFloat()
    local regen = GetConVar("voicecharger_regen"):GetFloat()
    -- send current voice_max_time
    net.Start("voice_refresh_max_time")
    net.WriteFloat(maxtime)
    net.Broadcast()

    for _, v in pairs(player.GetAll()) do
        if v:GetUserGroup() ~= "user" or (PS and v:PS_HasItemEquipped("removebattery")) then continue end -- "removebattery" is a pointshop item to remove voice drain in my server
        v.talkTime = v.talkTime or maxtime
        v.isTalking = v.isTalking or false
        local time = maxtime

        if v.isTalking == 1 then
            time = v.talkTime - drain
        elseif v.isTalking == 0 and v.talkTime < maxtime then
            time = v.talkTime + regen
        end

        v.talkTime = math.Clamp(time, 0, maxtime)
        net.Start("voice_charger_time")
        net.WriteFloat(v.talkTime)
        net.Send(v)

        if v.talkTime <= 0 and v.isTalking then
            net.Start("voice_force_stop")
            net.Send(v)
        end
    end

    next_think = CurTime() + 0.3
end)