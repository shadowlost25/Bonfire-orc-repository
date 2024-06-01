
--[[ Cumflation - By Buoysel

    Once an orc's Meios amount reaches a certain threshold, their balls will swell and begin leaking. 
    In this state, any orc they top will get cum inflated. 

    The inflated orc will absorb the cum after a set period of time and trigger muscle growth.

    Changelog: 
    v3.0
        - Refactored the code again to take the new meios properties in account and to make use of the 
        new belly shapes.
        - To make it so the growth is actually visiable, orcs who uses this script will have their forms 
        temporarily nerfed. 
            - For tops, ball size will be reduced to 0.5. This is to handle their swelling during the 
            blueballed state, and shrinkage with every cumshot.
            - Bottoms will have their bodyfat, muscle, height extrabelly, extrapecs, extralegs , and extrabutt
            reduced at the very moment of injection, both to handle the actual cuminflation growth, plus 
            the actual muscle growth that ensues while the cum absorption iterator is running.
            - These values are kept in the `defaults` table just before the `onrightclick()` and can 
            be modified.
        - It is possible to reclaim a user's old form by using by using one of the "Revert" functions in a scroll:
            
            batch target @self;oluacf Cumflation-V3,revertInflatorStats

            batch target @self;oluacf Cumflation-V3,revertInflateeStats

            - revertInflatorStats will also be ran automatically when Cumflation is uninstalled or 
            disabled via right-clicking the lua script. Only revertInflateeStats is 
            required to be ran manually this way.

        - Genies will constantly be in a blueballed state.
    v2.0 
        - Refactored much of the script, making it compatible with online play.
        - The script can now be toggled manually by right-clicking the Cumflation script in your inventory 
        - Absorbing the cum after a minute now causes muscle growth
        - Added an "Uninstall" function that cleanly reverts and uninstalls the mod.
    v1.0 
        - Initial release
]]

--[[ Important Data Flags - Reference these in your other scripts, if needed

            -- CF-Active - If the cumflation script is active
            
            -- CF-Blueballed - If the active script holder has blue balls
            
            -- CF-InflatorOrgStats - The original stats of the 'top' before
            adjustments, usually just meaning the original's ball size.
            Given at script activation, and reverted at deactivation.

            -- CF-Inflated - Given to the 'bottom', marks whether the script has
            been passed on to their inventory, and the timer to absorb their cum
            has started

            -- CF-InflateeOrgStats - The original stats of the 'bottom' before 
            adjustments for cumflation and muscle growth. This references properties
            related to bodyfat, muscle and belly size. This is given at the first
            'pulse' of cumflation, but remains indefinitely until the user casts:
            revertInflateeStats() on them.

]]
    
--Constants 
local SCRIPT_NAME = "Cumflation-V3"
local CF_GROWTH_RATE = 0.25

--Inflator/Inflatee target 
local target = nil 

--Timers 
local ABSORB_WAIT_LIMIT = 60 
local absorbTimer = 0 

local SOUND_WAIT_LIMIT = 120
local soundTimer = 0
local soundRandWait = 0

local sexActFilter = {
    [4] = true, --BedFap1
    [6] = true, --HandJob1
    [7] = true, --FloorFap1 
    [10] = true --FloorLineFap1
}

--[[These are the values an orc's physical properties will be set to 
if they're above a certain threshold. Obviously a growth scrippt cannot work 
if you are always at the max possible size 24/7...

A copy of your original stats will be saved, and can be re-applied once the 
uninstall() or one of the revert functions are used.
]]
local defaults = { 
    ["ballsize"] = 0.5,
    ["bodyfat"] = 0,
    ["extrabelly"] = 0,
    ["height"] = 0.75,
    ["muscle"] = 0.65,
    ["extrabutt"] = 0,
    ["extralats"] = 0,
    ["extralegs"] = 0,
    ["extrapecs"] = 0,
    ["nipplesize"] = 0
}

function onrightclick()

    --Toggle the script on and off 
    if not orc.hasitemflag("CF-Active", "@any") or 
        orc.ifitemflag("CF-Active", "false") then 

            saveInflatorStats()
            orc.setitemflag("CF-Active", "true")
            orc.setitemflag("CF-Blueballed", "false")
            orc.luaiterator(SCRIPT_NAME, "inflator", orc.infinity)

            orc.say("Cumflation activated.")

            CFdebug("onrightclick", "Cumflation has been activated.")

    elseif orc.ifitemflag("CF-Active", "true") then 

        revertInflatorStats()
        orc.setitemflag("CF-Active", "false")
        orc.setitemflag("CF-Blueballed", "false")
        orc.remiterators(SCRIPT_NAME, "inflator")

        orc.say("Cumflation has been deactivated.")

        CFdebug("onrightclick", "Cumflation has been stopped.")

    end

