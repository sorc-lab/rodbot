-- TODO: Eventually, this whole area will hold configurable variables so that each method can
--  consume the config variables, or ignore null ones. This would include trigger messages and xp
--  zone paths. Ideally, this script should work for ANY zone, including the noob zone just by
--  swapping out the config variables.

-- TODO: Weird spacings etc, run full file formatter.

require("HelloWorld")

Xp = Xp or {}

function Xp.tmp()
    HelloWorld.helloWorld()
end

-- TODO: CURRENT_MOVE really should be current move index or something.
Xp.CURRENT_MOVE = 1
Xp.CURRENT_BAG = 1
Xp.POTS_QUAFFED = 0
Xp.PATH_START_TIME = 0
Xp.PATH_END_TIME = 0

-- TODO: Remove these. They are not used.
Xp.INVIS_MODE = false

Xp.CURRENT_PATH = nil
Xp.FLEE_IDX = 1

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
Xp.SREENXP = {
    'e','se','pull grate','d','e', 'w', 'u', 'ne', 'nw', 'se', 'd', 'e', 's','n', 'e', 'se', 'e',
    'n', 'w', 's', 'nw', 'w', 'ne', 'ne', 'ne', 'e', 's', 'e',
    'w','n','w','sw','sw','sw','w','u','sw','nw','w'
}

Xp.SXP = {
    'n','e','s','w','u',
    'n','e','s','w','u',
    'n','e','s','w','u',
    'n','e','s','w','d',
    'n','e','s','w','d',
    'n','e','s','w','d',
    'n','e','s','w'
}

-- TODO: Standardize on naming convention for these paths/moves etc. continuePathing needs to conform
Xp.TO_PESVINT_FROM_GUILD = {
    -- From Sorc Guild to Wemic
    'd','out','out','w','nw','w','nw','w','n',

    -- From Wemic to Pesvint
    'e','e','e','e',
    'ne','ne','ne','ne','ne','ne',
    'e','e','ne','ne','n','ne','e','se',
    'e','e','e','e','e','e','e','e','e','e','e','d'
}

Xp.TO_GUILD_FROM_PESVINT = {
    -- From Pesvint to Wemic
    'u','w','w','w','w','w','w','w','w','w','w','w',
    'nw','w','sw','s','sw','sw','w','w',
    'sw','sw','sw','sw','sw','sw',
    'w','w','w','w',

    -- From Wemic to Guild
    's','e','se','e','se','e','in','in','u'
}

