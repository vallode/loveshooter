function love.load()
	world = love.physics.newWorld(0, 0)
	width, height = 800, 600
	love.physics.setMeter(25)
	love.window.setMode(width, height)

	bulletSpeed = 1000

	objects = {}
	bullets = {}

	-- Player
	objects.player = {}
	objects.player.body = love.physics.newBody(world, width/2, height/2, 'dynamic')
	objects.player.Shape = love.physics.newRectangleShape(25, 25)
	objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.Shape, 1)
	objects.player.body:setLinearDamping(4)
	objects.player.body:setInertia(0)
	objects.player.body:setMass(0.8)

	-- Pointer Path
	objects.playerCircle = {}
	objects.playerCircle.body = love.physics.newBody(world, width/2, height/2, 'static')
	objects.playerCircle.Shape = love.physics.newCircleShape(25)

	-- Pointer
	objects.playerPointer = {}
	objects.playerPointer.body = love.physics.newBody(world, width/2, height/2, 'dynamic')
	objects.playerPointer.image = love.graphics.newImage('assets/pointer.png')

	--Debug
	printDebug = {}
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
	if (love.keyboard.isDown("s") and objects.player.body:getY() < 600 - 12.5) then
		objects.player.body:applyForce(0, 2000)
	end
	if (love.keyboard.isDown("d") and objects.player.body:getX() < 800 - 12.5) then
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

	--Bullets
	for i,v in ipairs(bullets) do
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
	end
end

function love.draw()
	love.graphics.setBackgroundColor(75, 122, 105, 255)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setLineWidth(2)

	drawPlayer()
	drawPlayerCircle()
	drawBullets()
	drawCursor()
	drawPointer()

	love.graphics.print(table.concat(printDebug, '\n'), 20, 20)
end

function drawBullets()
	love.graphics.push()

	if debugMode == true then
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print('Bullet number: ' .. table.getn(bullets), 20, 100)
	end

	love.graphics.setColor(255, 255, 255, 255)
	for i,v in ipairs(bullets) do
		love.graphics.circle('fill', v.x, v.y, 5)
	end

	love.graphics.pop()
end

--Ray-casting to place pointer
function drawPointer()
	love.graphics.push()
	love.graphics.setColor(255, 101, 77)
	love.graphics.setLineWidth(2)

	local xn, yn, fraction = objects.playerCircle.Shape:rayCast(love.mouse.getX(), love.mouse.getY(),
							objects.player.body:getX(), objects.player.body:getY(),
							1, objects.player.body:getX(), objects.player.body:getY(), 0)

	if xn then
		rayHitX = love.mouse.getX() + (objects.player.body:getX() - love.mouse.getX()) * fraction
		rayHitY = love.mouse.getY() + (objects.player.body:getY() - love.mouse.getY()) * fraction
		angle = math.atan2(love.mouse.getY() - rayHitY, love.mouse.getX() - rayHitX)

		--Debug
		if debugMode == true then
			love.graphics.setColor(0, 0, 0)
			love.graphics.print('Ray fraction: ' .. fraction, 20, 10)
			love.graphics.print('Ray x: ' .. xn, 20, 25)
			love.graphics.print('Ray y: ' .. yn, 20, 40)
			love.graphics.print('Ray x hit at: ' .. rayHitX, 20, 55)
			love.graphics.print('Ray y hit at: ' .. rayHitY, 20, 70)
			love.graphics.print('Ray angle: ' .. angle, 20, 85)
			love.graphics.setColor(255, 101, 77)
			love.graphics.line(love.mouse.getX(),  love.mouse.getY(), rayHitX, rayHitY)
		end
	end

		love.graphics.push()

			if rayHitX then
				love.graphics.setColor(255, 255, 255, 100)
				love.graphics.translate(rayHitX, rayHitY)
				objects.playerPointer.body:setX(rayHitX)
				objects.playerPointer.body:setY(rayHitY)
				love.graphics.rotate(math.pi/2)
				love.graphics.draw(objects.playerPointer.image, 0, 0, angle, 0.7, 0.7, 8, 8)
			end

		love.graphics.pop()

	love.graphics.pop()
end

function drawCursor()
	love.graphics.push()

	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', love.mouse.getX() - 2.5, love.mouse.getY() - 2.5, 5, 5)

	love.graphics.pop()
end

function drawPlayer()
	love.graphics.push()

	--Debug
	if debugMode == true then
		love.graphics.setColor(0, 0, 0)
		love.graphics.print('Player X: '..objects.player.body:getX(), 20, 550)
		love.graphics.print('Player Y: '..objects.player.body:getY(), 20, 565)
		love.graphics.setColor(255, 101, 77)
	end

	love.graphics.translate(objects.player.body:getX(), objects.player.body:getY())
	love.graphics.setColor(204, 51, 77)
	love.graphics.polygon('fill', objects.player.Shape:getPoints())
	love.graphics.pop()
end

function drawPlayerCircle()
	love.graphics.push()
	love.graphics.translate(objects.player.body:getX(), objects.player.body:getY())

	if debugMode == true then
		love.graphics.setLineWidth(2)
		love.graphics.setColor(0, 0, 0, 100)
	else
		love.graphics.setLineWidth(0)
		love.graphics.setColor(0, 0, 0, 0)
	end

	love.graphics.circle('line', 0, 0, 25)
	love.graphics.pop()
end

--Inputs

function love.keypressed(key)
	-- Cursor Grab
	if key == ' ' then
		if (love.mouse.isGrabbed()) then
			love.mouse.setGrabbed(false)
			love.mouse.setVisible(true)
		else
			love.mouse.setGrabbed(true)
			love.mouse.setVisible(false)
		end
	end

	-- Debug mode
	if key == 'q' then
		if debugMode == true then
			debugMode = false
		else
			debugMode = true
		end
	end
end

function love.mousepressed(x, y, button)
	if button == 'l' then
			local startX = objects.playerPointer.body:getX()
			local startY = objects.playerPointer.body:getY()
			local mouseX = x
			local mouseY = y

			local angle = math.atan2((mouseY - startY), (mouseX - startX))

			local bulletDx = bulletSpeed * math.cos(angle)
			local bulletDy = bulletSpeed * math.sin(angle)

			table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
	end
end
