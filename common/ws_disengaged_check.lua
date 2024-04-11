-- WS Disengaged Check
function ws_is_disengaged(spell)
    if spell.type == "WeaponSkill" and player.status ~= "Engaged" then
        return true
    end
    return false
end

function ws_disengaged_check(spell)
    if ws_is_disengaged(spell) then
        if player.tp >= 1000 then
            add_to_chat(8, spell.name .. " aborted because weapon is not drawn.")
        end
        cancel_spell()
        return true
    end
    return false
end
