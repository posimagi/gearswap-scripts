function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	include("common/ws_disengaged_check.lua")
	include("common/ws_distance_check.lua")

	include("func/obi_check.lua") -- obi_check()

	include("all/dispelga.lua") -- sets.dispelga
	include("all/obi.lua") -- sets.obi
	include("all/quickmagic.lua") -- sets.quickmagic
	include("all/th.lua") -- sets.th

	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("brd/enmity.lua") -- sets.enmity
	include("brd/fastcast.lua") -- sets.fastcast
	include("brd/idle.lua") -- sets.idle
	include("brd/tp.lua") -- sets.tp
	include("brd/weapon.lua") -- sets.weapon
	include("brd/weapon-blurredharp.lua") -- sets.weapon.blurredharp
	include("brd/weapon-gjallarhorn.lua") -- sets.weapon.gjallarhorn
	include("brd/weapon-loughnashade.lua") -- sets.weapon.loughnashade
	include("brd/weapon-marsyas.lua") -- sets.weapon.marsyas

	include("brd/ws.lua") -- sets.ws
	include("brd/ws-accuracy.lua") -- sets.ws.accuracy

	include("brd/precast-nightingale.lua") -- sets.precast.nightingale
	include("brd/precast-songs.lua") -- sets.precast.songs
	include("brd/precast-soulvoice.lua") -- sets.precast.soulvoice
	include("brd/precast-troubadour.lua") -- sets.precast.troubadour

	include("brd/midcast-ballad.lua") -- sets.midcast.ballad
	include("brd/midcast-carol.lua") -- sets.midcast.carol
	include("brd/midcast-cursna.lua") -- sets.midcast.cursna
	include("brd/midcast-etude.lua") -- sets.midcast.etude
	include("brd/midcast-healing.lua") -- sets.midcast.healing
	include("brd/midcast-lullaby.lua") -- sets.midcast.lullaby
	include("brd/midcast-madrigal.lua") -- sets.midcast.madrigal
	include("brd/midcast-magicaccuracy.lua") -- sets.midcast.magicaccuracy
	include("brd/midcast-mambo.lua") -- sets.midcast.mambo
	include("brd/midcast-march.lua") -- sets.midcast.march
	include("brd/midcast-minne.lua") -- sets.midcast.minne
	include("brd/midcast-minuet.lua") -- sets.midcast.minuet
	include("brd/midcast-scherzo.lua") -- sets.midcast.scherzo
	include("brd/midcast-songs.lua") -- sets.midcast.songs
	include("brd/midcast-songs-offensive.lua") -- sets.midcast.songs.offensive
	include("brd/midcast-threnody.lua") -- sets.midcast.threnody

	_MAGICAL_WS = T {
		"Aeolian Edge",
	}

	_PRE_SONG_ABILITIES = T {
		"Nightingale",
		"Troubadour",
		"Marcato",
		"Tenuto",
		"Pianissimo",
	}

	_OFFENSIVE_SONGS = T {
		"Battlefield Elegy",
		"Carnage Elegy",
		"Magic Finale",
		"Foe Lullaby",
		"Foe Lullaby II",
		"Pining Nocturne",
		"Foe Requiem",
		"Foe Requiem II",
		"Foe Requiem III",
		"Foe Requiem IV",
		"Foe Requiem V",
		"Foe Requiem VI",
		"Foe Requiem VII",
		"Fire Threnody",
		"Fire Threnody II",
		"Ice Threnody",
		"Ice Threnody II",
		"Wind Threnody",
		"Wind Threnody II",
		"Earth Threnody",
		"Earth Threnody II",
		"Ltng. Threnody",
		"Ltng. Threnody II",
		"Water Threnody",
		"Water Threnody II",
		"Light Threnody",
		"Light Threnody II",
		"Dark Threnody",
		"Dark Threnody II",
		"Maiden's Virelai",
	}

	_STRING_SONGS = T {
		"Horde Lullaby",
		"Horde Lullaby II",
		"Mage's Ballad",
		"Mage's Ballad II",
		"Mage's Ballad III",
	}

	_WEAPON_SWAP_SPELLS = T {
		"Dispelga",
	}

	send_command(macrobook_cmd..porter_cmd..lockstyle_cmd)
end

function sub_job_change(new, old)
	send_command("wait 10; \
	input /lockstyleset 30; \
	gs equip sets.idle")
end

