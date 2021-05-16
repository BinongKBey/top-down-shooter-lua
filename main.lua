-- Player Object
player = { x = 200, y = 710, speed = 150, img = nil }

-- Timers
-- We declare these here so we don't have to edit them multiple places
canShoot = true
canShootTimerMax = 0.4 
canShootTimer = canShootTimerMax
bulletSpeed = 250

-- Image Storage
bulletImg = nil

-- Entity Storage
bullets = {} -- array of current bullets being drawn and updated

function love.load()
    player.img = love.graphics.newImage('assets/plane.png') --This line is used to import an image
    bulletImg = love.graphics.newImage('assets/bullet.png')
    sound = love.audio.newSource("assets/bg.mp3", "stream")
    love.audio.play(sound)
end

-- Updating
function love.update(dt)

    -- Bullet Timer Update
    canShootTimer = canShootTimer - (1 * dt)
    if canShootTimer < 0 then
        canShoot = true
    end

    -- update the positions of bullets
    for i, bullet in ipairs(bullets) do
        bullet.y = bullet.y - (bulletSpeed * dt)

        if bullet.y < 0 then -- remove bullets when they pass off the screen
            table.remove(bullets, i)
        end
    end

    --INPUTS
	-- I always start with an easy way to exit the game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

    if love.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot then
        -- Create some bullets
        newBullet = { x = player.x + (player.img:getWidth()/2)-4, y = player.y-2, img = bulletImg }
        table.insert(bullets, newBullet)
        canShoot = false
        canShootTimer = canShootTimerMax
    end

	if love.keyboard.isDown('left','a') then
        if player.x > 0 then -- binds us to the map
            player.x = player.x - (player.speed*dt)
        end
    elseif love.keyboard.isDown('right','d') then
        if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
            player.x = player.x + (player.speed*dt)
        end
    elseif love.keyboard.isDown('up','w') then
        if player.y > 0 then
            player.y = player.y - (player.speed*dt)
        end
    elseif love.keyboard.isDown('down','s') then
        if player.y< 710 then
            player.y = player.y + (player.speed*dt)
        end
    end
end

function love.draw() --This is the display function
    love.graphics.draw(player.img,player.x, player.y)
    for i, bullet in ipairs(bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end
end