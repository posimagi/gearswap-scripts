function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("all/impact.lua") -- sets.impact
	include("all/obi.lua") -- sets.obi
	include("all/th.lua") -- sets.th

	include("all/precast-enhancing.lua") -- sets.precast.enhancing
	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("whm/fastcast.lua") -- sets.fastcast
	include("whm/idle.lua") -- sets.idle
	include("whm/idle-hybrid.lua") -- sets.idle.hybrid
	include("whm/sublimation.lua") -- sets.sublimation
	include("whm/tp.lua") -- sets.tp
	include("whm/ws.lua") -- sets.ws

	include("whm/precast-benediction.lua") -- sets.precast.benediction
	include("whm/precast-devotion.lua") -- sets.precast.devotion
	include("whm/precast-healing.lua") -- sets.precast.healing

	include("whm/midcast-barspell.lua") -- sets.midcast.barspell
	include("whm/midcast-cursna.lua") -- sets.midcast.cursna
	include("whm/midcast-divine.lua") -- sets.midcast.divine
	include("whm/midcast-healing.lua") -- sets.midcast.healing
	include("whm/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("whm/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("whm/midcast-regen.lua") -- sets.midcast.regen

	include("func/buffactive_sublimation.lua") -- buffactive_sublimation()

	_HYBRID = false
	if _HYBRID then
		sets.idle = sets.idle.hybrid
	end

	send_command(
		"input /macro book 3; \
		input /macro set 1; \
		wait 5; \
		input /lockstyleset 20; \
		gs equip sets.idle"
	)
end

function sub_job_change(new, old)
	send_command(
		"input /macro book 3; \
		input /macro set 1; \
		wait 10; \
		input /lockstyleset 20; \
		gs equip sets.idle"
	)
end

function precast(spell, position)
	equip(sets.fastcast)
	if spell.skill == "Healing Magic" then
		equip(sets.precast.healing)
	elseif spell.skill == "Enhancing Magic" then
		equip(sets.precast.enhancing)
		if spell.english:contains("Stoneskin") then
			equip(sets.precast.stoneskin)
		end
	elseif spell.type == "JobAbility" then
		if spell.english == "Benediction" then
			equip(sets.precast.benediction)
		elseif spell.english == "Devotion" then
			equip(sets.precast.devotion)
		end
	elseif spell.type == "WeaponSkill" then
		equip(sets.ws)
	else
		if spell.english:contains("Impact") then
			equip(sets.impact)
		end
	end
end

function midcast(spell)
	if spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
		if spell.name:contains("Cursna") then
			equip(sets.midcast.cursna)
		end
		if world.weather_element == spell.element then
			equip(sets.obi)
		end
	elseif spell.skill == "Enfeebling Magic" then
		equip(sets.midcast.enfeebling)
		if spell.english:contains("Dia") then
			equip(sets.th)
		end
	elseif spell.skill == "Enhancing Magic" then
		equip(sets.midcast.enhancing)
		if spell.english:contains("Erase") then
			equip(sets.midcast.healing)
		elseif spell.english:contains("Regen") then
			equip(sets.midcast.regen)
		elseif spell.english:contains("Stoneskin") then
			equip(sets.midcast.stoneskin)
		end
	elseif spell.skill == "Divine Magic" then
		equip(sets.midcast.enfeebling, sets.midcast.divine)
	elseif spell.skill == "Dark Magic" then
		equip(sets.midcast.enfeebling)
	elseif spell.skill == "Elemental Magic" then
		if spell.english:contains("Impact") then
			equip(sets.impact)
		end
	end
end

function aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
		if spell.english == "Sublimation" or buffactive_sublimation() then
			equip(sets.sublimation)
		end
	elseif player.status == "Engaged" then
		equip(sets.tp)
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
