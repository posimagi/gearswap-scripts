MACROBOOK = {
    WAR = 1,
    MNK = 2,
    WHM = 3,
    BLM = 4,
    RDM = 5,
    THF = 6,
    PLD = 7,
    DRK = 8,
    BST = 9,
    BRD = 10,
    RNG = 11,
    SAM = 12,
    DRG = 12,
    NIN = 13,
    SMN = 15,
    BLU = 16,
    COR = 11,
    PUP = 2,
    DNC = 6,
    SCH = 20,
    GEO = 10,
    RUN = 7,
}

MACROSET = {
    MNK = 2,
    THF = 2,
    RNG = 2,
    DRG = 9,
    COR = 10,
    PUP  = 10,
    DNC = 10,
    GEO = 10,
    RUN = 10,
}

LOCKSTYLE = player.main_job_id + 20

DRESSUP = {
    BRD = "self combat on",
    NIN = "self combat on",
}

macrobook_cmd = string.format("wait 2; input /macro book %s; wait 1; input /macro set %s;", tonumber(MACROBOOK[player.main_job] or player.main_job_id), tonumber(MACROSET[player.main_job] or 1))
lockstyle_cmd = string.format("input /lockstyleset %s; gs equip sets.idle; du blinking %s;", tonumber(LOCKSTYLE or 200), tostring(DRESSUP[player.main_job] or "self all off"))
porter_cmd = string.format("lua l enternity; po repack; wait 15; lua u enternity;")