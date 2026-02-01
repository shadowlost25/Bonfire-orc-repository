--[[
    Clothing Growth -- By Buoysel

    Makes the orc grow when they're wearing a specific piece of clothing.
    Replace the value in itemID to change clothing the script will listen
    for (grabbed from the itemlist command), and change the string in
    attribute (obviously keeping the quotation marks), to change
    the physical property that will grow.

]]

local itemID = 179                       -- The item the script listens for
local attribute = "bodyfat"              -- the physical attribute you want to change. 
local GROWTH_RATE = 5                    -- Increase or decrease to make the growth faster or slower

local itemWorn = false                   -- <- Do not change this.
local oldValueFlag = "Old-" .. attribute -- <- Nor this.

function update()

    if orc.wearsitem(itemID) then 
        
        --Store the old attribute's value
        if not orc.hasitemflag(oldValueFlag, "@any") then 
            orc.setitemflag(oldValueFlag, orc[attribute])
        end

        itemWorn = true

        grow()

    elseif not orc.wearsitem(itemID) and itemWorn then 

        --Revert to the old value
        orc[attribute] = orc.itemflagfloat(oldValueFlag)
        orc.remitemflag(oldValueFlag)

        --Prevent the script from resetting over and over again
        itemWorn = false

    end

end


function grow()

    local rateOverTime = orc.game.deltatime * (GROWTH_RATE * .01)

    orc[attribute] = orc.game.movetowards(orc[attribute], 1.0, rateOverTime)
end