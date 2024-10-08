function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("all/dispelga.lua") -- sets.dispelga
	include("all/impact.lua") -- sets.impact
	include("all/midcast-aquaveil.lua") -- sets.midcast.aquaveil
	include("all/obi.lua") -- sets.obi
	include("all/orpheus.lua") -- sets.orpheus
	include("all/quickmagic.lua") -- sets.quickmagic
	include("all/th.lua") -- sets.th

	include("all/precast-enhancing.lua") -- sets.precast.enhancing
	include("all/precast-stoneskin.lua") -- sets.precast.stoneskin
	include("all/precast-utsusemi.lua") -- sets.precast.utsusemi

	include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

	include("rdm/enspell.lua") -- sets.enspell
	include("rdm/fastcast.lua") -- sets.fastcast
	include("rdm/idle.lua") -- sets.idle
	include("rdm/level60.lua") -- sets.level60
	include("rdm/naked.lua") -- sets.naked
	include("rdm/tp.lua") -- sets.tp
	include("rdm/weapon.lua") -- sets.weapon
	include("rdm/weapon-aeolianedge.lua") -- sets.weapon.aeolianedge
	include("rdm/weapon-blackhalo.lua") -- sets.weapon.blackhalo
	include("rdm/weapon-caliburnus.lua") -- sets.weapon.caliburnus
	include("rdm/weapon-cure.lua") -- sets.weapon.cure
	include("rdm/weapon-enspell.lua") -- sets.weapon.enspell
	include("rdm/weapon-evisceration.lua") -- sets.weapon.evisceration
	include("rdm/weapon-mpugandring.lua") -- sets.weapon.mpugandring
	include("rdm/weapon-sanguineblade.lua") -- sets.weapon.sanguineblade
	include("rdm/weapon-savageblade.lua") -- sets.weapon.savageblade
	include("rdm/weapon-seraphblade.lua") -- sets.weapon.seraphblade
	include("rdm/ws.lua") -- sets.ws
	include("rdm/ws-dark.lua") -- sets.ws.dark
	include("rdm/ws-magical.lua") -- sets.ws.magical
	include("rdm/ws-multihit.lua") -- sets.ws.multihit

	include("rdm/precast-chainspell.lua") -- sets.precast.chainspell
	include("rdm/precast-enfeebling.lua") -- sets.precast.enfeebling
	include("rdm/precast-healing.lua") -- sets.precast.healing
	include("rdm/precast-ra.lua") -- sets.precast.ra

	include("rdm/midcast-barspell.lua") -- sets.midcast.barspell
	include("rdm/midcast-barstatus.lua") -- sets.midcast.barstatus
	include("rdm/midcast-curecheat.lua") -- sets.midcast.curecheat
	include("rdm/midcast-cursna.lua") -- sets.midcast.cursna
	include("rdm/midcast-darkmagic.lua") -- sets.midcast.darkmagic
	include("rdm/midcast-elemental.lua") -- sets.midcast.elemental
	include("rdm/midcast-enfeeblingaccuracy.lua") -- sets.midcast.enfeeblingaccuracy
	include("rdm/midcast-enfeeblingpotency.lua") -- sets.midcast.enfeeblingpotency
	include("rdm/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("rdm/midcast-enhancingself.lua") -- sets.midcast.enhancingself
	include("rdm/midcast-enhancingskill.lua") -- sets.midcast.enhancingskill
	include("rdm/midcast-gain.lua") -- sets.midcast.gain
	include("rdm/midcast-healing.lua") -- sets.midcast.healing
	include("rdm/midcast-phalanx.lua") -- sets.midcast.phalanx
	include("rdm/midcast-ra.lua") -- sets.midcast.ra
	include("rdm/midcast-refresh.lua") -- sets.midcast.refresh
	include("rdm/midcast-regen.lua") -- sets.midcast.regen

	include("func/buffactive_enspell.lua") -- buffactive_enspell()
	include("func/haste_amount.lua") -- haste_amount()
	include("func/obi_check.lua") -- obi_check()

	_VARIABLE_POTENCY = T {
		"Addle",
		"Addle II",
		"Blind",
		"Blind II",
		"Distract",
		"Distract II",
		"Distract III",
		"Frazzle",
		"Frazzle II",
		"Frazzle III",
		"Gravity",
		"Gravity II",
		"Paralyze",
		"Paralyze II",
		"Poison",
		"Poison II",
		"Poisonga",
		"Slow",
		"Slow II"
	}

	_DARK_WS = T {
		"Sanguine Blade"
	}

	_MAGICAL_WS = T {
		"Aeolian Edge",
		"Red Lotus Blade",
		"Seraph Blade"
	}

	_MULTI_HIT_WS = T {
		"Chant du Cygne",
		"Death Blossom",
		"Evisceration",
		"Requiescat",
		"Vorpal Blade",
	}

	_BARSTATUS_SPELLS = T {
		"Baramnesia",
		"Baramnesra",
		"Barvirus",
		"Barvira",
		"Barparalyze",
		"Barparalyzra",
		"Barsilence",
		"Barsilencera",
		"Barpetrify",
		"Barpetra",
		"Barpoison",
		"Barpoisonra",
		"Barblind",
		"Barblindra",
		"Barsleep",
		"Barsleepra"
	}

	_AMINON = false
	if _AMINON then
		include("rdm/aminon/impact.lua") -- sets.impact
		include("rdm/aminon/ws.lua") -- sets.ws
	end

	_ONGO = false
	if _ONGO then
		include("rdm/ongo/tp.lua") -- sets.tp
	end

	_SEALED_FATE = false
	if _SEALED_FATE then
		include("rdm/sealed-fate/tp.lua") -- sets.tp
		-- sets.enspell = sets.tp
	end

	send_command(macrobook_cmd..porter_cmd..lockstyle_cmd)
end

function sub_job_change(new, old)
	send_command("wait 10; \
	input /lockstyleset 25; \
	gs equip sets.idle")
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

	if spell.type == "Scholar" then
		return
	elseif spell.type == "WeaponSkill" then
		equip(sets.ws)
		if _DARK_WS:contains(spell.name) then
			equip(sets.ws.magical, sets.ws.dark)
			obi_check(spell)
		elseif _MAGICAL_WS:contains(spell.name) then
			equip(sets.ws.magical)
			equip(sets.orpheus)
			-- obi_check(spell)
		elseif _MULTI_HIT_WS:contains(spell.name) then
			equip(sets.ws.multihit)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Chainspell") then
			equip(sets.precast.chainspell)
		end
	elseif spell.action_type == "Ranged Attack" then
		equip(sets.precast.ra)
	else
		equip(sets.quickmagic, sets.fastcast)
		if spell.skill == "Enfeebling Magic" then
			equip(sets.precast.enfeebling)
			if spell.english:contains("Dispelga") then
				_PREVIOUS_WEAPONS = T {
					main = player.equipment.main
				}
				equip(sets.dispelga)
			end
		elseif spell.skill == "Enhancing Magic" then
			equip(sets.precast.enhancing)
			if spell.english:contains("Stoneskin") then
				equip(sets.precast.stoneskin)
			end
		elseif spell.skill == "Elemental Magic" then
			if spell.english:contains("Impact") then
				equip(sets.impact)
			end
		elseif spell.skill == "Healing Magic" then
			equip(sets.precast.healing)
		end
	end
end

function midcast(spell)
	if spell.type == "Scholar" then
		return
	elseif spell.skill == "Enfeebling Magic" then
		if spell.english:contains("Dia") or spell.english:contains("Inundation") then
			equip(sets.th)
		elseif _VARIABLE_POTENCY:contains(spell.name) then
			equip(sets.midcast.enfeeblingpotency)
		else
			equip(sets.midcast.enfeeblingaccuracy)
		end
	elseif spell.skill == "Enhancing Magic" then
		equip(sets.midcast.enhancing)
		if spell.target.type == "SELF" then
			equip(sets.midcast.enhancingself)
		end
		if spell.english:contains("Aquaveil") then
			equip(sets.midcast.aquaveil)
		elseif spell.english:contains("Bar") then
			equip(sets.midcast.barspell)
			if _BARSTATUS_SPELLS:contains(spell.english) then
				equip(sets.midcast.barstatus)
			end
		elseif spell.english:contains("En") then
			equip(sets.midcast.enhancingskill)
		elseif spell.english:contains("Gain") then
			equip(sets.midcast.gain)
		elseif spell.english:contains("Phalanx") then
			if spell.target.type == "SELF" then
				equip(sets.midcast.phalanx)
			end
		elseif spell.english:contains("Refresh") then
				equip(sets.midcast.refresh)
		elseif spell.english:contains("Regen") then
				equip(sets.midcast.regen)
		elseif spell.english:contains("Stoneskin") then
			equip(sets.midcast.stoneskin)
		elseif spell.english:contains("Temper") then
			equip(sets.midcast.enhancingskill)
		end
	elseif spell.skill == "Dark Magic" then
		equip(sets.midcast.darkmagic)
		if spell.english:contains("Bio") then
			equip(sets.th)
		end
		obi_check(spell)
	elseif spell.skill == "Healing Magic" then
		equip(sets.midcast.healing)
		obi_check(spell)
		if spell.name:contains("Cursna") then
			equip(sets.midcast.cursna)
		end
	elseif spell.skill == "Elemental Magic" then
		equip(sets.midcast.elemental)
		if spell.english:contains("Impact") then
			equip(sets.impact)
		end
		obi_check(spell)
	elseif spell.type == "Ninjutsu" then
		if spell.english:contains("Utsusemi") then
			equip(sets.precast.utsusemi)
		end
	elseif spell.action_type == "Ranged Attack" then
		equip(sets.midcast.ra)
	end
end

function aftercast(spell)
	if spell.type == "Scholar" then
		return
	elseif spell.action_type == "Ranged Attack" then
		equip(sets.idle, sets.precast.ra)
	elseif player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		equip(sets.tp)
		if buffactive_enspell() then
			equip(sets.enspell)
		end
	end
	if spell.english:contains("Dispelga") then
		equip(_PREVIOUS_WEAPONS)
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
