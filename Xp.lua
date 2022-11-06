require("repo.PathRepo")

Xp = Xp or {}

-- TODO: CURRENT_MOVE really should be current move index or something.
Xp.CURRENT_MOVE = 1
Xp.POTS_QUAFFED = 0
Xp.PATH_START_TIME = 0
Xp.PATH_END_TIME = 0

function Xp.gtop() Xp.execFlightPath(PathRepo.TO_PESVINT_FROM_GUILD, false) end
function Xp.ltop() Xp.execFlightPath(PathRepo.TO_PESVINT_FROM_LIRATH, false) end
function Xp.ptog() Xp.execFlightPath(PathRepo.TO_GUILD_FROM_PESVINT, false) end
function Xp.ltobs() Xp.execFlightPath(PathRepo.TO_BLACK_SHRINE_FROM_LIRATH, false) end
function Xp.ptol() Xp.execFlightPath(PathRepo.TO_LIRATH_FROM_PESVINT, false) end

function Xp.PXP() Xp.startPathing(PathRepo.XP_PESVINT) end

function Xp.execFlightPath(flightPath, hasRestTimer)
    Xp.CURRENT_MOVE = 1

    -- sets global timer. important for killing timer in stopPathing func.
    moveTimer = tempTimer(.5, function() Xp.continuePath(flightPath, hasRestTimer) end, true)
end

function Xp.startPathing(path)
    Xp.PATH_START_TIME = os.time()

    -- TODO: This needs to be an arg? Or it needs to use global conf to know Xp init cmds.
    send("cast air steel")
    send("cast shocking grasp")
    send("cast electric field")
    send("cast mystical cloak")

    Xp.CURRENT_MOVE = 1

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

-- TODO: Fix this design. Use triggers to perform next action, vs. performing actions every x seconds
function Xp.startAttackTimer()
    -- NOTE: Cyans only last 30 seconds.
    -- NOTE: Attack timer set to 2sec normally, but 4sec needed to reduce cyan consumption
    attackTimer = tempTimer(4, Xp.sendAttackCommands, true)
end

-- TODO: Probably not necessary as a separate function. can this be in-lined where it is used?
function Xp.stopAttackTimer()
  disableTimer(attackTimer)
end

-- TODO: This can be all one string of mobs spanning across all zones. They are never combined, so
--  we can just include all.
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

    -- TODO: This section needs to be broken up with global settings, somehow.
    send("cast lightning storm")
    --send("lunge")
end

function Xp.continuePath(moves, rest)
    if Xp.CURRENT_MOVE > #moves then
        Xp.stopPathing()

        Xp.PATH_END_TIME = os.time()

        Xp.CURRENT_MOVE = 1
        cecho("\n<red:yellow>YOU HAVE ARRIVED AT YOUR DESTINATION\n")

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
                        Xp.startPathing(PathRepo.PXP)
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

-- TODO: This needs to exist in its own Trigger class per guild. Can manually enable/disable via Mudlet.
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
