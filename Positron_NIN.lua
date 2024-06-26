function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("func/dusk_to_dawn.lua") -- dusk_to_dawn()
	include("func/obi_check.lua") -- obi_check()

	include("all/doom.lua") -- sets.doom
	include("all/obi.lua") -- sets.obi

	include("nin/enmity.lua") -- sets.enmity
	include("nin/futae.lua") -- sets.futae
	include("nin/idle.lua") -- sets.idle
	include("nin/fastcast.lua") -- sets.fastcast
	include("nin/movementspeed.lua") -- sets.movementspeed
	include("nin/ninjutsu.lua") -- sets.ninjutsu
	include("nin/tools.lua") -- sets.tools (for validate only)
	include("nin/tp.lua") -- sets.tp
	include("nin/ws.lua") -- sets.ws
	include("nin/ws-magical.lua") -- sets.ws.magical
	include("nin/ws-multihit.lua") -- sets.ws.multihit

	include("nin/precast-utsusemi.lua") -- sets.precast.utsusemi
	include("nin/precast-waltzes.lua") -- sets.precast.waltzes

	include("nin/midcast-elemental.lua") -- sets.midcast.elemental
	include("nin/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("nin/midcast-ra.lua") -- sets.midcast.ra
	include("nin/midcast-utsusemi.lua") -- sets.midcast.utsusemi

	_ENFEEBLING_NINJUTSU = T {
		"Aisha: Ichi",
		"Dokumori: Ichi",
		"Hojo: Ichi",
		"Hojo: Ni",
		"Jubaku: Ichi",
		"Kurayami: Ichi",
		"Kurayami: Ni",
		"Yurin: Ichi"
	}

	_MAGICAL_WS = T {
		"Aeolian Edge",
		"Blade: Teki",
		"Blade: To",
		"Blade: Chi",
		"Blade: Ei",
		"Blade: Yu",
		"Tachi: Jinpu"
	}

	_MULTI_HIT_WS = T {
		"Blade: Jin",
		"Blade: Ku",
		"Blade: Shun",
		"Evisceration"
	}

	_CAPPED_HASTE = true
	if _CAPPED_HASTE then
		include("nin/tp-stp.lua") -- sets.tp
	end

	_GOKOTAI_REGAIN = false
	if _GOKOTAI_REGAIN then
		include("nin/tp-dualwield.lua") -- sets.tp
	end

	send_command(macrobook_cmd..porter_cmd..lockstyle_cmd)
end

function sub_job_change(new, old)
	send_command("wait 10; \
	input /lockstyleset 95; \
	gs equip sets.idle")
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
		if _MAGICAL_WS:contains(spell.name) then
			equip(sets.ws.magical)
			obi_check(spell)
		elseif _MULTI_HIT_WS:contains(spell.name) then
			equip(sets.ws.multihit)
		end
	elseif spell.type == "JobAbility" then
		equip(sets.enmity)
	elseif spell.type == "Waltz" then
		equip(sets.precast.waltzes)
	elseif spell.type == "Ninjutsu" then
		equip(sets.fastcast)
		if spell.english:contains("Utsusemi") then
			equip(sets.precast.utsusemi)
		end
	else
		equip(sets.fastcast)
	end
end

function midcast(spell)
	if spell.type == "Ninjutsu" then
		equip(sets.ninjutsu)
		if buffactive["Yonin"] or buffactive["Enmity Boost"] then
			equip(sets.enmity)
		end
		if _ENFEEBLING_NINJUTSU:contains(spell.english) then
			equip(sets.midcast.enfeebling)
		elseif spell.english:contains("Utsusemi") then
			equip(sets.midcast.utsusemi)
		elseif spell.english:contains("ton: ") then
			equip(sets.midcast.elemental)
			obi_check(spell)
			if buffactive["Futae"] then
				equip(sets.futae)
			end
		end
	elseif spell.action_type == "Ranged Attack" then
		equip(sets.midcast.ra)
	end
end

function aftercast(spell)
	if spell.interrupted and spell.english:contains("ton: ") then
		return
	elseif player.status == "Idle" then
		equip(sets.idle)
		if dusk_to_dawn() then
			equip(sets.movementspeed)
		end
	elseif player.status == "Engaged" then
		equip(sets.tp)
	end
end

function buff_change(name, gain, buff_details)
	if name == "Doom" then
		if gain then
			equip(sets.doom)
			disable("neck", "left_ring")
		else
			enable("neck", "left_ring")
		end
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
	elseif new == "Idle" then
		equip(sets.idle)
		if dusk_to_dawn() then
			equip(sets.movementspeed)
		end
	end
end

function buff_change(name, gain, buff_details)
end
