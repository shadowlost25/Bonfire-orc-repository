
--[[ Cumflation
    After a set duration, the Inflator will get pent up and start leaking. In this 
    state, any orc they top will get cum inflated. 

    The inflated orc will absorb the cum after a set period of time.

    Changelog: 
    v2.0 
        - Refactored much of the script, making it compatible with online play.
        - The script can now be toggled manually by right-clicking the Cumflation scroll 
        - Absorbing the cum after a minute now causes muscle growth
        - Added an "Uninstall" funciton that cleanly reverts and uninstalls the mod.
    v1.0 
        - Initial release
]]
    
--[[
    Data Flags:
        CF-Active: true, false    -- IF the user is running this script as an inflator.
        CF-BallBones: 1 - 1.5     -- CBT Scale for the balls
        CF-TopStats: ballsize     -- Holds the tops old ball size that they will shirnk back down to
        CF-Blueballed: true,false -- If the top has blue balls, they can inflate their partner.

        CF-Inflated: true,false   -- If the bottom is inflated, they will wait to absorb the cum
        CF-BottomStats: bodyfat   -- Holds the bottom's old body fat size that they will shrink back down to as they build muscle
        CF-BellyBones: 1 - 1.5    -- CBT Scale for the belly
]]

--Constants
local SCRIPT_NAME = "Cumflation"
local CF_GROWTH_RATE = 0.100     -- Standard Rate of growth before mathmatical operations

--Inflator/Inflatee target
local target = nil

--Timers
local BB_WAIT_TIME = 30          -- Wait time before an orc's balls grow, or before the bottom absorbs the cum
local blueballTimer = 0

local ABSORB_WAIT = 60           -- Wait time before the inflatee absorbs the cum
local absorbTimer = 0

local CUM_LIMIT = 45             -- The longest the top will wait before leaking cum
local cumTimer = 0
local cumWait = 0

local SOUND_LIMIT = 120          -- The longest either orc will wait before moaning.
local soundTimer = 0
local soundWait = 0


function onrightclick()

    -- Toggle the script on and off

    if not orc.hasitemflag("CF-Active", "@any") or 
       orc.ifitemflag("CF-Active", "true") == false then 
        
        orc.setitemflag("CF-Active", "true")
        orc.luaiterator("Cumflation", "inflator", orc.infinity)
        orc.consolecommand("infodialogue " .. orc.orcname .. " is now using Cumflation. After " .. BB_WAIT_TIME .. " seconds, your orc's balls will start growing.")

        debug("onrightclick", "Cumflation is active.")

    else 

        orc.setitemflag("CF-Active", "false")
        orc.consolecommand("oluaria Cumflation,inflator")
        orc.consolecommand("oluaria Cumflation,inflatee")

        revert()

        removeFlags()
        
        orc.consolecommand("infodialogue Cumflation has been deactivated.")

        debug("onrightclick", "Cumflation deactivated.")

    end

end

function resetTimers() 
    --Resets all timers
    
    blueballTimer = 0
    absorbTimer = 0
    
    soundTimer = 0
    soundWait = 0

    cumTimer = 0
    cumWait = 0
    
end

function inflator()

    --This is assumed to be the script holder, or top, who inflates the bottom.

    blueballOverTime()

    --Get the closest orc
    target = orc.findclosest(2)
    if target ~= nil then 

        --Activate if both are sexing    
        if orc.issexing and target.issexing then 

            --Fill up the bottom orc if blueballed
            if orc.cumming and orc.ifitemflag("CF-Blueballed","true") then 

                resetTimers()

                --Inject a copy into the bottom's inventory
                if (target.hasitemflag("CF-Inflated", "@any") == false)  then 

                    --Don't copy the script to other inflators.
                    if not target.hasitemflag("CF-Active", "@any") then 
                        orc.luacopyover(orc,target,'Cumflation')
                    end
                    target.luaiterator('Cumflation','inflatee',orc.infinity)

                    debug("inflator", "Copied Cumflation to " .. target.orcname)
                end

                --Empty and shrink the top's balls.
                local rateOverTime = (CF_GROWTH_RATE * orc.game.deltatime) / 1.5

                local ballBones = orc.itemflagfloat("CF-BallBones")
                local topStats = orc.itemflagfloat("CF-TopStats")
                
                if (ballBones > 1 or orc.ballsize > topStats) then
                    orc.consolecommand("cbt gen," .. ballBones .. ",true")
                    orc.setitemflag("CF-BallBones", ballBones - rateOverTime)
                    orc.ballsize = orc.game.movetowards(orc.ballsize, topStats, rateOverTime)
                else

                    orc.consolecommand("removescriptflag CF-TopStats")
                    orc.consolecommand("removescriptflag CF-BallBones")
                    orc.consolecommand("removescriptflag CF-Blueballed")

                    debug("inflator", orc.orcname .. " is no longer blueballed")
                end

            end
        end
    end   
