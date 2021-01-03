function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.petmidcast = {}
	sets.aftercast = {}

	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("smn/fastcast.lua") -- sets.fastcast
	include("smn/idle.lua") -- sets.idle
	include("smn/summoning.lua") -- sets.summoning
	include("smn/tp.lua") -- sets.tp

	include("smn/precast-bp.lua") -- sets.precast.bp

	include("smn/midcast-refresh.lua") -- sets.midcast.refresh

	include("smn/petmidcast-bp.lua") -- sets.petmidcast.bp

	_ALL_SLOTS = T{"range", "ammo", "head", "body", "hands", "legs", "feet",
				   "neck", "waist", "left_ear", "right_ear", "left_ring", "right_ring", "back"}

	send_command(
		"input /macro book 15; \
		input /macro set 1; \
		wait 5; \
		input /lockstyleset 87; \
		gs equip sets.idle"
	)
end

function precast(spell, position)
	equip(sets.fastcast)
	if spell.type == "SummonerPact" then
		equip(sets.summoning)
	elseif spell.type == "BloodPactRage" then
		equip(sets.precast.bp)
	elseif spell.skill == "Healing Magic" then
		equip(sets.precast.healing)
	elseif spell.english:contains("Stoneskin") then
		equip(sets.precast.stoneskin)
	end
end

function midcast(spell)
	if spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
    elseif spell.english:contains("Refresh") then
		equip(sets.midcast.refresh)
	elseif spell.english:contains("Stoneskin") then
		equip(sets.midcast.stoneskin)
	end
end

function pet_midcast(spell)
	if spell.type == "BloodPactRage" then
		equip(sets.petmidcast.bp)
	elseif spell.type == "BloodPactWard" then
		equip(sets.summoning)
	end
end

function aftercast(spell)
	equip(sets.idle)
end

function pet_aftercast(spell)
	equip(sets.idle)
end

function status_change(new, old)
    if new == "Engaged" then
        equip(sets.tp)
    elseif new == "Idle" then
        equip(sets.idle)
    end
end

function buff_change(name, gain, buff_details)
	if name == "Astral Conduit" then
		if gain then
			equip(sets.petmidcast.bp)
			disable(_ALL_SLOTS)
		else
			enable(_ALL_SLOTS)
		end
	end
end
