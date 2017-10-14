version = 'triangle 0.0.1'

title = require('title')
game = require('game')

sourcePumped = love.audio.newSource('assets/Pumped.mp3', 'stream')

fontTitle = love.graphics.newFont('assets/3Dventure.ttf', 150)
fontSubtitle1 = love.graphics.newFont('assets/3Dventure.ttf', 32)
fontSubtitle2 = love.graphics.newFont('assets/Messe Duesseldorf.ttf', 32)
font = love.graphics.newFont(12)

width, height = 800, 600
state = title

scale = 1
bulletspeed = 1000
rotation = 0.332
volume = 0.15

funkScale = true
funkColor = true

paused = false

function love.load()
	state.init()
end

function love.update(dt)
	state.update(dt)
end

function love.draw()
	state.draw()
end

function love.keypressed(key)
	-- Cursor Grab
	if key == 'f8' then
		if (love.mouse.isGrabbed()) then
			love.mouse.setGrabbed(false)
			love.mouse.setVisible(true)
		else
			love.mouse.setGrabbed(true)
			love.mouse.setVisible(false)
		end
	end

	if key == 'space' and state == title then
		state = game
		state.init()
	end

	-- Debug mode
	if key == 'q' then
		if debugMode == true then
			debugMode = false
		else
			debugMode = true
		end
	end

	if key == 'f1' then
		love.load()
	end

	if key == 'f2' then
		if paused == true then
			paused = not paused
			love.audio.resume(sourcePumped)
		else
			paused = true
			love.audio.pause(sourcePumped)
		end
	end
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 and state == game then
		local startX = objects.playerPointer.body:getX()
		local startY = objects.playerPointer.body:getY()
		local mouseX = x
		local mouseY = y

		local angle = math.atan2((mouseY - startY), (mouseX - startX))

		local bulletDx = bulletspeed * math.cos(angle)
		local bulletDy = bulletspeed * math.sin(angle)

		table.insert(objects.bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
	end
end

function love.wheelmoved(x, y)
	if y > 0 then
		if volume < 1 then
			volume = volume + 0.01
			love.audio.setVolume(volume)
		end
	elseif y < 0 then
		if volume > 0 then
			volume = volume - 0.01
			love.audio.setVolume(volume)
		elseif volume < 0.01 then
			volume = 0
			love.audio.setVolume(volume)
		end
	end
end
