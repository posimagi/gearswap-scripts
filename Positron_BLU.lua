function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("all-th.lua") -- sets.th
	include("all-stoneskin.lua") -- sets.stoneskin

	include("blu/fastcast.lua") -- sets.fastcast
	include("blu/idle.lua") -- sets.idle
	include("blu/midcast-mab.lua") -- sets.midcast.mab

	send_command(
		"wait 5; \
		input /macro book 16; \
		input /macro set 1; \
		input /lockstyle on; \
		gs equip sets.idle")
end

function precast(spell, position)
	equip(sets.fastcast)
end

function midcast(spell)
	equip(sets.midcast.mab)
end

function aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		-- equip(sets.tp)
	end
end

function status_change(new, old)
	if new == "Engaged" then
		-- equip(sets.tp)
	elseif new == "Idle" then
		equip(sets.idle)
	end
end
