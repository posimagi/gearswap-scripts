function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("func/obi_check.lua") -- obi_check()

	include("all/dispelga.lua") -- sets.dispelga
	include("all/impact.lua") -- sets.impact
	include("all/obi.lua") -- sets.obi
	include("all/quickmagic.lua") -- sets.quickmagic

	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-aquaveil.lua") -- sets.midcast.aquaveil
	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("geo/idle.lua") -- sets.idle
	include("geo/fastcast.lua") -- sets.fastcast
	include("geo/naked.lua") -- sets.naked
	include("geo/th.lua") -- sets.th
	include("geo/tp.lua") -- sets.tp
	include("geo/weapon.lua") -- sets.weapon
	include("geo/weapon-staff.lua") -- sets.weapon.staff
	include("geo/ws.lua") -- sets.ws
	include("geo/ws-dark.lua") -- sets.ws.dark
	include("geo/ws-magical.lua") -- sets.ws.magical

	include("geo/precast-bolster.lua") -- sets.precast.bolster
	include("geo/precast-concentricpulse.lua") -- sets.precast.concentricpulse
	include("geo/precast-elemental.lua") -- sets.precast.elemental
	include("geo/precast-fullcircle.lua") -- sets.precast.fullcircle
	include("geo/precast-healing.lua") -- sets.precast.healing
	include("geo/precast-lifecycle.lua") -- sets.precast.lifecycle
	include("geo/precast-radialarcana.lua") -- sets.precast.radialarcana

	include("geo/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("geo/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("geo/midcast-geocolure.lua") -- sets.midcast.geocolure
	include("geo/midcast-geomancy.lua") -- sets.midcast.geomancy
	include("geo/midcast-healing.lua") -- sets.midcast.healing
	include("geo/midcast-indicolure.lua") -- sets.midcast.indicolure
	include("geo/midcast-elemental.lua") -- sets.midcast.elemental
	include("geo/midcast-refresh.lua") -- sets.midcast.refresh

	_MAGICAL_WS = T {
		"Flash Nova",
		"Seraph Strike",
		"Shining Strike",
	}

	_DARK_WS = T {
		"Cataclysm",
	}

	_TIER_ONE_NUKES = T {
		"Fire",
		"Blizzard",
		"Aero",
		"Stone",
		"Thunder",
		"Water"
	}

	send_command(macrobook_cmd..porter_cmd..lockstyle_cmd)
end

function sub_job_change(new, old)
	send_command(
		"wait 10; \
	input /lockstyleset 59; \
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

	equip(sets.fastcast)
	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if _DARK_WS:contains(spell.english) then
			equip(sets.ws.magical, sets.ws.dark)
			obi_check(spell)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Bolster") then
			equip(sets.precast.bolster)
		elseif spell.english:contains("Concentric Pulse") then
			equip(sets.precast.concentricpulse)
		elseif spell.english:contains("Full Circle") then
			equip(sets.precast.fullcircle)
		elseif spell.english:contains("Life Cycle") then
			equip(sets.precast.lifecycle)
		elseif spell.english:contains("Radial Arcana") then
			equip(sets.precast.radialarcana)
		end
	elseif spell.skill == "Healing Magic" then
		equip(sets.precast.healing)
	elseif spell.skill == "Elemental Magic" then
		equip(sets.precast.elemental)
		if spell.english:contains("Impact") then
			equip(sets.impact)
		end
	elseif spell.english:contains("Dispelga") then
		_PREVIOUS_WEAPONS = T {
			main = player.equipment.main
		}
		equip(sets.dispelga)
	end
end

function midcast(spell)
	if spell.skill == "Geomancy" then
		equip(sets.midcast.geomancy)
		if spell.english:contains("Indi-") then
			equip(sets.midcast.indicolure)
		elseif spell.english:contains("Geo-") then
			equip(sets.midcast.geocolure)
		end
	elseif spell.skill == "Enfeebling Magic" then
		equip(sets.midcast.enfeebling)
		if spell.english:contains("Dia") then
			equip(sets.th)
		end
	elseif spell.skill == "Enhancing Magic" then
		equip(sets.midcast.enhancing)
		if spell.english:contains("Aquaveil") then
			equip(sets.midcast.aquaveil)
		elseif spell.english:contains("Stoneskin") then
			equip(sets.midcast.stoneskin)
		elseif spell.english:contains("Refresh") then
			equip(sets.midcast.refresh)
		end
	elseif spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
	elseif spell.skill == "Elemental Magic" then
		equip(sets.midcast.elemental)
		obi_check(spell)
		if spell.english:contains("Impact") then
			equip(sets.impact)
		elseif world.area == "Outer Ra'Kaznar [U]" and
			_TIER_ONE_NUKES:contains(spell.english)
		then
			equip(sets.naked)
		end
	elseif spell.skill == "Dark Magic" then
		if spell.english:contains("Bio") then
			equip(sets.th)
		end
	end
end

function aftercast(spell)
	if world.area == "Outer Ra'Kaznar [U]" and spell.skill == "Elemental Magic" then
		equip(sets.weapon)
	end
	if player.status == "Engaged" then
		equip(sets.tp)
	elseif player.status == "Idle" then
		equip(sets.idle)
	end
	if spell.english:contains("Dispelga") then
		equip(_PREVIOUS_WEAPONS)
	end
end

function status_change(new, old)
	if player.status == "Engaged" then
		equip(sets.tp)
	elseif player.status == "Idle" then
		equip(sets.idle)
	end
end
