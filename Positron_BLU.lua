function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")

	include("func/obi_check.lua") -- obi_check()

	
	include("all/obi.lua") -- sets.obi
	include("all/quickmagic.lua") -- sets.quickmagic
	include("all/th.lua") -- sets.th

	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-aquaveil.lua") -- sets.midcast.aquaveil
	include("all/midcast-darkness.lua") -- sets.midcast.darkness
	include("all/midcast-earth.lua") -- sets.midcast.earth
	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("blu/bluemagic.lua") -- sets.bluemagic
	include("blu/fastcast.lua") -- sets.fastcast
	include("blu/idle.lua") -- sets.idle
	include("blu/naked.lua") -- sets.naked
	include("blu/tp.lua") -- sets.tp
	include("blu/weapon.lua") -- sets.weapon
	include("blu/weapon-melee.lua") -- sets.weapon.melee
	include("blu/ws.lua") -- sets.ws
	include("blu/ws-multihit.lua") -- sets.ws.multihit

	include("blu/precast-diffusion.lua") -- sets.precast.diffusion

	include("blu/midcast-elemental.lua") -- sets.midcast.elemental
	include("blu/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("blu/midcast-phalanx.lua") -- sets.midcast.phalanx
	include("blu/midcast-refresh.lua") -- sets.midcast.refresh

	_ENFEEBLING_SPELLS = T {
		"Blank Gaze",
		"Cruel Joke",
		"Dream Flower",
		"Feather Tickle",
		"Geist Wall",
		"Reaving Wind",
		"Sheep Song",
		"Soporific",
		"Tourbillion",
		"Yawn"
	}

	_SKILL_SPELLS = T {
		"Atra. Libations",
		"Blood Drain",
		"Blood Saber",
		"Diamondhide",
		"Digest",
		"Magic Barrier",
		"Metallic Body",
		"MP Drainkiss",
		"Occultation",
		"Osmosis",
		"Restoral",
	}

	send_command(macrobook_cmd..porter_cmd..lockstyle_cmd)
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

	if spell.type == "JobAbility" then
	elseif spell.type == "WeaponSkill" then
		if spell.english:contains("Chant du Cygne") then
			equip(sets.ws.multihit)
		else
			equip(sets.ws)
		end
	else
		equip(sets.fastcast)
		if spell.english:contains("Stoneskin") then
			equip(sets.precast.stoneskin)
		end
	end
end

function midcast(spell)
	if spell.type == "JobAbility" then
	elseif spell.type == "WeaponSkill" then
	else
		if _SKILL_SPELLS:contains(spell.english) then
			equip(sets.idle, sets.bluemagic)
		elseif spell.english:contains("Aquaveil") then
			equip(sets.idle, sets.midcast.aquaveil)
		elseif spell.english:contains("Refresh") or spell.english:contains("Battery Charge") then
			equip(sets.idle, sets.midcast.refresh)
		elseif spell.english:contains("Phalanx") then
			equip(sets.idle, sets.midcast.phalanx)
		elseif spell.english:contains("Sound Blast") or spell.english:contains("Dia") then
			equip(sets.idle, sets.th)
		elseif _ENFEEBLING_SPELLS:contains(spell.english) then
			equip(sets.idle, sets.midcast.enfeebling)
		elseif spell.english:contains("Stoneskin") then
			equip(sets.idle, sets.midcast.stoneskin)
		else
			equip(sets.idle, sets.midcast.elemental)
			if spell.english:contains("Tenebral Crush") then
				equip(sets.midcast.darkness)
			elseif spell.english:contains("Entomb") then
				equip(sets.midcast.earth)
			end
			obi_check(spell)
		end
		if buffactive["Diffusion"] then
			equip(sets.precast.diffusion)
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

function self_command(command)
	if command == "weapon" then
		if player.equipment.main == "Tizona" then
			equip(sets.weapon)
			send_command("input /lockstyleset 36")
			add_to_chat("Sakpata's Sword equipped")
		else
			equip(sets.weapon.melee)
			send_command("input /lockstyleset 56")
			add_to_chat("Tizona equipped")
		end
	end
end