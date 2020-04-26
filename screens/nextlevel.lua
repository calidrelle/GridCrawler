local this = {}

this.load = function()
    local x = (WIDTH - 80 * SCALE) / 2
    local y = HEIGHT / 2
end

this.update = function(dt)

end

this.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Changement de niveau, vendeur....")
end

this.keypressed = function(key)

end

return this
