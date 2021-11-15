function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    
    include("pld/fastcast.lua") -- sets.fastcast
    include("pld/idle.lua") -- sets.idle
    include("pld/tp.lua") -- sets.tp
    include("pld/ws.lua") -- sets.ws

    send_command(
        "input /macro book 7; \
        wait 1; \
        input /macro set 1; \
        wait 5; \
		input /lockstyleset 27; \
        gs equip sets.idle; \
		du blinking self all off;")
end

function precast(spell, position)
	-- WS Engaged Check
	if
			spell.type == "WeaponSkill" and
			player.status ~= "Engaged" then
		cancel_spell()
		return
	end

	-- WS Distance Check
	_RANGE_MULTIPLIER = 1.642276421172564
	if 
			spell.type == "WeaponSkill" and
			spell.target.distance > (spell.range * _RANGE_MULTIPLIER + spell.target.model_size) then
		add_to_chat(8, spell.name.." aborted due to target out of range.")
		cancel_spell()
		return
	end

    if spell.type == "WeaponSkill" then
        equip(sets.ws)
    elseif spell.type == "JobAbility" then

    else
        equip(sets.fastcast)
    end
end

function midcast(spell)
end

function aftercast(spell)
    if player.status == "Idle" then
        equip(sets.idle)
    elseif player.status == "Engaged" then
        equip(sets.tp)
    end
end

function status_change(new, old)
    if new == "Engaged" then
        equip(sets.tp)
    elseif new == "Idle" then
        equip(sets.idle)
    end
end

function buff_change(name, gain, buff_details)
end