function precast(spell, position)
	if ws_disengaged_check(spell) then return end
	if ws_distance_check(spell) then return end

	-- Instrument
	if _OFFENSIVE_SONGS:contains(spell.english) then
		equip(sets.weapon.gjallarhorn)
	elseif _STRING_SONGS:contains(spell.english) then
		equip(sets.weapon.blurredharp)
	elseif spell.english:contains("Aria") then
		equip(sets.weapon.loughnashade)
	elseif spell.english:contains("Honor") then
		equip(sets.weapon.marsyas)
	end

	if spell.type == "JobAbility" then
		if spell.english:contains("Nightingale") or spell.english:contains("Troubadour") then
			equip(sets.precast.nightingale, sets.precast.troubadour)
		elseif spell.english:contains("Soul Voice") then
			equip(sets.precast.soulvoice)
		end
	elseif spell.type == "WeaponSkill" then
		equip(sets.ws)
		if _MAGICAL_WS:contains(spell.english) then
			equip(sets.ws.magical)
			obi_check(spell)
		end
	elseif spell.type == "Step" then
		equip(sets.ws.accuracy)
	elseif spell.english:contains("Dispelga") then	
		_PREVIOUS_WEAPONS = sets.weapon
		if sets.dispelga.main ~= player.equipment.main then
			_PREVIOUS_WEAPONS = T {
				main = player.equipment.main,
				sub = player.equipment.sub
			}
		end
		equip(sets.dispelga)
	else
		equip(sets.fastcast)
		if spell.type == "BardSong" then
			equip(sets.precast.songs)
		elseif spell.english:contains("Stoneskin") then
			equip(sets.precast.stoneskin)
		end
	end
end

function midcast(spell)
	if spell.type == "BardSong" then
		equip(sets.midcast.songs)

		-- Instrument
		if _OFFENSIVE_SONGS:contains(spell.english) then
			equip(sets.weapon.gjallarhorn)
		elseif _STRING_SONGS:contains(spell.english) then
			equip(sets.weapon.blurredharp)
		elseif spell.english:contains("Aria") then
			equip(sets.weapon.loughnashade)
		elseif spell.english:contains("Honor") then
			equip(sets.weapon.marsyas)
		else
			equip(sets.weapon.loughnashade)
		end

		-- Gear
		if _OFFENSIVE_SONGS:contains(spell.english) then
			equip(sets.midcast.songs.offensive)
			if spell.english:contains("Lullaby") then
				equip(sets.midcast.lullaby)
				equip(sets.idle, sets.enmity) -- FIXME: Ongo only!
			elseif spell.english:contains("Threnody") then
				equip(sets.midcast.threnody)
			end
		elseif spell.english:contains("Ballad") then
			equip(sets.midcast.ballad)
		elseif spell.english:contains("Carol") then
			equip(sets.midcast.carol)
		elseif spell.english:contains("Etude") then
			equip(sets.midcast.etude)
		elseif spell.english:contains("Madrigal") then
			equip(sets.midcast.madrigal)
		elseif spell.english:contains("Mambo") then
			equip(sets.midcast.mambo)
		elseif spell.english:contains("March") then
			equip(sets.midcast.march)
		elseif spell.english:contains("Minne") then
			equip(sets.midcast.minne)
		elseif spell.english:contains("Minuet") then
			equip(sets.midcast.minuet)
		elseif spell.english:contains("Scherzo") then
			equip(sets.midcast.scherzo)
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
	elseif spell.english:contains("Dispelga") then
		equip(sets.dispelga)
	elseif spell.skill == "Dark Magic" then
		equip(sets.midcast.magicaccuracy)
	end
end

function aftercast(spell)
	if _PRE_SONG_ABILITIES:contains(spell.english) then
		-- do nothing
	elseif player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		equip(sets.tp)
	end
	if _WEAPON_SWAP_SPELLS:contains(spell.english) then
		equip(_PREVIOUS_WEAPONS)
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
	elseif new == "Idle" then
		equip(sets.idle)
	end
end

function self_command(command)
	if command == "aminon" then
		if _AMINON then
			include("brd/idle.lua") -- sets.idle
			include("brd/tp.lua") -- sets.tp
			equip(sets.idle)
			_AMINON = false
			add_to_chat("Standard sets equipped")
		else
			include("brd/aminon/idle.lua") -- sets.idle
			include("brd/aminon/tp.lua") -- sets.tp
			equip(sets.idle)
			_AMINON = true
			add_to_chat("Aminon sets equipped")
		end
	end
end