function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("rdm/enspell.lua") -- sets.enspell
	include("rdm/fastcast.lua") -- sets.fastcast
	include("rdm/idle.lua") -- sets.idle
	include("rdm/th.lua") -- sets.th
	include("rdm/tp.lua") -- sets.tp
	include("rdm/ws.lua") -- sets.ws

	include("all-precast-utsusemi.lua") -- sets.precast.utsusemi
	include("all-stoneskin.lua") -- sets.stoneskin
	
	sets.ws.sanguineblade = {} -- placeholder
	-- include('rdm-ws-sanguineblade.lua')      -- sets.ws.sanguineblade

	include("rdm/precast-chainspell.lua") -- sets.precast.chainspell
	include("rdm/precast-enhancing.lua") -- sets.precast.enhancing

	include("rdm/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("rdm/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("rdm/midcast-enhancingskill.lua") -- sets.midcast.enhancingskill
	include("rdm/midcast-mb.lua") -- sets.midcast.mb
	include("rdm/midcast-refresh.lua") -- sets.midcast.refresh

	include("func/buffactive_enspell.lua") -- buffactive_enspell()

	send_command(
		"wait 5; \
		input /macro book 5; \
		input /macro set 1; \
		input /lockstyleset 40; \
		gs equip sets.idle")
end

function sub_job_change(new, old)

end

function precast(spell, position)
	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if spell.english:contains("Sanguine Blade") then
			equip(sets.ws.sanguineblade)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Chainspell") then
			equip(sets.precast.chainspell)
		end
	else
		equip(sets.fastcast)
		if spell.skill == "Enhancing Magic" then
			equip(sets.precast.enhancing)
		elseif spell.english:contains("Impact") then
			equip(sets.impact)
		end
	end
end

function midcast(spell)
	if spell.skill == "Enfeebling Magic" then
		equip(sets.midcast.enfeebling)
		if spell.english:contains("Dia") then
			equip(sets.th)
		end
	elseif spell.skill == "Enhancing Magic" then
		equip(sets.midcast.enhancing)
		if spell.english:contains("Refresh") then
			equip(sets.midcast.refresh)
		elseif spell.english:contains("En") then
			equip(sets.midcast.enhancingskill)
		elseif spell.english:contains("Stoneskin") then
			equip(sets.stoneskin)
		end
	elseif spell.skill == "Dark Magic" then
		equip(sets.midcast.enfeebling)
	elseif spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
	elseif spell.skill == "Elemental Magic" then
		equip(sets.midcast.mb)
	elseif spell.type == "Ninjutsu" then
		if spell.english:contains("Utsusemi") then
			equip(sets.precast.utsusemi)
		end
	end
end

function aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		equip(sets.tp)
		if buffactive_enspell() then
			equip(sets.enspell)
		end
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
		if buffactive_enspell() then
			equip(sets.enspell)
		end
	elseif new == "Idle" then
		equip(sets.idle)
	end
end
