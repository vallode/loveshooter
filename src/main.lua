function love.load()
	world = love.physics.newWorld(0, 0)
	width = 800
	height = 600
	love.physics.setMeter(25)
	love.window.setMode(width, height)

	objects = {}

	-- Player
	objects.player = {}
	objects.player.body = love.physics.newBody(world, width/2, height/2, 'dynamic')
	objects.player.Shape = love.physics.newRectangleShape(25, 25)
	objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.Shape, 1)
	objects.player.body:setLinearDamping(4)
	objects.player.body:setInertia(0)
	objects.player.body:setMass(0.8)

	love.graphics.setBackgroundColor(75, 122, 105, 1)
end

function love.update(dt)
	world:update(dt)

	-- Movement
	if (love.keyboard.isDown("w") and objects.player.body:getY() > 0) then
		objects.player.body:applyForce(0, -2000)
	end
	if (love.keyboard.isDown("a") and objects.player.body:getX() > 0) then
		objects.player.body:applyForce(-2000, 0)
	end
	if (love.keyboard.isDown("s") and objects.player.body:getY() < 600 - 25) then
		objects.player.body:applyForce(0, 2000)
	end
	if (love.keyboard.isDown("d") and objects.player.body:getX() < 800 - 25) then
		objects.player.body:applyForce(2000, 0)
	end

	-- Temporary barrier, pushes player back into field of play
	if (objects.player.body:getY() < 0 + 12.5) then
		objects.player.body:applyForce(0, 8000)
	end
	if (objects.player.body:getX() < 0 + 12.5) then
		objects.player.body:applyForce(8000, 0)
	end
	if (objects.player.body:getY() > 600 - 12.5) then
		objects.player.body:applyForce(0, -8000)
	end
	if (objects.player.body:getX() > 800 - 12.5) then
		objects.player.body:applyForce(-8000, 0)
	end
end

-- Cursor Grab
function love.keypressed(key)
	if key == ' ' then
		if (love.mouse.isGrabbed()) then
			love.mouse.setGrabbed(false)
			love.mouse.setVisible(true)
		else
			love.mouse.setGrabbed(true)
			love.mouse.setVisible(false)
		end
	end
end

function love.draw()
	drawPlayer()
	drawRectacle()
	drawCursor()
	drawRay()
end

function drawRectacle()
	love.graphics.push()
	love.graphics.setColor(204, 51, 77)
	love.graphics.rectangle('fill', (objects.player.body:getX() - 25),(objects.player.body:getY() + 5), 5, 10)
	love.graphics.pop()
end

function drawRay()
	love.graphics.push()
	love.graphics.setColor(255, 101, 77)
	love.graphics.setLineWidth(2)

	xn, yn, fraction =
	objects.player.Shape:rayCast(love.mouse.getX(), love.mouse.getY(),
								objects.player.body:getX(), objects.player.body:getY(),
								1, objects.player.body:getX(), objects.player.body:getY(), 0)

	if xn then
		love.graphics.setColor(0, 0, 0)
		love.graphics.print('Ray fraction '..fraction, 50, 50)
		love.graphics.print('Ray x '..xn, 50, 65)
		love.graphics.print('Ray y '..yn, 50, 80)
		r1HitX = love.mouse.getX() + (objects.player.body:getX() - love.mouse.getX()) * fraction
		r1HitY = love.mouse.getY() + (objects.player.body:getY() - love.mouse.getY()) * fraction
		love.graphics.print('Ray x hit '..r1HitX, 50, 95)
		love.graphics.print('Ray y hit '..r1HitY, 50, 110)
	end

	love.graphics.setColor(255, 101, 77)
	love.graphics.line(love.mouse.getX(),  love.mouse.getY(), r1HitX, r1HitY)
	love.graphics.rectangle('fill', r1HitX - 25, r1HitY, 10, 10)
	love.graphics.pop()
end

function drawCursor()
	love.graphics.push()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', love.mouse.getX(), love.mouse.getY(), 5, 5)
	love.graphics.pop()
end

function drawPlayer()
	love.graphics.push()
	love.graphics.translate(objects.player.body:getX(), objects.player.body:getY())
	love.graphics.setColor(204, 51, 77)
	love.graphics.polygon('fill', objects.player.Shape:getPoints())
	love.graphics.pop()
end