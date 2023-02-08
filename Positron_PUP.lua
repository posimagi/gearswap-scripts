function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("pup/idle.lua") -- sets.idle
	include("pup/tp.lua") -- sets.tp
	include("pup/tp-pet.lua") -- sets.tp.pet
	include("pup/ws.lua") -- sets.ws

	include("pup/precast-maneuvers.lua") -- sets.precast.maneuvers
	include("pup/precast-overdrive.lua") -- sets.precast["Overdrive"]
	include("pup/precast-repair.lua") -- sets.precast["Repair"]
	include("pup/precast-rolereversal.lua") -- sets.precast["Role Reversal"]
	include("pup/precast-tacticalswitch.lua") -- sets.precast["Tactical Switch"]
	include("pup/precast-ventriloquy.lua") -- sets.precast["Ventriloquy"]

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
	elseif spell.type == "JobAbility" then
		equip(sets.precast[spell.name])
	elseif spell.type == "PetCommand" then
		if spell.english:contains("Maneuver") then
			equip(sets.precast.maneuvers)
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
