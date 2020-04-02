function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("smn/idle.lua") -- sets.idle
	include("smn/summoning.lua") -- sets.summoning

	include("smn/precast-bp.lua") -- sets.precast.bp

	include("smn/midcast-bp.lua") -- sets.midcast.bp

	send_command(
		"wait 5; \
		input /macro book 15; \
		input /macro set 1; \
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
	if spell.type == "BloodPactRage" then
		equip(sets.midcast.bp)
	end
end

function aftercast(spell)
	equip(sets.idle)
end

function status_change(new, old)
end
