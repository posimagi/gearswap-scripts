function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("func/obi_check.lua") -- obi_check()

	include("all/obi.lua") -- sets.obi
	include("all/precast-utsusemi.lua") -- sets.precast.utsusemi

	include("cor/fastcast.lua") -- sets.fastcast
	include("cor/idle.lua") -- sets.idle
	include("cor/tp.lua") -- sets.tp
	include("cor/ws.lua") -- sets.ws
	include("cor/ws-dark.lua") -- sets.ws.dark
	include("cor/ws-magical.lua") -- sets.ws.magical
	include("cor/ws-singlehit.lua") -- sets.ws.singlehit

	include("cor/precast-phantomroll.lua") -- sets.precast.phantomroll
	include("cor/precast-quickdraw.lua") -- sets.precast.quickdraw
	include("cor/precast-ra.lua") -- sets.precast.ra
	include("cor/precast-randomdeal.lua") -- sets.precast.randomdeal
	include("cor/precast-wildcard.lua") -- sets.precast.wildcard

	include("cor/midcast-phalanx.lua") -- sets.midcast.phalanx
	include("cor/midcast-ra.lua") -- sets.midcast.ra

	send_command(
		"input /macro book 11; \
		wait 1; \
		input /macro set 10; \
		wait 5; \
		input /lockstyleset 96; \
		gs equip sets.idle"
	) -- lockstyle
end

function sub_job_change(new, old)
	send_command(
		"input /macro book 11; \
		wait 1; \
		input /macro set 10; \
		wait 10; \
		input /lockstyleset 96; \
		gs equip sets.idle"
	)
end

function precast(spell, position)
	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if spell.english:contains("Leaden Salute") then
			equip(sets.ws.magical, sets.ws.dark)
			obi_check(spell)
		elseif 
				spell.english:contains("Wildfire") or
				spell.english:contains("Aeolian Edge") then
			equip(sets.ws.magical)
			obi_check(spell)
		elseif spell.english:contains("Savage Blade") then
			equip(sets.ws.singlehit)
		end
	elseif spell.type == "CorsairRoll" then
		equip(sets.precast.phantomroll)
	elseif spell.type == "CorsairShot" then
		equip(sets.precast.quickdraw)
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Double-Up") then
			equip(sets.precast.phantomroll)
		elseif spell.english:contains("Random Deal") then
			equip(sets.precast.randomdeal)
		elseif spell.english:contains("Wild Card") then
			equip(sets.precast.wildcard)
		end
	elseif spell.type == "Ninjutsu" then
		equip(sets.fastcast)
		if spell.english:contains("Utsusemi") then
			equip(sets.precast.utsusemi)
		end
	elseif spell.action_type == "Ranged Attack" then
		equip(sets.precast.ra)
	else
		equip(sets.fastcast)
	end
end
include("func/ws_distance_check.lua")

function midcast(spell)
	if spell.english:contains("Phalanx") then
		equip(sets.midcast.phalanx)
	elseif spell.action_type == "Ranged Attack" then
		equip(sets.midcast.ra)
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
