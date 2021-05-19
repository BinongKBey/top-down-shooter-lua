
-- Collision Function
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
    x2 < x1+w1 and
    y1 < y2+h2 and
    y2 < y1+h1
end

isAlive = true
score = 0
start = false

-- Player Object
player = { x = 200, y = 710, speed = 150, img = nil }

-- BULLET
-- We declare these here so we don't have to edit them multiple places
canShoot = true
canShootTimerMax = 0.2 
canShootTimer = canShootTimerMax
bulletSpeed = 250
-- Image Storage
bulletImg = nil
-- Entity Storage
bullets = {} -- array of current bullets being drawn and updated


-- Enemy
--More timers
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax
-- More images
enemyImg = nil -- Like other images we'll pull this in during out love.load function
-- More storage
enemies = {} -- array of current enemies on screen

function love.load()
    player.img = love.graphics.newImage('assets/plane.png')
    enemyImg = love.graphics.newImage('assets/enemy.png')
    bulletImg = love.graphics.newImage('assets/bullet.png')
    sound = love.audio.newSource("assets/bg.mp3", "static")
    sound:setLooping(true)
    sound:play();
end

-- Updating
function love.update(dt)

    -- Enemy
    -- Time out enemy creation
    createEnemyTimer = createEnemyTimer - (1 * dt)
    if start and createEnemyTimer < 0 then
        createEnemyTimer = createEnemyTimerMax

        -- Create an enemy
        randomNumber = math.random(10, love.graphics.getWidth() - 10)
        newEnemy = { x = randomNumber, y = -10, img = enemyImg }
        table.insert(enemies, newEnemy)
    end
    -- update the positions of enemies
    for i, enemy in ipairs(enemies) do
        enemy.y = enemy.y + (200 * dt)

        if enemy.y > 850 then -- remove enemies when they pass off the screen
            table.remove(enemies, i)
        end
    end

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

    -- Collision Check
    for i, enemy in ipairs(enemies) do
        for j, bullet in ipairs(bullets) do
            if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
                table.remove(bullets, j)
                table.remove(enemies, i)
                if isAlive then
                    score = score + 1
                end
            end
        end
    
        if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) 
        and isAlive then
            table.remove(enemies, i)
            isAlive = false
        end
    end

    --INPUTS
	-- I always start with an easy way to exit the game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

    if isAlive and love.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot then
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

    if not isAlive and love.keyboard.isDown('r') then
        -- remove all our bullets and enemies from screen
        bullets = {}
        enemies = {}
    
        -- reset timers
        canShootTimer = canShootTimerMax
        createEnemyTimer = createEnemyTimerMax
    
        -- move player back to default position
        player.x = 50
        player.y = 710
    
        -- reset our game state
        score = 0
        isAlive = true
    end

    -- Start Game
    if not start and love.keyboard.isDown('space') then
        start=true
    end
end

function love.draw()
    love.graphics.print("Score: ", 30, 20)
    love.graphics.print(score, 90, 20)
    if not start then
        love.graphics.draw(player.img, love.graphics:getWidth()/2-player.img:getWidth()/2, (love.graphics:getHeight()/2-20-player.img:getHeight()))
        love.graphics.print("Press 'Spacebar' to Start Game", love.graphics:getWidth()/2-100, love.graphics:getHeight()/2-10)
    else
        if isAlive then
            love.graphics.draw(player.img, player.x, player.y)
        else
            love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
        end
        -- Player Bullet
        for i, bullet in ipairs(bullets) do
            love.graphics.draw(bullet.img, bullet.x, bullet.y)
        end
    
        -- Enemy
        for i, enemy in ipairs(enemies) do
            love.graphics.draw(enemy.img, enemy.x, enemy.y)
        end
    end
end