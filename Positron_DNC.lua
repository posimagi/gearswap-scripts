function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("all-th.lua") -- sets.th
	
	include("dnc/idle.lua") -- sets.idle
	include("dnc/tp.lua") -- sets.tp
	include("dnc/ws.lua") -- sets.ws

	include("dnc/precast-steps.lua") -- sets.precast.steps
	include("dnc/precast-waltzes.lua") -- sets.precast.waltzes
	include("dnc/precast-sambas.lua") -- sets.precast.sambas
	include("dnc/precast-jigs.lua") -- sets.precast.jigs
	-- include("dnc/precast-nofootrise.lua") -- sets.precast.nofootrise
	include("dnc/precast-reverseflourish.lua") -- sets.precast.reverseflourish
	include("dnc/climacticflourish.lua") -- sets.climacticflourish

	include("func/buffactive_climacticflourish.lua") -- buffactive_climacticflourish()

	send_command(
		"input /macro book 6; \
		wait 5; \
		input /lockstyleset 98; \
		gs equip sets.idle")
end

function precast(spell, position)
	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if buffactive_climacticflourish() then
			equip(sets.climacticflourish)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("No Foot Rise") then
			-- equip(sets.precast.nofootrise)									
		end
	elseif spell.type:contains("Flourish") then
		if spell.english:contains("Reverse") then
			equip(sets.precast.reverseflourish)
		elseif spell.english:contains("Climactic") then
			equip(sets.climacticflourish)
		end
	elseif spell.type == "Step" then
		equip(sets.precast.steps)
	elseif spell.type == "Waltz" then
		equip(sets.precast.waltzes)
	elseif spell.type == "Samba" then
		equip(sets.precast.sambas)
	elseif spell.type == "Jig" then
		equip(sets.precast.jigs)
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