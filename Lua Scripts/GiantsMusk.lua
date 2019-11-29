--[[

    The Giant's Musk. When the user gets excited enough, they'll begin to sweat
    and the musk will start to grow them and all orcs around them.

]]

--This orc has been "musked" already, so don't try to re-inject the script.
orc.setitemflag("GM-Musked", "1")

local GROWTH_RATE = 0.010
local SHRINK_RATE = 0.015
local BONE_SCALE_GROWTH = 1
local BONE_SCALE_SHRINK = 1

local isMaxed = false
local active = false
local timer = 0
local waitTime = 30.0
local bonusTime = 3.0
local bonusChance = 0.10

--Orignal Stats
local oldHeight = orc.height 
local oldMuscle = orc.muscle
local oldFat = orc.bodyfat
local oldPenisS = orc.penissize
local oldPenisG = orc.penisgirth
local oldBallS = orc.ballsize

function reInit() 
    --Save an orc's current stats as their old form.
    oldHeight = orc.height 
    oldMuscle = orc.muscle
    oldFat = orc.bodyfat
    oldPenisS = orc.penissize
    oldPenisG = orc.penisgirth
    oldBallS = orc.ballsize
end

function start ()

    if orc.istheplayer then 

        --Start growing when the player gets horny...
        if orc.arousal > 0.5 then 

            --Save current shape as old, Initial musk, and reset the timer.
            if active == false then 
                reInit()

                orc.consolecommand("orccallback galaxyParticles")
                orc.consolecommand("buff SweatLesser,15")
                orc.sounddeepbreath(0.5)

                active = true
            end

            --Try and add an extra effect every 3 seconds
            if timer > bonusTime then 
                --Re-apply sweat buff on a random chance
                if math.random() <= bonusChance then
                    orc.consolecommand("orccallback galaxyParticles")
                    orc.consolecommand("buff SweatLesser,15")
                end

                makeSound()

                timer = 0
            end
            timer = timer + orc.game.deltatime

            grow(GROWTH_RATE)

            --Inject all orcs within a 12 meter radius and activate the macro.
            local nearest = orc.findclosest(12)
            if nearest ~= nil then 

                if nearest.ifitemflag("GM-Musked", "1") == false then
                    orc.consolecommand("aoecmd macrocopy @playername,@self,GiantsMusk\\0\\12\\0")
                    orc.consolecommand("aoecmd macroexec GiantsMusk\\0\\12\\0")
                end
            end

        --...Or shrink him back to normal after 30 seconds have passed.
        else 
            if active then 
                timer = timer + orc.game.deltatime
                if timer > waitTime then 
                    shrink(SHRINK_RATE)
                end
            end
        end
    
    --Any bystanders will grow while the player is horny.
    else
        orc.orcobjset('@playername')
        if orc.orcobjective ~= nil and (orc.distancetoobjective <= 12 and orc.orcobjective.arousal > 0.5) then 
            if active == false then 
                reInit()            

                orc.sounddeepbreath(0.5)

                active = true
                timer = 0
            end 

            orc.arousal = 1
            grow(GROWTH_RATE)

            if timer > bonusTime then 
                makeSound()

                timer = 0
            end
            timer = timer + orc.game.deltatime

        else 
            --Shrink after 30 seconds, and remove the script from this bystander's inventory.
            if active then 
                timer = timer + orc.game.deltatime
                if timer > waitTime then 
                    shrink(SHRINK_RATE)
                    if active == false then 
                        orc.setitemflag("GM-Musked", "0")
                        orc.consolecommand("oluaria GiantsMusk,start")
                        orc.consolecommand("oluarem GiantsMusk")
                    end

                end
            end
        end
    end
end

function makeSound() 
    --Occasionally make the player cum to bring their arousal back to 100
    if math.random() <= bonusChance + 0.05 then
        orc.cum()
    end

    --Randomy make noises
    if math.random() <= bonusChance then
        orc.sounddeepbreath(0.5)
    end

    if math.random() <= bonusChance then 
        orc.sounddeepbreathlesser(0.5)
    end

    if math.random() <= bonusChance then
        orc.soundtimpani(0.5)
    end

    if math.random() <= bonusChance then 
        orc.soundbrass(0.5)
    end
end

function grow(rate) 
    --Grow over time

    local rateOverTime = orc.game.deltatime * rate

    orc.height = orc.height + rateOverTime
    orc.muscle = orc.muscle + rateOverTime
    orc.bodyfat = orc.bodyfat + rateOverTime
    orc.penissize = orc.penissize + rateOverTime
    orc.penisgirth = orc.penisgirth + (rateOverTime * 5)
    orc.ballsize = orc.ballsize + (rateOverTime * 5)


    --Start scaling the bones if every thing else is maxed.
    if  orc.height >= 1 and 
        orc.muscle >= 1 and 
        orc.penissize >= 1 and 
        orc.penisgirth >= 4 and 
        orc.ballsize >= 2 then 

        scaleBones( (rateOverTime / 2) ) 
    end
