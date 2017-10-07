function love.load()
	love.physics.setMeter(25)
	world = love.physics.newWorld(0, 0)

	objects = {}

	-- Player
	objects.player = {}
	objects.player.body = love.physics.newBody(world, 600/2, 800/2, 'dynamic')
	objects.player.shape = love.physics.newRectangleShape(25, 25)
	objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.shape, 1)
	objects.player.body:setLinearDamping(4)
	objects.player.body:setInertia(0)
	objects.player.body:setMass(0.8)

	love.graphics.setBackgroundColor(75, 122, 105, 1)
	love.window.setMode(800, 600)
end

function love.update(dt)
	world:update(dt)

	if (love.keyboard.isDown("w") and objects.player.body:getY() > 0) then
		objects.player.body:applyForce(0, -1600)
	end
	if (love.keyboard.isDown("a") and objects.player.body:getX() > 0) then
		objects.player.body:applyForce(-1600, 0)
	end
	if (love.keyboard.isDown("s") and objects.player.body:getY() < 600 - 25) then
		objects.player.body:applyForce(0, 1600)
	end
	if (love.keyboard.isDown("d") and objects.player.body:getX() < 800 - 25) then
		objects.player.body:applyForce(1600, 0)
	end

	if (objects.player.body:getY() < 0) then
		objects.player.body:applyForce(0, 3200)
	end
	if (objects.player.body:getX() < 0) then
		objects.player.body:applyForce(3200, 0)
	end
	if (objects.player.body:getY() > 600 - 25) then
		objects.player.body:applyForce(0, -3200)
	end
	if (objects.player.body:getX() > 800 - 25) then
		objects.player.body:applyForce(-3200, 0)
	end
end

function love.draw()
	love.graphics.setColor(204, 51, 77)
	love.graphics.rectangle('fill', objects.player.body:getX(), objects.player.body:getY(), 25, 25)
end