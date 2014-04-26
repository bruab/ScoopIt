require "litterbox"

---------------------------------------------------------------------
-----------------------SETUP FUNCTIONS-------------------------------
---------------------------------------------------------------------

function love.load()
    math.randomseed(os.time())
    gameOver = false
    elapsedTime = 0
    catTimer = 0
    catIncrement = 5
    catOnScreen = false
    poopTimer = 0
    litterBoxes = {}
    dirtyLitterboxes = 0
    scoopX = 320
    scoopY = 250
    litterbox = love.graphics.newImage("images/litterbox.png")
    cat = love.graphics.newImage("images/cat.png")
    scoop = love.graphics.newImage("images/scoop.png")
    poop = love.graphics.newImage("images/poop.png")
    --cat is 120x90
    --litterbox is 150x42
    --scoop is 75x75
    gameOver1 = love.graphics.newImage("images/angrycat1.jpg")
    gameOver2 = love.graphics.newImage("images/angrycat2.jpg")
    gameOver3 = love.graphics.newImage("images/angrycat3.jpg")
    gameOver4 = love.graphics.newImage("images/giantpoop.png")
    love.graphics.setNewFont(36)
    love.graphics.setBackgroundColor(255,255,255)
    setupLitterboxes()
end

function setupLitterboxes()
    i = 1
    for y=0,2 do
        for x=0,3 do
            litterBoxes[i] = Litterbox.create(litterbox, 200*x, 200*y)
            i = i+1
        end
    end
end

---------------------------------------------------------------------
-----------------------UPDATE FUNCTIONS------------------------------
---------------------------------------------------------------------

function love.update(dt)
    if not gameOver then
        updateTimers(dt)
        updateCat()
        updateScoop(dt)
        checkPoopStatus()
    end
end

function updateTimers(dt)
    elapsedTime = elapsedTime + dt
    catTimer = catTimer + dt
    if poopOnScreen then
        poopTimer = poopTimer + dt
        if poopTimer > catIncrement / 2 then
            poopOnScreen = false
        end
    end
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
            currentBox = chooseRandomLitterbox()
            catX = currentBox.x + 10
            catY = currentBox.y + 10
        else
            doPoop()
        end
        catTimer = 0
    end
end

function updateScoop(dt)
    updateScoopLocation(dt)
    checkForScoopEdgeCollision()
    checkForScoopCatCollision()
    --checkForScoopAction??
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
    checkForScoopEdgeCollision()
    checkForScoopCatCollision()
end

function checkForScoopEdgeCollision()
    if scoopX < 0 then
        scoopX = 0
    end
    if scoopX > 725 then
        scoopX = 725
    end
    if scoopY < 0 then
        scoopY = 0
    end
    if scoopY > 525 then
        scoopY = 525
    end
end

function checkForScoopCatCollision()
    if catOnScreen then
        xCollision = false
        yCollision = false
        --scoop approaches from left
        if scoopX < catX and catX < scoopX+50 then
            xCollision = true
        end
        --scoop approaches from right
        if catX < scoopX and scoopX < catX+ 65 then
            xCollision = true
        end
        --scoop approaches from above
        if scoopY < catY and catY < scoopY + 60 then
            yCollision = true
        end
        --scoop approaches from below
        if catY < scoopY and scoopY < catY + 70 then
            yCollision = true
        end
        if xCollision and yCollision then
            doScoopCatCollision()
        end
    end
end

function doScoopCatCollision()
    chooseCatCollisionGameOverGraphic()
    gameOverMessage = "DON'T RUSH ME"
    doGameOver()
end

function checkPoopStatus()
    count = 0
    for i,box in ipairs(litterBoxes) do
        if box.containsPoop then
            count = count + 1
        end
    end
    if count == 12 then
        gameOverGraphic = gameOver4
        gameOverMessage = "All full!"
        doGameOver()
    end
end

---------------------------------------------------------------------
-----------------------DRAW FUNCTIONS--------------------------------
---------------------------------------------------------------------

function love.draw()
    if not gameOver then
        drawLitterboxes()
        drawCat()
        drawPoop()
        drawScoop()
        --drawMessage()
    else
        drawGameOver()
    end
end

function drawLitterboxes()
    for i,box in ipairs(litterBoxes) do
        box:draw()
    end
end

function drawCat()
    if catOnScreen then
        love.graphics.draw(cat, catX, catY)
    end
end

function drawPoop()
    if poopOnScreen then
        love.graphics.draw(poop, catX+30, catY+30)
    end
end

function drawScoop()
    love.graphics.draw(scoop, scoopX, scoopY)
end

function drawGameOver()
    love.graphics.draw(gameOverGraphic, 0, 0)
    drawMessage(gameOverMessage)
end

---------------------------------------------------------------------
----------------------UTILITY FUNCTIONS------------------------------
---------------------------------------------------------------------

function getRandomCatX()
    randomX = math.random(0,3)
    offset = 10
    return 200*randomX + offset
end

function getRandomCatY()
    randomY = math.random(0,2)
    offset = 10
    return 200*randomY + offset
end

function drawMessage(message)
    love.graphics.setColor(0,0,0)
    love.graphics.print(message, 20, 550)
    love.graphics.setColor(255,255,255)
end

function doGameOver()
    gameOver = true
end

function chooseCatCollisionGameOverGraphic()
    num = math.random(1,3)
    if num == 1 then
        gameOverGraphic = gameOver1
    end
    if num == 2 then
        gameOverGraphic = gameOver2
    end
    if num == 3 then
        gameOverGraphic = gameOver3
    end
end

function doPoop()
    poopTimer = 0
    poopOnScreen = true
    currentBox:poopIn()
end

function chooseRandomLitterbox()
    index = math.random(1, 12)
    if litterBoxes[index].containsPoop then
        chooseRandomLitterbox()
    end
    return litterBoxes[index]
end
