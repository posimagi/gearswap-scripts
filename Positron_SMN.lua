function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.petmidcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("func/obi_check.lua") -- obi_check()

	include("all/obi.lua") -- sets.obi
	include("all/quickmagic.lua") -- sets.quickmagic
	
	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("smn/fastcast.lua") -- sets.fastcast
	include("smn/idle.lua") -- sets.idle
	include("smn/tp.lua") -- sets.tp
	include("smn/ws.lua") -- sets.ws
	include("smn/ws-dark.lua") -- sets.ws.dark

	include("smn/precast-bp.lua") -- sets.precast.bp

	include("smn/midcast-healing.lua") -- sets.midcast.healing
	include("smn/midcast-refresh.lua") -- sets.midcast.refresh
	include("smn/midcast-summoning.lua") -- sets.midcast.summoning

	include("smn/petmidcast-bp.lua") -- sets.petmidcast.bp

	_ALL_SLOTS = T {
		"range",
		"ammo",
		"head",
		"body",
		"hands",
		"legs",
		"feet",
		"neck",
		"waist",
		"left_ear",
		"right_ear",
		"left_ring",
		"right_ring",
		"back"
	}

	_DARK_WS = T {
		"Cataclysm"
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

	equip(sets.fastcast)
	if spell.type == "BloodPactRage" or spell.type == "BloodPactWard" then
		equip(sets.midcast.summoning, sets.precast.bp)
	elseif spell.skill == "Healing Magic" then
		equip(sets.precast.healing)
	elseif spell.english:contains("Stoneskin") then
		equip(sets.precast.stoneskin)
	elseif spell.type == "WeaponSkill" then
		equip(sets.ws)
		if _DARK_WS:contains(spell.english) then
			equip(sets.ws.dark)
			obi_check(spell)
		end
	end
end

function midcast(spell)
	if spell.type == "SummonerPact" then
		equip(sets.midcast.summoning)
	elseif spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
	elseif spell.english:contains("Refresh") then
		equip(sets.midcast.refresh)
	elseif spell.english:contains("Stoneskin") then
		equip(sets.midcast.stoneskin)
	end
end

function pet_midcast(spell)
	if spell.type == "BloodPactRage" then
		equip(sets.petmidcast.bp)
		if spell.english:contains("Perfect Defense") then
			equip(sets.midcast.summoning)
		end
	elseif spell.type == "BloodPactWard" then
		equip(sets.midcast.summoning)
	end
end

function aftercast(spell)
	if spell.type ~= "BloodPactRage" and spell.type ~= "BloodPactWard" then
		if player.status == "Idle" then
			equip(sets.idle)
		elseif player.status == "Engaged" then
			equip(sets.tp)
		end
	end
end

function pet_aftercast(spell)
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

function buff_change(name, gain, buff_details)
	if name == "Astral Conduit" then
		if gain then
			equip(sets.petmidcast.bp)
			disable(_ALL_SLOTS)
		else
			enable(_ALL_SLOTS)
		end
	end
end
