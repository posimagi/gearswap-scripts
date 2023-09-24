function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("all/precast-utsusemi.lua") -- sets.precast.utsusemi
	include("all/th.lua") -- sets.th

	include("dnc/enmity.lua") -- sets.enmity
	include("dnc/fastcast.lua") -- sets.fastcast
	include("dnc/idle.lua") -- sets.idle
	include("dnc/movementspeed.lua") -- sets.movementspeed
	include("dnc/tp.lua") -- sets.tp
	include("dnc/tp-haste0.lua") -- sets.tp.haste0
	include("dnc/tp-haste30.lua") -- sets.tp.haste30
	include("dnc/weapon.lua") -- sets.weapon
	include("dnc/weapon-critical.lua") -- sets.weapon.critical
	include("dnc/ws.lua") -- sets.ws
	include("dnc/ws-critical.lua") -- sets.ws.critical
	include("dnc/ws-magical.lua") -- sets.ws.magical
	include("dnc/ws-multihit.lua") -- sets.ws.multihit

	include("dnc/buildingflourish.lua") -- sets.buildingflourish
	include("dnc/climacticflourish.lua") -- sets.climacticflourish
	include("dnc/strikingflourish.lua") -- sets.strikingflourish

	include("dnc/precast-featherstep.lua") -- sets.precast.featherstep
	include("dnc/precast-jigs.lua") -- sets.precast.jigs
	include("dnc/precast-nofootrise.lua") -- sets.precast.nofootrise
	include("dnc/precast-reverseflourish.lua") -- sets.precast.reverseflourish
	include("dnc/precast-sambas.lua") -- sets.precast.sambas
	include("dnc/precast-steps.lua") -- sets.precast.steps
	include("dnc/precast-trance.lua") -- sets.precast.trance
	include("dnc/precast-waltzes.lua") -- sets.precast.waltzes
	include("dnc/precast-waltzesself.lua") -- sets.precast.waltzesself

	include("func/buffactive_buildingflourish.lua") -- buffactive_buildingflourish()
	include("func/buffactive_climacticflourish.lua") -- buffactive_climacticflourish()
	include("func/buffactive_movementspeed.lua") -- buffactive_movementspeed()
	include("func/buffactive_strikingflourish.lua") -- buffactive_strikingflourish()
	include("func/haste_amount.lua") -- haste_amount()
	include("func/obi_check.lua") -- obi_check()

	_CRITICAL_WS = T {
		"Evisceration",
	}

	_MAGICAL_WS = T {
		"Aeolian Edge",
		"Cyclone",
		"Gust Slash"
	}

	_MULTI_HIT_WS = T {
		"Asuran Fists",
		"Dancing Edge",
		"Exenterator",
	}

	_REGAL_GLOVES = false
	if _REGAL_GLOVES then
		include("dnc/tp-regal.lua") -- sets.tp
	end

	send_command(macrobook_cmd..porter_cmd..lockstyle_cmd)
end

function sub_job_change(new, old)
	send_command("wait 10; \
	input /lockstyleset 39; \
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
		if _CRITICAL_WS:contains(spell.name) then
			equip(sets.ws.critical)
		elseif _MAGICAL_WS:contains(spell.name) then
			equip(sets.ws.magical)
			obi_check(spell)
		elseif _MULTI_HIT_WS:contains(spell.name) then
			equip(sets.ws.multihit)
		end
		if buffactive_strikingflourish() then
			equip(sets.strikingflourish)
		end
		if buffactive_buildingflourish() then
			equip(sets.buildingflourish)
		end
		if buffactive_climacticflourish() then
			equip(sets.climacticflourish)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("No Foot Rise") then
			equip(sets.precast.nofootrise)
		elseif spell.english:contains("Trance") then
			equip(sets.precast.trance)
		end
	elseif spell.type:contains("Flourish") then
		if spell.english:contains("Animated") then
			equip(sets.enmity)
		elseif spell.english:contains("Climactic") then
			equip(sets.climacticflourish)
		elseif spell.english:contains("Reverse") then
			equip(sets.precast.reverseflourish)
		elseif spell.english:contains("Striking") then
			equip(sets.strikingflourish)
		end
	elseif spell.type == "Step" then
		equip(sets.precast.steps)
		if spell.english:contains("Feather Step") then
			equip(sets.precast.featherstep)
		end
	elseif spell.type == "Waltz" then
		equip(sets.idle, sets.precast.waltzes)
		if spell.target.type == "SELF" then
			equip(sets.precast.waltzesself)
		end
	elseif spell.type == "Samba" then
		equip(sets.idle, sets.precast.sambas)
	elseif spell.type == "Jig" then
		equip(sets.idle, sets.precast.jigs)
	elseif spell.type == "Ninjutsu" then
		equip(sets.fastcast)
		if spell.english:contains("Utsusemi") then
			equip(sets.precast.utsusemi)
		end
	end
end

function midcast(spell)
end

function aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		if haste_amount(_HASTE_0) then
			equip(sets.tp.haste0)
		elseif haste_amount(_HASTE_30) then
			equip(sets.tp.haste30)
		else
			equip(sets.tp)
		end
		if buffactive_climacticflourish() then
			equip(sets.climacticflourish)
		end
	end
end

function status_change(new, old)
	if new == "Engaged" then
		if haste_amount(_HASTE_0) then
			equip(sets.tp.haste0)
		elseif haste_amount(_HASTE_30) then
			equip(sets.tp.haste30)
		else
			equip(sets.tp)
		end
		if buffactive_climacticflourish() then
			equip(sets.climacticflourish)
		end
	elseif new == "Idle" then
		equip(sets.idle)
	end
end

function buff_change(name, gain, buff_details)
	if name == "Climactic Flourish" then
		if gain then
			equip(sets.climacticflourish)
		else
			if player.status == "Engaged" then
				if haste_amount(_HASTE_0) then
					equip(sets.tp.haste0)
				elseif haste_amount(_HASTE_30) then
					equip(sets.tp.haste30)
				else
					equip(sets.tp)
				end
			elseif player.status == "Idle" then
				equip(sets.idle)
			end
		end
	elseif _MOVEMENT_SPEED_BUFFS:contains(name) then
		if gain then
			sets.idle = set_combine(sets.idle, sets.movementspeed)
			if player.status == "Idle" then
				equip(sets.idle)
			end
		else
			include("dnc/idle.lua") -- sets.idle
			if player.status == "Idle" then
				equip(sets.idle)
			end
		end
	end
end
