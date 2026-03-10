    --MuskScriptV2 by pandaemonium/thribby
    --DISCLAIMER: I lifted code from the following scripts' functions: Cumflation-Simplified by coldbubu's onrightclick and TendrilsScript by Buoysel's constantTendrils. The majority of this script is made by repurposing their code. The parts that break the most will likely be mine.

local SCRIPT_NAME = "MuskScriptv2"
local SCRIPT_FLAG = "PD-Musk-Active"
local WAIT_TIME = 10
local timer = 0

function onrightclick()

    --Toggle the script on and off.
    if not orc.hasitemflag(SCRIPT_FLAG, "@any") or 
        orc.ifitemflag(SCRIPT_FLAG, "false") then 

            orc.setitemflag(SCRIPT_FLAG, "true")
            orc.luaiterator(SCRIPT_NAME, "constantMusk", orc.infinity)

            orc.say("Get a whiff of this musk.")
            orc.consolecommand("forceanim Dance4")
            orc.consolecommand("overlay OrcSparkleGalaxyOverlayFiner")

    elseif orc.ifitemflag(SCRIPT_FLAG, "true") then 

        orc.setitemflag(SCRIPT_FLAG, "false")
        orc.remiterators(SCRIPT_NAME, "constantMusk")

        orc.say("Smell ya later.")
            orc.consolecommand("forceanim Gesture Flex1")
            orc.consolecommand("aoecmd buffclear Drool\5\12\1")

    end

end

function constantMusk()

    if timer < WAIT_TIME then 
        timer = timer + orc.game.deltatime
        return
    else 
        timer = 0
    end

    orc.consolecommand("overlay OrcSparkleGalaxyOverlayFiner")
    MuskSniffers()

end


    --orcs nearby the musky orc should drool/get hard/sweat or something. Maybe orcs super close/touching the musky orc could get a temporary musk cloud?

function MuskSniffers()
    --Orcs nearby the musky orc drool.
    if orc.ifitemflag(SCRIPT_FLAG, "true") then 

        local nearest = orc.findclosest(12)

        if nearest ~= nil then

            orc.consolecommand("aoe Drool,10,12,1")
        end

    end

end


    --levels of effects depending on how much clothes the musky orc is wearing?

