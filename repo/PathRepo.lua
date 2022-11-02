PathRepo = PathRepo or {}

-- TODO: Xerxis wall.
--Oct  4 15:48:33  Quendraszth tells you, "xpXW =
--                 {"out","e","s","s","u","w","w","w","w","w","s","s","s","s","s","s","e","e","s","s",
--                 "s","s","sw","u","d","ne","e","e","e","d","n","e","e","s","get money from
--all","repair xpweap","repair
--xpweap","pm","n","w","w","s","u","e","e","e","se","u","d","nw","n","n","n","n","e",
--                 "e","n","n","n","n","n","n","ne","sw","w","w","w","w","w","d","n","n","w","mg"}RE
--                 SET"
--Oct  4 15:49:03  Quendraszth tells you, "starts in the advance tower north of town...
--                 fixes whatever you have nicknamed to 'xpweap' and uses 'alias mg sorcerer' or
--                 hatever your guild is"

-- starts down from captain in noob area.
PathRepo.SREENXP = {
    'e','se','pull grate','d','e', 'w', 'u', 'ne', 'nw', 'se', 'd', 'e', 's','n', 'e', 'se', 'e',
    'n', 'w', 's', 'nw', 'w', 'ne', 'ne', 'ne', 'e', 's', 'e',
    'w','n','w','sw','sw','sw','w','u','sw','nw','w'
}

-- Rename this. It must be serrllach? Just delete it?
PathRepo.SXP = {
    'n','e','s','w','u',
    'n','e','s','w','u',
    'n','e','s','w','u',
    'n','e','s','w','d',
    'n','e','s','w','d',
    'n','e','s','w','d',
    'n','e','s','w'
}

-- TODO: Standardize on naming convention for these paths/moves etc. continuePathing needs to conform
PathRepo.TO_PESVINT_FROM_GUILD = {
    -- From Sorc Guild to Wemic
    'd','out','out','w','nw','w','nw','w','n',

    -- From Wemic to Pesvint
    'e','e','e','e',
    'ne','ne','ne','ne','ne','ne',
    'e','e','ne','ne','n','ne','e','se',
    'e','e','e','e','e','e','e','e','e','e','e','d'
}

PathRepo.TO_GUILD_FROM_PESVINT = {
    -- From Pesvint to Wemic
    'u','w','w','w','w','w','w','w','w','w','w','w',
    'nw','w','sw','s','sw','sw','w','w',
    'sw','sw','sw','sw','sw','sw',
    'w','w','w','w',

    -- From Wemic to Guild
    's','e','se','e','se','e','in','in','u'
}

PathRepo.FXP = {
    -- Start at elementals
    'w',
    'n','s',
    'w','n','s',
    'w','w','w','w',
    'e','ne','ne','ne','ne',
    'e',
    's','w','s',
    'n','e','e','e',
    'w','w','n','e',
    -- UUR, probably only for high lvl
    --'u','d',
    'w','n','n',
    'w','e','n',
    'e','e','e','e',
    'w','s','n',
    -- over and down to the cells
    'w','w','w','w','w','d',
    's','n',
    'n','w','w','w',
    's','n','e','s',
    'n','e','s',
    'n','e','e','s',
    'n','e','s',
    'n','e','s',
    --out of cells
    'n','w','w','w','s','u',
    -- start start over
    'e','e',
    's','s','s',
    'w','sw','sw','sw','sw','e','e','e','e','e'

}

PathRepo.LXP = {
    -- south gate, n, then west to west wall, n to north wall, down middle, repeat to north wall then
    -- cut across and down, then circle back to south gate
    'n','w','w','w','w','w',
    'n','n','n','n','n','n','n','n','n','n','n','n','n','n','n','n',
    'e','e','e','e','e','e','e','e','e','e',
    's','s','s','s','s','s','s','s','s','s','s','s','s','s','s','s',
    'w','w','w','w','w','s'
}

PathRepo.XP_PESVINT = {
    'e','e',
    'n','n','n','n','n','n','n',
    'e','e','e','e','e','e','e','e','e','e',
    's','s','s','s','s','s','s','s','s','s','s','s','s','s',
    'w','w','w','w','w','w','w','w','w','w',
    'n','n','n','n','n','n','n',
    'w','w'
}

-- Pesvint West Gate to Lirath South Gate
PathRepo.TO_LIRATH_FROM_PESVINT = {
    -- To Valeris
    'u',
    'w','w','w','w','w','w','w','w','w','w','w',
    'nw','nw','nw','n','n','ne','ne','e','ne','ne','ne',

    -- To cliff face
    'n','n','n','n','n','n','d',

    -- To Stowe
    'n','n','n','n','n','n','n','n',

    -- To Lirath South Gate
    'n','n','n','n','n','n','n','n','n','n','n','n','n'
}

PathRepo.TO_PESVINT_FROM_LIRATH = {
    's','s','s','s','s','s','s','s','s','s','s','s','s',
    's','s','s','s','s','s','s','s',
    'u','s','s','s','s','s','s',
    'sw','sw','sw','w','sw','sw','s','s','se','se','se',
    'e','e','e','e','e','e','e','e','e','e','e',
    'd'
}

-- Lirath south gate to Black Shrine
PathRepo.TO_BLACK_SHRINE_FROM_LIRATH = {
    -- To Lirath East Gate
    'n','e','e','e','e','e','n','n','n','n','n','n','n','n',

    -- To Manetheren Marsh area
    'e','e','e','e','e','e','e','e','se','e','se','e','e','e','e','e','se','e','e','ne','ne','e',
    'se','se','e','e','e','e','e','e',

    -- To Shaman in Marsh
    'ne','n','n','nw','nw','n','n','w','sw','sw','sw','w','nw','nw','sw','w','sw','d','se'
}
