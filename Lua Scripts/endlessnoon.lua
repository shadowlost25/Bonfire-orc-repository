--[[ Endless Noon -- by Daigo

	When active, sets the current in-game time of day to be noon

]]


function start()
	orc.setitemflag("EndlessNoon", "0") 		--on injection, set noon flag to 0
end

function onrightclick()
	if orc.ifitemflag("EndlessNoon", "1") then
		orc.setitemflag("EndlessNoon", "0")
	elseif orc.ifitemflag("EndlessNoon", "0") then
		orc.setitemflag("EndlessNoon", "1") 	-- on right click, flip noon flag
	end
end

function update()
	if orc.ifitemflag("EndlessNoon", "1") then
		orc.consolecommand("daytime 12") 				-- if it's noon it's noon girl
	end
end