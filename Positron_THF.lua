function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("all/precast-utsusemi.lua") -- sets.precast.utsusemi

	include("thf/domain.lua") -- sets.domain
	include("thf/fastcast.lua") -- sets.fastcast
	include("thf/idle.lua") -- sets.idle
	include("thf/idle-hybrid.lua") -- sets.idle.hybrid
	include("thf/ra.lua") -- sets.ra
	include("thf/regen.lua") -- sets.regen
	include("thf/th.lua") -- sets.th
	include("thf/th-medium.lua") -- sets.th.medium
	include("thf/th-minimal.lua") -- sets.th.minimal
	include("thf/tp.lua") -- sets.tp
	include("thf/tp-hybrid.lua") -- sets.tp.hybrid
	include("thf/ws.lua") -- sets.ws
	include("thf/ws-singlehit.lua") -- sets.ws.singlehit
	include("thf/ws-magical.lua") -- sets.ws.magical

	include("thf/precast-despoil.lua") -- sets.precast.despoil
	include("thf/precast-flee.lua") -- sets.precast.flee
	include("thf/precast-steal.lua") -- sets.precast.steal

	include("func/buffactive_sata.lua") -- buffactive_sata()

	_HYBRID = false
	if _HYBRID then
		sets.idle = sets.idle.hybrid
		sets.tp = sets.tp.hybrid
	end

	_IDLE_REGEN = true
	if _IDLE_REGEN then
		sets.idle = set_combine(sets.idle, sets.regen)
	end

	_TH = "medium"
	if _TH == "full" then
		sets.tp = set_combine(sets.tp, sets.th)
		sets.ws = set_combine(sets.ws, sets.th)
		sets.ws.magical = set_combine(sets.ws.magical, sets.th)
	elseif _TH == "medium" then
		sets.tp = set_combine(sets.tp, sets.th.medium)
		sets.ws.magical = set_combine(sets.ws.magical, sets.th.medium)
	elseif _TH == "minimal" then
		sets.tp = set_combine(sets.tp, sets.th.minimal)
	elseif _TH == "none" then
		-- do nothing
	end

	send_command(
		"input /macro book 6; \
		input /macro set 2; \
		wait 5; \
		input /lockstyleset 50; \
		gs equip sets.idle"
	)
end

function sub_job_change(new, old)
	send_command(
		"input /macro book 6; \
		input /macro set 2; \
		wait 10; \
		input /lockstyleset 50; \
		gs equip sets.idle"
	)
end

function precast(spell, position)
	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if spell.english:contains("Rudra's Storm") or spell.english:contains("Mandalic Stab") then
			equip(sets.ws.singlehit)
		elseif spell.english:contains("Aeolian Edge") then
			equip(sets.ws.magical)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Flee") then
			equip(sets.precast.flee)
		elseif spell.english:contains("Steal") then
			equip(sets.precast.steal)
		elseif spell.english:contains("Despoil") then
			equip(sets.precast.despoil)
		end
	elseif spell.type == "Ninjutsu" then
		equip(sets.fastcast)
		if spell.english:contains("Utsusemi") then
			equip(sets.precast.utsusemi)
		end
	elseif spell.action_type == "Ranged Attack" then
		equip(sets.ra)
	else
		equip(sets.fastcast)
	end
end

function midcast(spell)
end

function aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		equip(sets.tp)
		if spell.english:contains("Sneak Attack") or spell.english:contains("Trick Attack") then
			equip(sets.th)
		elseif buffactive_sata() then
			equip(sets.th)
		end
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
		if buffactive_sata() then
			equip(sets.th)
		end
	elseif new == "Idle" then
		equip(sets.idle)
	end
end

function buff_change(name, gain, buff_details)
	if name == "Sneak Attack" or name == "Trick Attack" then
		if gain then
			equip(sets.th)
		else
			if player.status == "Engaged" then
				equip(sets.tp)
			elseif player.status == "Idle" then
				equip(sets.idle)
			end
		end
	end
end
