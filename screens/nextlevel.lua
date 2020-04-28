local this = {}

local btnNextLevel

this.load = function()
    local x = (WIDTH - 80 * SCALE) / 2
    local y = HEIGHT / 2

    btnNextLevel = GUI.addButton("Niveau suivant", 50, 50, 100)

    -- On vide les pages de l'inventaire
    Inventory.removePages()
end

this.update = function(dt)
    if btnNextLevel.clicked then
        -- on retourne dans le jeu pour générer une nouvelle map, mais sans initialiser le joueur ni ses stats modifiées
        ScreenManager.setScreen("NEXTLEVEL")
    end
end

this.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Changement de niveau, vendeur....")
end

this.keypressed = function(key)

end

return this
