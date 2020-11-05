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
	include("rdm/tp-hybrid.lua") -- sets.tp.hybrid
	include("rdm/ws.lua") -- sets.ws
	include("rdm/ws-dark.lua") -- sets.ws.dark
	include("rdm/ws-magical.lua") -- sets.ws.magical

	include("rdm/precast-chainspell.lua") -- sets.precast.chainspell
	include("rdm/precast-enfeebling.lua") -- sets.precast.enfeebling

	include("rdm/midcast-aquaveil.lua") -- sets.midcast.aquaveil
	include("rdm/midcast-barspell.lua") -- sets.midcast.barspell
	include("rdm/midcast-cursna.lua") -- sets.midcast.cursna
	include("rdm/midcast-enfeeblingaccuracy.lua") -- sets.midcast.enfeeblingaccuracy
	include("rdm/midcast-enfeeblingpotency.lua") -- sets.midcast.enfeeblingpotency
	include("rdm/midcast-enhancing.lua") -- sets.midcast.enhancing
	include("rdm/midcast-enhancingself.lua") -- sets.midcast.enhancingself
	include("rdm/midcast-enhancingskill.lua") -- sets.midcast.enhancingskill
	include("rdm/midcast-healing.lua") -- sets.midcast.healing
	include("rdm/midcast-mb.lua") -- sets.midcast.mb
	include("rdm/midcast-phalanx.lua") -- sets.midcast.phalanx
	include("rdm/midcast-refresh.lua") -- sets.midcast.refresh

	include("func/buffactive_enspell.lua") -- buffactive_enspell()

	_VARIABLE_POTENCY = T{
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
		"Paralyze",
		"Paralyze II",
		"Poison",
		"Poison II",
		"Poisonga",
		"Slow",
		"Slow II"
	}
	
	_MAGICAL_WS = T{
		"Aeolian Edge",
		"Red Lotus Blade",
		"Seraph Blade",
	}

	_DARK_WS = T{
		"Sanguine Blade",
	}

	_ODIN = false
	if _ODIN then
		include("rdm/odin/idle.lua") -- sets.idle
		include("rdm/odin/enspell.lua") -- sets.enspell
		include("rdm/odin/tp.lua") -- sets.tp
		include("rdm/odin/midcast-enfeebling.lua") -- sets.midcast.enfeebling
		include("rdm/odin/midcast-enhancing.lua") -- sets.midcast.enhancing
		include("rdm/odin/midcast-healing.lua") -- sets.midcast.healing
	end

	_LILITH = false
	if _LILITH then
		include("rdm/lilith/tp.lua") -- sets.tp
		sets.enspell = sets.tp
	end
	
	_SEALED_FATE = false
	if _SEALED_FATE then
		include("rdm/sealed-fate/tp-damage.lua") -- sets.tp
		-- include("rdm/sealed-fate/tp-accuracy.lua") -- sets.tp
		sets.enspell = sets.tp
	end

	_HYBRID = false
	if _HYBRID then
		sets.idle = sets.idle.hybrid
		sets.tp = sets.tp.hybrid
	end

	send_command(
		"input /macro book 5; \
		input /macro set 1; \
		wait 5; \
		input /lockstyleset 40; \
		gs equip sets.idle"
	)
end

function sub_job_change(new, old)
	send_command(
		"input /macro book 5; \
		input /macro set 1; \
		wait 10;\
		input /lockstyleset 40; \
		gs equip sets.idle"
	)
end

function precast(spell, position)
	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if _DARK_WS:contains(spell.name) then
			equip(sets.ws.dark)
		elseif _MAGICAL_WS:contains(spell.name) then
			equip(sets.ws.magical)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Chainspell") then
			equip(sets.precast.chainspell)
		end
	else
		equip(sets.fastcast)
		if spell.skill == "Enfeebling Magic" then
			equip(sets.precast.enfeebling)
		elseif spell.skill == "Enhancing Magic" then
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
		if _VARIABLE_POTENCY:contains(spell.name) then
			equip(sets.midcast.enfeeblingpotency)
		else
			equip(sets.midcast.enfeeblingaccuracy)
		end
		if spell.english:contains("Dia") then
			equip(sets.th)
		end
	elseif spell.skill == "Enhancing Magic" then
		equip(sets.midcast.enhancing)
		if spell.target.type == "SELF" then
			equip(sets.midcast.enhancingself)
		end
		if spell.english:contains("Refresh") then
			equip(sets.midcast.refresh)
		elseif spell.english:contains("Aquaveil") then
			equip(sets.midcast.enhancingskill, sets.midcast.aquaveil)
		elseif spell.english:contains("Bar") then
			equip(sets.midcast.enhancingskill, sets.midcast.barspell)
		elseif spell.english:contains("En") then
			equip(sets.midcast.enhancingskill)
		elseif spell.english:contains("Gain") then
			equip(sets.midcast.enhancingskill)
		elseif spell.english:contains("Phalanx") then
			equip(sets.midcast.enhancingskill)
			if spell.target.type == "SELF" then
				equip(sets.midcast.phalanx)
			end
		elseif spell.english:contains("Stoneskin") then
			equip(sets.midcast.stoneskin)
		elseif spell.english:contains("Temper") then
			equip(sets.midcast.enhancingskill)
		end
	elseif spell.skill == "Dark Magic" then
		equip(sets.midcast.enfeebling)
		if spell.english:contains("Bio") then
			equip(sets.th)
		end
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
