--[[ Proximity Size Theft -- by Buoysel

    A sample script to steal another orc's muscle attribute
    and transfer it to the player. This can be easily modified
    to drain more properties

]]


local target = nil
local targetRange = 2.5

local DRAIN_RATE = 0.05

local rateOverTime = 0

function update()
    drainOrcs()
end

function drainOrcs()

    rateOverTime = orc.game.deltatime * DRAIN_RATE

    target = orc.findclosest(targetRange) -- Get nearby orc

    if target == nil or not orc.canaffect(orc,target) then -- Don't run if no orc is found
        return 
    end

    drainMuscle(target)

    drainHeight(target)

end


function drainMuscle(target) 

    --Return if the target has nothing to give... 0.25 is the minimum allowed muscle value
    if not (target.muscle > 0.25) then return end

    target.muscle = orc.game.movetowards(target.muscle, 0, rateOverTime)
    orc.muscle = orc.game.movetowards(orc.muscle, 1.0, rateOverTime)

end


function drainHeight(target) 

    --Return if the target has nothing to give...
    if not (target.height > 0) then return end

    target.height = orc.game.movetowards(target.height, 0, rateOverTime)
    orc.height = orc.game.movetowards(orc.height, 1.0, rateOverTime)

end
