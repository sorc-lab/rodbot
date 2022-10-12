TekBot = TekBot or {}

-- Regex triggers on: says loudly, "defs (.*)"
function TekBot.defs()
    local defTarg = matches[2]
    send("cast air steel on "..defTarg)
    tempTimer(2, function() send("cast resist magic on "..defTarg) end)
    tempTimer(4, function() send("cast resist electricity on "..defTarg) end)
    tempTimer(6, function() send("cast layered winds on "..defTarg) end)
end

-- Regex triggers on: says loudly, "layers (.*)"
function TekBot.layers()
    local defTarg = matches[2]
    send("cast layered winds on "..defTarg)
end

-- Regex triggers on: says loudly, "reduce (.*)"
function TekBot.reduce()
    local defTarg = matches[2]
    send("cast reduce weight on "..defTarg)
end

-- Regex triggers on: says loudly, "bond (.*)"
function TekBot.bond()
    local defTarg = matches[2]
    send("cast reduce weight on "..defTarg)
    tempTimer(2, function() send("cast aerial possession on "..defTarg) end)
end

-- Regex triggers on: says loudly, "invis (.*)"
function TekBot.invis()
    local defTarg = matches[2]
    send("cast invisibility on "..defTarg)
end

-- TODO: Fail trigger on: 'You lack the proper component to cast this spell'

--.--------------------------------------------------------------.
--| Sorcerer Defenses  | 'lsay defs <your_name>'                 |
--| Layered Winds(x8)  | 'lsay layers <your_name>'               |
--| *Reduce Weight     | 'lsay reduce <weapon|armour>'           |
--| *Aerial Possession | 'lsay bond <weapon>'                    |
--| *Invisibility      | 'lsay invis <your_name|container_type>' |
--'--------------------------------------------------------------'
--*Item enchants require them to be dropped on the floor.

--https://www.asciiart.eu/nature/mountains
--https://ascii.co.uk/art/fuji
