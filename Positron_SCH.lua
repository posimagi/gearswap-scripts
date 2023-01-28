function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")

	include("func/buffactive_darkarts.lua") -- buffactive_darkarts()
	include("func/buffactive_lightarts.lua") -- buffactive_lightarts()
	include("func/buffactive_movementspeed.lua") -- buffactive_movementspeed()
	include("func/buffactive_sublimation.lua") -- buffactive_sublimation()
	include("func/obi_check.lua") -- obi_check()

	include("all/dispelga.lua") -- sets.dispelga
	include("all/impact.lua") -- sets.impact
	include("all/obi.lua") -- sets.obi
	include("all/quickmagic.lua") -- sets.quickmagic
	include("all/th.lua") -- sets.th

	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-darkness.lua") -- sets.midcast.darkness
	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("sch/darkarts.lua") -- sets.darkarts
	include("sch/fastcast.lua") -- sets.fastcast
	include("sch/idle.lua") -- sets.idle
	include("sch/klimaform.lua") -- sets.klimaform
	include("sch/lightarts.lua") -- sets.lightarts
	include("sch/movementspeed.lua") -- sets.movementspeed
	include("sch/naked.lua") -- sets.naked
	include("sch/perpetuance.lua") -- sets.perpetuance
	include("sch/sublimation.lua") -- sets.sublimation
	include("sch/tp.lua") -- sets.tp
	include("sch/ws.lua") -- sets.ws

	include("sch/precast-grimoire.lua") -- sets.precast.grimoire
	include("sch/precast-healing.lua") -- sets.precast.healing
	include("sch/precast-tabularasa.lua") -- sets.precast.tabularasa

	include("sch/midcast-aquaveil.lua") -- sets.midcast.aquaveil
	include("sch/midcast-barspell.lua") -- sets.midcast.barspell
	include("sch/midcast-cursna.lua") -- sets.midcast.cursna
	include("sch/midcast-darkness.lua") -- sets.midcast.darkness
	include("sch/midcast-elemental.lua") -- sets.midcast.elemental
	include("sch/midcast-elemental-vagary.lua") -- sets.midcast.elemental.vagary
	include("sch/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("sch/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("sch/midcast-healing.lua") -- sets.midcast.healing
	include("sch/midcast-helix.lua") -- sets.midcast.helix
	include("sch/midcast-light.lua") -- sets.midcast.light
	include("sch/midcast-refresh.lua") -- sets.midcast.refresh
	include("sch/midcast-regen.lua") -- sets.midcast.regen

	_REGEN_DURATION = false
	if _REGEN_DURATION then
		include("sch/midcast-regen-duration.lua") -- sets.midcast.regen
	end

	_TIER_ONE_NUKES = T {
		"Fire",
		"Blizzard",
		"Aero",
		"Stone",
		"Thunder",
		"Water",
		"Geohelix",
		"Hydrohelix",
		"Anemohelix",
		"Pyrohelix",
		"Cryohelix",
		"Ionohelix",
		"Noctohelix",
		"Luminohelix",
	}

	_TIER_TWO_NUKES = T {
		"Fire II",
		"Blizzard II",
		"Aero II",
		"Stone II",
		"Thunder II",
		"Water II"
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
		obi_check(spell)
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Tabula Rasa") then
			equip(sets.precast.tabularasa)
		elseif spell.english:contains("Light Arts") then
			equip(sets.lightarts)
		elseif spell.english:contains("Dark Arts") then
			equip(sets.darkarts)
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
		if spell.skill == "Elemental Magic" then
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
		elseif spell.english:contains("Bar") then
			equip(sets.midcast.barspell)
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
		equip(sets.midcast.elemental)
		obi_check(spell)
		if spell.english:contains("helix") then
			equip(sets.midcast.helix)
			-- if spell.english:contains("Luminohelix") then
			--	 equip(sets.midcast.light)
			if spell.english:contains("Noctohelix") then
				equip(sets.midcast.darkness)
			end
		elseif spell.english:contains("Kaustra") then
			equip(sets.midcast.darkness)
		elseif spell.english:contains("Impact") then
			equip(sets.impact)
		end
		if buffactive["Klimaform"] and world.weather_element == spell.element then
			equip(sets.klimaform)
		end
		if world.area:contains("Outer Ra'Kaznar [U") then
			if _TIER_ONE_NUKES:contains(spell.english) then
				equip(sets.naked)
			elseif _TIER_TWO_NUKES:contains(spell.english) then
				equip(sets.midcast.elemental.vagary)
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
	if player.status == "Idle" then
		equip(sets.idle)
		if world.area:contains("Outer Ra'Kaznar [U") then
			if _TIER_ONE_NUKES:contains(spell.english) then
				equip(sets.darkarts)
			end
		end
		if player.tp < 1000 then
			if buffactive["Light Arts"] and not spell.english:contains("Dark Arts") then
				equip(sets.lightarts)
			elseif buffactive["Dark Arts"] and not spell.english:contains("Light Arts") then
				equip(sets.darkarts)
			end
		end
	else
		equip(sets.tp)
	end
	if spell.english == "Sublimation" or buffactive_sublimation() then
		equip(sets.sublimation)
	end
	if spell.english:contains("Dispelga") then
		equip(_PREVIOUS_WEAPONS)
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

function buff_change(name, gain, buff_details)
	if _MOVEMENT_SPEED_BUFFS:contains(name) then
		if gain then
			sets.idle = set_combine(sets.idle, sets.movementspeed)
			if player.status == "Idle" then
				equip(sets.idle)
			end
		else
			include("sch/idle.lua") -- sets.idle
			if player.status == "Idle" then
				equip(sets.idle)
			end
		end
	end
end
