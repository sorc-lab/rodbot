-- TODO: Eventually, this whole area will hold configurable variables so that each method can
--  consume the config variables, or ignore null ones. This would include trigger messages and xp
--  zone paths. Ideally, this script should work for ANY zone, including the noob zone just by
--  swapping out the config variables.

-- TODO: Weird spacings etc, run full file formatter.

Xp = Xp or {}

-- TODO: CURRENT_MOVE really should be current move index or something.
Xp.CURRENT_MOVE = 1
Xp.CURRENT_BAG = 1

Xp.CURRENT_PATH = nil
Xp.FLEE_IDX = 1

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

Xp.LIRATH_XP = {
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
    function() Xp.continuePath("Pesvint", Xp.TO_PESVINT_FROM_GUILD) end,
    true
  )
end

function Xp.ltop()
    Xp.CURRENT_MOVE = 1

    moveTimer = tempTimer(
        .5,
        function() Xp.continuePath("Pesvint", Xp.TO_PESVINT_FROM_LIRATH) end,
        true
    )
end

function Xp.fleeFromLirathToPesvint()
    echo("\nAre we fleeing to Pesvint?\n")
    Xp.CURRENT_MOVE = 1

    moveTimer = tempTimer(
            .5,
            function() Xp.continuePath("FLEE TO GUILD", Xp.TO_PESVINT_FROM_LIRATH) end,
            true
    )
end

function Xp.ptog()
    Xp.CURRENT_MOVE = 1

    moveTimer = tempTimer(
        .5,
        function() Xp.continuePath("Sorcerer's Guild", Xp.TO_GUILD_FROM_PESVINT) end,
        true
    )
end

function Xp.fleeFromPesvintToGuild()
    Xp.CURRENT_MOVE = 1

    moveTimer = tempTimer(
            .5,
            function() Xp.continuePath("Sorcerer's Guild", Xp.TO_GUILD_FROM_PESVINT) end,
            true
    )
end

function Xp.ltobs()
    Xp.CURRENT_MOVE = 1

    moveTimer = tempTimer(
        .5,
        function() Xp.continuePath("Black Shrine", Xp.TO_BLACK_SHRINE_FROM_LIRATH) end,
        true
    )
end

function Xp.ptol()
    Xp.CURRENT_MOVE = 1

    moveTimer = tempTimer(
        .5,
        function() Xp.continuePath("Lirath", Xp.TO_LIRATH_FROM_PESVINT) end,
        true
    )
end

local function arraySlice (tbl, s, e)
    local pos, new = 1, {}

    for i = s, e do
        new[pos] = tbl[i]
        pos = pos + 1
    end

    return new
end

