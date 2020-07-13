function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.petmidcast = {}
	sets.aftercast = {}

	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("smn/idle.lua") -- sets.idle
	include("smn/summoning.lua") -- sets.summoning

	include("smn/precast-bp.lua") -- sets.precast.bp

	include("smn/petmidcast-bp.lua") -- sets.petmidcast.bp

	send_command(
		"input /macro book 15; \
		input /macro set 1; \
		wait 5; \
		input /lockstyle on; \
		gs equip sets.idle"
	)
end

function precast(spell, position)
	if spell.type == "SummonerPact" then
		equip(sets.summoning)
	elseif spell.type == "BloodPactRage" then
		equip(sets.precast.bp)
	end
end

function midcast(spell)
end

function pet_midcast(spell)
	if spell.type == "BloodPactRage" then
		equip(sets.petmidcast.bp)
	end
end

function aftercast(spell)
end

function pet_aftercast(spell)
	equip(sets.idle)
end

function status_change(new, old)
end
