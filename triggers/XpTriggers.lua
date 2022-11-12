--- ATTACK TRIGGER ---------------------------------------------------------------------------------
--- TRIGGERS
--- "You lunge at (.)" -> regexp
--- "You are too exhausted to lunge"
--- Your target doesn't appear to be there anymore
---
send("lunge")
----------------------------------------------------------------------------------------------------

--- ADVANCE ROOM TRIGGER ---------------------------------------------------------------------------
--- TRIGGERS
--- "You can't seem to find your target to lunge"
---
--local moves = PathRepo.XP_PESVINT
local moves = PathRepo.FXP

if Xp.CURRENT_MOVE > #moves then
    -- TODO: Add rest timer if needed, but instead, just add more zones to loop
    Xp.CURRENT_MOVE = 1
    --cecho("\n<red:yellow>Finished Xp path. TODO: re-loop\n")
    --send("hide")
    Xp.pesvint() -- TODO: This can probably be generic xp-init func w/ global config settings.
else -- TODO: Would be nice to have default case above.
    -- TODO: The path needs to come from elsewhere. Can't be hard coded inside this trigger. Configurable
    --send(PathRepo.FXP[Xp.CURRENT_MOVE])
    send(moves[Xp.CURRENT_MOVE])
    Xp.CURRENT_MOVE = Xp.CURRENT_MOVE + 1
    send("kill "..Xp.NPC_TARGETS)
    send("lunge")
end
----------------------------------------------------------------------------------------------------

-- TODO: ADD TRIGGER FOR: deals you the final blow, and the world fades
-- NOTE: This should kill all triggers.