end

function saveInflatorStats() 

    --[[Save two flags: The inflator's original stats, and 
    their adjusted stats if above certain limits.]]


    local stats = ""
    
    stats = stats .. orc.ballsize                   --[[1]]
    if orc.ballsize > defaults["ballsize"] then  
        orc.ballsize = defaults["ballsize"]
    end 

    if not orc.hasitemflag("CF-InflatorOrgStats", "@any") then 
        orc.setitemflag("CF-InflatorOrgStats", stats)
    end

    CFdebug("saveInflatorStats", "Attempted to save InflatorStats." .. 
            "\n\tOriginal Ball Size: " .. stats ..
            "\n\tAdjusted: " .. defaults["ballsize"])

end

function inflator()

    if not orc.ifitemflag("CF-Active", "true") then return end

    blueballOverTime()

end

function blueballOverTime()
    
    --[[Grow this orc's balls over time when meios is full, 
    and make them leak when they reach the max size.]]

    -- Genies will always have blue balls
    if orc.corruption == 0 then 
        if orc.meios < 8 and orc.ifitemflag("CF-Blueballed", "false") then
            return 
        end
    end

    if not orc.ifitemflag("CF-Blueballed", "true") then 
        orc.setitemflag("CF-Blueballed", "true")
       CFdebug("blueballOverTime", orc.orcname .. " is getting blue balled.")
    end

    --Start teh growths 
    local rateOverTime = (CF_GROWTH_RATE * orc.game.deltatime) / 4

    orc.arousal = orc.game.movetowards(orc.arousal, 1.0, rateOverTime * 2)
    orc.ballsize = orc.game.movetowards(orc.ballsize, 2.0, rateOverTime)

    --Cum periodically
    if canLeak() then 
        orc.cum() 
        drainBalls()
    end

    --Moan periodically
    soundTimer = soundTimer + orc.game.deltatime
    if soundTimer > soundRandWait then 
        orc.sounddeepbreath(0.5)
        soundTimer = 0
        soundRandWait = orc.game.randomint(0,SOUND_WAIT_LIMIT)
    end

    --If meios drops below 8 from doing stuff
    if hasBeenRelieved() then 
        lostBlueballed()
    end

    --If meios drops before 4. For cases where if the top bottoms through anything else.   
    --At least until I come up with a better way to fix this. 
    if orc.meios < 4 and (not orc.issexing or not orc.isfapping or orc.corruption == 0 ) then 
        lostBlueballed()
    end

end

function canLeak() 
    return orc.ballsize >= 2.0 and orc.meios >= 12 and not orc.issexing
end

function hasBeenRelieved()
    return  orc.meios < 8 and 
            (orc.afterglowing or orc.isfapping or sexActFilter[orc.sextype])

end

function lostBlueballed() 

    --Genies will never lose blueballs
    if orc.corruption > 0 then return end

    orc.setitemflag("CF-Blueballed", "false")
    resetTimers()
    CFdebug("blueballOverTime", orc.orcname .. " lost Blueballed status.")
end

function oncum()

    --[[Each cumshot should grow the inflatee's belly a little bit, but 
    only while in the Blueballed state.]]

    if not orc.ifitemflag("CF-Blueballed", "true") then return end 

    if orc.issexing and sexActFilter[orc.sextype] == nil and orc.sextop then 
        cumflate()
    end

    if orc.isfapping or sexActFilter[orc.sextype] then 
        drainBalls()
    end

end

function drainBalls()

    --Genies never have their balls drained.
    if orc.corruption > 0 then return end 

    local rateOverTime = (CF_GROWTH_RATE * orc.game.deltatime)

    --Drain the top's balls
    orc.ballsize = orc.game.movetowards(orc.ballsize, defaults["ballsize"], rateOverTime * 8)

end

function cumflate()

    --Grab the target this orc is interacting with 
    target = orc.orcobjective
    if target == nil then 
        return 
    end 

    --Only do this if the top can actually copy lua scripts to the target.
    if not orc.canaffect(orc, target) then return end

    if (orc.sextype == target.sextype) and target.penetrated then 

        --Copy Cumflation to the target if they do not have it
        if not target.ifitemflag("CF-Inflated", "true") then 

            if not target.hasluascript(SCRIPT_NAME) then 
                orc.luacopyover(orc, target, SCRIPT_NAME)

                ----Grab the inflatee's stats
                target.luacallfunction(SCRIPT_NAME, "saveInflateeStats")

            end

            --Start the inflatee iterator 
            target.setitemflag("CF-Inflated", "true")

            target.luaiterator(SCRIPT_NAME, "inflatee", orc.infinity)

            CFdebug("inflator", "Copied Cumflation to " .. target.orcname)

        end

        drainBalls()

        local rateOverTime = (CF_GROWTH_RATE * orc.game.deltatime) * 4

        --Reset the bottom's absorption rate per cum shot 
        target.luacallfunction(SCRIPT_NAME, "resetTimers")

        --Grow the bottom's  belly 
        target.bodyfat = target.game.movetowards(target.bodyfat, 0.65, rateOverTime)
        target.extrabelly = target.game.movetowards(target.extrabelly, 1.0, rateOverTime)
        target.extrapecs = target.game.movetowards(target.extrapecs, 1.0, rateOverTime)
        target.extrabutt = target.game.movetowards(target.extrabutt, 1.0, rateOverTime)

    end

