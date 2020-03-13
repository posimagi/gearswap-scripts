function get_sets()
    sets = {}
    sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include('cor/idle.lua') -- sets.idle
	include('cor/tp.lua') -- sets.tp
	include('cor/ws.lua') -- sets.ws

    include('all-obi.lua') -- sets.obi

    include('cor/ws-leadensalute.lua') -- sets.ws.leadensalute
    include('cor/precast-phantomroll.lua') -- sets.precast.phantomroll

	send_command('wait 5; input /lockstyleset 96; gs equip sets.idle') -- lockstyle
end

function precast(spell, position)
	if spell.type == 'WeaponSkill' then
        equip(sets.ws)
        if spell.english:contains('Leaden Salute') then
            equip(sets.ws.leadensalute)
            if world.weather_element == 'Dark' then
                equip(sets.obi)
            end
		end
	elseif spell.type == 'CorsairRoll' then
		equip(sets.precast.phantomroll)
	elseif spell.type == 'JobAbility' then
        if spell.english:contains('Double-Up') then
			equip(sets.precast.phantomroll)
		end
	end
end

function midcast(spell)

end

function aftercast(spell)
	if player.status == 'Idle' then
		equip(sets.idle)
	elseif player.status == 'Engaged' then
		equip(sets.tp)
	end
end

function status_change(new, old)
	if new == 'Engaged' then
		equip(sets.tp)
	elseif new == 'Idle' then
		equip(sets.idle)
	end
end