function Xp.flee()
    if Xp.CURRENT_MOVE > 1 then
        Xp.stopPathing()
        send("stop")

        -- Slices a new array starting with current position in current path.
        local fleeMoves = arraySlice(Xp.CURRENT_PATH, Xp.CURRENT_MOVE, #Xp.CURRENT_PATH)

        -- TODO: Note that I have to make my own continuePath func here b/c continue path uese global state
        --  Need to make it so all these functions take in their needed values, not globals.
        fleeTimer = tempTimer(
                .5,
                function() Xp.continueFleeing("Sorcerer's Guild", fleeMoves) end,
                true
        )
    end
end

-- TODO: *** THESE TRIGGERS ARE NOT TRIGGERING ***
function Xp.initFleeTriggers()
    fleeToPesvintTrigger = tempTrigger(
            "FLEE TO PESVINT!",
            function()
                echo("\nAre we triggering to flee to Pesvint?\n")
                Xp.fleeFromLirathToPesvint()
            end
    )

    fleeToGuildTrigger = tempTrigger(
            "YOU HAVE ARRIVED AT YOUR DESTINATION: FLEE TO GUILD",
            function() Xp.fleeFromPesvintToGuild() end
    )

  -- TODO: *** START MOVING THESE NOTES OFF TO A REGEN FUNCTION ***
    -- TODO: ADD A REGEN JUST TO SIT FOR 5 mins to let zone re-pop
  -- TODO: Add each flee trigger here as separate trigger, but have them all trigger same function
  -- TODO: Once bot reaches flee destination, have it init a new timer and triggers that will do the following
  --        1. set timer to check 'l me' every 60 secs
  --        2. Set triggers that check output of 'l me' to see if buffs missing
  --        3. Set global bot state that sets each buff register to true/false
  --        4. Set a separate trigger that has regexp trigger on 'HP:  <val>' and have it run the same flee func
  --        5. The flee func will exec the regen func
  --        6. The regen func sets the timer to 'l me' and react and check bot state
  --        7. Once bot state is 100% hp and all buffs reset, exec a return to combat func
  --        8. returnToCombat moves the bot back to starting point and re-execs the startPathing func.
  --
  --        NOTE: The flee trigger needs to execute the movement commands on a timer that is 1 sec,
  --          per command, or less. See what the threshold is
  --        NOTE: Before you start working on these items, create a private repo and make a branch for each one.
  --        NOTE: Don't use 'grasp key', for now, just run back to the sorc guild.
end

-- TODO: This func needs a trigger on "What?" And then stop immediately, or even consider send("quit")
function Xp.startPathing(path)
    Xp.CURRENT_MOVE = 1
    Xp.CURRENT_PATH = path
    Xp.startAttackTimer()

    continuePathTrigger = tempTrigger(
        --"Cannot find clockwork soldiers",
        "Cannot find fire giants,ogres,elementals,militia men,ogre-mage",
        --"Cannot find militia man,cutthroat,cutpurse",
        --"Cannot find mock",
        function() Xp.continuePath("Pesvint Path", path) end
    )

    -- TODO: Does this do anything? Make sure it still works.
    --reInitPathingTrigger = tempTrigger(
    --    "YOU HAVE ARRIVED AT YOUR DESTINATION: Pesvint Path",
    --    function()
    --        pausePathingTimer = tempTimer(
    --            300,
    --            function()
    --                echo("\nIs the reInit path working?\n")
    --
    --                -- TODO: Not sure if these are needed here.
    --                killTrigger(continuePathTrigger)
    --                killTrigger(reInitPathingTrigger)
    --                Xp.continuePath("Pesvint Path", path)
    --            end
    --        )
    --    end
    --)

    -- The hardened air around you is beginning to soften
    -- Your Electric Field Spell Expires
    -- Cannot find militia man,conscript,citizen
    -- The hardened air around you softens
    -- You are currently too mentally drained to cast Electric Field
    -- You are currently too mentally drained to cast Air Steel
    -- Your hands have lost their electrical energy.

    -- *********************************************************************************************
    -- BUG: For some reason, when one trigger goes off, all three go off. Keep just one for now
    -- *********************************************************************************************

    -- TODO: You may not be able to set multiple tempTriggers, see if you can use another way.
    --airSteelDropTrigger = tempTrigger(
    --        "The hardened air around you softens",
    --        function() Xp.flee() end
    --)

    --electricFieldDropTrigger = tempTrigger(
    --        "Your Electric Field Spell Expires",
    --        function() Xp.flee() end
    --)
    --
    --shockingGraspDropTrigger = tempTrigger(
    --        "Your hands have lost their electrical energy",
    --        function() Xp.flee() end
    --)
end

function Xp.stopPathing()
    if attackTimer then
        disableTimer(attackTimer)
    end

    if continuePathTrigger then
        killTrigger(continuePathTrigger)
    end

    --killTrigger(reInitPathingTrigger)
end

function Xp.startAttackTimer()
    attackTimer = tempTimer(2, Xp.sendAttackCommands, true)
end

function Xp.stopAttackTimer()
  disableTimer(attackTimer)
end

function Xp.sendAttackCommands()
    --send("kill militia man,cutthroat,cutpurse")
    --send("kill militia men")
    --send("kill mock")

    send("kill fire giants,ogres,elementals,militia men,ogre-mage")
    --send("kill clockwork soldiers")
    --send("cast plasma blast")
    send("cast lightning storm")
end

function Xp.continuePath(destination, moves)
  if Xp.CURRENT_MOVE > #moves then
      echo("\nAttempting to stop pathing.\n")
      send("stop")
      Xp.stopPathing()
      --disableTimer(attackTimer)
      Xp.CURRENT_MOVE = 1
      cecho("\n<red:yellow>YOU HAVE ARRIVED AT YOUR DESTINATION: "..destination.."\n")

      restTimer = tempTimer(
              300,
              function()
                  Xp.startPathing(Xp.FXP)
                  disableTimer(restTimer)
              end,
              true
      )
  else
    send(moves[Xp.CURRENT_MOVE])
    Xp.CURRENT_MOVE = Xp.CURRENT_MOVE + 1
  end
end

-- TODO: See this method and one above. They should work more generically.
-- TODO: This method needs be handed the next index. It cannot increment within, else use global.
function Xp.continueFleeing(destination, moves)
    if Xp.FLEE_IDX > #moves then
        Xp.FLEE_IDX = 1
        disableTimer(fleeTimer)
        send("stop")

        cecho("\n<red:yellow>FLEE TO PESVINT!\n")
    else
        --echo("\nFleeing: "..moves[Xp.FLEE_IDX].."\n")
        send(moves[Xp.FLEE_IDX])
        Xp.FLEE_IDX = Xp.FLEE_IDX + 1
    end
end

-- TODOs:
--  1. Fix path, it is getting stuck in King's room. Verify the path manually.
--  2. Run bot until all bag1 pots are gone
--  3. Test the bagMissTrigger. It should start grabbing pots from bag2 and setting global currBag
--  4. Run bot until all bag2 pots are gone.
--  5. Write the invis mode code and test with both bags empty.
function Xp.drinkCyanPotion()
    hud = line
    hudSplit = string.split(hud, "Gp: ")[2]

    substr = string.sub(hudSplit, 1, 4)
    hasParen = false

    -- If parenthesis detected, then GP must be below 1000
    for k,v in ipairs(string.split(substr, "")) do
        if v == '(' then
            hasParen = true
        end
    end

    -- If below 1000, check if we are below 600, if true, quaf potion
    if hasParen then
        bagMissTrigger = tempTrigger(
                "You cannot find a cyan potion to drink",
                function()
                    Xp.CURRENT_BAG = 2
                    send("get cyan potion from bag 2")
                    send("drink cyan potion")

                    -- TODO: Keep a global variable that knows which bag you are on. If we land here, and on bag 2, then go into invis mode.
                end
        )

        -- TODO: This should just echo out something for a 2nd trigger to handle?
        -- NOTE: This section needs to pull pot out of bag 1, else pull from bag 2, else go into invis mode.
        cecho("\n<blue:yellow>QUAF CYAN POTION\n")
        send("get cyan potion from bag 2")
        send("drink cyan potion")

        -- TODO: Remove disableTrigger and move this whole trigger into its own persistent trigger
        -- NOTE: Would prefer to at least test this first.

    end
end
