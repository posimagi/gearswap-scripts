function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("all/th.lua") -- sets.th

	include("run/engaged.lua") -- sets.engaged
	include("run/enmity.lua") -- sets.enmity
	include("run/fastcast.lua") -- sets.fastcast
	include("run/idle.lua") -- sets.idle
	include("run/interrupt.lua") -- sets.interrupt
	include("run/naked.lua") -- sets.naked
	include("run/ws.lua") -- sets.ws
	include("run/ws-multihit.lua") -- sets.ws.multihit

	-- sets.embolden

	include("run/precast-battuta.lua") -- sets.precast["Battuta"]
	include("run/precast-elementalsforzo.lua") -- sets.precast["Elemental Sforzo"]
	include("run/precast-liement.lua") -- sets.precast["Liement"]
	include("run/precast-vallation.lua") -- sets.precast["Vallation"], sets.precast["Valiance"]
	include("run/precast-vivaciouspulse.lua") -- sets.precast["Vivacious Pulse"]
	include("run/precast-enhancing.lua") -- sets.precast.enhancing

	include("run/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("run/midcast-phalanx.lua") -- sets.midcast.phalanx
	include("run/midcast-refresh.lua") -- sets.midcast.refresh
	-- include("run/midcast-regen.lua") -- sets.midcast.regen

	_MAGIC = T {
		"WhiteMagic",
		"BlackMagic",
		"BlueMagic"
	}

	_ABILITY = T {
		"JobAbility",
		"Ward",
		"Effusion"
	}

	_ENMITY_ABILITIES = T {
		"Battuta",
		"Burst Affinity",
		"Chain Affinity",
		"Gambit",
		"Liement",
		"One for All",
		"Pflug",
		"Swordplay",
		"Valiance",
		"Vallation",
	}

	_ENMITY_SPELLS = T {
		"Foil",
		"Geist Wall",
		"Jettatura",
	}

	_INTERRUPT_SPELLS = T {
		"Aquaveil",
		"Cocoon",
		"Poisonga",
		"Sheep Song",
	}

	send_command(
		"input /macro book 7; \
	wait 1; \
	input /macro set 10; \
	wait 5; \
	input /lockstyleset 60; \
	gs equip sets.idle; \
	du blinking self all off;"
	)
end

function precast(spell, position)
	-- WS Engaged Check
	if spell.type == "WeaponSkill" and player.status ~= "Engaged" then
		cancel_spell()
		return
	end

	-- WS Distance Check
	_RANGE_MULTIPLIER = 1.642276421172564
	if spell.type == "WeaponSkill" and
		spell.target.distance >
		(spell.range * _RANGE_MULTIPLIER + spell.target.model_size)
	then
		add_to_chat(8, spell.name .. " aborted due to target out of range.")
		cancel_spell()
		return
	end

	if _MAGIC:contains(spell.type) then
		equip(sets.idle, sets.fastcast)
		if spell.skill == "Enhancing Magic" then
			equip(sets.precast.enhancing)
		end
	elseif spell.type == "WeaponSkill" then
		equip(sets.ws)
		if spell.name:contains("Resolution") then
			equip(sets.ws.multihit)
		elseif spell.name:contains("Shockwave") then
			equip(sets.th)
		end
	elseif _ABILITY:contains(spell.type) then
		equip(sets.enmity, sets.precast[spell.name])
	elseif spell.type == "Item" then
		equip(sets.cursna)
	end
end

function midcast(spell)
	equip(sets.idle)
	if spell.skill == "Enhancing Magic" then
		equip(sets.midcast.enhancing)
		if spell.english:contains("Foil") then
			equip(sets.enmity)
		elseif spell.english:contains("Refresh") then
			equip(sets.midcast.refresh)
		elseif spell.english:contains("Phalanx") then
			equip(sets.midcast.phalanx)
		end
	elseif spell.type == "Item" then
		equip(sets.idle, sets.cursna)
	end
	if _INTERRUPT_SPELLS:contains(spell.english) then
		equip(sets.interrupt)
	elseif _ENMITY_SPELLS:contains(spell.english) then
		equip(sets.enmity)
	end
end

function aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		equip(sets.idle, sets.engaged)
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.idle, sets.engaged)
	elseif new == "Idle" then
		equip(sets.idle)
	end
end

function buff_change(name, gain, buff_details)
end
