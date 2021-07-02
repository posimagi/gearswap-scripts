function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("func/buffactive_darkarts.lua") -- buffactive_darkarts()
	include("func/buffactive_lightarts.lua") -- buffactive_lightarts()
	include("func/buffactive_sublimation.lua") -- buffactive_sublimation()
	include("func/obi_check.lua") -- obi_check()

	include("all/impact.lua") -- sets.impact
	include("all/obi.lua") -- sets.obi

	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-darkness.lua") -- sets.midcast.darkness
	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("sch/fastcast.lua") -- sets.fastcast
	include("sch/idle.lua") -- sets.idle
	include("sch/naked.lua") -- sets.naked
	include("sch/perpetuance.lua") -- sets.perpetuance
	include("sch/sublimation.lua") -- sets.sublimation
	include("sch/th.lua") -- sets.th

	include("sch/precast-grimoire.lua") -- sets.precast.grimoire
	include("sch/precast-healing.lua") -- sets.precast.healing
	include("sch/precast-tabularasa.lua") -- sets.precast.tabularasa

	include("sch/midcast-aquaveil.lua") -- sets.midcast.aquaveil
	include("sch/midcast-cursna.lua") -- sets.midcast.cursna
	include("sch/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("sch/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("sch/midcast-healing.lua") -- sets.midcast.healing
	include("sch/midcast-helix.lua") -- sets.midcast.helix
	include("sch/midcast-light.lua") -- sets.midcast.light
	include("sch/midcast-mb.lua") -- sets.midcast.mb
	include("sch/midcast-refresh.lua") -- sets.midcast.refresh
	include("sch/midcast-regen.lua") -- sets.midcast.regen

	_REGEN_DURATION = false
	if _REGEN_DURATION then
		include("sch/midcast-regen-duration.lua") -- sets.midcast.regen
	end

	_TIER_ONE_NUKES = T{
		"Fire",
		"Blizzard",
		"Aero",
		"Stone",
		"Thunder",
		"Water"
	}

	send_command(
		"input /macro book 20; \
		wait 1; \
		input /macro set 1; \
		wait 5; \
		input /lockstyleset 97; \
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
		if spell.english:contains("Tabula Rasa") then
			equip(sets.precast.tabularasa)
		end
	else
		equip(sets.fastcast)
		if spell.skill == "Healing Magic" then
			equip(sets.precast.healing)
		end
		if spell.type == "WhiteMagic" and buffactive_lightarts() then
			equip(sets.precast.grimoire)
		elseif spell.type == "BlackMagic" and buffactive_darkarts() then
			equip(sets.precast.grimoire)
		end
	end
end

function midcast(spell)
	if spell.skill == "Enfeebling Magic" then
		equip(sets.midcast.enfeebling)
		obi_check(spell)
		if spell.english:contains("Dia") then
			equip(sets.th)
		end
	elseif spell.skill == "Enhancing Magic" then
		equip(sets.midcast.enhancing)
		if spell.english:contains("Aquaveil") then
			equip(sets.midcast.aquaveil)
		elseif spell.english:contains("Refresh") then
			equip(sets.midcast.refresh)
		elseif spell.english:contains("Regen") then
			equip(sets.midcast.regen)
		elseif spell.english:contains("Stoneskin") then
			equip(sets.midcast.stoneskin)
		end
		if buffactive["Perpetuance"] then
			equip(sets.perpetuance)
		end
	elseif spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
		if spell.name:contains("Cursna") then
			equip(sets.midcast.cursna)
		end
		obi_check(spell)
	elseif spell.skill == "Elemental Magic" then
		equip(sets.midcast.mb)
		obi_check(spell)
		if spell.english:contains("helix") then
			equip(sets.midcast.helix)
			if spell.english:contains("Luminohelix") then
				equip(sets.midcast.light)
			elseif spell.english:contains("Noctohelix") then
				equip(sets.midcast.darkness)
			end
		elseif spell.english:contains("Kaustra") then
			equip(sets.midcast.darkness)
		elseif spell.english:contains("Impact") then
			equip(sets.impact)
		end
		if world.area == "Outer Ra'Kaznar [U]" then
			if _TIER_ONE_NUKES:contains(spell.english) then
				equip(sets.naked)
			end
		end
	elseif spell.skill == "Dark Magic" then
		if spell.english:contains("Bio") then
			equip(sets.th)
		end
		obi_check(spell)
	end
end

function aftercast(spell)
	equip(sets.idle)
	if spell.english == "Sublimation" or buffactive_sublimation() then
		equip(sets.sublimation)
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
	elseif new == "Idle" then
		equip(sets.idle)
		if buffactive_sublimation() then
			equip(sets.sublimation)
		end
	end
end