end

function saveInflateeStats() 

    --Save the orc's original stats and adjusted stats. 

    if orc.hasitemflag("CF-InflateeOrgStats", "@any") then 
        return 
    end

    local stats = ""
    local statsLog = "Attempted to save InflateeStats:"

    stats = stats .. orc.bodyfat .. ";"        --[1]
    statsLog = statsLog .. "\n\t\tBodyfat: " .. orc.bodyfat .. ", Adjusted: " .. defaults["bodyfat"]
    if orc.bodyfat > defaults["bodyfat"] then 
        orc.bodyfat = defaults["bodyfat"]
    end


    stats = stats .. orc.extrabelly .. ";"        --[2]
    statsLog = statsLog .. "\n\t\tExtBelly: " .. orc.extrabelly .. ", Adjusted: " .. defaults["extrabelly"]
    if orc.extrabelly > defaults["extrabelly"] then 
        orc.extrabelly = defaults["extrabelly"]
    end

    
    stats = stats .. orc.height .. ";"        --[3]
    statsLog = statsLog .. "\n\t\tHeight: " .. orc.height .. ", Adjusted: " .. defaults["height"]
    if orc.height > defaults["height"] then 
        orc.height = defaults["height"]
    end


    stats = stats .. orc.muscle .. ";"        --[4]
    statsLog = statsLog .. "\n\t\tMuscle: " .. orc.muscle .. ", Adjusted: " .. defaults["muscle"]
    if orc.muscle > defaults["muscle"] then 
        orc.muscle = defaults["muscle"]
    end


    stats = stats .. orc.extrabutt .. ";"        --[5]
    statsLog = statsLog .. "\n\t\tExtButt: " .. orc.extrabutt .. ", Adjusted: " .. defaults["extrabutt"]
    if orc.extrabutt > defaults["extrabutt"] then 
        orc.extrabutt = defaults["extrabutt"]
    end


    stats = stats .. orc.extralats .. ";"        --[6]
    statsLog = statsLog .. "\n\t\tExtLats: " .. orc.extralats .. ", Adjusted: " .. defaults["extralats"]
    if orc.extralats > defaults["extralats"] then 
        orc.extralats = defaults["extralats"]
    end


    stats = stats .. orc.extralegs .. ";"        --[7]
    statsLog = statsLog .. "\n\t\tExtLegs: " .. orc.extralegs .. ", Adjusted: " .. defaults["extralegs"]
    if orc.extralegs > defaults["extralegs"] then 
        orc.extralegs = defaults["extralegs"]
    end


    stats = stats .. orc.extrapecs .. ";"        --[8]
    statsLog = statsLog .. "\n\t\tExtPecs: " .. orc.extrapecs .. ", Adjusted: " .. defaults["extrapecs"]
    if orc.extrapecs > defaults["extrapecs"] then 
        orc.extrapecs = defaults["extrapecs"]
    end


    stats = stats .. orc.nipplesize       --[9]
    statsLog = statsLog .. "\n\t\tNipples: " .. orc.nipplesize .. ", Adjusted: " .. defaults["nipplesize"]
    if orc.nipplesize > defaults["nipplesize"] then 
        orc.nipplesize = defaults["nipplesize"]
    end


    orc.setitemflag("CF-InflateeOrgStats", stats)


    CFdebug("saveInflatorStats", statsLog)

end

function inflatee()

    absorbCumOverTime()

end

