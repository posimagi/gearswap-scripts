function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}
	
	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin
	
	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("brd/fastcast.lua") -- sets.fastcast
	include("brd/idle.lua") -- sets.idle
	include("brd/tp.lua") -- sets.tp
	include("brd/ws.lua") -- sets.ws
	
	include("brd/midcast-cursna.lua") -- sets.midcast.cursna
	include("brd/midcast-healing.lua") -- sets.midcast.healing
	include("brd/midcast-songs.lua") -- sets.midcast.songs

	send_command(
		"input /macro book 10; \
		input /macro set 1; \
		wait 5; \
		input /lockstyleset 91; \
		gs equip sets.idle")
end

function precast(spell, position)
	equip(sets.fastcast)
	if spell.english:contains("Stoneskin") then
		equip(sets.precast.stoneskin)
	elseif spell.type == "WeaponSkill" then
		equip(sets.ws)
	end
end

function midcast(spell)
	equip(sets.midcast.songs)
	if spell.english:contains("Stoneskin") then
		equip(sets.midcast.stoneskin)
	elseif spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
		if spell.name:contains("Cursna") then
			equip(sets.midcast.cursna)
		end
	end
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
