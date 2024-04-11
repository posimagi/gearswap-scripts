-- Sneak Check
function sneak_check(spell)
    if spell.english == "Sneak" or spell.english == "Spectral Jig" then
        if spell.target.type == "SELF" and buffactive['Sneak'] then
            recast = windower.ffxi.get_spell_recasts()[spell.recast_id]
            if recast <= 0.0 then
                send_command("cancel Sneak")
                cast_delay(0.6)
            else
                add_to_chat(8, spell.name .. " aborted because it's still on cooldown.")
                cancel_spell()
            end
        end
    end
end