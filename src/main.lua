function love.load()
	world = love.physics.newWorld(0, 0)
	width, height = 800, 600
	love.physics.setMeter(25)
	love.window.setMode(width, height)

	bulletSpeed = 1000

	scale = 1
	rotation = 0.332
	funk = true

	time = 0

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
	objects.playerCircle.Shape = love.physics.newCircleShape(25 * scale)

	-- Pointer
	objects.playerPointer = {}
	objects.playerPointer.body = love.physics.newBody(world, width/2, height/2, 'dynamic')
	objects.playerPointer.image = love.graphics.newImage('assets/pointer.png')

	--Debug
	printDebug = {}

	love.graphics.setBackgroundColor(75, love.math.random(0, 125), love.math.random(80, 105), 255)
	r, g, b, a = love.math.random(0, 255), love.math.random(0, 255), love.math.random(0, 255), 255
end

function love.update(dt)
	time = time + dt

	printDebug[1] = 'FPS: ' .. tostring(love.timer.getFPS())
	printDebug[2] = 'Avg. Delta: ' .. love.timer.getAverageDelta()
	printDebug[9] = 'Player X: '..objects.player.body:getX()
	printDebug[10] = 'Player Y: '..objects.player.body:getY()
	printDebug[11] = 'Bullet number: ' .. table.getn(bullets)

	if funk == true then
		scale = scale + (dt * 1.1)
		rotation = rotation + (dt * 5.5)
	elseif funk == false then
		scale = scale - (dt * 1.1)
	end

	if scale > 1.3 then
		funk = false
	elseif scale < 1 then
		funk = true
	end

	objects.player.Shape = love.physics.newRectangleShape(25 * scale, 25 * scale)

	world:update(dt)

	-- Movement
	if (love.keyboard.isDown("w") and objects.player.body:getY() > 0) then
		objects.player.body:applyForce(0, -2000)
	end
	if (love.keyboard.isDown("a") and objects.player.body:getX() > 0) then
		objects.player.body:applyForce(-2000, 0)
	end
	if (love.keyboard.isDown("s") and objects.player.body:getY() < height - 12.5) then
		objects.player.body:applyForce(0, 2000)
	end
	if (love.keyboard.isDown("d") and objects.player.body:getX() < width - 12.5) then
		objects.player.body:applyForce(2000, 0)
	end

	-- Temporary barrier, pushes player back into field of play
	if (objects.player.body:getY() < 0 + 12.5) then
		objects.player.body:applyForce(0, 8000)
	end
	if (objects.player.body:getX() < 0 + 12.5) then
		objects.player.body:applyForce(8000, 0)
	end
	if (objects.player.body:getY() > height - 12.5) then
		objects.player.body:applyForce(0, -8000)
	end
	if (objects.player.body:getX() > width - 12.5) then
		objects.player.body:applyForce(-8000, 0)
	end

	--Bullets
	for i,v in ipairs(bullets) do
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
	end
end

function love.draw()

	if funk == true and time > 1.0913 then
		love.graphics.setBackgroundColor(75, love.math.random(0, 125), love.math.random(80, 105), 255)
		r, g, b, a = love.math.random(0, 255), love.math.random(0, 255), love.math.random(0, 255), 255
		time = 0
	end

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setLineWidth(2)

	drawPlayer()
	drawPlayerCircle()
	drawPointer()
	drawBullets()
	drawCursor()

	if debugMode == true then
		love.graphics.print(table.concat(printDebug, '\n'), 20, 20)
	end
end

function drawPlayer()
	love.graphics.push()

	love.graphics.translate(objects.player.body:getX(), objects.player.body:getY())
	love.graphics.rotate(rotation)
	love.graphics.setColor(204, 51, 77)
	love.graphics.polygon('fill', objects.player.Shape:getPoints())
	love.graphics.pop()
end

function drawPlayerCircle()
	love.graphics.push()
	love.graphics.translate(objects.player.body:getX(), objects.player.body:getY())
	objects.playerCircle.Shape = love.physics.newCircleShape(25 * scale)

	if debugMode == true then
		love.graphics.setLineWidth(2 * scale)
		love.graphics.setColor(0, 0, 0, 100)
	else
		love.graphics.setLineWidth(0)
		love.graphics.setColor(0, 0, 0, 0)
	end

	love.graphics.circle('line', 0, 0, 25 * scale)
	love.graphics.pop()
end


function drawBullets()
	love.graphics.push()

	love.graphics.setColor(r, g, b, a)
	love.graphics.setBlendMode('additive')

	for i,v in ipairs(bullets) do
		love.graphics.circle('fill', v.x, v.y, 5 * scale)
	end

	love.graphics.setBlendMode('alpha')
	love.graphics.pop()
end

--Ray-casting to place pointer
function drawPointer()
	love.graphics.push()
	love.graphics.setColor(255, 101, 77)
	love.graphics.setLineWidth(2 * scale)

	local xn, yn, fraction = objects.playerCircle.Shape:rayCast(love.mouse.getX(), love.mouse.getY(),
							objects.player.body:getX(), objects.player.body:getY(),
							1, objects.player.body:getX(), objects.player.body:getY(), 0)

	if xn then
		rayHitX = love.mouse.getX() + (objects.player.body:getX() - love.mouse.getX()) * fraction
		rayHitY = love.mouse.getY() + (objects.player.body:getY() - love.mouse.getY()) * fraction
		angle = math.atan2(love.mouse.getY() - rayHitY, love.mouse.getX() - rayHitX)

		--Debug
		if debugMode == true then
			printDebug[3] = 'Ray fraction: ' .. fraction
			printDebug[4] = 'Ray x: ' .. xn
			printDebug[5] = 'Ray y: ' .. yn
			printDebug[6] = 'Ray x hit at: ' .. rayHitX
			printDebug[7] = 'Ray y hit at: ' .. rayHitY
			printDebug[8] = 'Ray angle: ' .. angle
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
				love.graphics.draw(objects.playerPointer.image, 0, 0, angle, 0.7 * scale, 0.7 * scale, 8, 8)
			end

		love.graphics.pop()

	love.graphics.pop()
end

function drawCursor()
	love.graphics.push()

	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', love.mouse.getX() - ((5 * scale) / 2), love.mouse.getY() - ((5 * scale) / 2), 5 * scale, 5 * scale)

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
