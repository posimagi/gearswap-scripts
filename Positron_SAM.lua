function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("func/obi_check.lua") -- obi_check()

	include("all/obi.lua") -- sets.obi

	include("sam/idle.lua") -- sets.idle
	include("sam/tp.lua") -- sets.tp
	include("sam/weakws.lua") -- sets.weakws
	include("sam/ws.lua") -- sets.ws
	include("sam/ws-hybrid.lua") -- sets.ws.hybrid
	include("sam/ws-magical.lua") -- sets.ws.magical
	include("sam/ws-meikyoshisui.lua") -- sets.ws.meikyoshisui
	include("sam/ws-multihit.lua") -- sets.ws.multihit
	include("sam/ws-pdl.lua") -- sets.ws.pdl
	include("sam/ws-sekkanoki.lua") -- sets.ws.sekkanoki

	include("sam/precast-meditate.lua") -- sets.precast.meditate
	include("sam/precast-shikikoyo.lua") -- sets.precast.skikikoyo

	_HYBRID_WS = T {
		"Tachi: Goten",
		"Tachi: Kagero",
		"Tachi: Jinpu",
		"Tachi: Koki"
	}

	_MAGICAL_WS = T {
		"Aeolian Edge",
		"Raiden Thrust",
		"Thunder Thrust",
	}

	_MULTI_HIT_WS = T {
		"Penta Thrust",
		"Stardiver",
		"Tachi: Rana"
	}

	send_command(macrobook_cmd..porter_cmd..lockstyle_cmd)
end

function precast(spell, position)
	-- WS Engaged Check
	if spell.type == "WeaponSkill" and player.status ~= "Engaged" then
		cancel_spell()
		return
	end

	-- WS Distance Check
	_RANGE_MULTIPLIER = 1.642276421172564
	if spell.type == "WeaponSkill" and
		spell.target.distance >
		(spell.range * _RANGE_MULTIPLIER + spell.target.model_size)
	then
		add_to_chat(8, spell.name .. " aborted due to target out of range.")
		cancel_spell()
		return
	end

	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if _MULTI_HIT_WS:contains(spell.english) then
			equip(sets.ws.multihit)
		elseif _MAGICAL_WS:contains(spell.english) then
			equip(sets.ws.magical)
			obi_check(spell)
		elseif _HYBRID_WS:contains(spell.english) then
			equip(sets.ws.hybrid)
			obi_check(spell)
		end
		if buffactive["Meikyo Shisui"] then
			equip(sets.ws.meikyoshisui)
		elseif buffactive["Sekkanoki"] then
			equip(sets.ws.sekkanoki)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Meditate") then
			equip(sets.precast.meditate)
		elseif spell.english:contains("Shikikoyo") then
			equip(sets.precast.shikikoyo)
		end
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
