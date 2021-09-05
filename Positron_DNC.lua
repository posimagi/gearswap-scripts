function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("all/precast-utsusemi.lua") -- sets.precast.utsusemi
	include("all/th.lua") -- sets.th

	include("dnc/enmity.lua") -- sets.enmity
	include("dnc/fastcast.lua") -- sets.fastcast
	include("dnc/idle.lua") -- sets.idle
	include("dnc/tp.lua") -- sets.tp
	include("dnc/tp-hybrid.lua") -- sets.tp.hybrid
	include("dnc/turtle.lua") -- sets.turtle
	include("dnc/ws.lua") -- sets.ws
	include("dnc/ws-critical.lua") -- sets.ws.critical
	include("dnc/ws-magical.lua") -- sets.ws.magical
	include("dnc/ws-singlehit.lua") -- sets.ws.singlehit

	include("dnc/climacticflourish.lua") -- sets.climacticflourish
	include("dnc/strikingflourish.lua") -- sets.strikingflourish

	include("dnc/precast-jigs.lua") -- sets.precast.jigs
	include("dnc/precast-nofootrise.lua") -- sets.precast.nofootrise
	include("dnc/precast-reverseflourish.lua") -- sets.precast.reverseflourish
	include("dnc/precast-sambas.lua") -- sets.precast.sambas
	include("dnc/precast-steps.lua") -- sets.precast.steps
	include("dnc/precast-waltzes.lua") -- sets.precast.waltzes

	include("func/buffactive_climacticflourish.lua") -- buffactive_climacticflourish()
	include("func/buffactive_strikingflourish.lua") -- buffactive_strikingflourish()

	_HYBRID = false
	if _HYBRID then
		sets.tp = sets.tp.hybrid
	end

	send_command(
		"input /macro book 6; \
		wait 1; \
		input /macro set 10; \
		wait 5; \
		input /lockstyleset 98; \
		gs equip sets.idle"
	)
end

function sub_job_change(new, old)
	send_command(
		"wait 10; \
		input /lockstyleset 98; \
		gs equip sets.idle"
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

	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if spell.english:contains("Rudra's Storm") then
			equip(sets.ws.singlehit)
		elseif spell.english:contains("Aeolian Edge") then
			equip(sets.ws.magical)
		elseif spell.english:contains("Evisceration") then
			equip(sets.ws.critical)
		end
		if buffactive_strikingflourish() then
			equip(sets.strikingflourish)
		end
		if buffactive_climacticflourish() then
			equip(sets.climacticflourish)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("No Foot Rise") then
			equip(sets.precast.nofootrise)
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
	elseif spell.type == "Waltz" then
		equip(sets.precast.waltzes)
	elseif spell.type == "Samba" then
		equip(sets.precast.sambas)
	elseif spell.type == "Jig" then
		equip(sets.precast.jigs)
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
		equip(sets.tp)
		if buffactive_climacticflourish() then
			equip(sets.climacticflourish)
		end
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
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
				equip(sets.tp)
			elseif player.status == "Idle" then
				equip(sets.idle)
			end
		end
	end
end
