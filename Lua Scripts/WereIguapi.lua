--[[ WereIguapi -- by quarfein

Report any bug you might find while using this to quarfein on Discord

To use this script, follow these steps:
- In Bonfire, go to Options > System > Open LUA Scripts Location, and slide this file in the window opening.
- In game, press F1 ton open the console, and type "oluainj WereIguapi", and then enter.
- Once the script is injected, go to your inventory, in the lua script tab, and right click the script.

At any moment this script is used, it can be right clicked again to be turned off. You will recover all your normal functions, your original shape, etc.

THIS SCRIPT USES THE NATTY COMMAND TO WORK, IT WILL DISRUPT YOUR REGISTERED NATURAL SHAPE.

The use of this script is to essentially turn you into a Were Iguapi at night. Bigger, fiercer all over. During day, your usual form will be brought back.
In the bath house, the time being always midnight will reveal your nature to everyone. Passing through doors, stopping the script etc, while transforming is safe.

When cursed (script activated, whether in your iguapi shape or not), topping and cumming in orcs will curse them too. A copy of the script will be injected into them. They can turn it off and never worry about it again.
If an orc curses three people, he will turn into an alpha. Alphas have an all white/grey coat, have their iguapi shape permanently (can be reversed by turning off the script) and will curse people by cumming near them.
Alphas will get hard when their meios is too high, and cum four times when it reaches 12.

People not having sexual favors activated with you will not be turned or be affected by the script. 

Change notes:
- Nerfed the alpha cursing range from 50 to 12
- Alphas will not roar anymore when cumming from the meios counter, and they will not be able to cum without control if they fap
 ]]

local SCRIPT_NAME = "WereIguapi"
local GROWTH_TIME = 20

function start()
    orc.setitemflag("isBeast", "false")
    orc.setitemflag("isCursed", "false")
    orc.setitemflag("isAlpha", "false")
    orc.setitemflag("turned", 0)
    orc.setitemflag("cursedNumber", 0)
end

function onrightclick()
    if orc.ifitemflag("isCursed", "false") then
        orc.setitemflag("isCursed", "true")
        orc.luaiterator(SCRIPT_NAME, "checkToBeastify", orc.infinity)
        orc.luaiterator(SCRIPT_NAME, "alphaHorny", orc.infinity)
        -- beastify()

    elseif orc.ifitemflag("isCursed", "true") then
        orc.setitemflag("isCursed", "false")
        orc.remiterators(SCRIPT_NAME, "checkToBeastify")
        orc.remiterators(SCRIPT_NAME, "alphaHorny")
        revertBeastify()
    end
end

function checkToBeastify()
    if ((orc.game.daytime >= 19 or orc.game.daytime < 7) or orc.ifitemflag("isAlpha", "true") ) and orc.ifitemflag("isCursed", "true") and orc.ifitemflag("isBeast", "false") then
        beastify()
        if orc.ifitemflag("isAlpha", "true") then
            alphaMarks()
        end
    elseif (orc.game.daytime < 19 and orc.game.daytime > 7) and orc.ifitemflag("isCursed", "true") and orc.ifitemflag("isBeast", "true") and not orc.ifitemflag("isAlpha", "true") then
        revertBeastify()
    end
        
end

function beastify()
    if orc.ifitemflag("isBeast", "false") then
        saveStats()
	end
    orc.horns = 1
    orc.arousal = 0

    orc.setitemflag("isBeast", "true")

    orc.setitemflag("cumAfterBeastify", "true")

    orc.luaiterator(SCRIPT_NAME, "beastGrow", GROWTH_TIME)

	orc.sounddeepbreath(0.5)

end

