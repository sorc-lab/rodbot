-- TODO: Eventually, this whole area will hold configurable variables so that each method can
--  consume the config variables, or ignore null ones. This would include trigger messages and xp
--  zone paths. Ideally, this script should work for ANY zone, including the noob zone just by
--  swapping out the config variables.

-- TODO: Weird spacings etc, run full file formatter.

Xp = Xp or {}

-- TODO: CURRENT_MOVE really should be current move index or something.
Xp.CURRENT_MOVE = 1
Xp.CURRENT_BAG = 1
Xp.INVIS_MODE = false

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
        function() Xp.continuePath("Sorcerer's Guild", Xp.TO_GUILD_FROM_PESVINT, false) end,
        true
    )
end

function Xp.fleeFromPesvintToGuild()
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

function Xp.continuePath(destination, moves, rest)
  if Xp.CURRENT_MOVE > #moves then
      Xp.stopPathing()
      Xp.CURRENT_MOVE = 1
      cecho("\n<red:yellow>YOU HAVE ARRIVED AT YOUR DESTINATION: "..destination.."\n")

      if rest then
          restTimer = tempTimer(
                  300,
                  function()
                      -- TODO: Move this to Xp.CURRENT_PATH
                      Xp.startPathing(Xp.FXP)
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
--      BUG: I think once I have 0 pots in bag1 or bag2, some sort of infinite loop kicks off and I
--          have to force quit the client. It queues up commands in a way that dead locks the client.
--  2. Run bot until all bag1 pots are gone
--  3. Test the bagMissTrigger. It should start grabbing pots from bag2 and setting global currBag
--  4. Run bot until all bag2 pots are gone.
--  5. Write the invis mode code and test with both bags empty.
-- NOTE: Also, consider adding a cast invis at the end of the path before the 5min timer is set.
function Xp.drinkCyanPotion()
    hud = line
    hudSplit = string.split(hud, "Gp: ")[2]
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
        bagMissTrigger = tempTrigger(
                "You cannot find a cyan potion to drink",
                function()
                    if Xp.CURRENT_BAG == 2 then
                        Xp.CURRENT_BAG = 1
                        Xp.stopPathing()
                        killTrigger("bagMissTrigger")
                        Xp.INVIS_MODE = true

                        return
                    end

                    Xp.CURRENT_BAG = 2
                    send("get cyan potion from bag "..Xp.CURRENT_BAG)
                    send("drink cyan potion")
                end
        )

        -- TODO: Somehow we're still in an infinite loop at Fire Giants. This did not occur in Pesvint.
        -- NOTE: Maybe the killTrigger func inside the trigger doesn't work, so we can call that here.
        if Xp.INVIS_MODE == true then
            -- TODO: This is invis mode state. Implement after quaf bug fix. Just return for now.
            -- NOTE: I recently moved the send("stop") into stopPathing, this is not ideal for this feature
            return
        end

        cecho("\n<blue:yellow>QUAF CYAN POTION\n")
        send("get cyan potion from bag "..Xp.CURRENT_BAG)
        send("drink cyan potion")
    end
end
