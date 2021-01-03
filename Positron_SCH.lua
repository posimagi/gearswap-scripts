function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("func/obi_check.lua") -- obi_check()

	include("all/obi.lua") -- sets.obi

	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-darkness.lua") -- sets.midcast.darkness
	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("sch/fastcast.lua") -- sets.fastcast
	include("sch/idle.lua") -- sets.idle
	include("sch/sublimation.lua") -- sets.sublimation
	include("sch/th.lua") -- sets.th

	include("sch/precast-healing.lua") -- sets.precast.healing

	include("sch/midcast-cursna.lua") -- sets.midcast.cursna
	include("sch/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("sch/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("sch/midcast-healing.lua") -- sets.midcast.healing
	include("sch/midcast-helix.lua") -- sets.midcast.helix
	include("sch/midcast-light.lua") -- sets.midcast.light
	include("sch/midcast-mb.lua") -- sets.midcast.mb
	include("sch/midcast-refresh.lua") -- sets.midcast.refresh
	include("sch/midcast-regen.lua") -- sets.midcast.regen

	include("func/buffactive_sublimation.lua") -- buffactive_sublimation()

	send_command(
		"input /macro book 20; \
		input /macro set 1; \
		wait 5; \
		input /lockstyleset 97; \
		gs equip sets.idle"
	)
end

function precast(spell, position)
	equip(sets.fastcast)
	if spell.skill == "Healing Magic" then
		equip(sets.precast.healing)
	end
end

function midcast(spell)
	if spell.skill == "Enfeebling Magic" then
		equip(sets.midcast.enfeebling)
		if spell.english:contains("Dia") then
			equip(sets.th)
		end
	elseif spell.skill == "Enhancing Magic" then
		equip(sets.midcast.enhancing)
		if spell.english:contains("Refresh") then
			equip(sets.midcast.refresh)
		elseif spell.english:contains("Regen") then
			equip(sets.midcast.regen)
		elseif spell.english:contains("Stoneskin") then
			equip(sets.midcast.stoneskin)
		end
	elseif spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
		if spell.name:contains("Cursna") then
			equip(sets.midcast.cursna)
		end
	elseif spell.skill == "Elemental Magic" then
		equip(sets.midcast.mb)
		obi_check(spell)
		if spell.english:contains("helix") then
			equip(sets.midcast.helix)
			if spell.english:contains("Luminohelix") then
				equip(sets.midcast.light)
			elseif spell.english:contains("Noctohelix") then
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
