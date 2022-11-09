--- ATTACK TRIGGER ---------------------------------------------------------------------------------
-- TODO: See if you can switch this to 'You lunge at (.)'
-- ReLungeTrigger
-- "You lunge at (.)" -> regexp
-- "You are too exhausted to lunge"
-- Your target doesn't appear to be there anymore
send("lunge")
----------------------------------------------------------------------------------------------------

--- ADVANCE ROOM TRIGGER ---------------------------------------------------------------------------
-- AdvanceRoomTrigger
-- "You can't seem to find your target to lunge"
-- TODO: The path needs to come from elsewhere. Can't be hard coded inside this trigger. Configurable
send(PathRepo.FXP[Xp.CURRENT_MOVE])
Xp.CURRENT_MOVE = Xp.CURRENT_MOVE + 1
send("kill "..Xp.NPC_TARGETS)
send("lunge")
----------------------------------------------------------------------------------------------------
