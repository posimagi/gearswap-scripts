_HASTE_0 = 0
_HASTE_30 = 1
_HASTE_CAP = 2

function haste_amount()
    haste_buffs = buffactive['Haste'] or 0
    march_buffs = buffactive['March'] or 0

    if haste_buffs + march_buffs >= 2 then
        return _HASTE_CAP
    elseif haste_buffs + march_buffs == 1 then
        return _HASTE_30
    else
        return _HASTE_0
    end
end