end

function shrink(rate) 
    --Shrink over time and deactivate if the old stats have been reached

    local rateOverTime = orc.game.deltatime * rate 

    if orc.height > oldHeight then 
        orc.height = orc.height - rateOverTime
    end
    
    if orc.muscle > oldMuscle then 
        orc.muscle = orc.muscle - rateOverTime
    end

    if orc.bodyfat > oldFat then 
        orc.bodyfat = orc.bodyfat - rateOverTime
    end

    if orc.penissize > oldPenisS then 
        orc.penissize = orc.penissize - rateOverTime
    end

    if orc.penisgirth > oldPenisG then 
        orc.penisgirth = orc.penisgirth - (rateOverTime * 5)
    end

    if orc.ballsize > oldBallS then 
        orc.ballsize = orc.ballsize - (rateOverTime * 5)
    end

    scaleBones( - (rateOverTime / 2))

    if  orc.height <= oldHeight and 
        orc.muscle <= oldMuscle and 
        orc.bodyfat <= oldFat and
        orc.penissize <= oldPenisS and 
        orc.penisgirth <= oldPenisG and 
        orc.ballsize <= oldBallS and
        BONE_SCALE_GROWTH <= 1 and 
        BONE_SCALE_SHRINK <= 1 then 
            active = false
            timer = 0
    end
end


function scaleBones(rot) 
--Slowly scale the bones on top of the regular growth

    if BONE_SCALE_GROWTH >= 1 and BONE_SCALE_GROWTH <= 1.5 then
        orc.consolecommand("cbt gen,".. BONE_SCALE_GROWTH ..",false")
        orc.consolecommand("cbt spine1,".. BONE_SCALE_GROWTH ..",true")
    end

    if BONE_SCALE_GROWTH >= 1 and BONE_SCALE_GROWTH <= 1.3 then
        orc.consolecommand("batch cbt shoulderl,"..  BONE_SCALE_GROWTH ..",true;cbt shoulderr,"..  BONE_SCALE_GROWTH ..",true;")
        orc.consolecommand("batch cbt bicepl,"..  BONE_SCALE_GROWTH ..",true;cbt bicepr,"..  BONE_SCALE_GROWTH ..",true;")
    end

    if BONE_SCALE_GROWTH >= 1 and BONE_SCALE_GROWTH <= 1.2 then
        orc.consolecommand("batch cbt buttl,"..  BONE_SCALE_GROWTH ..",true;cbt buttr,"..  BONE_SCALE_GROWTH ..",true;")
        orc.consolecommand("batch cbt pelvis,"..  BONE_SCALE_GROWTH ..",false;")
    end

    if BONE_SCALE_GROWTH >= 1 and BONE_SCALE_GROWTH <= 1.15 then
        orc.consolecommand("batch cbt clavl,"..  BONE_SCALE_GROWTH ..",true;cbt clavr,"..  BONE_SCALE_GROWTH ..",true;")
        orc.consolecommand("batch cbt spine3,"..  BONE_SCALE_GROWTH ..",true;")
    end

    if BONE_SCALE_GROWTH >= 1 and BONE_SCALE_GROWTH <= 1.1 then
        orc.consolecommand("batch cbt neck1,"..  BONE_SCALE_GROWTH ..",true;cbt neck2,"..  BONE_SCALE_GROWTH ..",true;")
    end

    if BONE_SCALE_GROWTH >= 1 and BONE_SCALE_GROWTH <= 1.05 then 
        orc.consolecommand("cbt spine2,".. BONE_SCALE_GROWTH ..",true")
    end

    if BONE_SCALE_SHRINK >= 0.85 and BONE_SCALE_GROWTH <= 1 then 
        orc.consolecommand("batch cbt thighl,"..  BONE_SCALE_SHRINK ..",false;cbt thighr,"..  BONE_SCALE_SHRINK ..",false;") 
    end

    BONE_SCALE_GROWTH = BONE_SCALE_GROWTH + rot
    BONE_SCALE_SHRINK = BONE_SCALE_SHRINK - rot

    --Clamp the values
    if BONE_SCALE_GROWTH > 1.5 then 
        BONE_SCALE_GROWTH = 1.5
    elseif BONE_SCALE_GROWTH < 1 then 
        BONE_SCALE_GROWTH = 1
    end

    if BONE_SCALE_SHRINK < 0.85 then 
        BONE_SCALE_SHRINK = 0.85
    elseif BONE_SCALE_SHRINK > 1 then 
        BONE_SCALE_SHRINK = 1
    end
end
