local timer = 0         -- Tracks elapsed time
local waitTime = 300    -- 5 minutes

function update() 

    if timer < waitTime then
        timer = timer + orc.game.deltatime
        return
    else 
        timer = 0
    end

    orc.consolecommand("orccallback galaxyParticles")
    
end