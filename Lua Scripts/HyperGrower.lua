--[[ HyperGrower -- by Buoysel

    Temorarily maxes out cock size when horny.
    For the best effect, penis size should not already be maxed out prior
    to injecting the script.

]]
--Rates
local GROWTH_RATE = 0.020
local SHRINK_RATE = 0.025


--Original Stats
local oldPenisS = nil
local oldPenisG = nil
local oldBallS = nil
local boneScale = 1


--Timers
local hyperTimer = 0
local hyperWaitTime = 3.0

local timer = 0
local waitTime = 30.0

function start()

    orc.luaiterator("HyperGrower", "hyperGrow", orc.infinity)

end

function hyperGrow() 

    if orc.arousal > 0.8 then
        timer = 0
        grow(GROWTH_RATE)
    else 
        shrink(SHRINK_RATE)
    end

end

function grow(rate) 
    
    if not orc.ifitemflag("HG-Active", "1") then 
        activate()
    end

    local rateOverTime = orc.game.deltatime * GROWTH_RATE

    orc.penissize = orc.game.movetowards(orc.penissize, 1.0, rateOverTime)
    orc.penisgirth = orc.game.movetowards(orc.penisgirth, 4.0, rateOverTime * 5)
    orc.ballsize = orc.game.movetowards(orc.ballsize, 2.0, rateOverTime * 5)

    --Start scaling the bones if every thing else is maxed.
    if isMaxed() and orc.knowsbuff("HyperPenisLength") then 

        if hyperTimer < hyperWaitTime then 
            hyperTimer = hyperTimer + orc.game.deltatime
        else 
            if orc.mana >= 80 then 
                orc.buff(orc, "HyperPenisLength", 10, 1)
            end
            hyperTimer = 0
        end

        if orc.corruption == 3 or 
           orc.isfusion then 
            scaleBones((rateOverTime)) 
        end
    end
end

function isMaxed() 
    return (orc.penissize >= 1 and orc.penisgirth >=2 and orc.ballsize >= 2)
end

function shrink(rate) 

    if not orc.ifitemflag("HG-Active", "1") or orc.isfusion then
        return
    end

    if timer < waitTime then 
        timer = timer + orc.game.deltatime
        return
    end

    if not hasFlags() then 
        orc.consolecommand("natty")
        deactivate()
        return
    end

    local rateOverTime = orc.game.deltatime * rate 

    orc.penissize = orc.game.movetowards(orc.penissize, oldPenisS, rateOverTime)
    orc.penisgirth = orc.game.movetowards(orc.penisgirth, oldPenisG, rateOverTime * 5)
    orc.ballsize = orc.game.movetowards(orc.ballsize, oldBallS, rateOverTime * 5)

    
    if orc.corruption == 3 or 
    orc.isfusion then 
        scaleBones( - (rateOverTime))
    end

    if hasShrunkBack() then 
        deactivate()
    end
end

function hasShrunkBack()
    return (
            orc.penissize <= oldPenisS and 
            orc.penisgirth <= oldPenisG and 
            orc.ballsize <= oldBallS and 
            boneScale <= 1
    )
end

function activate()
    orc.setitemflag("HG-Active", "1")
    orc.setitemflag("HG-oldPenisS", orc.penissize)
    orc.setitemflag("HG-oldPenisG", orc.penisgirth)
    orc.setitemflag("HG-oldBallS", orc.ballsize)
end

function deactivate()

    orc.setitemflag("HG-Active", "0")
    oldPenisS = nil
    oldPenisG = nil
    oldBallS = nil
    timer = 0

end

function hasFlags()

    --if ANY of the old flags are missing, cancel the shrinking script immediately!
    if not orc.hasitemflag("HG-oldPenisS") or 
       not orc.hasitemflag("HG-oldPenisG") or 
       not orc.hasitemflag("HG-oldBallS") then 
        
        return false
    else 

        if oldPenisS == nil then 
            oldPenisS = orc.itemflagfloat("HG-oldPenisS")
        end
    
        if oldPenisG == nil then 
            oldPenisG = orc.itemflagfloat("HG-oldPenisG")
        end
    
        if oldBallS == nil then 
            oldBallS = orc.itemflagfloat("HG-oldBallS")
        end

        return true
    end
end

function scaleBones(rot) 

    if not orc.isfusion and not orc.corruption == 3 then 
        return
    end

    --Slowly scale the bones on top of the regular growth
    if boneScale >= 1 and boneScale <= 1.5 then
        orc.consolecommand("cbt gen,".. boneScale ..",false")
    end

    boneScale = boneScale + rot

    --Clamp the values
    if boneScale > 1.51 then 
        boneScale = 1.51
    elseif boneScale < 1 then 
        boneScale = 1
    end

end
