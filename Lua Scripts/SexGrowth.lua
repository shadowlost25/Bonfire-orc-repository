
local GROWTH_TIME = orc.game.deltatime
local TOP_RATE = 0.005
local BTM_RATE = 0.010
local BONE_SCALE_GROWTH = 1
local BONE_SCALE_SHRINK = 1


function start()
    --Get the closest orc
    local nearest = orc.findclosest(5)
    if nearest ~= nil then 
        if orc.issexing and nearest.issexing then
            grow(orc, TOP_RATE)
            grow(nearest, BTM_RATE)
        end
    end   
end


function grow(target, rate)
    --Slowly grow over time

    local growthRate = rate * GROWTH_TIME

    target.height = target.height + growthRate
    target.muscle = target.muscle + growthRate
    target.penissize = target.penissize + growthRate
    target.penisgirth = target.penisgirth + (growthRate * 5)
    target.penisshower = target.penisshower + growthRate
    target.ballsize = target.ballsize + growthRate

    scaleBones(target, rate)
end


function scaleBones(target, rate) 
    --Slowly scale the bones on top of the regular growth
    local growthRate = rate * GROWTH_TIME

    if BONE_SCALE_GROWTH <= 1.5 then
            target.consolecommand("cbt gen,".. BONE_SCALE_GROWTH ..",false")
        end

    if BONE_SCALE_GROWTH <= 1.3 then
        target.consolecommand("batch cbt shoulderl,"..  BONE_SCALE_GROWTH ..",true;cbt shoulderr,"..  BONE_SCALE_GROWTH ..",true;")
        target.consolecommand("batch cbt bicepl,"..  BONE_SCALE_GROWTH ..",true;cbt bicepr,"..  BONE_SCALE_GROWTH ..",true;")
    end

    if BONE_SCALE_GROWTH <= 1.2 then
        target.consolecommand("batch cbt buttl,"..  BONE_SCALE_GROWTH ..",true;cbt buttr,"..  BONE_SCALE_GROWTH ..",true;")
        target.consolecommand("batch cbt pelvis,"..  BONE_SCALE_GROWTH ..",false;")
    end

    if BONE_SCALE_GROWTH <= 1.15 then
        target.consolecommand("batch cbt clavl,"..  BONE_SCALE_GROWTH ..",true;cbt clavr,"..  BONE_SCALE_GROWTH ..",true;")
        target.consolecommand("batch cbt spine3,"..  BONE_SCALE_GROWTH ..",true;")
    end

    if BONE_SCALE_GROWTH <= 1.1 then
        target.consolecommand("batch cbt neck1,"..  BONE_SCALE_GROWTH ..",true;cbt neck2,"..  BONE_SCALE_GROWTH ..",true;")
    end

    if BONE_SCALE_SHRINK >= 0.9 then 
        target.consolecommand("batch cbt arml,"..  BONE_SCALE_SHRINK ..",false;cbt armr,"..  BONE_SCALE_SHRINK ..",false;")
        target.consolecommand("batch cbt spine1,"..  BONE_SCALE_SHRINK ..",true;cbt spine2,"..  BONE_SCALE_SHRINK ..",true;")
    end

    if BONE_SCALE_SHRINK >= 0.85 then 
        target.consolecommand("batch cbt thighl,"..  BONE_SCALE_SHRINK ..",false;cbt thighr,"..  BONE_SCALE_SHRINK ..",false;") 
    end

    BONE_SCALE_GROWTH = BONE_SCALE_GROWTH + growthRate
    BONE_SCALE_SHRINK  = BONE_SCALE_SHRINK - growthRate

end
