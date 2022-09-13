-- TODO: Eventually, this whole area will hold configurable variables so that each method can
--  consume the config variables, or ignore null ones. This would include trigger messages and xp
--  zone paths. Ideally, this script should work for ANY zone, including the noob zone just by
--  swapping out the config variables.

Xp = Xp or {}

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

Xp.CURRENT_MOVE = 1

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

-- More complex triggers: https://wiki.mudlet.org/w/Manual:Lua_Functions#tempTrigger
function Xp.startPathing()
  Xp.startAttackTimer()
  continuePathTrigger = tempTrigger("Cannot find mock", Xp.continuePath)
end

function Xp.initFleeTriggers()
  -- The hardened air around you is beginning to soften
  -- Your Electric Field Spell Expires
  -- Cannot find militia man,conscript,citizen
  -- The hardened air around you softens
  -- You are currently too mentally drained to cast Electric Field
  -- You are currently too mentally drained to cast Air Steel
  -- Your hands have lost their electrical energy.

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

function Xp.stopPathing()
  disableTimer(attackTimer)
  killTrigger(continuePathTrigger)
end

function Xp.continuePath()
  if Xp.CURRENT_MOVE < #Xp.lirathMoves then
    send(Xp.lirathMoves[Xp.CURRENT_MOVE])
    Xp.CURRENT_MOVE = Xp.CURRENT_MOVE + 1
  else
    cecho("\n<red:yellow>You've reached the end of your path!\n")
    Xp.stopPathing()
    Xp.CURRENT_MOVE = 1
  end
end

function Xp.startAttackTimer()
  attackTimer = tempTimer(2, Xp.sendAttackCommands, true)
end

function Xp.stopAttackTimer()
  disableTimer(attackTimer)
end

function Xp.sendAttackCommands()
  send("kill mock")
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
