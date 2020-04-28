GUI = {}

local buttons = {}

GUI.init = function()
    buttons = {}
end

GUI.addButton = function(text, x, y, width)
    local btn = {}
    btn.clicked = false
    btn.hover = false
    btn.visible = true
    btn.text = text
    btn.x = x
    btn.y = y
    btn.width = width or Assets.button:getWidth() * SCALE
    btn.height = Assets.button:getHeight() * SCALE

    btn.drText = love.graphics.newText(Font32, btn.text)
    btn.textWidth = btn.drText:getWidth()
    btn.textHeight = btn.drText:getHeight()

    btn.draw = function()
        if not btn.visible then
            return
        end
        if btn.hover then
            love.graphics.setColor(1, 1, 1, 1)
        else
            love.graphics.setColor(0.8, 0.8, 1, 0.8)
        end
        love.graphics.draw(Assets.button, x, y, 0, btn.width / Assets.button:getWidth(), btn.height / Assets.button:getHeight())
        love.graphics.draw(btn.drText, btn.x + (btn.width - btn.textWidth) / 2, 4 + btn.y + (btn.height - btn.textHeight) / 2)
    end

    btn.update = function(dt, mx, my)
        if not btn.visible then
            return
        end
        if mx < btn.x or mx > btn.x + btn.width or my < btn.y or my > btn.y + btn.height then
            btn.hover = false
            return
        end
        btn.hover = true
        btn.clicked = btn.pressed and not love.mouse.isDown(1)
        btn.pressed = love.mouse.isDown(1)
    end

    table.insert(buttons, btn)
    return btn
end

GUI.reset = function()
    while #buttons > 0 do
        table.remove(buttons, 1)
    end
end

GUI.update = function(dt)
    local mx, my = love.mouse.getPosition()
    for _, b in pairs(buttons) do
        b.update(dt, mx, my)
    end
end

GUI.draw = function()
    for _, b in pairs(buttons) do
        b.draw()
    end
end

GUI.drawProgressBar = function(x, y, width, height, pcentFilled, r, g, b)
    love.graphics.setLineWidth(3)
    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(r, g, b, 1)
    love.graphics.rectangle("fill", x, y, width * pcentFilled, height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", x, y, width, height)
    love.graphics.setLineWidth(1)
end

return GUI
