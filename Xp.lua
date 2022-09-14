-- TODO: Eventually, this whole area will hold configurable variables so that each method can
--  consume the config variables, or ignore null ones. This would include trigger messages and xp
--  zone paths. Ideally, this script should work for ANY zone, including the noob zone just by
--  swapping out the config variables.

-- TODO: Weird spacings etc, run full file formatter.

Xp = Xp or {}

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

Xp.LIRATH_XP = {
    -- south gate, n, then west to west wall, n to north wall, down middle, repeat to north wall then
    -- cut across and down, then circle back to south gate
    'n','w','w','w','w','w',
    'n','n','n','n','n','n','n','n','n','n','n','n','n','n','n','n',
    'e','e','e','e','e','e','e','e','e','e',
    's','s','s','s','s','s','s','s','s','s','s','s','s','s','s','s',
    'w','w','w','w','w','s'
}

Xp.PESVINT_XP = {
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
    -- TODO: Fill out
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

Xp.CURRENT_MOVE = 1

-- TODO: These move functions should take args and become generic. They definitely still need the
--  arrival message with destination label
function Xp.moveFromGuildToPesvint()
  Xp.CURRENT_MOVE = 1

  moveTimer = tempTimer(
    .5,
    function() Xp.continuePath("Pesvint", Xp.TO_PESVINT_FROM_GUILD) end,
    true
  )
end

function Xp.moveFromPesvintToGuild()
    Xp.CURRENT_MOVE = 1

    moveTimer = tempTimer(
        .5,
        function() Xp.continuePath("Sorcerer's Guild", Xp.TO_GUILD_FROM_PESVINT) end,
        true
    )
end

function Xp.moveFromLirathToBlackShrine()
    Xp.CURRENT_MOVE = 1

    moveTimer = tempTimer(
        .5,
        function() Xp.continuePath("Black Shrine", Xp.TO_BLACK_SHRINE_FROM_LIRATH) end,
        true
    )
end

-- TODO: This entire function can be tested manually mid battle. No need to wire it up to triggers yet.
function Xp.initFleeEvent()
    -- exec Xp.stopPathing to kill triggers and attack timer
    -- send("stop")
    -- Need to decrement pathing moves until you get back to 1, need to move array in reverse.
    --      TODO: This can be tested manually before going live.

    -- Need to pass current movement array into this function. Or, we could set this GLOBALLY
    -- Take the current path and create a the current move index
    -- Generate a new array that starts from the current idx and ends at 1 in revers. Cut off all the rest.
    -- Feed that new array into a moveToEscapePoint method that takes the generated array
        -- This function will call the continuePath method and have destination string to trigger off
    -- Trigger on flee success msg, then execute any pre-made move method, like move to guild.
end

function Xp.initFleeTriggers()
  -- The hardened air around you is beginning to soften
  -- Your Electric Field Spell Expires
  -- Cannot find militia man,conscript,citizen
  -- The hardened air around you softens
  -- You are currently too mentally drained to cast Electric Field
  -- You are currently too mentally drained to cast Air Steel
  -- Your hands have lost their electrical energy.

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

function Xp.startPathing(path)
    Xp.CURRENT_MOVE = 1
    Xp.startAttackTimer()

    continuePathTrigger = tempTrigger(
        "Cannot find cutthroat,cutpurse",
        --"Cannot find militia man",
        function() Xp.continuePath("Pesvint Path", path) end
    )

    reInitPathingTrigger = tempTrigger(
        "YOU HAVE ARRIVED AT YOUR DESTINATION: Pesvint Path",
        function()
            -- TODO: Not sure if these are needed here.
            killTrigger(continuePathTrigger)
            killTrigger(reInitPathingTrigger)
            Xp.continuePath("Pesvint Path", path)
        end
    )

    --Xp.initFleeTriggers()
end

function Xp.stopPathing()
  disableTimer(attackTimer)
  killTrigger(continuePathTrigger)
  killTrigger(reInitPathingTrigger)
end

function Xp.startAttackTimer()
    attackTimer = tempTimer(2, Xp.sendAttackCommands, true)
end

function Xp.stopAttackTimer()
  disableTimer(attackTimer)
end

function Xp.sendAttackCommands()
  --send("kill militia man")
  send("kill cutthroat,cutpurse")
  send("cast plasma blast")
end

function Xp.continuePath(destination, moves)
  if Xp.CURRENT_MOVE > #moves then
    Xp.CURRENT_MOVE = 1
    cecho("\n<red:yellow>YOU HAVE ARRIVED AT YOUR DESTINATION: "..destination.."\n")
    disableTimer(moveTimer)
  else
    send(moves[Xp.CURRENT_MOVE])
    Xp.CURRENT_MOVE = Xp.CURRENT_MOVE + 1
  end
end
