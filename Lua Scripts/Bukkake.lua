function bukkake()
    
    --The user will start a floor fap animation when someone faps near them.

    --Get the nearest orc
    local nearest = orc.findclosest(12)

    if nearest ~= nil then 

        --Is the orc fapping within range?
        if nearest.isfapping then 

            --Start Fapping
            if orc.isbusy == false then 
                orc.consolecommand("batch target @self;floorfap1;targetclear")
            end

        else
            --Stop fapping
            if orc.isbusy == true then 
                orc.consolecommand("batch target @self;floorfap1stop;targetclear")
            end

        end

    end
    
end