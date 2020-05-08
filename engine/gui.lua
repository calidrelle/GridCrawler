GUI = {}

local buttons = {}

GUI.init = function()
    buttons = {}
end

GUI.addInfoBull = function(text, duree, ypos, persistant)
    local this = {}
    this.type = "info"
    this.text = text
    this.persistant = persistant or false
    this.duration = duree or 5
    this.actif = true
    this.alpha = 1
    this.large = WIDTH / 2
    this.ypos = ypos or 50
    this.wrappedtext = nil
    _, this.wrappedtext = FontVendor32:getWrap(this.text, this.large)

    for key, value in pairs(buttons) do
        if value.type == "info" and value.ypos == this.ypos then
            table.remove(buttons, key)
        end
    end

    this.update = function(dt)
        this.duration = this.duration - dt
        if this.duration < 1.5 then
            this.alpha = this.duration -- fade out la dernière seconde
            this.ypos = this.ypos + 20 * dt
        end
        if this.duration <= 0 then
            this.actif = false
        end
    end

    this.draw = function()
        love.graphics.setFont(FontVendor32)
        love.graphics.setColor(0.2, 0.2, 0.2, 0.8 * this.alpha)
        love.graphics.rectangle("fill", (WIDTH - this.large) / 2, this.ypos, this.large, #this.wrappedtext * 32 + 12)
        love.graphics.setColor(1, 1, 1, this.alpha)
        love.graphics.printf(this.text, (WIDTH - this.large) / 2, this.ypos + 6, this.large, "center")
    end

    table.insert(buttons, this)
    return this
end

GUI.addButton = function(text, x, y, width)
    local this = {}
    this.type = "button"
    this.actif = true
    this.clicked = false
    this.hover = false
    this.visible = true
    this.text = text
    this.x = x
    this.y = y
    this.hints = ""
    this.width = width or Assets.button:getWidth() * SCALE
    this.height = Assets.button:getHeight() * SCALE
    this.soundHover = false

    this.drText = love.graphics.newText(Font32, this.text)
    this.textWidth = this.drText:getWidth()
    this.textHeight = this.drText:getHeight()

    this.draw = function()
        if not this.visible then
            return
        end
        if this.hover then
            love.graphics.setColor(1, 1, 1, 1)
        else
            love.graphics.setColor(0.8, 0.8, 1, 0.8)
        end
        love.graphics.draw(Assets.button, x, y, 0, this.width / Assets.button:getWidth(), this.height / Assets.button:getHeight())
        love.graphics.draw(this.drText, this.x + (this.width - this.textWidth) / 2, 4 + this.y + (this.height - this.textHeight) / 2)

        if this.hover and this.hints ~= "" then
            love.graphics.setFont(Font20)
            love.graphics.print(this.hints, love.mouse.getX(), love.mouse.getY() + 16)
        end
    end

    this.update = function(dt, mx, my)
        if not this.visible then
            return
        end
        if mx < this.x or mx > this.x + this.width or my < this.y or my > this.y + this.height then
            this.hover = false
            this.soundHover = false
            return
        end
        this.hover = true
        if not this.soundHover then
            Assets.snd_btnHover:play()
            this.soundHover = true
        end

        this.clicked = this.pressed and not love.mouse.isDown(1)
        this.pressed = love.mouse.isDown(1)

        if this.clicked then
            Assets.snd_btnClicked:play()
        end
    end

    table.insert(buttons, this)
    return this
end

GUI.drawProgressBar = function(x, y, width, height, value, valuemax, r, g, b, displayValues)
    love.graphics.setLineWidth(3)
    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(r, g, b, 1)
    love.graphics.rectangle("fill", x, y, width * value / valuemax, height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", x, y, width, height)
    love.graphics.setLineWidth(1)

    if displayValues then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(Font20)
        if math.floor(value) == 0 and value > 0 then
            value = 1 -- ne pas afficher 0 sauf si on est mort
        end
        love.graphics.printf(math.floor(value) .. "/" .. math.floor(valuemax), x + 4, y + 6, width - 4, "center")
    end
end

------------------------------------------------ GUI MANAGMENT ---
GUI.reset = function()
    for i = #buttons, 1, -1 do
        if buttons[i].type == "info" then
            if not buttons[i].persistant then
                table.remove(buttons, i)
            end
        else
            table.remove(buttons, i)
        end
    end
end

GUI.update = function(dt)
    local mx, my = love.mouse.getPosition()
    for _, b in pairs(buttons) do
        b.update(dt, mx, my)
    end
    for i = #buttons, 1, -1 do
        if buttons[i].actif == false then
            table.remove(buttons, i)
        end
    end
end

GUI.draw = function()
    for _, b in pairs(buttons) do
        b.draw()
    end
end

return GUI
