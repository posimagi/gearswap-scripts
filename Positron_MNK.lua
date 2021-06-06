function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    
    include("mnk/idle.lua") -- sets.idle
    include("mnk/idle-hybrid.lua") -- sets.idle.hybrid
    include("mnk/tp.lua") -- sets.tp
    include("mnk/tp-hybrid.lua") -- sets.tp.hybrid
    include("mnk/ws.lua") -- sets.ws

    _HYBRID = false
    if _HYBRID then
		sets.idle = sets.idle.hybrid
		sets.tp = sets.tp.hybrid
	end

    send_command(
        "input /macro book 2; \
        wait 1; \
        input /macro set 2; \
		wait 5; \
        input /lockstyleset 92; \
        gs equip sets.idle")
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
