Background = {}

local timer = 0
local scale

Background.update = function(dt)
    timer = timer + dt * 0.3
    scale = (1 + 1 / 20 + math.sin(timer) / 20)
end

Background.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Assets.titleScreen, WIDTH / 2, HEIGHT / 2, 0, WIDTH / Assets.titleScreen:getWidth() * scale,
                       HEIGHT / Assets.titleScreen:getHeight() * scale, Assets.titleScreen:getWidth() / 2,
                       Assets.titleScreen:getHeight() / 2)

    love.graphics.draw(Assets.title, (WIDTH - Assets.title:getWidth() * 0.85) / 2, HEIGHT * 1 / 20, 0, 0.85, 0.85)
end

return Background
