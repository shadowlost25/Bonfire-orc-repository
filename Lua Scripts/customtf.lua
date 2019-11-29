spin = 0.0
soundsa = false
soundsb = false

progress = 0.0
progress2 = 0.0

bumpyincrement1 = 0.0
bumpyincrement2 = 0.5

began = false

height = orc.height

reachedtarget = false
reachedtarget2 = false

skincolormid_r = orc.skincolormid_r
skincolormid_g = orc.skincolormid_g
skincolormid_b = orc.skincolormid_b
skincolormid_m = orc.skincolormid_m
skincolorund_r = orc.skincolorund_r
skincolorund_g = orc.skincolorund_g
skincolorund_b = orc.skincolorund_b
skincolorund_m = orc.skincolorund_m

skincolortop_r = orc.skincolortop_r
skincolortop_g = orc.skincolortop_g
skincolortop_b = orc.skincolortop_b
skincolortop_m = orc.skincolortop_m

haircolor1_r = orc.haircolor1_r
haircolor1_g = orc.haircolor1_g
haircolor1_b = orc.haircolor1_b

haircolor2_r = orc.haircolor2_r
haircolor2_g = orc.haircolor2_g
haircolor2_b = orc.haircolor2_b

beardstubble = orc.beardstubble
beardlength = orc.beardlength
hairlength = orc.hairlength
height = orc.height

bodyfat = orc.bodyfat
extrabutt = orc.extrabutt
jawsize = orc.jawsize
tusksize = orc.tusksize

ballsize = orc.ballsize
earshape = orc.earshape
earsize = orc.earsize

muscle = orc.muscle
lipgirth = orc.lipgirth
penisgirth = orc.penisgirth
penissize = orc.penissize
penisshower = orc.penisshower
bodyhair = orc.bodyhair

coatdensity = orc.coatdensity

normalspeed = 0.5
peakspeed = 2.0

objective = nil

speed = 0.0
deltat = 0.0
actualincrement = 0.0
wave = 0.0

delta_old = 0.0
delta2_old = 0.0

delta = 0.0
delta2 = 0.0

function reinitvalues()

	height = orc.height

	skincolormid_r = orc.skincolormid_r
	skincolormid_g = orc.skincolormid_g
	skincolormid_b = orc.skincolormid_b
	skincolormid_m = orc.skincolormid_m

	skincolorund_r = orc.skincolorund_r
	skincolorund_g = orc.skincolorund_g
	skincolorund_b = orc.skincolorund_b
	skincolorund_m = orc.skincolorund_m

	skincolortop_r = orc.skincolortop_r
	skincolortop_g = orc.skincolortop_g
	skincolortop_b = orc.skincolortop_b
	skincolortop_m = orc.skincolortop_m

	haircolor1_r = orc.haircolor1_r
	haircolor1_g = orc.haircolor1_g
	haircolor1_b = orc.haircolor1_b

	haircolor2_r = orc.haircolor2_r
	haircolor2_g = orc.haircolor2_g
	haircolor2_b = orc.haircolor2_b

	beardstubble = orc.beardstubble
	beardlength = orc.beardlength
	hairlength = orc.hairlength
	height = orc.height

	bodyfat = orc.bodyfat
	extrabutt = orc.extrabutt
	jawsize = orc.jawsize
	tusksize = orc.tusksize

	ballsize = orc.ballsize
	earshape = orc.earshape
	earsize = orc.earsize

	muscle = orc.muscle
	lipgirth = orc.lipgirth
	penisgirth = orc.penisgirth
	penissize = orc.penissize
	penisshower = orc.penisshower
	bodyhair = orc.bodyhair

	coatdensity = orc.coatdensity

	progress = 0.0
	progress2 = 0.0

	bumpyincrement1 = 0.0
	bumpyincrement2 = 0.5

end

function begin()

	if began == false then

		if orc.hasitemflag('customtfvar','any') == false then

			orc.setitemflag('customtfvar','0')

		end

		reinitvalues()

		began = true

		reachedtarget = false
		reachedtarget2 = false

	end

end

function increment1()

	speed = (0.5*(normalspeed+(normalspeed*(orc.arousal*0.25)))) * orc.game.lerp(1.0,peakspeed,1.0 - math.abs( orc.game.cos( progress * 180.0 )))

	deltat = orc.game.deltatime * ( 0.125 * speed )

	if reachedtarget == false then

		wave = 16.0 * speed

		bumpyincrement1 = bumpyincrement1 + ( deltat * wave )

		bumpyincrement1 = orc.game.cycle(bumpyincrement1,1.0)

		if soundsa == false then
			
			if bumpyincrement1 > 0.5 then
				 soundsa = true
				 orc.soundtimpani(progress)
			end

		else
			
			if bumpyincrement1 < 0.5 then
				 soundsa = false
				 orc.throb()
				 if orc.arousal > 0.5 then
					--orc.cum()
				 end
			end

		end

		actualincrement = orc.game.flatstutter(bumpyincrement1) * ( 1.25 * normalspeed )

		progress = progress + ( deltat * actualincrement  ) 

		if progress >= 1.0 then
			reachedtarget = true
		end

	else

		progress = orc.game.movetowards(progress,1.0,orc.game.deltatime * speed)

	end

end

