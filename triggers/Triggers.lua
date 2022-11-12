-- TODO: Call this class Quaffer or something. Also, make TekBotTriggers etc. and pull into this dir.

-- TODO: Do trigger source code even need to be tables?
-- NOTE: Do they even need function declarations? Would be nice to copy/paste in Mudlet w/o
-- NOTE: This one seems like it needs to be copy/pasted since it has global settings.
Triggers = Triggers or {}

-- TODO: This needs to exist in its own Trigger class per guild. Can manually enable/disable via Mudlet.
-- TODO: Need a potion counter that increments, then shifts to different bag.
-- NOTE: Code should assume each bag is full and main inv is empty.
-- Must copy/paste into perl regex trigger on: regexp: (Gp: )(\d{1,3})
function Triggers.drinkCyanPotion()
    hud = line
    hudSplit = string.split(hud, "Gp: ")[2]

    -- TODO: This hudSplit value needs to be captured as global const that explains what it is
    -- NOTE: This is how you quaf on 10s vs 1000s etc. Needs to be 4 to quaf below 1000, and 3 to
    --  quaf below 100
    substr = string.sub(hudSplit, 1, 3)
    --substr = string.sub(hudSplit, 1, 4)

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

        send("get cyan potion from satchel")
        send("drink cyan potion")
        send("put cyan potions in satchel")

        Xp.POTS_QUAFFED = Xp.POTS_QUAFFED + 1

        --send("get mana potion from bags")
        --send("drink mana potion")
        --send("put mana potions in bags")
    end
end
