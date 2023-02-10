require("repo.PathRepo")

Xp = Xp or {}

-- TODO: CURRENT_MOVE really should be current move index or something.
Xp.CURRENT_MOVE = 1
Xp.POTS_QUAFFED = 0
Xp.PATH_START_TIME = 0
Xp.PATH_END_TIME = 0

-- TODO: Test if the "kill ogres" part of this initiates an attack on ogre-mage, which should be removed.
--Xp.NPC_TARGETS = "fire giants,ogres,elementals,militia men,rat,orc,gnomes,duergar,varena,hermit,svirfnebli,troll,warden,priest,prince,clockwork soldiers"
-- TODO: Make constants per zone.
Xp.NPC_TARGETS = "giants,elementals,militia men,officers"
--Xp.NPC_TARGETS = "gnomes,drow,orcs,rats,elves,throck,soldiers,duergar,svirfnebli"

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


-- TODO: Can change name later. Just need a fresh slate to re-write startPathing. Or keep name? duno.
function Xp.pesvint()
    Xp.CURRENT_MOVE = 1

    -- start the xp bot by attacking room 1
    --send("kill "..Xp.NPC_TARGETS)
    send("launch dim mak at monsters")
    --send("launch kata at "..Xp.NPC_TARGETS)
end

function Xp.fireGiants()
    Xp.CURRENT_MOVE = 1

    -- start the xp bot by attacking room 1
    send("kill "..Xp.NPC_TARGETS)
    send("lunge")
end

function Xp.startPathing(path)
    Xp.PATH_START_TIME = os.time()
    Xp.CURRENT_MOVE = 1

    Xp.setupPathingBuffs()
    --Xp.startAttackTimer()

    -- TODO: Try triggering a lunge/attack cmds on success of previous. Keep the trigger that moves
    --  to next room. This approach will require two triggers, as a first stab at it to remove
    --  attack timer.

    Xp.sendAttackCommands()

    attackTrigger1 = tempTrigger(
            "Ok, You sneak",
            function() Xp.sendAttackCommands() end
    )

    -- TODO: This is highly problematic. You need to trigger on lunge, not each slash.
    attackTrigger2 = tempTrigger(
            "You lunge at",
            function() Xp.sendAttackCommands() end
    )

    -- TODO: Genericize this. See sendAttackCommands and mirror its command here.
    continuePathTrigger = tempTrigger(
            -- TODO: This trigger fails b/c the line breaks, most likely
            --"Cannot find "..Xp.NPC_TARGETS,

            "Cannot find fire giants,ogres,elementals,militia",
            function() Xp.continuePath(path, true) end
    )
end

-- TODO: Func needs feature flags
function Xp.setupPathingBuffs()
    -- sorc specific setup
    --send("cast air steel")
    --send("cast shocking grasp")
    --send("cast electric field")
    --send("cast mystical cloak")

    -- privateer specific setup
    -- TODO: Place defense stance command here
    --send("")
end

function Xp.stopPathing()
    send("stop")
    if attackTimer then disableTimer(attackTimer) end
    if continuePathTrigger then killTrigger(continuePathTrigger) end
    if moveTimer then disableTimer(moveTimer) end
end

-- TODO: Fix this design. Use triggers to perform next action, vs. performing actions every x seconds
function Xp.startAttackTimer()
    -- NOTE: Cyans only last 30 seconds.
    -- NOTE: Attack timer set to 2sec normally, but 4sec needed to reduce cyan consumption
    attackTimer = tempTimer(2, Xp.sendAttackCommands, true)
end

-- TODO: This func needs feature flags
function Xp.sendAttackCommands()
    send("kill "..Xp.NPC_TARGETS)
    --send("cast lightning storm")
    send("lunge")
end

-- TODO: This func can be retired, but retain the metrics part of it.
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

        -- TODO: This is the "rest section" and needs feature toggles.
        send("hide")
        --send("cast invisibility")

        -- TODO: This should go in its own function. This also needs config values tied to it, globally.
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