function beastGrow()

    local growthRate = (orc.game.deltatime * 0.25) / (GROWTH_TIME * 0.4)

    if orc.ifitemflag("cumAfterBeastify", "true") then

        orc.setitemflag("turned", orc.game.movetowards(orc.itemflagfloat("turned"), 1, growthRate))

        orc.tusksize = orc.game.movetowards(orc.tusksize, 1, growthRate)
        orc.coatdensity = orc.game.movetowards(orc.coatdensity, 1, growthRate)
        orc.bodyhair = orc.game.movetowards(orc.bodyhair, 1, growthRate)
        orc.footsize = orc.game.movetowards(orc.footsize, 1, growthRate)
        orc.handgirth = orc.game.movetowards(orc.handgirth, 1, growthRate)
        orc.earshape = orc.game.movetowards(orc.earshape, .1, growthRate)
        orc.extrabelly = orc.game.movetowards(orc.extrabelly, 1, growthRate)
        orc.extrabutt = orc.game.movetowards(orc.extrabutt, 1, growthRate)
        orc.extralats = orc.game.movetowards(orc.extralats, 1, growthRate)
        orc.extralegs = orc.game.movetowards(orc.extralegs, 1, growthRate)
        orc.extrapecs = orc.game.movetowards(orc.extrapecs, 1, growthRate)
        orc.muscle = orc.game.movetowards(orc.muscle, 1, growthRate)
        orc.bodyfat = orc.game.movetowards(orc.bodyfat, 0.5, growthRate / 2)
        orc.ballsize = orc.game.movetowards(orc.ballsize, 2, growthRate * 2)
        orc.headcrown = orc.game.movetowards(orc.headcrown, 0.5, growthRate / 2)
        orc.height = orc.game.movetowards(orc.height, 1.5, growthRate * 1.5)
        orc.jawsize = orc.game.movetowards(orc.jawsize, 1, growthRate)
        orc.nipplesize = orc.game.movetowards(orc.nipplesize, 1, growthRate)
        orc.lipgirth = orc.game.movetowards(orc.lipgirth, 1, growthRate)
        orc.snout = orc.game.movetowards(orc.snout, 1, growthRate)
        orc.penisextra = orc.game.movetowards(orc.penisextra, 1, growthRate)
        orc.penisgirth = orc.game.movetowards(orc.penisgirth, 4, growthRate * 4)
        orc.penissize = orc.game.movetowards(orc.penissize, 1, growthRate)
        orc.penisshower = orc.game.movetowards(orc.penisshower, 1, growthRate)
        orc.arousal = orc.game.movetowards(orc.arousal, 1, growthRate * (GROWTH_TIME / 9))
    end

    if orc.arousal > 0.95 and orc.ifitemflag("turned", 1) and orc.ifitemflag("cumAfterBeastify", "true") then
        orc.cum()
        -- orc.sounddeepbreath(1)
        orc.consolecommand("emote roar")
        orc.setitemflag("cumAfterBeastify", "false")
    end

end

function saveStats()
    orc.consolecommand("resnatty")
end

function revertBeastify()
    orc.remiterators(SCRIPT_NAME, "beastGrow")
    orc.setitemflag("isBeast", "false")
    orc.setitemflag("turned", 0)
    orc.consolecommand("natty")
end

function oncum()
    if orc.ifitemflag("isCursed", "true") and orc.sextop and orc.findclosest(5).issexing then
        target = orc.findclosest(2)
        curseAttempt(target)
    elseif orc.ifitemflag("isCursed", "true") and orc.ifitemflag("isAlpha", "true") and orc.findclosest(12) != nil then
        target = orc.findclosest(12)
        curseAttempt(target)
    end
    if orc.itemflagfloat("cursedNumber") >= 3 and orc.ifitemflag("isAlpha", "false") then
        turnAlpha()
    end
end

function curseAttempt(target)
    if not target.hasluascript(SCRIPT_NAME) then
        orc.luacopyover(orc, target, SCRIPT_NAME)
        target.luacallfunction(SCRIPT_NAME, "onrightclick")
        orc.setitemflag("cursedNumber", orc.itemflagfloat("cursedNumber") + 1)
    end
end

function turnAlpha()

    orc.setitemflag("isAlpha", "true")

    if orc.ifitemflag("isBeast", "true") then
        alphaMarks()
    end

end

function alphaHorny()
    local growthRate = (orc.game.deltatime * 0.25) / (GROWTH_TIME * 0.4)
    if orc.ifitemflag("isAlpha", "true") then
        if orc.meios >= 10 then
            orc.arousal = orc.game.movetowards(orc.arousal, 1, growthRate * (GROWTH_TIME / 12))
        end
        if orc.meios >= 12 and orc.arousal > 0.95 and not orc.issexing and not orc.isfapping then
            for i=1,4 do orc.cum() end
            orc.sounddeepbreath(1)
        end
    end
end

function alphaMarks()

    for i=1,4 do orc.HairColorB_Set(i, 255, 255, 255, 255) end

end