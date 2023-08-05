-- WS Engaged Check
function disengaged_ws()
    if spell.type == "WeaponSkill" and player.status ~= "Engaged" then
        return true
    end
    return false
end
