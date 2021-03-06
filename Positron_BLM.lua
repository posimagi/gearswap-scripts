function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("func/obi_check.lua") -- obi_check()

	include("all/impact.lua") -- sets.impact
	include("all/obi.lua") -- sets.obi

	include("all/precast-enhancing.lua") -- sets.precast.enhancing
	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-darkness.lua") -- sets.midcast.darkness
	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("blm/fastcast.lua") -- sets.fastcast
	include("blm/idle.lua") -- sets.idle
	include("blm/manawall.lua") -- sets.manawall
	include("blm/ws.lua") -- sets.ws
	include("blm/ws-myrkr.lua") -- sets.ws.myrkr

	include("blm/precast-healing.lua") -- sets.precast.healing

	include("blm/midcast-dark.lua") -- sets.midcast.dark
	include("blm/midcast-drain.lua") -- sets.midcast.drain
	include("blm/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("blm/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("blm/midcast-mb.lua") -- sets.midcast.mb
	include("blm/midcast-refresh.lua") -- sets.midcast.refresh

	_DRAIN_SPELLS = T{
		"Aspir",
		"Aspir II",
		"Aspir III",
		"Drain",
		"Drain II",
		"Drain III",
	}

	send_command(
		"input /macro book 4; \
		wait 1; \
		input /macro set 1; \
		wait 5; \
		input /lockstyleset 86; \
		gs equip sets.idle"
	)
end

function sub_job_change(new, old)
	send_command(
		"input /macro book 4; \
		wait 1; \
		input /macro set 1; \
		wait 10; \
		input /lockstyleset 86; \
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

	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if spell.english:contains("Myrkr") then
			equip(sets.ws.myrkr)
		end
	elseif spell.type == "JobAbility" then

	else
		equip(sets.fastcast)
		if spell.skill == "Enfeebling Magic" then
			equip(sets.precast.enfeebling)
		elseif spell.skill == "Enhancing Magic" then
			equip(sets.precast.enhancing)
			if spell.english:contains("Stoneskin") then
				equip(sets.precast.stoneskin)
			end
		elseif spell.skill == "Elemental Magic" then
			if spell.english:contains("Impact") then
				equip(sets.impact)
			end
		elseif spell.skill == "Healing Magic" then
			equip(sets.precast.healing)
		end
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
		elseif spell.english:contains("Stoneskin") then
			equip(sets.midcast.stoneskin)
		end
	elseif spell.skill == "Dark Magic" then
		equip(sets.midcast.mb, sets.midcast.dark, sets.midcast.darkness)
		if _DRAIN_SPELLS:contains(spell.english) then
			equip(sets.midcast.drain)
		end
		obi_check(spell)
	elseif spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
		obi_check(spell)
	elseif spell.skill == "Elemental Magic" then
		equip(sets.midcast.mb)
		obi_check(spell)
		if spell.english:contains("Impact") then
			equip(sets.impact)
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

function buff_change(name, gain, buff_details)
	if name == "Mana Wall" then
		if gain then
			equip(sets.manawall)
			disable("feet", "back")
		else
			enable("feet", "back")
		end
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
	elseif new == "Idle" then
		equip(sets.idle)
	end
end