function absorbCumOverTime()

    --Absorb cum and induce muscle growth.
    if absorbTimer < ABSORB_WAIT_LIMIT then 
        absorbTimer = absorbTimer + orc.game.deltatime
        return 
    end

    local rateOverTime = CF_GROWTH_RATE * orc.game.deltatime

    if orc.bodyfat > defaults["bodyfat"] or orc.extrabelly > defaults["extrabelly"] then 

        local absorbRate = rateOverTime / 6
        orc.bodyfat = orc.game.movetowards(orc.bodyfat, defaults["bodyfat"], absorbRate)
        orc.extrabelly = orc.game.movetowards(orc.extrabelly, defaults["extrabelly"], absorbRate)

        local muscleRate = rateOverTime /  10

        orc.height = orc.game.movetowards(orc.height, 1.5, muscleRate)
        orc.muscle = orc.game.movetowards(orc.muscle, 1.0, muscleRate)
        orc.extrabutt = orc.game.movetowards(orc.extrabutt, 1.0, muscleRate)
        orc.extralats = orc.game.movetowards(orc.extralats, 1.0, muscleRate)
        orc.extralegs = orc.game.movetowards(orc.extralegs, 1.0, muscleRate)
        orc.extrapecs = orc.game.movetowards(orc.extrapecs, 1.0, muscleRate)
        orc.nipplesize = orc.game.movetowards(orc.nipplesize, 1.0, muscleRate)

    end

    --Stop the iterator
    if cumAbsorbed() then 

        CFdebug("absorbCumOverTime", "Cum absorbed.")

        orc.remiterators(SCRIPT_NAME, "inflatee") 
        orc.remitemflag("CF-Inflated")
        if not orc.ifitemflag("CF-Active", "true") then 
            orc.remscript(SCRIPT_NAME)
            CFdebug("absorbCumOverTime", "Deleting script from inflatee's inventory")
        end
    end

end

function cumAbsorbed() 

    return (orc.bodyfat <= defaults["bodyfat"] and 
            orc.extrabelly <= defaults["extrabelly"])

end

function resetTimers()

    absorbTimer = 0

    soundTimer = 0
    soundRandWait = 0

end

function revertInflatorStats()

    local inflatorStats = splitString(orc.itemflagstring("CF-InflatorOrgStats"))
    if inflatorStats == nil then 
        CFdebug("revertInflatorStats", orc.orcname .. "'s Inflator stats cannot be found, cancelling.")
        orc.consolecommand("infodialogue This orc's original stats are missing. Cannot revert them.")
        return 
    end 

    orc.ballsize = tonumber(inflatorStats[1])

    orc.remitemflag("CF-InflatorOrgStats")
    CFdebug("revertInflatorStats", "Inflator stats reverted and flag deleted.")


end

function revertInflateeStats()

    --Required to be called manually. Restores an orc's form back to 
    --normal using the Inflator and or Inflatee's stats, if they exist.

    local target = orc.orcobjective
    if target == nil then 
        CFdebug("revertInflateeStats", orc.orcname .. "'s tried to revert a target's stats, but they weren't found.")
        orc.say("I have no target...")
        return 
    end

    if not target.hasitemflag("CF-InflateeOrgStats", "@any") then 
        CFdebug("revertInflateeStats", target.orcname .. "' does not have the inflatee's stats.")
        orc.say("They haven't been cumflated.")
        return 
    end


    local inflateeStats = splitString(target.itemflagstring("CF-InflateeOrgStats"))
    if inflateeStats == nil then 
        CFdebug("revertInflateeStats", target.orcname .. "'s Inflatee stats cannot be found, cancelling.")
        orc.consolecommand("infodialogue This orc's original stats are missing. Cannot revert them.")
        return 
    end 

    target.bodyfat = tonumber(inflateeStats[1])
    target.extrabelly = tonumber(inflateeStats[2])
    
    target.height = tonumber(inflateeStats[3])
    target.muscle = tonumber(inflateeStats[4])
    target.extrabutt = tonumber(inflateeStats[5])
    target.extralats = tonumber(inflateeStats[6])
    target.extralegs = tonumber(inflateeStats[7])
    target.extrapecs = tonumber(inflateeStats[8])
    target.nipplesize = tonumber(inflateeStats[9])

    target.remitemflag("CF-InflateeOrgStats")
    CFdebug("revertInflateeStats", "Inflatee stats reverted and flag deleted.")

end

function uninstall()

    CFdebug("uninstall", "Removing data flags, reverting stats, and uninstalling Cumflation")

    orc.remitemflag("CF-Active")
    orc.remitemflag("CF-Blueballed")
    orc.remitemflag("CF-Inflated")
    revertInflatorStats()
    revertInflateeStats()

    orc.remscript(SCRIPT_NAME)

end

function splitString(inputstr)
    --Splits the old stats flag and returns a table of values.

    if inputstr == nil or inputstr == "" then 

        CFdebug("splitString","inputstr is nil. Attempting to cancel...")

        --If inputstr is nil, then something wrong happened to the
        --OldStats flag. UNINSTALL IMMEDIATELY!
        orc.game.infodialogue(orc.orcname .. " has lost his original Cumflation flags. Cannot revert.")

        return nil
    end
    
    local sep = ";"
    local t = {}

    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t,str)
    end

    return t
end

function CFdebug(functionName, text) 
    -- Print debugging messages out to the console
    orc.debuglog( SCRIPT_NAME .. ", " .. functionName .. "() on " .. orc.orcname .. ":\n\t" .. text)
end