function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}
	
	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin
	
	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("brd/fastcast.lua") -- sets.fastcast
	include("brd/idle.lua") -- sets.idle
	include("brd/th.lua") -- sets.th
	include("brd/tp.lua") -- sets.tp
	include("brd/ws.lua") -- sets.ws

	include("brd/precast-nightingale.lua") -- sets.precast.nightingale
	include("brd/precast-troubadour.lua") -- sets.precast.troubadour

	include("brd/midcast-ballad.lua") -- sets.midcast.ballad
	include("brd/midcast-cursna.lua") -- sets.midcast.cursna
	include("brd/midcast-healing.lua") -- sets.midcast.healing
	include("brd/midcast-songs.lua") -- sets.midcast.songs
	include("brd/midcast-songs-offensive.lua") -- sets.midcast.songs.offensive

	_PRE_SONG_ABILITIES = T{
		"Nightingale",
		"Troubadour",
		"Marcato",
		"Tenuto",
		"Pianissimo",
	}

	_OFFENSIVE_SONGS = T{
		"Battlefield Elegy",
		"Carnage Elegy",
		"Foe Lullaby",
		"Foe Lullaby II",
		"Horde Lullaby",
		"Horde Lullaby II",
		"Magic Finale",
		"Pining Nocturne",
	} -- TODO: improve this

	send_command(
		"input /macro book 10; \
		wait 1; \
		input /macro set 1; \
		wait 5; \
		input /lockstyleset 91; \
		gs equip sets.idle; \
		du blinking self all off;"
	)
end

function sub_job_change(new, old)
	send_command(
		"wait 10; \
		input /lockstyleset 91; \
		gs equip sets.idle"
	)
end

function precast(spell, position)
	-- WS Engaged Check
	if
			spell.type == "WeaponSkill" and
			player.status ~= "Engaged" then
		cancel_spell()
		return
	end

	-- WS Distance Check
	_RANGE_MULTIPLIER = 1.642276421172564
	if 
			spell.type == "WeaponSkill" and
			spell.target.distance > (spell.range * _RANGE_MULTIPLIER + spell.target.model_size) then
		add_to_chat(8, spell.name.." aborted due to target out of range.")
		cancel_spell()
		return
	end

	if spell.type == "JobAbility" then
		if 
				spell.english:contains("Nightingale") or 
				spell.english:contains("Troubadour") then
			equip(sets.precast.nightingale, sets.precast.troubadour)
		end
	elseif spell.type == "WeaponSkill" then
		equip(sets.ws)
	else
		equip(sets.fastcast)
		if spell.type == "BardSong" then
			equip(sets.precast.songs)
			if buffactive['Nightingale'] then
				midcast(spell)
			end
		elseif spell.english:contains("Stoneskin") then
			equip(sets.precast.stoneskin)
		end
	end
end

function midcast(spell)
	if spell.type == "BardSong" then
		equip(sets.midcast.songs)
		if _OFFENSIVE_SONGS:contains(spell.english) then
			equip(sets.midcast.songs.offensive)
		elseif spell.english:contains("Ballad") then
			equip(sets.midcast.ballad)
		end
	elseif spell.english:contains("Stoneskin") then
		equip(sets.midcast.stoneskin)
	elseif spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
		if spell.name:contains("Cursna") then
			equip(sets.midcast.cursna)
		end
	elseif spell.english:contains("Dia") then
		equip(sets.th)
	end
end

function aftercast(spell)
	if spell.interrupted and spell.english:contains("Elegy") then
		return
    end
	if _PRE_SONG_ABILITIES:contains(spell.english) then
		-- do nothing
	elseif player.status == "Idle" then
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
