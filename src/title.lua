title = {}

title.init = function()
	world = love.physics.newWorld(0, 0)
	love.window.setMode(width, height, {vsync=true})

	backgroundColorTimer = 0
	volume = 0.01

	scale = 1

	r, g, b, a, nr, ng, nb = 75, 125, 105, 255, 75, 125, 105
	love.audio.setVolume(volume)
	love.audio.play(sourcePumped)
end

title.update = function(dt)
	backgroundColorTimer = backgroundColorTimer + dt

	if backgroundColorTimer >= 0.5 then
		nr, ng, nb, a = love.math.random(25, 75), love.math.random(0, 125), love.math.random(80, 105), 255
		backgroundColorTimer = 0
	end

	if r < nr then
		r = r + (((nr - r) / dt) / 1000)
	elseif r > nr then
		r = r - (((r - nr) / dt) / 1000)
	end

	if g < ng then
		g = g + (((ng - g) / dt) / 1000)
	elseif g > ng then
		g = g - (((g - ng) / dt) / 1000)
	end

	if b < nb then
		b = b + (((nb - b) / dt) / 1000)
	elseif b > nb then
		b = b - (((b - nb) / dt) / 1000)
	end

	if scale > 1.3 then
		growing = false
	elseif scale < 1 then
		growing = true
	end

	if growing == true then
		scale = scale + dt/2
	else
		scale = scale - dt/2
	end
end

title.draw = function ()
	love.graphics.setBackgroundColor(r, g, b, a)
	love.graphics.translate(0,0)
	love.graphics.setBlendMode('alpha')
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setNewFont(12)

	love.graphics.printf('Made by Vallode', 5, height-20, width, 'left')
	love.graphics.printf('Version: ' .. version, -5, height-20, width, 'right')

	--Title screen
	love.graphics.translate(width/2, height/1.5)
	love.graphics.setFont(fontTitle)

	love.graphics.printf('Square^', 0, 0, width, 'center', 0, 1, 1, width/2, height/2.5, 0, 0)

	love.graphics.setFont(fontSubtitle2)
	love.graphics.printf({{0,0,0,0}, 'Press ', {r*0.9, 255, b*0.9, a}, '\'space\'',{0,0,0,0}, ' to start'}, 0, 0, width, 'center', 0, scale, scale, width/2-3, height/20+(3*scale), 0, 0)
	love.graphics.printf({{0,0,0,0}, 'Press ', {r*0.9, g*0.9, 255, a}, '\'space\'',{0,0,0,0}, ' to start'}, 0, 0, width, 'center', 0, scale, scale, width/2+3, height/20-(3*scale), 0, 0)
	love.graphics.setFont(fontSubtitle2)
	love.graphics.printf({'Press ', {255, g*0.9, b*0.9, a}, '\'space\'',{255, 255, 255, 255}, ' to start'}, 0, 0, width, 'center', 0, scale, scale, width/2, height/20, 0, 0)
end

return title