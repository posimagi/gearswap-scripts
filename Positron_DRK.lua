function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("all/impact.lua") -- sets.impact
	include("all/obi.lua") -- sets.obi

	include("drk/fastcast.lua") -- sets.fastcast
	include("drk/idle.lua") -- sets.idle
	include("drk/tp.lua") -- sets.tp
	include("drk/ws.lua") -- sets.ws
	include("drk/ws-multihit.lua") -- sets.ws.multihit
	include("drk/ws-magical.lua") -- sets.ws.magical

	include("drk/precast-arcanecircle.lua") -- sets.precast.arcanecircle
	include("drk/precast-bloodweapon.lua") -- sets.precast.bloodweapon
	include("drk/precast-darkseal.lua") -- sets.precast.darkseal
	include("drk/precast-diaboliceye.lua") -- sets.precast.diaboliceye
	include("drk/precast-lastresort.lua") -- sets.precast.lastresort
	include("drk/precast-nethervoid.lua") -- sets.precast.nethervoid
	include("drk/precast-weaponbash.lua") -- sets.precast.weaponbash

	include("drk/midcast-absorb.lua") -- sets.midcast.absorb
	include("drk/midcast-drain.lua") -- sets.midcast.drain
	include("drk/midcast-dreadspikes.lua") -- sets.midcast.dreadspikes
	include("drk/midcast-elemental.lua") -- sets.midcast.elemental
	include("drk/midcast-endark.lua") -- sets.midcast.endark
	include("drk/midcast-impact.lua") -- sets.midcast.impact

	include("func/obi_check.lua") -- obi_check()

	_ABSORB_SPELLS = T {
		"Absorb-ACC",
		"Absorb-AGI",
		"Absorb-Attri",
		"Absorb-CHR",
		"Absorb-DEX",
		"Absorb-INT",
		"Absorb-MND",
		"Absorb-STR",
		"Absorb-TP",
		"Absorb-VIT",
	}

	_DRAIN_SPELLS = T {
		"Aspir",
		"Aspir II",
		"Drain",
		"Drain II",
		"Drain III",
	}

	_MAGICAL_WS = T {
		"Aeolian Edge",
	}

	_MULTI_HIT_WS = T {
		"Resolution",
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

	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if _MAGICAL_WS:contains(spell.name) then
			equip(sets.ws.magical)
			obi_check(spell)
		elseif _MULTI_HIT_WS:contains(spell.name) then
			equip(sets.ws.multihit)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Arcane Circle") then
			equip(sets.precast.arcanecircle)
		elseif spell.english:contains("Blood Weapon") then
			equip(sets.precast.bloodweapon)
		elseif spell.english:contains("Dark Seal") then
			equip(sets.precast.darkseal)
		elseif spell.english:contains("Diabolic Eye") then
			equip(sets.precast.diaboliceye)
		elseif spell.english:contains("Last Resort") then
			equip(sets.precast.lastresort)
		elseif spell.english:contains("Nether Void") then
			equip(sets.precast.nethervoid)
		end
	elseif spell.skill == "Elemental Magic" then
		if spell.english:contains("Impact") then
			equip(sets.impact)
		end
	else
		equip(sets.fastcast)
	end
end

function midcast(spell)
	if spell.skill == "Dark Magic" then
		if _ABSORB_SPELLS:contains(spell.english) then
			equip(sets.midcast.absorb)
		elseif _DRAIN_SPELLS:contains(spell.english) then
			equip(sets.midcast.drain)
		elseif spell.english:contains("Dread Spikes") then
			equip(sets.midcast.dreadspikes)
		elseif spell.english:contains("Endark") then
			equip(sets.midcast.endark)
		end
	elseif spell.skill == "Elemental Magic" then
		equip(sets.midcast.elemental)
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

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
	elseif new == "Idle" then
		equip(sets.idle)
	end
end

function buff_change(name, gain, buff_details)

end
