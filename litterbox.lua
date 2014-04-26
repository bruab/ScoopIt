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
