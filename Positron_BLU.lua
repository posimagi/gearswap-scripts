function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}
	
	include("func/obi_check.lua") -- obi_check()

	include("all/obi.lua") -- sets.obi
	include("all/th.lua") -- sets.th

	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin
	
	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("blu/fastcast.lua") -- sets.fastcast
	include("blu/idle.lua") -- sets.idle
	include("blu/naked.lua") -- sets.naked
	include("blu/tp.lua") -- sets.tp
	include("blu/ws.lua") -- sets.ws
	include("blu/ws-multihit.lua") -- sets.ws.multihit
	
	include("blu/precast-diffusion.lua") -- sets.precast.diffusion

	include("blu/midcast-aquaveil.lua") -- sets.midcast.aquaveil
	include("blu/midcast-elemental.lua") -- sets.midcast.elemental
	include("blu/midcast-phalanx.lua") -- sets.midcast.phalanx
	include("blu/midcast-refresh.lua") -- sets.midcast.refresh

	send_command(
		"input /macro book 16; \
		wait 1; \
		input /macro set 1; \
		wait 5; \
		input /lockstyleset 36; \
		gs equip sets.idle; \
		du blinking self all off;"
	)
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

	if spell.type == "JobAbility" then
		
	elseif spell.type == "WeaponSkill" then
		if spell.english:contains("Chant du Cygne") then
			equip(sets.ws.multihit)
		else
			equip(sets.ws)
		end
	else
		equip(sets.fastcast)
	end
end

function midcast(spell)
	if spell.type == "JobAbility" then
		
	elseif spell.type == "WeaponSkill" then

	else
		if spell.english:contains("Aquaveil") then
			equip(sets.idle, sets.midcast.aquaveil)
		elseif 
				spell.english:contains("Refresh") or
				spell.english:contains("Battery Charge") then
			equip(sets.idle, sets.midcast.refresh)
		elseif spell.english:contains("Phalanx") then
			equip(sets.idle, sets.midcast.phalanx)
		elseif 
				spell.english:contains("Dream Flower") or 
				spell.english:contains("Yawn") then
			equip(sets.idle, sets.th)
		else
			equip(sets.idle, sets.midcast.elemental)
			obi_check(spell)
		end
		if buffactive["Diffusion"] then
			equip(sets.precast.diffusion)
		end
	end
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
