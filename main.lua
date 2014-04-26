---------------------------------------------------------------------
-----------------------SETUP FUNCTIONS-------------------------------
---------------------------------------------------------------------

function love.load()
    elapsedTime = 0
    catTimer = 0
    catIncrement = 5
    catOnScreen = false
    dirtyLitterboxes = 0
    scoopX = 320
    scoopY = 250
    litterbox = love.graphics.newImage("images/litterbox.png")
    cat = love.graphics.newImage("images/cat.png")
    scoop = love.graphics.newImage("images/scoop.png")
    love.graphics.setNewFont(36)
    love.graphics.setBackgroundColor(255,255,255)
end

---------------------------------------------------------------------
-----------------------UPDATE FUNCTIONS------------------------------
---------------------------------------------------------------------

function love.update(dt)
    updateTimers(dt)
    updateCat()
    updateScoopLocation(dt)
    --checkForScoopCatCollision
    --checkForScoopAction??
    --checkPoopStatus
end

function updateTimers(dt)
    elapsedTime = elapsedTime + dt
    catTimer = catTimer + dt
    if elapsedTime > 60 then
        catIncrement = 4
    end
    if elapsedTime > 120 then
        catIncrement = 3
    end
    if elapsedTime > 180 then
        catIncrement = 2
    end
    if elapsedTime > 240 then
        catIncrement = 1
    end
    -- TODO clean up
end

function updateCat()
    updateCatLocation()
end

function updateCatLocation()
    if catTimer > catIncrement then
        catOnScreen = not catOnScreen
        if catOnScreen then
            catX = getRandomCatX()
            catY = getRandomCatY()
        end
        catTimer = 0
    end
end

function updateScoopLocation(dt)
    if love.keyboard.isDown("up") then
        scoopY = scoopY - dt * 100
    end
    if love.keyboard.isDown("down") then
        scoopY = scoopY + dt * 100
    end
    if love.keyboard.isDown("left") then
        scoopX = scoopX - dt * 100
    end
    if love.keyboard.isDown("right") then
        scoopX = scoopX + dt * 100
    end
end

---------------------------------------------------------------------
-----------------------DRAW FUNCTIONS--------------------------------
---------------------------------------------------------------------

function love.draw()
    drawLitterboxes()
    drawCat()
    --drawPoop()
    drawScoop()
    --drawMessage()
end

function drawLitterboxes()
    for y=0,2 do
        for x=0,3 do
            love.graphics.draw(litterbox, 200*x, 200*y)
        end
    end
end

function drawCat()
    if catOnScreen == true then
        love.graphics.draw(cat, catX, catY)
    end
end

function drawScoop()
    love.graphics.draw(scoop, scoopX, scoopY)
end

---------------------------------------------------------------------
----------------------UTILITY FUNCTIONS------------------------------
---------------------------------------------------------------------

function getRandomCatX()
    randomX = math.random(0,3)
    offset = 35
    return 200*randomX + offset
end

function getRandomCatY()
    randomY = math.random(0,2)
    offset = 10
    return 200*randomY + offset
end

function writeMessage(message)
    love.graphics.setColor(0,0,0)
    love.graphics.print(message, 20, 550)
    love.graphics.setColor(255,255,255)
end
