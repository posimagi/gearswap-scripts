function get_sets()
	sets = {}
	sets.midcast = {}
	sets.aftercast = {}
    
    include('geo/idle.lua')                         -- sets.idle
    include('all-th.lua')					        -- sets.th

    -- include('geo-fastcast.lua')                      -- sets.fastcast

    -- include('geo/midcast-enfeebling.lua')           -- sets.midcast.enfeebling
    -- include('geo/midcast-enhancing.lua')            -- sets.midcast.enhancing
    -- include('geo/midcast-healing.lua')              -- sets.midcast.healing
    include('geo/midcast-geomancy.lua')             -- sets.midcast.geomancy
    include('geo/midcast-indicolure.lua')           -- sets.midcast.indicolure
    include('geo/midcast-geocolure.lua')            -- sets.midcast.geocolure
	include('geo/midcast-mb.lua')                   -- sets.midcast.mb

	include('all-stoneskin.lua')			  -- sets.stoneskin

	send_command('wait 5; input /lockstyleset 51; gs equip sets.idle') -- lockstyle
end

function precast(spell,position)
	equip(sets.fastcast)
end

function midcast(spell)
    if spell.skill == 'Geomancy' then
        equip(sets.midcast.geomancy)
        if spell.english:contains('Indi-') then
            equip(sets.midcast.indicolure)
        elseif spell.english:contains('Geo-') then
            equip(sets.midcast.geocolure)
        end
    elseif spell.skill == 'Enfeebling Magic' then
        equip(sets.midcast.enfeebling)
		if spell.english:contains('Dia') then
            equip(sets.th)
		end
    elseif spell.skill == 'Enhancing Magic' then
        equip(sets.midcast.enhancing)
        if spell.english:contains('Stoneskin') then
            equip(sets.stoneskin)
        end
	elseif spell.skill == 'Healing Magic' then
        equip(sets.midcast.healing)
    elseif spell.skill == 'Elemental Magic' then
		equip(sets.midcast.mb)
	elseif spell.skill == 'Dark Magic' then
		if spell.english:contains('Bio') then
			equip(sets.th)
		end
	end
end

function aftercast(spell)
	equip(sets.idle)
end

function status_change(new,old)

end