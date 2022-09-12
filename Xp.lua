-- Run via sending command in Mudlet client: lua Xp.startPathing()

Xp = Xp or {}

Xp.CURRENT_MOVE = 1

Xp.sreenMoves = {
  -- Get to end of path where Prince spawns
  'e','se','pull grate','d','e', 'w', 'u', 'ne', 'nw', 'se', 'd', 'e', 's','n', 'e', 'se', 'e',
  'n', 'w', 's', 'nw', 'w', 'ne', 'ne', 'ne', 'e', 's', 'e',
  -- Go back to beginning
  'w','n','w', 'sw', 'sw', 'sw', 'e', 'se', 'n', 'e', 's', 'w', 'nw', 'w', 's', 'n', 'w', 'u', 'nw',
  'se', 'sw', 'd', 'e', 'w', 'u', 'nw', 'w'
}

-- TODO: Make var name all caps
Xp.lirathMoves = {
  -- south gate, n, then west to west wall, n to north wall, down middle, repeat to north wall then
  -- cut across and down, then circle back to south gate
  'n','w','w','w','w','w',
  'n','n','n','n','n','n','n','n','n','n','n','n','n','n','n','n',
  'e','e','e','e','e','e','e','e','e','e',
  's','s','s','s','s','s','s','s','s','s','s','s','s','s','s','s',
  'w','w','w','w','w','s'
}

-- More complex triggers: https://wiki.mudlet.org/w/Manual:Lua_Functions#tempTrigger
function Xp.startPathing()
  Xp.startAttackTimer()
  continuePathTrigger = tempTrigger("Cannot find mock", Xp.continuePath)
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
    cecho("\n<red:yellow>You've reached the end of your path!")
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
