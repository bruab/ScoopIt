function love.load()
    elapsedTime = 0
    catTimer = 0
    catOnScreen = false
    dirtyLitterboxes = 0
    x = 0
    y = 0
    scoopX = 320
    scoopY = 250
    litterbox = love.graphics.newImage("images/litterbox.png")
    cat = love.graphics.newImage("images/cat.png")
    scoop = love.graphics.newImage("images/scoop.png")
    love.graphics.setNewFont(36)
    love.graphics.setBackgroundColor(255,255,255)
end

function love.update(dt)
    elapsedTime = elapsedTime + dt
    catTimer = catTimer + dt
    updateCatLocation()
    updateScoopLocation(dt)
    if love.keyboard.isDown("up") then
        x = x + dt * 100
        y = y + dt * 100
        --num = num + 100 * dt -- increment num by 100 per second
    end
end

function updateCatLocation()
    if catTimer > 5 then
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

function love.draw()
    drawLitterboxes()
    drawCat()
    drawScoop()
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
    else
        writeMessage("Scoop it.")
    end
end

function drawScoop()
    love.graphics.draw(scoop, scoopX, scoopY)
end

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
