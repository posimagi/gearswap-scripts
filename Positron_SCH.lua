function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-darkness.lua") -- sets.midcast.darkness
	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("sch/fastcast.lua") -- sets.fastcast
	include("sch/idle.lua") -- sets.idle
	include("sch/th.lua") -- sets.th

	include("sch/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("sch/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("sch/midcast-healing.lua") -- sets.midcast.healing
	include("sch/midcast-helix.lua") -- sets.midcast.helix
	include("sch/midcast-mb.lua") -- sets.midcast.mb

	include("func/buffactive_sublimation.lua") -- buffactive_sublimation()

	send_command(
		"wait 5; \
		input /macro book 20; \
		input /macro set 1; \
		input /lockstyleset 97; \
		gs equip sets.idle"
	)
end

function precast(spell, position)
	equip(sets.fastcast)
end

function midcast(spell)
	if spell.skill == "Enfeebling Magic" then
		equip(sets.midcast.enfeebling)
		if spell.english:contains("Dia") then
			equip(sets.th)
		end
	elseif spell.skill == "Enhancing Magic" then
		equip(sets.midcast.enhancing)
		if spell.english:contains("Stoneskin") then
			equip(sets.midcast.stoneskin)
		end
	elseif spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
	elseif spell.skill == "Elemental Magic" then
		equip(sets.midcast.mb)
		if spell.english:contains("helix") then
			equip(sets.midcast.helix)
			if spell.english:contains("Noctohelix") then
				equip(sets.midcast.darkness)
			end
		elseif spell.english:contains("Kaustra") then
			equip(sets.midcast.darkness)
		end
	elseif spell.skill == "Dark Magic" then
		if spell.english:contains("Bio") then
			equip(sets.th)
		end
	end
end

function aftercast(spell)
	equip(sets.idle)
	if spell.english == "Sublimation" or buffactive_sublimation() then
		equip(sets.sublimation)
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
