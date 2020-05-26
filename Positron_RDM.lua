function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("all/impact.lua") -- sets.impact

	include("all/precast-enhancing.lua") -- sets.precast.enhancing
	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin
	include("all/precast-utsusemi.lua") -- sets.precast.utsusemi

	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("rdm/enspell.lua") -- sets.enspell
	include("rdm/fastcast.lua") -- sets.fastcast
	include("rdm/idle.lua") -- sets.idle
	include("rdm/idle-hybrid.lua") -- sets.idle.hybrid
	include("rdm/th.lua") -- sets.th
	include("rdm/tp.lua") -- sets.tp
	include("rdm/ws.lua") -- sets.ws
	include("rdm/ws-magical.lua") -- sets.ws.magical

	include("rdm/precast-chainspell.lua") -- sets.precast.chainspell

	include("rdm/midcast-cursna.lua") -- sets.midcast.cursna
	include("rdm/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("rdm/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("rdm/midcast-enhancingskill.lua") -- sets.midcast.enhancingskill
	include("rdm/midcast-healing.lua") -- sets.midcast.healing
	include("rdm/midcast-mb.lua") -- sets.midcast.mb
	include("rdm/midcast-phalanx.lua") -- sets.midcast.phalanx
	include("rdm/midcast-refresh.lua") -- sets.midcast.refresh

	include("func/buffactive_enspell.lua") -- buffactive_enspell()

	_ODIN = false
	if _ODIN then
		include("rdm/odin/midcast-enfeebling.lua") -- sets.midcast.enfeebling
		include("rdm/odin/midcast-enhancing.lua") -- sets.midcast.enhancing
		include("rdm/odin/midcast-healing.lua") -- sets.midcast.healing
		include("rdm/odin/tp.lua") -- sets.tp
	end

	_HYBRID = false
	if _HYBRID then
		sets.idle = sets.idle.hybrid
	end

	send_command(
		"wait 5; \
		input /macro book 5; \
		input /macro set 1; \
		input /lockstyleset 40; \
		gs equip sets.idle"
	)
end

function sub_job_change(new, old)
end

function precast(spell, position)
	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if spell.english:contains("Aeolian Edge") or
		   spell.english:contains("Seraph Blade") or
		   spell.english:contains("Sanguine Blade") then
			equip(sets.ws.magical)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Chainspell") then
			equip(sets.precast.chainspell)
		end
	else
		equip(sets.fastcast)
		if spell.skill == "Enhancing Magic" then
			equip(sets.precast.enhancing)
			if spell.english:contains("Stoneskin") then
				equip(sets.precast.stoneskin)
			end
		elseif spell.skill == "Elemental Magic" then
			if spell.english:contains("Impact") then
				equip(sets.impact)
			end
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
		elseif spell.english:contains("Gain") then
			equip(sets.midcast.enhancingskill)
		elseif spell.english:contains("Phalanx") then
			equip(sets.midcast.enhancingskill)
			if spell.targets['Self'] then
				equip(sets.midcast.phalanx)
			end
		elseif spell.english:contains("Stoneskin") then
			equip(sets.midcast.stoneskin)
		end
	elseif spell.skill == "Dark Magic" then
		equip(sets.midcast.enfeebling)
	elseif spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
		if spell.name:contains("Cursna") then
			equip(sets.midcast.cursna)
		end
	elseif spell.skill == "Elemental Magic" then
		equip(sets.midcast.mb)
		if spell.english:contains("Impact") then
			equip(sets.impact)
		end
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
