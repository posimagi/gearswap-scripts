function notify_on_cooldown(spell)
    recast = windower.ffxi.get_spell_recasts()[spell.recast_id]
    if recast > 0 then
        recast_seconds = string.format("%.1f", recast/60)
        send_command("input /p "..spell.english.." on cooldown for "..recast_seconds.." seconds!")
    end
end