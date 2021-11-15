function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    
    include("all/precast-utsusemi.lua") -- sets.precast.utsusemi
    
    include("drg/fastcast.lua") -- sets.fastcast
    include("drg/idle.lua") -- sets.idle
    include("drg/tp.lua") -- sets.tp
    include("drg/ws.lua") -- sets.ws
    include("drg/ws-singlehit.lua") -- sets.ws.singlehit

    include("drg/precast-angon.lua") -- sets.precast.angon
    include("drg/precast-callwyvern.lua") -- sets.precast.callwyvern
    include("drg/precast-jump.lua") -- sets.precast.jump
    include("drg/precast-spiritlink.lua") -- sets.precast.spiritlink

    _SINGLE_HIT_WS = T{
        "Raiden Thrust",
        "Sonic Thrust",
        "Camlann's Torment",
        "Savage Blade",
    }

    send_command(
		"input /macro book 12; \
        wait 1; \
        input /macro set 9; \
        wait 5; \
        input /lockstyleset 34; \
		gs equip sets.idle"
    )
end

function sub_job_change(new, old)
	send_command(
		"wait 10; \
        input /lockstyleset 34; \
		gs equip sets.idle; \
		du blinking self all off;"
    )
end

_TH = true

function precast(spell, position)
	-- WS Engaged Check
	if
			spell.type == "WeaponSkill" and
			player.status ~= "Engaged" then
		cancel_spell()
		return
	end

	-- WS Distance Check
	_RANGE_MULTIPLIER = 1.642276421172564
	if 
			spell.type == "WeaponSkill" and
			spell.target.distance > (spell.range * _RANGE_MULTIPLIER + spell.target.model_size) then
		add_to_chat(8, spell.name.." aborted due to target out of range.")
		cancel_spell()
		return
	end

    if spell.type == "WeaponSkill" then
        equip(sets.ws)
        if _SINGLE_HIT_WS:contains(spell.name) then
			equip(sets.ws.singlehit)
        end
    elseif spell.type == "JobAbility" then
        if spell.english:contains("Jump") then
            equip(sets.tp, sets.precast.jump)
        elseif spell.english:contains("Call Wyvern") then
            equip(sets.precast.callwyvern)
        elseif spell.english:contains("Spirit Link") then
            equip(sets.precast.spiritlink)
        elseif spell.english:contains("Angon") then
            equip(sets.precast.angon)
        end
    else
        equip(sets.fastcast)
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
    end
end

function status_change(new, old)
    if new == "Engaged" then
        equip(sets.tp)
        if _TH then
			equip(sets.th)
        end
        
    elseif new == "Idle" then
        equip(sets.idle)
    end
end
