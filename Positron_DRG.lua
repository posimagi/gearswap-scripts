function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    
    include("drg/idle.lua") -- sets.idle
    include("drg/tp.lua") -- sets.tp
    include("drg/ws.lua") -- sets.ws

    include("drg/precast-angon.lua") -- sets.precast.angon
    include("drg/precast-callwyvern.lua") -- sets.precast.callwyvern
    include("drg/precast-spiritlink.lua") -- sets.precast.spiritlink

    send_command(
		"input /macro book 12; \
        input /macro set 9; \
        wait 5; \
        input /lockstyleset 88; \
		gs equip sets.idle"
    )
end

function sub_job_change(new, old)
	send_command(
		"input /macro book 12; \
        input /macro set 9; \
        wait 10; \
        input /lockstyleset 88; \
		gs equip sets.idle"
    )
end

_TH = true

function precast(spell, position)
    if spell.type == "WeaponSkill" then
        equip(sets.ws)
    elseif spell.type == "JobAbility" then
        if spell.english:contains("Jump") then
            equip(sets.tp)
        elseif spell.english:contains("Call Wyvern") then
            equip(sets.precast.callwyvern)
        elseif spell.english:contains("Spirit Link") then
            equip(sets.precast.spiritlink)
        elseif spell.english:contains("Angon") then
            equip(sets.precast.angon)
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
