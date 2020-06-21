function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("all/precast-utsusemi.lua") -- sets.precast.utsusemi

	include("thf/domain.lua") -- sets.domain
	include("thf/idle.lua") -- sets.idle
	include("thf/th.lua") -- sets.th
	include("thf/tp.lua") -- sets.tp
	include("thf/ws.lua") -- sets.ws
	include("thf/ws-singlehit.lua") -- sets.ws.singlehit
	include("thf/ws-magical.lua") -- sets.ws.magical

	include("thf/precast-despoil.lua") -- sets.precast.despoil
	include("thf/precast-flee.lua") -- sets.precast.flee
	include("thf/precast-steal.lua") -- sets.precast.steal

	include("func/buffactive_sata.lua") -- buffactive_sata()

	_TH = true

	send_command(
		"wait 5; \
		input /macro book 6; \
		input /macro set 2; \
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
		if spell.english:contains("Utsusemi") then
			equip(sets.precast.utsusemi)
		end
	end
end

function midcast(spell)
end

function aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		equip(sets.tp)
		if _TH then
			equip(sets.th)
		end
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
		if _TH then
			equip(sets.th)
		end
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
				if _TH then
					equip(sets.th)
				end
			elseif player.status == "Idle" then
				equip(sets.idle)
			end
		end
	end
end
