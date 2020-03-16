function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("whm/idle.lua") -- sets.idle
	include("all-th.lua") -- sets.th
	include("whm/tp.lua") -- sets.tp
	include("whm/ws.lua") -- sets.ws
	include("whm/fastcast.lua") -- sets.fastcast

	include("whm/sublimation.lua") -- sets.sublimation

	include("whm/precast-benediction.lua") -- sets.precast.Benediction

	include("whm/midcast-healing.lua") -- sets.midcast.healing
	include("whm/midcast-regen.lua") -- sets.midcast.regen
	include("whm/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("whm/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("whm/midcast-barspell.lua") -- sets.midcast.barspell

	include("all-stoneskin.lua") -- sets.stoneskin

	include("func/buffactive_sublimation.lua") -- buffactive_sublimation()

	send_command(
		"wait 5; \
		input /macro book 3; \
		input /macro set 1; \
		input /lockstyleset 20; \
		gs equip sets.idle")
end

function precast(spell, position)
	equip(sets.fastcast)
	if spell.type == "JobAbility" then
		if spell.english == "Benediction" then
			equip(sets.precast.benediction)
		elseif spell.english == "Sublimation" then
			equip(sets.sublimation)
		end
	elseif spell.type == "WeaponSkill" then
		equip(sets.ws)
	else
		-- equip(sets.fastcast)
		if spell.english:contains("Impact") then
			equip(sets.impact)
		end
	end
end

function midcast(spell)
	if spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
	elseif spell.skill == "Enfeebling Magic" then
		equip(sets.midcast.enfeebling)
		if spell.english:contains("Dia") then
			equip(sets.th)
		end
	elseif spell.skill == "Enhancing Magic" then
		equip(sets.midcast.enhancing)
		if spell.english:contains("Regen") then
			equip(sets.midcast.regen)
		elseif spell.english:contains("Stoneskin") then
			equip(sets.stoneskin)
		end
	elseif spell.skill == "Dark Magic" then
		equip(sets.midcast.enfeebling)
	elseif spell.skill == "Elemental Magic" then
	-- equip(sets.midcast.elemental, sets.impact)
	end
end

function aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
		if spell.english == "Sublimation" or
		    buffactive_sublimation() then
			equip(sets.sublimation)
		end
	elseif player.status == "Engaged" then
		equip(sets.tp)
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
	elseif new == "Idle" then
		equip(sets.idle)
		if buffactive_sublimation() then
			equip(sets.sublimation)
		end
	end
end
