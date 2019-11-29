orc.setitemflag("CF-Flated", "0")

--Constants
local CF_GROWTH_RATE = 0.100    --Standard Rate of grow before mathmatical operations
local WAIT_TIME = 30.0          --Wait time before and orc's balls grow, or before the bottom absorbs the cum
local CUM_LIMIT = 30            --The longest the top will wait before leaking cum
local SOUND_LIMIT = 60          --The longest either orc will wait before moaning.

--Timers
local nearest = nil
local timer = 0

local cumTimer = 0
local cumWait = 0

local soundTimer = 0
local soundWait = 0

--Old stats
local oldFat = orc.bodyfat
local oldEButt = orc.extrabutt
local boneScale = 1

function start()

    --If CF-Flated is 0, this is the top.
    if orc.ifitemflag("CF-Flated","0") then 

        --Get the closest orc
        if nearest == nil then 
            nearest = orc.findclosest(2)

        --Inject a copy of this script into the bottom's inventory.    
        elseif orc.issexing and nearest.issexing then 

            --Fill up the bottom orc.
            if orc.cumming and orc.ifitemflag("CF-Blueballed","1") then 

                if (nearest.hasitemflag("CF-Flated", "@any") == false)  then 
                    
                        orc.luacopyover(orc,nearest,'Cumflation')
                        nearest.setitemflag("CF-Flated", "1")
                        nearest.luaiterator('Cumflation','start',orc.infinity)
                end

                --Reset the timer
                timer = 0
                soundWait = 0
                cumWait = 0

                --Empty and shrink the top's balls.
                local rateOverTime = (CF_GROWTH_RATE * orc.game.deltatime) / 1.5
                if boneScale > 1 then
                    orc.consolecommand("cbt gen," .. boneScale .. ",true")
                    boneScale = boneScale - rateOverTime
                else
                   orc.consolecommand("removescriptflag CF-Blueballed") 
                end
            end
        else 
            nearest = nil
        end

        --Grow this orc's balls over time and make them leak when they reach max size.
        timer = timer + orc.game.deltatime
        if timer > WAIT_TIME then

            orc.setitemflag("CF-Blueballed","1")

            local rateOverTime = (CF_GROWTH_RATE * orc.game.deltatime) / 8

            if boneScale <= 1.5 then
                orc.consolecommand("cbt gen," .. boneScale .. ",true")
                boneScale = boneScale + rateOverTime
            end

            if boneScale >= 1.5 and orc.issexing == false then 

                cumTimer = cumTimer + orc.game.deltatime
                if cumTimer >= cumWait then
                    orc.cum();
                    cumTimer = 0
                    cumWait = orc.game.randomint(0,CUM_LIMIT)
                end

            end

            soundTimer = soundTimer + orc.game.deltatime
            if soundTimer >= soundWait then 
                orc.sounddeepbreath(0.5)
                soundTimer = 0
                soundWait = orc.game.randomint(0,SOUND_LIMIT)
            end

        end

    --If CF-Flated is 1, this is the bottom.
    elseif orc.ifitemflag("CF-Flated","1") then 

        if nearest == nil then 
            nearest = orc.findclosest(2)
        
        --Inflate when the top starts cumming.
        elseif orc.issexing and nearest.issexing then 

            --Reset shrink timer
            timer = 0
            soundWait = 0

            if nearest.cumming and nearest.ifitemflag("CF-Blueballed","1")then 
                local rateOverTime = (CF_GROWTH_RATE * orc.game.deltatime) / 2
                orc.bodyfat = orc.bodyfat + rateOverTime
                orc.extrabutt = orc.extrabutt + rateOverTime
                
                if boneScale <= 1.5 then
                    orc.consolecommand("cbt spine1," .. boneScale .. ",true")
                end

                if boneScale <= 1.15 then
                    orc.consolecommand("cbt spine3," .. boneScale .. ",true")
                end

                if boneScale <= 1.05 then 
                    orc.consolecommand("cbt spine2," .. boneScale .. ",true")
                end

                if boneScale <= 1.5 then 
                    boneScale = boneScale + rateOverTime
                end
            end

        else 
            nearest = nil 
        end

        --Shrink after not being filled for 30 seconds
        timer = timer + orc.game.deltatime
        if timer > (WAIT_TIME * 2) then
            shrink()
        end
        
    end
end

function shrink()

    local rateOverTime = (CF_GROWTH_RATE * orc.game.deltatime) / 10
    if orc.bodyfat > oldFat then 
        orc.bodyfat = orc.bodyfat - rateOverTime
    end

    if orc.extrabutt > oldEButt then 
        orc.extrabutt = orc.extrabutt - rateOverTime
    end

    if boneScale <= 1.5 then 
        orc.consolecommand("cbt spine1," .. boneScale .. ",true")
    end

    if boneScale <= 1.15 then 
        orc.consolecommand("cbt spine3," .. boneScale .. ",true")
    end

    if boneScale <= 1.05 then 
        orc.consolecommand("cbt spine2," .. boneScale .. ",true")
    end

    if boneScale > 1 then 
        boneScale = boneScale - rateOverTime
    end

    soundTimer = soundTimer + orc.game.deltatime
    if soundTimer >= soundWait then 
        orc.soundbrass(0.5)
        soundTimer = 0
        soundWait = orc.game.randomint(0,SOUND_LIMIT)
    end

    --When the scale is back to normal, delete this script.
    if orc.bodyfat <= oldFat and 
        orc.extrabutt <= oldEButt and 
        boneScale <= 1 then 
        orc.consolecommand("removescriptflag CF-Flated")
        orc.consolecommand("oluarem Cumflation")
    end

end