Xp.FXP = {
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

Xp.LXP = {
    -- south gate, n, then west to west wall, n to north wall, down middle, repeat to north wall then
    -- cut across and down, then circle back to south gate
    'n','w','w','w','w','w',
    'n','n','n','n','n','n','n','n','n','n','n','n','n','n','n','n',
    'e','e','e','e','e','e','e','e','e','e',
    's','s','s','s','s','s','s','s','s','s','s','s','s','s','s','s',
    'w','w','w','w','w','s'
}

Xp.PXP = {
    'e','e',
    'n','n','n','n','n','n','n',
    'e','e','e','e','e','e','e','e','e','e',
    's','s','s','s','s','s','s','s','s','s','s','s','s','s',
    'w','w','w','w','w','w','w','w','w','w',
    'n','n','n','n','n','n','n',
    'w','w'
}

-- Pesvint West Gate to Lirath South Gate
Xp.TO_LIRATH_FROM_PESVINT = {
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

Xp.TO_PESVINT_FROM_LIRATH = {
    's','s','s','s','s','s','s','s','s','s','s','s','s',
    's','s','s','s','s','s','s','s',
    'u','s','s','s','s','s','s',
    'sw','sw','sw','w','sw','sw','s','s','se','se','se',
    'e','e','e','e','e','e','e','e','e','e','e',
    'd'
}

-- Lirath south gate to Black Shrine
Xp.TO_BLACK_SHRINE_FROM_LIRATH = {
    -- To Lirath East Gate
    'n','e','e','e','e','e','n','n','n','n','n','n','n','n',

    -- To Manetheren Marsh area
    'e','e','e','e','e','e','e','e','se','e','se','e','e','e','e','e','se','e','e','ne','ne','e',
    'se','se','e','e','e','e','e','e',

    -- To Shaman in Marsh
    'ne','n','n','nw','nw','n','n','w','sw','sw','sw','w','nw','nw','sw','w','sw','d','se'
}

-- TODO: These move functions should take args and become generic. They definitely still need the
--  arrival message with destination label
function Xp.gtop()
  Xp.CURRENT_MOVE = 1

  moveTimer = tempTimer(
    .5,
    function() Xp.continuePath("Pesvint", Xp.TO_PESVINT_FROM_GUILD, false) end,
    true
  )
end

function Xp.ltop()
    Xp.CURRENT_MOVE = 1

    moveTimer = tempTimer(
        .5,
        function() Xp.continuePath("Pesvint", Xp.TO_PESVINT_FROM_LIRATH, false) end,
        true
    )
end

function Xp.ptog()
    Xp.CURRENT_MOVE = 1

    moveTimer = tempTimer(
        .5,
        function() Xp.continuePath("Sorcerer's Guild", Xp.TO_GUILD_FROM_PESVINT, false) end,
        true
    )
end

function Xp.ltobs()
    Xp.CURRENT_MOVE = 1

    moveTimer = tempTimer(
        .5,
        function() Xp.continuePath("Black Shrine", Xp.TO_BLACK_SHRINE_FROM_LIRATH, false) end,
        true
    )
end

function Xp.ptol()
    Xp.CURRENT_MOVE = 1

    moveTimer = tempTimer(
        .5,
        function() Xp.continuePath("Lirath", Xp.TO_LIRATH_FROM_PESVINT, false) end,
        true
    )
end

-- TODO: This func needs a trigger on "What?" And then stop immediately, or even consider send("quit")
function Xp.startPathing(path)
    Xp.PATH_START_TIME = os.time()

    send("cast air steel")
    send("cast shocking grasp")
    send("cast electric field")
    send("cast mystical cloak")

    Xp.CURRENT_MOVE = 1
    Xp.CURRENT_PATH = path
    Xp.startAttackTimer()

    continuePathTrigger = tempTrigger(
        --"Cannot find clockwork soldiers",
        "Cannot find fire giants,ogres,elementals,militia men,ogre-mage",
        --"Cannot find cutpurse",
        --"Cannot find rat,orc,gnomes,duergar,varena,hermit,svirfnebli,troll,warden,priest,prince",
        --"Cannot find militia men",
        --"Cannot find militia men,cutthroats,cutpurses",
        --"Cannot find mock",
        function() Xp.continuePath("Pesvint Path", path, true) end
    )
end

function Xp.stopPathing()
    send("stop")

    if attackTimer then
        disableTimer(attackTimer)
    end

    if continuePathTrigger then
        killTrigger(continuePathTrigger)
    end

    if moveTimer then
        disableTimer(moveTimer)
    end
end

function Xp.startAttackTimer()
    -- TODO: Timer is being set to 4 seconds due to over quaffing Cyans and costing lots of plat.
    -- TODO: You need to figure out how to attack on trigger vs timer and attack every other round
    --  by setting a 2 second tempTimer on each attack.

    -- NOTE: Cyans only last 30 seconds.

    attackTimer = tempTimer(4, Xp.sendAttackCommands, true)
end

function Xp.stopAttackTimer()
  disableTimer(attackTimer)
end

function Xp.sendAttackCommands()
    --send("kill militia men,cutthroats,cutpurses")
    --send("kill cutpurse")
    --send("kill militia men")
    --send("kill mock")

    send("kill fire giants,ogres,elementals,militia men,ogre-mage")
    --send("level rod at fire giants,ogres,elementals,militia men,ogre-mage")
    --send("kill rat,orc,gnomes,duergar,varena,hermit,svirfnebli,troll,warden,priest,prince")
    --send("kill clockwork soldiers")
    --send("cast plasma blast")
    send("cast lightning storm")
    --send("lunge")
end

function Xp.continuePath(destination, moves, rest)
    if Xp.CURRENT_MOVE > #moves then
        Xp.stopPathing()

        Xp.PATH_END_TIME = os.time()

        Xp.CURRENT_MOVE = 1
        cecho("\n<red:yellow>YOU HAVE ARRIVED AT YOUR DESTINATION: "..destination.."\n")

        echo("\nPath started: "..Xp.PATH_START_TIME.."\n")
        echo("\nPath ended: "..Xp.PATH_END_TIME.."\n")
        echo("\nPotions quaffed: "..Xp.POTS_QUAFFED.."\n")

        -- TODO: Figure out how long it takes to run through ~100 potions. Manually set timer to stop.
        -- NOTE: This could evolve into an "evac" timer that will evac once done botting.

        -- TODO: Need to add actual (end - start) / 60 calc to give minutes.
        -- NOTE: Need to produce a calc that takes total Cyans and calcs the minutes + the 5min rest
        --    timers in between and spit out a "time to stop" and manaully plug that into phone timer.

        -- Reset metric capture registers
        Xp.PATH_START_TIME = 0
        Xp.PATH_END_TIME = 0
        Xp.POTS_QUAFFED = 0

        send("hide")
        send("cast invisibility")

        if rest then
            restTimer = tempTimer(
                    250,
                    function()
                        -- TODO: Move this to Xp.CURRENT_PATH
                        Xp.startPathing(Xp.PXP)
                        disableTimer(restTimer)
                    end,
                    true
            )
        end
    else
        send(moves[Xp.CURRENT_MOVE])
        Xp.CURRENT_MOVE = Xp.CURRENT_MOVE + 1
    end
end

-- TODO: Need a potion counter that increments, then shifts to different bag.
-- NOTE: Code should assume each bag is full and main inv is empty.
-- Must copy/paste into perl regex trigger on: regexp: (Gp: )(\d{1,3})
function Xp.drinkCyanPotion()
    hud = line
    hudSplit = string.split(hud, "Gp: ")[2]

    -- TODO: This hudSplit value needs to be captured as global const that explains what it is
    -- NOTE: This is how you quaf on 10s vs 1000s etc. Needs to be 4 to quaf below 1000, and 3 to
    --  quaf below 100
    --substr = string.sub(hudSplit, 1, 3)
    substr = string.sub(hudSplit, 1, 4)

    hasParen = false

    -- If parenthesis detected, then GP must be below 1000
    for k,v in ipairs(string.split(substr, "")) do
        if v == '(' then
            hasParen = true
        else
            hasParen = false
        end
    end

    -- If below 1000, check if we are below 600, if true, quaf potion
    if hasParen then
        cecho("\n<blue:yellow>QUAF POTION\n")

        send("get cyan potion from bags")
        send("drink cyan potion")
        send("put cyan potions in bags")

        Xp.POTS_QUAFFED = Xp.POTS_QUAFFED + 1

        --send("get mana potion from bags")
        --send("drink mana potion")
        --send("put mana potions in bags")
    end
end