function increment2()

	speed = (1.25 * (normalspeed+(normalspeed*(orc.arousal*0.25))) ) * orc.game.lerp(1.0, peakspeed ,1.0 - math.abs( orc.game.cos( progress * 180.0 )))

	deltat = orc.game.deltatime * ( 0.125 * speed )

	if reachedtarget2 == false then

		wave = 4.0 * speed

		bumpyincrement2 = bumpyincrement2 + ( deltat * wave )

		bumpyincrement2 = orc.game.cycle(bumpyincrement2,1.0)

		if soundsb == false then
			
			if bumpyincrement2 > 0.5 then
				soundsb = true
				orc.soundbrass(progress2)
			end

		else
			
			if bumpyincrement2 < 0.5 then
				 soundsb = false
				--  orc.throb()
			end

		end

		actualincrement = orc.game.flatstutter(bumpyincrement2) * (2*normalspeed)

		progress2 = progress2 + ( deltat * actualincrement  ) 

		if progress2 >= 1.0 then
			reachedtarget2 = true
		end

	else

		progress2 = orc.game.movetowards(progress2,1.0,orc.game.deltatime * speed)

	end

end

function tf()

		if orc.corruption <= 0.0 then

			morph()

			confer()

			if progress == 1.0 and progress2 == 1.0 then
				orc.cum()
				orc.consolecommand('oluaria customtf,tf')
			end

		else

			began = false

		end

end

function morph()

	begin()

	--

	increment1()
	increment2()

	--

	delta = orc.game.backeaseinout( progress )
	delta2 = orc.game.backeaseinout ( progress2 )

	if delta ~= delta_old then

		orc.skincolormid_r = orc.game.lerp(skincolormid_r,188,delta)
		orc.skincolormid_g = orc.game.lerp(skincolormid_g,103,delta)
		orc.skincolormid_b = orc.game.lerp(skincolormid_b,57,delta)
		orc.skincolormid_m = orc.game.lerp(skincolormid_m,32,delta)

		orc.skincolorund_r = orc.game.lerp(skincolorund_r,126,delta)
		orc.skincolorund_g = orc.game.lerp(skincolorund_g,113,delta)
		orc.skincolorund_b = orc.game.lerp(skincolorund_b,106,delta)
		orc.skincolorund_m = orc.game.lerp(skincolorund_m,32,delta)

		orc.beardlength = orc.game.lerp(beardlength,0,delta)

		orc.beardstubble = orc.game.lerp(beardstubble,0.75,delta)

		orc.hairlength = orc.game.lerp(hairlength,0,delta)

		if orc.game.deltatime < 0.2 then
			orc.heightr = orc.game.lerp(height,1.125,delta)
		else
			orc.height = orc.game.lerp(height,1.125,delta)
		end

		orc.bodyfat = orc.game.lerp(bodyfat,0.125,delta)

		orc.extrabutt = orc.game.lerp(extrabutt,1,delta)

		orc.jawsize = orc.game.lerp(jawsize,0.9,delta)

		orc.tusksize = orc.game.lerp(tusksize,0,delta)

		orc.ballsize = orc.game.lerp(ballsize,2,delta)

		orc.earshape = orc.game.lerp(earshape,1,delta)

		orc.earsize = orc.game.lerp(earsize,1,delta)

	end


	if delta2 ~= delta2_old then

		orc.skincolortop_r =orc.game.lerp(skincolortop_r,174 ,delta2)
		orc.skincolortop_g =orc.game.lerp(skincolortop_g,135,delta2)
		orc.skincolortop_b =orc.game.lerp(skincolortop_b,114,delta2)
		orc.skincolortop_m =orc.game.lerp(skincolortop_m,123,delta2)

		--

		orc.haircolor1_r =orc.game.lerp(haircolor1_r,0 ,delta2)
		orc.haircolor1_g =orc.game.lerp(haircolor1_g,0,delta2)
		orc.haircolor1_b =orc.game.lerp(haircolor1_b,0,delta2)

		orc.haircolor2_r =orc.game.lerp(haircolor2_r,73 ,delta2)
		orc.haircolor2_g =orc.game.lerp(haircolor2_g,23,delta2)
		orc.haircolor2_b =orc.game.lerp(haircolor2_b,0,delta2)

		--

		orc.muscle = orc.game.lerp(muscle,1,delta2)

		orc.lipgirth = orc.game.lerp(lipgirth,1,delta2)

		orc.penisgirth = orc.game.lerp(penisgirth,1.5,delta2)

		orc.penissize = orc.game.lerp(penissize,2,delta2)

		orc.penisshower = orc.game.lerp(penisshower,1,delta2)

		orc.bodyhair = orc.game.lerp(bodyhair,0.75,delta2)

		orc.coatdensity = orc.game.lerp(coatdensity,0.0,delta2)

	end

	--

	delta_old = delta
	delta2_old = delta2


end


function confer()
	
	-- Gives the growth to others around

	if objective == nil then
		
		objective = orc.findclosest(6)

	else

		if objective.hasitemflag('customtfvar','any') == false then

			orc.luacopyover(orc,objective,'customtf')

			objective.luaiterator('customtf','tf',orc.infinity)

			objective.setitemflag('customtfvar','0')

		else

			objective = orc.findnextclosest(6,objective)

		end

	end

end