end

function inflatee()

     --This is assumed to be the bottom, who gets inflated.

    absorbCumOverTime()
   
    target = orc.findclosest(2)
    if target ~= nil then 

        --Inflate when the top starts cumming.
        if orc.issexing and target.issexing then 

            --Reset shrink timer
            resetTimers()

            --If this orc is having sex with the Cuminflator, and they are blueballed, then inflate over time.

            if target.cumming and target.ifitemflag("CF-Blueballed","true") then 
                
                --Save old fat to data flag.
                if not orc.ifitemflag("CF-Inflated", "true") then 
                    orc.setitemflag("CF-Inflated", "true")
                    orc.setitemflag("CF-BottomStats", orc.bodyfat)
                    orc.setitemflag("CF-BellyBones", "1")

                    debug("inflatee", orc.orcname .. " is now inflating.")
                end


                local rateOverTime = (CF_GROWTH_RATE * orc.game.deltatime) / 2
                
                local bellyBones = orc.itemflagfloat("CF-BellyBones")
                
                orc.bodyfat = orc.bodyfat + rateOverTime
                
                
                if bellyBones <= 1.5 then
                    orc.consolecommand("cbt spine1," .. bellyBones .. ",true")
                end

                if bellyBones <= 1.15 then
                    orc.consolecommand("cbt spine3," .. bellyBones .. ",true")
                end

                if bellyBones <= 1.05 then 
                    orc.consolecommand("cbt spine2," .. bellyBones .. ",true")
                end

                if bellyBones <= 1.5 then 
                    orc.setitemflag("CF-BellyBones", bellyBones + rateOverTime)
                end
            end
        end
    end
end

function blueballOverTime() 

    --Grow this orc's balls over time and make them leak when they reach max size.
   
    if blueballTimer < BB_WAIT_TIME then 
        blueballTimer = blueballTimer + orc.game.deltatime
        return
    end

    --Mark the orc as blue balled and save their old ball size:
    if not orc.ifitemflag("CF-Blueballed", "true") then 
        orc.setitemflag("CF-Blueballed","true")
        orc.setitemflag("CF-TopStats", orc.ballsize)
        orc.setitemflag("CF-BallBones", "1")

        debug("blueballOverTime", orc.orcname .. " is now blueballed")
    end

    --Start teh growths
    local rateOverTime = (CF_GROWTH_RATE * orc.game.deltatime) / 8

    orc.arousal = orc.game.movetowards(orc.arousal,1.0,rateOverTime * 4)
    orc.ballsize = orc.game.movetowards(orc.ballsize,2.0,rateOverTime)
    
    local ballBones = orc.itemflagfloat("CF-BallBones")

    if ballBones <= 1.5 then
        orc.consolecommand("cbt gen," .. ballBones .. ",true")
        orc.setitemflag("CF-BallBones", ballBones + rateOverTime)
    end

    --Cum periodically
    if ballBones >= 1.5 and orc.issexing == false then 

        cumTimer = cumTimer + orc.game.deltatime
        if cumTimer > cumWait then
            orc.cum();
            cumTimer = 0
            cumWait = orc.game.randomint(0,CUM_LIMIT)
        end

    end

    --Moan periodically
    soundTimer = soundTimer + orc.game.deltatime
    if soundTimer > soundWait then 
        orc.sounddeepbreath(0.5)
        soundTimer = 0
        soundWait = orc.game.randomint(0,SOUND_LIMIT)
    end

end

