function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	include("common/ws_disengaged_check.lua")
	include("common/ws_distance_check.lua")
	
	include("all/obi.lua") -- sets.obi

	include("pld/enmity.lua") -- sets.enmity
	include("pld/fastcast.lua") -- sets.fastcast
	include("pld/idle.lua") -- sets.idle
	include("pld/interrupt.lua") -- sets.interrupt
	include("pld/tp.lua") -- sets.tp
	include("pld/ws.lua") -- sets.ws
	include("pld/ws-magical.lua") -- sets.ws.magical

	include("pld/precast-chivalry.lua") -- sets.precast['Chivalry']
	include("pld/precast-cover.lua") -- sets.precast['Cover']
	include("pld/precast-divineemblem.lua") -- sets.precast['Divine Emblem']
	include("pld/precast-fealty.lua") -- sets.precast['Fealty']
	include("pld/precast-holycircle.lua") -- sets.precast['Holy Circle']
	include("pld/precast-invincible.lua") -- sets.precast['Invincible']
	include("pld/precast-rampart.lua") -- sets.precast['Rampart']
	include("pld/precast-sentinel.lua") -- sets.precast['Sentinel']
	include("pld/precast-shieldbash.lua") -- sets.precast['Shield Bash']

	include("pld/midcast-healing.lua") -- sets.midcast.healing
	include("pld/midcast-holy.lua") -- sets.midcast.holy
	include("pld/midcast-protect.lua") -- sets.midcast.protect

	include("func/obi_check.lua") -- obi_check()

	_MAGICAL_WS = T {
		"Aeolian Edge",
		"Red Lotus Blade",
		"Seraph Blade"
	}

	_TAG_SPELLS = T {
		"Banishga",
		"Geist Wall",
		"Jettatura",
		"Poisonga",
		"Sheep Song"
	}

	send_command(macrobook_cmd..porter_cmd..lockstyle_cmd)
end

function precast(spell, position)
	if ws_disengaged_check(spell) then return end
	if ws_distance_check(spell) then return end

	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if _MAGICAL_WS:contains(spell.name) then
			equip(sets.ws.magical)
			obi_check(spell)
		end
	elseif spell.type == "JobAbility" then
		equip(sets.idle, sets.enmity, sets.precast[spell.name])
	else
		equip(sets.fastcast)
	end
end

function midcast(spell)
	if _TAG_SPELLS:contains(spell.english) then
		equip(sets.idle, sets.interrupt)
	elseif spell.english:contains("Flash") then
		equip(sets.idle, sets.enmity)
	elseif spell.english:contains("Cure") then
		equip(sets.idle, sets.midcast.healing, sets.interrupt)
	elseif spell.english:contains("Protect") then
		_PREVIOUS_SHIELD = T {
			sub = player.equipment.sub
		}
		equip(sets.idle, sets.midcast.protect)
	elseif spell.english:contains("Reprisal") then
		equip(sets.idle, sets.enmity)
	elseif spell.english:contains("Holy") then
		equip(sets.idle, sets.midcast.holy)
	end
end

function aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		equip(sets.tp)
	end
	if spell.english:contains("Protect") then
		equip(_PREVIOUS_SHIELD)
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
