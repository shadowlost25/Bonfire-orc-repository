--OrcBed name
local stonebed = orc.orcname .. "bed"

--Charcter coords
local charCoords = "0," ..  --X
                   "0," ..  --Y
                   "0"      --Y

--Coordinates
local xcord = 0
local ycord = 0
local zcord = 0
local xyzcord = xcord .. "," .. ycord .. "," .. zcord

--Rotation
local xrot = 0
local yrot = 0
local zrot = 0
local xyzrot = xrot .. "," .. yrot .. "," .. zrot


function spawnBed() 
    orc.consolecommand("asset World/Props/Prefabs/StoneCircleLite")
    orc.consolecommand("batch assetnameset " .. stonebed ..";asset " .. stonebed)
    orc.consolecommand("assetpos " .. xyzcord .. "," .. xyzrot .. ",false")
end

function removeBed()
    --Removes the spawned bed, and send the player and NPC to a previous location.
    orc.consolecommand("assetclear " .. stonebed)
    orc.consolecommand("batch target @self;chrpos ".. charCoords .. ";targetclear")
    orc.consolecommand("batch target @playername;chrpos ".. charCoords .. ";nudgebwd;nudgebwd;targetclear")
end