function absorbCumOverTime()

    --Shrink after not being filled for 60 seconds
    if absorbTimer < ABSORB_WAIT then 
        absorbTimer = absorbTimer+ orc.game.deltatime
        return
    end

    local rateOverTime = (CF_GROWTH_RATE * orc.game.deltatime)

    local bellyBones = orc.itemflagfloat("CF-BellyBones")
    local bottomStats = orc.itemflagfloat("CF-BottomStats")

    --While there is excess bodyfat remaining, reduce the orc's fat, while also build up their muscle.
    if (orc.bodyfat > bottomStats or bellyBones > 1) then 

        --Reduce body fat
        local absorbRate = rateOverTime / 4
        orc.bodyfat = orc.game.movetowards(orc.bodyfat, bottomStats, absorbRate)

        if bellyBones <= 1.5 then 
            orc.consolecommand("cbt spine1," .. bellyBones .. ",true")
        end
    
        if bellyBones <= 1.15 then 
            orc.consolecommand("cbt spine3," .. bellyBones .. ",true")
        end
    
        if bellyBones <= 1.05 then 
            orc.consolecommand("cbt spine2," .. bellyBones .. ",true")
        end
    
        if bellyBones > 1 then 
            orc.setitemflag("CF-BellyBones", bellyBones - absorbRate)
        end
        
        --Build muscle
        local muscleRate = rateOverTime / 10

        if orc.height < 1.0 then 
            orc.height = orc.game.movetowards(orc.height, 1.0, muscleRate)
        end

        orc.muscle = orc.game.movetowards(orc.muscle, 1.0, muscleRate)
        orc.extrabutt = orc.game.movetowards(orc.extrabutt, 1.0, muscleRate)
        orc.footsize = orc.game.movetowards(orc.footsize, 1.0, muscleRate)
        orc.handgirth = orc.game.movetowards(orc.handgirth, 1.0, muscleRate)

    else 

        -- Remove the excess flags
        orc.consolecommand("removescriptflag CF-Inflated")
        orc.consolecommand("removescriptflag CF-BottomStats")
        orc.consolecommand("removescriptflag CF-BellyBones")

        -- And delete the flag if they aren't running it as an inflator.
        orc.consolecommand("oluaria Cumflation,inflatee")

        if not orc.hasitemflag("CF-Active", "@any") then 
            orc.remscript("Cumflation")

        end

        debug("absorbCumOverTime", orc.orcname .. " absorbed all of the cum. Removing Cumflation from Inflatee.")

    end

    soundTimer = soundTimer + orc.game.deltatime
    if soundTimer >= soundWait then 
        orc.soundbrass(0.5)
        soundTimer = 0
        soundWait = orc.game.randomint(0,SOUND_LIMIT)
    end

end

function revert() 

    debug("revert", "Restoring this orc's form.")

    -- Restores body back to normal.
    if orc.hasitemflag("CF-TopStats") then 
        orc.ballsize = orc.itemflagfloat("CF-TopStats")
    end

    if orc.hasitemflag("CF-BottomStats") then 
        orc.bodyfat = orc.itemflagfloat("CF-BottomStats")
    end

    orc.consolecommand("cbt spine1,1,true")
    orc.consolecommand("cbt spine3,1,true")
    orc.consolecommand("cbt spine2,1,true")
    orc.consolecommand("cbt gen,1,true")

end

function removeFlags()

    debug("removeFlags", "Deleting data Flags")
    
    orc.consolecommand("removescriptflag CF-TopStats")
    orc.consolecommand("removescriptflag CF-BallBones")
    orc.consolecommand("removescriptflag CF-Blueballed")

    orc.consolecommand("removescriptflag CF-Inflated")
    orc.consolecommand("removescriptflag CF-BottomStats")
    orc.consolecommand("removescriptflag CF-BellyBones")
    
end

function uninstall()

    orc.consolecommand("removescriptflag CF-Active")

    revert()
    removeFlags()

    orc.remscript("Cumflation")
end

function debug(functionName, text) 
    -- Print debugging messages out to the console
    orc.debuglog( SCRIPT_NAME .. ", " .. functionName .. "() on " .. orc.orcname .. ":\n\t" .. text)
end