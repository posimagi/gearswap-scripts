function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    
    include("all/doom.lua") -- sets.doom

    include("war/fastcast.lua") -- sets.fastcast
    include("war/idle.lua") -- sets.idle
    include("war/th.lua") -- sets.th
    include("war/tp.lua") -- sets.tp
    include("war/ws.lua") -- sets.ws

    include("war/precast-aggressor.lua") -- sets.precast.aggressor
    include("war/precast-berserk.lua") -- sets.precast.berserk
    include("war/precast-bloodrage.lua") -- sets.precast.bloodrage
    include("war/precast-tomahawk.lua") -- sets.precast.tomahawk
    include("war/precast-warcry.lua") -- sets.precast.warcry

    send_command(
		"input /macro book 1; \
        input /macro set 1; \
        wait 5; \
        input /lockstyleset 93; \
		gs equip sets.idle"
	)
end

_TH = false

function precast(spell, position)
    if spell.type == "WeaponSkill" then
        equip(sets.ws)
    elseif spell.type == "JobAbility" then
        if spell.english:contains("Aggressor") then
            equip(sets.precast.aggressor)
        elseif spell.english:contains("Berserk") then
            equip(sets.precast.berserk)
        elseif spell.english:contains("Blood Rage") then
            equip(sets.precast.bloodrage)
        elseif spell.english:contains("Tomahawk") then
            equip(sets.precast.tomahawk)
        elseif spell.english:contains("Warcry") then
            equip(sets.precast.warcry)
        end
    else
        equip(sets.idle, sets.fastcast)
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

function buff_change(name, gain, buff_details)
    if name == "Doom" then
        if gain then
            equip(sets.doom)
            disable("neck", "left_ring")
        else
            enable("neck", "left_ring")
        end
    end
end

function status_change(new, old)
    if world.zone:contains("Abyssea") then
        disable("head", "neck", "waist")
    else
        enable("head", "neck", "waist")
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
