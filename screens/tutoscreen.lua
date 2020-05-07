-- TODO: insérer cet écran dans les require de main.lua
local this = {}

local btnMenu
local xpos
local ypos
local large

this.load = function()
    love.mouse.setVisible(true)
    btnMenu = GUI.addButton("Menu", WIDTH * 4 / 5, HEIGHT - 2 * TILESIZE * SCALE)
    xpos = 50
    ypos = HEIGHT / 4
    large = WIDTH - xpos * 2
end

local function doGoMenu()
    ScreenManager.setScreen("MENU")
end

this.update = function(dt)
    ypos = HEIGHT / 4
    if btnMenu.clicked then
        doGoMenu()
    end
end

local function printUnder(text, font)
    local fnt = font or FontVendor20
    love.graphics.setFont(fnt)
    local _, height = fnt:getWrap(text, large)
    love.graphics.printf(text, xpos + 6, ypos, large - 4, "left")
    ypos = ypos + #height * fnt:getHeight() + 4

end

this.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    Background.draw()
    love.graphics.setColor(.21, .21, .21, .8)
    love.graphics.rectangle("fill", xpos, ypos, large, 450)

    love.graphics.setColor(1, 1, 1, 1)
    printUnder("\n")
    printUnder("Bienvenue dans GridCrawler", FontVendor32)
    love.graphics.setColor(0.8, 0.8, 1, 1)
    printUnder("\n")
    printUnder("Le Roi de Gridland a estimé que vous n'étiez pas assez digne de le servir, quel affront !")
    printUnder(
        "Pour lui prouvez votre valeur et rendre fière votre famille, vous devez sortir vivant du donjon dans lequel il vous a emprisonné.\nChacun des 9 étages de ce donjon vous mettra à l'épreuve, mais un marchand vous aidera entre chaque étage, s'il le peut.")

    printUnder("\n")
    printUnder("  - A chaque étage, trouve les 8 parchemins pour reconstituer le grimoire d'ouverture de la grille")
    printUnder("  - Pour te déplacer, utilise les touches ([Z], [Q], [S]] et [D] par défaut)")
    printUnder("  - Saute par dessus les pics pour ne pas de faire empaler ([Espace] par défaut)")
    printUnder("  - Utilise ton épée pour te battre et pour casser tout ce que tu peux ([ctrl droit] par défaut)")
    printUnder("                 (Tu peux changer ces touches dans les options)")
    printUnder("  - Les monstres et les objets donnent de l'or et parfois, un parchemin")
    printUnder(
        "  - Une fois la grille ouverte, tu as accès au marchand qui peut te vendre des améliorations avant de descendre au niveau inférieur")

    printUnder("\n    Bonne chance, Aventurier !!")
end

this.keypressed = function(key)
    if key == "return" or key == "kpenter" then
        doGoMenu()
    end
end

return this
