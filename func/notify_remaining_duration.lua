function notify_remaining_duration(spell)
    -- NOTE: currently does not work unless you trigger the ability twice.
    for i, buff in pairs(player.buff_details) do
        if player.buff_details[i].name == spell.name then
            seconds = math.floor(player.buff_details[i].duration) - 5
            if seconds >= 0 then
                send_command("wait "..seconds.."; input /p "..spell.english.." ends in 5 seconds!")
            end
        end
    end
end