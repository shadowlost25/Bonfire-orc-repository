

--[[ Ditto: Makes you transform into a nearby orc for some selfcest fun!

    If used online, you must first either be in PVP mode or have mutual
    consent with your target for this script to work.

    How to use: 

    1. Download the script to your AppData folder at:
    C:\Users\%username%\AppData\LocalLow\Prasetto\Bonfire\Mods\lua

    2. In Bonfire, use the `oluainj` command to inject the script:
    batch target @self;oluainj Ditto

    The script will start running automatically and you will be good to go,
    but for added fun, this script introduces three new console commands:

    3. (optional) Create three blanks scrolls, and paste one of the below commands
    into each:

    Ditto - Toggle. A toggle to enable the transformation. Using this
    after you transform will let you keep your new appearance until you
    toggle the script back on again.:
        batch target @self;oluacf Ditto,toggle

    Ditto - Group Transform. Causes everyone in a 12 meter radius to copy you.
    While a group transformation is in progress, you will not revert to your old form:
        batch target @self;oluacf Ditto,groupTransform

    Ditto - Group Revert. Restores everyone to their last naturally achieved form:
        batch target @self;oluacf Ditto,groupRevert
]]

-- Targetting
local RANGE = 2.5
local lastTarget = nil

-- if the host is a fusion, don't overwrite certain fields
local heightRetained = nil 
local muscleRetained = nil 
local penisSRettained = nil 
local ballsizeRetained = nil
local bodyfatRetained = nil

-- Post-convert corrections timer
local delaytime = 6
local delaytimer = 0

function start()
    orc.setitemflag("Ditto-Enabled", "1")
    orc.setitemflag("Ditto-Transformed", "0")
    orc.setitemflag("Ditto-GroupTransformActive", "0")
    orc.luaiterator("Ditto", "lookForTarget", orc.infinity)
    orc.luaiterator("Ditto", "geniefy", orc.infinity)
end

function toggle()
    --Set whether to copy people or not.
    
    if orc.ifitemflag("Ditto-Enabled", "0") or 
        orc.hasitemflag("Ditto-Enabled", "@any") == false then 

        orc.setitemflag("Ditto-Enabled", "1")       
    else
        orc.setitemflag("Ditto-Enabled", "0")
    end
    
end

function lookForTarget() 

    if orc.ifitemflag("Ditto-Enabled", "1") == false then 
        return 
    end

    orc.getclosest(RANGE)

    if orc.orcobjective == nil or orc.orcobjective ~= lastTarget then 
        revert()
    else
        if orc.canseeorcobjective and orc.distancetoobjective <= RANGE then 
            transform()
        end
    end

    lastTarget = orc.orcobjective

end

function transform()

    -- Don't run this if a group tranformation is active
    if orc.ifitemflag("Ditto-GroupTransformActive", "1") then 
        return 
    end

    --Don't run this online without the other orc's consent
    if not orc.canaffect(orc,orc.orcobjective) then 
        return
    end
    
    --Don't run this if already transformed
    if orc.ifitemflag("Ditto-Transformed", "1") then 
        return 
    else 
        orc.setitemflag("Ditto-Transformed", "1")
    end

    retainFields() 
    orc.consolecommand("convert " .. orc.orcobjective.orcname .. "," .. orc.orcname .. ",3,100")
    orc.luaiterator("Ditto","postConvertCorrection",orc.infinity)

end

function revert()

    -- Don't run this if a group transformation is active
    if orc.ifitemflag("Ditto-GroupTransformActive", "1") then 
        return 
    end

    -- Don't run this if already reverted
    if orc.ifitemflag("Ditto-Transformed", "0") then 
        return 
    else 
        orc.setitemflag("Ditto-Transformed", "0")
    end

    if not orc.isfusion and orc.corruption == 0 then 
        orc.consolecommand("origins")
    end
    
end

function groupTransform() 

    orc.consolecommand("aoecmd convert ".. orc.orcname .. ",@self,5,100\\0\\12")
    orc.consolecommand("aoecmd quickgrow3\\0\\12")
    orc.setitemflag("Ditto-GroupTransformActive", "1")

end

function groupRevert()
    orc.consolecommand("aoecmd natty\\0\\12")
    orc.setitemflag("Ditto-GroupTransformActive", "0")
    revert()
end


function postConvertCorrection() 

    --The convert commmand won't copy all values 1 to 1,
    --So correct the values a few seconds after transforming

    if delaytimer < delaytime then 
        delaytimer = delaytimer + orc.game.deltatime
        return
    else 
        delaytimer = 0
    end

    if lastTarget ~= nil then 

        if not orc.isfusion then 
            -- Let the retained fields override these instead
            orc.height = lastTarget.height
            orc.penisgirth = lastTarget.penisgirth
            orc.ballsize = lastTarget.ballsize
        end

        orc.beardlength = lastTarget.beardlength
        orc.beardstubble = lastTarget.beardstubble
        orc.tusksize = lastTarget.tusksize
        orc.jawsize = lastTarget.jawsize
        orc.lipgirth = lastTarget.lipgirth
        orc.coatdensity = lastTarget.coatdensity

        applyRetained()
    end

    orc.consolecommand("oluaria Ditto,postConvertCorrection")
        
end

function retainFields() 

    -- If the orc is a fusion, don't convert certain fields

    if not orc.isfusion then 
        return 
    end

    if orc.orcobjective.height < orc.height then 
        heightRetained = orc.height
    end

    if orc.orcobjective.muscle < orc.muscle then 
        muscleRetained = orc.muscle
    end

    if orc.orcobjective.penissize < orc.penissize then 
        penisSRettained = orc.penissize 
    end

    if orc.orcobjective.ballsize < orc.ballsize then 
        ballsizeRetained = orc.ballsize
    end

    if orc.orcobjective.bodyfat < orc.bodyfat then 
        bodyfatRetained = orc.bodyfat
    end
end

function applyRetained() 
    -- If the orc is a fusion, apply any retained fields
    if not orc.isfusion then 
        return 
    end

    if heightRetained ~= nil then 
        orc.height = heightRetained
    else 
        orc.height = lastTarget.height
    end

    if muscleRetained ~= nil then 
        orc.muscle = muscleRetained
    else 
        orc.muscle = lastTarget.muscle
    end

    if penisSRettained ~= nil then 
        orc.penissize = penisSRettained
    else 
        orc.penissize = lastTarget.penissize
    end

    if ballsizeRetained ~= nil then 
        orc.ballsize = ballsizeRetained
    else 
        orc.ballsize = lastTarget.ballsize
    end

    if bodyfatRetained ~= nil then 
        orc.bodyfat = bodyfatRetained
    else 
        orc.bodyfat = lastTarget.bodyfat
    end

    heightRetained = nil 
    muscleRetained = nil 
    penisSRettained = nil 
    ballsizeRetained = nil 
    bodyfatRetained = nil

end

function geniefy()
    -- Start geniefication if orc is corrupted and has a synced orgasm. 
    if orc.corruption > 0 and orc.corruption <= 1 then 
        if orc.issexing and orc.perfectglowing then 
            orc.consolecommand("buffperma AutoGenieCorruption")
            if orc.orcobjective ~= nil then 
                orc.orcobjective.consolecommand("buffperma AutoGenieCorruption")
            end
        end
    end
end
