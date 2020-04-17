function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    
    include("war/idle.lua") -- sets.idle
    include("war/th.lua") -- sets.th
    include("war/tp.lua") -- sets.tp
    include("war/ws.lua") -- sets.ws

    send_command(
		"wait 5; \
		input /macro book 1; \
        input /macro set 2; \
        gs equip sets.ws; \
        wait 1; \
        input /lockstyle on; \
        wait 1; \
		gs equip sets.idle"
	)
end

_TH = true

function precast(spell, position)
    if spell.type == "WeaponSkill" then
        equip(sets.ws)
    elseif spell.type == "JobAbility" then
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
    end
end

function status_change(new, old)
    if world.zone:contains("Abyssea") then
        disable("head", "neck", "waist")
    end
    if new == "Engaged" then
        equip(sets.tp)
        if _TH then
			equip(sets.th)
        end
        
    elseif new == "Idle" then
        equip(sets.idle)
    end
end