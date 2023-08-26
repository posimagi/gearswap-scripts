function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("all/precast-utsusemi.lua") -- sets.precast.utsusemi
	include("all/obi.lua") -- sets.obi

	include("thf/conspirator.lua") -- sets.conspirator
	include("thf/domain.lua") -- sets.domain
	include("thf/fastcast.lua") -- sets.fastcast
	include("thf/idle.lua") -- sets.idle
	include("thf/magian.lua") -- sets.magian
	include("thf/ra.lua") -- sets.ra
	include("thf/regen.lua") -- sets.regen
	include("thf/th.lua") -- sets.th
	include("thf/th-minimal.lua") -- sets.th.minimal
	include("thf/tp.lua") -- sets.tp
	include("thf/tp-empyreanam.lua") -- sets.tp.empyreanam
	include("thf/weapon.lua") -- sets.weapon
	include("thf/weapon-omen.lua") -- sets.weapon.omen
	include("thf/ws.lua") -- sets.ws
	include("thf/ws-critical.lua") -- sets.ws.critical
	include("thf/ws-magical.lua") -- sets.ws.magical
	include("thf/ws-multihit.lua") -- sets.ws.multihit

	include("thf/precast-accomplice.lua") -- sets.precast.accomplice
	include("thf/precast-despoil.lua") -- sets.precast.despoil
	include("thf/precast-feint.lua") -- sets.precast.feint
	include("thf/precast-flee.lua") -- sets.precast.flee
	include("thf/precast-hide.lua") -- sets.precast.hide
	include("thf/precast-steal.lua") -- sets.precast.steal
	include("thf/precast-waltzes.lua") -- sets.precast.waltzes

	include("thf/midcast-elemental.lua") -- sets.midcast.elemental
	include("thf/midcast-phalanx.lua") -- sets.midcast.phalanx

	include("func/buffactive_conspirator.lua") -- buffactive_conspirator()
	include("func/buffactive_elvorseal.lua") -- buffactive_elvorseal()
	include("func/buffactive_sata.lua") -- buffactive_sata()
	include("func/obi_check.lua") -- obi_check()

	_MAGICAL_WS = T {
		"Aeolian Edge",
		"Cyclone",
		"Gust Slash",
		"Red Lotus Blade",
		"Sanguine Blade",
		"Seraph Blade"
	}

	_MULTI_HIT_WS = T {
		"Dancing Edge",
		"Evisceration",
		"Exenterator"
	}

	_ALL_SLOTS = T {
		"range",
		"ammo",
		"head",
		"body",
		"hands",
		"legs",
		"feet",
		"neck",
		"waist",
		"left_ear",
		"right_ear",
		"left_ring",
		"right_ring",
		"back"
	}

	_IDLE_REGEN = false
	if _IDLE_REGEN then
		sets.idle = set_combine(sets.idle, sets.regen)
	end

	_EMPYREAN_AM = false
	if _EMPYREAN_AM then
		sets.tp = sets.tp.empyreanam
	end

	_TREASURE_HUNTER = "minimal"
	if _TREASURE_HUNTER == "full" then
		sets.tp = set_combine(sets.tp, sets.th)
		sets.ws = set_combine(sets.ws, sets.th)
		sets.ws.magical = set_combine(sets.ws.magical, sets.th)
		sets.midcast.elemental = set_combine(sets.midcast.elemental, sets.th)
	elseif _TREASURE_HUNTER == "minimal" then
		sets.tp = set_combine(sets.tp, sets.th.minimal)
		sets.ws.magical = set_combine(sets.ws.magical, sets.th.minimal)
		sets.midcast.elemental = set_combine(sets.midcast.elemental, sets.th.minimal)
	elseif _TREASURE_HUNTER == "none" then
		-- do nothing
	end

	send_command(macrobook_cmd..porter_cmd..lockstyle_cmd)
	if player.sub_job == "NIN" then
		send_command("wait 1; \
		input /macro set 1;")
	end
end

function sub_job_change(new, old)
	send_command(
		"input /macro book 6; \
	wait 1; \
	input /macro set 2; \
	wait 10; \
	input /lockstyleset 26; \
	gs equip sets.idle"
	)
	if player.sub_job == "NIN" then
		send_command("wait 1; \
		input /macro set 1;")
	end
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
		if _MAGICAL_WS:contains(spell.name) then
			equip(sets.ws.magical)
			obi_check(spell)
		elseif _MULTI_HIT_WS:contains(spell.name) then
			equip(sets.ws.multihit)
		end
		if buffactive_sata() then
			equip(sets.ws.critical)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Accomplice") or
			spell.english:contains("Collaborator")
		then
			equip(sets.precast.accomplice)
		elseif spell.english:contains("Despoil") then
			equip(sets.precast.despoil)
		elseif spell.english:contains("Feint") then
			equip(sets.precast.feint)
		elseif spell.english:contains("Flee") then
			equip(sets.precast.flee)
		elseif spell.english:contains("Hide") then
			equip(sets.precast.hide)
		elseif spell.english:contains("Steal") or spell.english:contains("Mug") then
			equip(sets.precast.steal)
		end
	elseif spell.type == "Waltz" then
		equip(sets.precast.waltzes)
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
	if spell.skill == "Elemental Magic" then
		equip(sets.midcast.elemental)
	elseif spell.english:contains("Phalanx") then
		equip(sets.midcast.phalanx)
	elseif spell.english:contains("Poisonga") or spell.english:contains("Sleepga") then
		equip(sets.th.medium)
	end
end

function aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		equip(sets.tp)
		if spell.english:contains("Conspirator") then
			equip(sets.conspirator)
		elseif buffactive_conspirator() then
			equip(sets.conspirator)
		end
		if buffactive_elvorseal() then
			equip(sets.domain)
		end
		if spell.english:contains("Sneak Attack") or
			spell.english:contains("Trick Attack")
		then
			equip(sets.th)
		elseif buffactive_sata() then
			equip(sets.th)
		end
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
		if buffactive_conspirator() then
			equip(sets.conspirator)
		end
		if buffactive_elvorseal() then
			equip(sets.domain)
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
			elseif player.status == "Idle" then
				equip(sets.idle)
			end
		end
	elseif name == "Mobilization" then
		if not gain then
			equip(sets.domain)
		end
	elseif name == "Elvorseal" then
		if not gain then
			equip(sets.idle)
		end
	end
end
