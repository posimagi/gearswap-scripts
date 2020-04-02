function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}

    include("all/th.lua") -- sets.th

    include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

    include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

    include("geo/idle.lua") -- sets.idle
    include("geo/fastcast.lua") -- sets.fastcast

    include("geo/precast-bolster.lua") -- sets.precast.bolster

    -- include('geo/midcast-enhancing.lua') -- sets.midcast.enhancing
    -- include('geo/midcast-enfeebling.lua') -- sets.midcast.enfeebling
    include("geo/midcast-geocolure.lua") -- sets.midcast.geocolure
    include("geo/midcast-geomancy.lua") -- sets.midcast.geomancy
    -- include('geo/midcast-healing.lua') -- sets.midcast.healing
    include("geo/midcast-indicolure.lua") -- sets.midcast.indicolure
    include("geo/midcast-mb.lua") -- sets.midcast.mb

    send_command(
        "wait 5; \
        input /macro book 10; \
        input /macro set 10; \
        input /lockstyleset 51; \
        gs equip sets.idle"
    )
end

function precast(spell, position)
    equip(sets.fastcast)
    if spell.english:contains("Bolster") then
        equip(sets.precast.bolster)
    end
end

function midcast(spell)
    if spell.skill == "Geomancy" then
        equip(sets.midcast.geomancy)
        if spell.english:contains("Indi-") then
            equip(sets.midcast.indicolure)
        elseif spell.english:contains("Geo-") then
            equip(sets.midcast.geocolure)
        end
    elseif spell.skill == "Enfeebling Magic" then
        equip(sets.midcast.enfeebling)
        if spell.english:contains("Dia") then
            equip(sets.th)
        end
    elseif spell.skill == "Enhancing Magic" then
        equip(sets.midcast.enhancing)
        if spell.english:contains("Stoneskin") then
            equip(sets.midcast.stoneskin)
        end
    elseif spell.skill == "Healing Magic" then
        equip(sets.midcast.healing)
    elseif spell.skill == "Elemental Magic" then
        equip(sets.midcast.mb)
    elseif spell.skill == "Dark Magic" then
        if spell.english:contains("Bio") then
            equip(sets.th)
        end
    end
end

function aftercast(spell)
    equip(sets.idle)
end

function status_change(new, old)
end
