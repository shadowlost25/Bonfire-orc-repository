--[[ Cumflation-Simplified -- by coldbubu

  Deleted the commands for forcing the Top's size to change, and also deleted the commands related to meios properties.

  Now starting Lua will no longer change the Top's shape. No matter what the state of Top is, it will default to blueballed state.

  Now, except for the belly, other parts of the Bottom will not be forced to change. The inflated orc will absorb the cum after a set period of time and restore belly shape.

  After using commands of Scoll to call out the Lua script, you still need to right-click to start Lua correctly.

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

local SCRIPT_NAME = "Cumflation-Simplified"
local CF_GROWTH_RATE = 0.75

local target = nil 

--Timers 
local ABSORB_WAIT_LIMIT = 240 
local absorbTimer = 0 


local sexActFilter = {
    [4] = true, --BedFap1
    [6] = true, --HandJob1
    [7] = true, --FloorFap1 
    [10] = true --FloorLineFap1
}

local defaults = { 

    ["extrabelly"] = 0,

}


function onrightclick()

    --Toggle the script on and off 
    if not orc.hasitemflag("CF-Active", "@any") or 
        orc.ifitemflag("CF-Active", "false") then 

            orc.setitemflag("CF-Active", "true")
            orc.setitemflag("CF-Blueballed", "true")
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


function inflator()

    if not orc.ifitemflag("CF-Active", "true") then return end

end


function oncum()

    --[[Each cumshot should grow the inflatee's belly a little bit, but 
    only while in the Blueballed state.]]

    if orc.issexing and sexActFilter[orc.sextype] == nil and orc.sextop then 
        cumflate()
    end

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

        local rateOverTime = (CF_GROWTH_RATE * orc.game.deltatime) * 4

        --Reset the bottom's absorption rate per cum shot 
        target.luacallfunction(SCRIPT_NAME, "resetTimers")

        --Grow the bottom's  belly 
        target.extrabelly = target.game.movetowards(target.extrabelly, 1.0, rateOverTime)

    end

end

function saveInflateeStats() 

    --Save the orc's original stats and adjusted stats. 

    if orc.hasitemflag("CF-InflateeOrgStats", "@any") then 
        return 
    end

    local stats = ""
    local statsLog = "Attempted to save InflateeStats:"


    stats = stats .. orc.extrabelly .. ";"        --[2]
    statsLog = statsLog .. "\n\t\tExtBelly: " .. orc.extrabelly .. ", Adjusted: " .. defaults["extrabelly"]
    if orc.extrabelly > defaults["extrabelly"] then 
        orc.extrabelly = defaults["extrabelly"]
    end


    orc.setitemflag("CF-InflateeOrgStats", stats)


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

    if orc.extrabelly > defaults["extrabelly"] then 

        local absorbRate = rateOverTime / 6

        orc.extrabelly = orc.game.movetowards(orc.extrabelly, defaults["extrabelly"], absorbRate)


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

    return (orc.extrabelly <= defaults["extrabelly"])

end

function resetTimers()

    absorbTimer = 0

end

function revertInflatorStats()

    local inflatorStats = splitString(orc.itemflagstring("CF-InflatorOrgStats"))
    if inflatorStats == nil then 
        CFdebug("revertInflatorStats", orc.orcname .. "'s Inflator stats cannot be found, cancelling.")
        orc.consolecommand("infodialogue This orc's original stats are missing. Cannot revert them.")
        return 
    end 

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

    target.extrabelly = tonumber(inflateeStats[2])
    

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