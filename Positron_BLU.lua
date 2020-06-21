function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}
	
	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin
	
	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("blu/fastcast.lua") -- sets.fastcast
	include("blu/idle.lua") -- sets.idle
	include("blu/th.lua") -- sets.th
	
	include("blu/midcast-aquaveil.lua") -- sets.midcast.aquaveil
	include("blu/midcast-mab.lua") -- sets.midcast.mab
	include("blu/midcast-refresh.lua") -- sets.midcast.refresh

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
	if spell.english:contains("Aquaveil") then
		equip(sets.midcast.aquaveil)
	elseif spell.english:contains("Refresh") or
		   spell.english:contains("Battery Charge") then
		equip(sets.midcast.refresh)
	elseif spell.english:contains("Dream Flower") then
		equip(sets.th)
	end
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
