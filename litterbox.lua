Litterbox = {}
Litterbox.__index = Litterbox

function Litterbox.create(img, x, y)
    local ltrbx = {}
    setmetatable(ltrbx,Litterbox)
    ltrbx.img = img
    ltrbx.x = x
    ltrbx.y = y
    ltrbx.containsPoop = false
    return ltrbx
end
                
function Litterbox:poopIn()
    self.containsPoop = true
end

function Litterbox:clean()
    self.containsPoop = false
end

function Litterbox:draw()
    love.graphics.draw(self.img, self.x, self.y)
end

function Litterbox:collision(scoopX, scoopY)
    xCollision = false
    yCollision = false
    --scoop approaches from left
    if scoopX < self.x and self.x < scoopX+30 then
        xCollision = true
    end
    --scoop approaches from right
    if self.x < scoopX and scoopX < self.x+ 85 then
        xCollision = true
    end
    --scoop approaches from above
    if scoopY < self.y and self.y < scoopY + 40 then
        yCollision = true
    end
    --scoop approaches from below
    if self.y < scoopY and scoopY < self.y + 70 then
        yCollision = true
    end
    if xCollision and yCollision then
        return true
    end
    return false
end
