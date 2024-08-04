----------------- Breathing Sounds ----------------------
local delay = CurTime() + 0.1

hook.Add("Think", "HLT Stamina Play Out Of Breath Sound", function()
    if delay > CurTime() then return end
    delay = CurTime() + 0.1
    
    local ply = LocalPlayer()
    ply.outOfBreathSound = ply.outOfBreathSound or CreateSound(ply, "player/breathe1.wav")
    local snd = ply.outOfBreathSound

    if not IsValid(ply) or not ply:Alive() then
        snd:Stop()
        return
    end

    local breathSoundIntensityMult = math.Remap(ply:getStamina(), 0, 30, 1, 0)

    if (ply:getStamina() < 30) then
        if not snd:IsPlaying() then
            snd:PlayEx(.01, 100)
        else
            snd:ChangeVolume(0.2 * breathSoundIntensityMult, .05)
            snd:ChangePitch(100 + 5 * breathSoundIntensityMult, .05)
        end
    else
        snd:Stop()
    end
end)

