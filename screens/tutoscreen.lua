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
  Background.setAlpha(1)
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
  printUnder("  - A chaque étage, trouve les 8 parchemins pour reconstituer le grimoire d'ouverture de la grille")
  printUnder("  - Pour te déplacer, utilise les touches ([Z], [Q], [S]] et [D] par défaut)")
  printUnder("  - Saute par dessus les pics pour ne pas te faire empaler ([Espace] par défaut)")
  printUnder("  - Utilise ton épée pour te battre et pour casser tout ce que tu peux ([ctrl droit] par défaut)")
  printUnder("                 (Tu peux changer ces touches dans les options)")
  printUnder("  - Les monstres et les objets donnent de l'or et parfois un parchemin")
  printUnder(
    "  - Une fois la grille ouverte, tu as accès au marchand. Tu peux lui acheter des améliorations avant de descendre au niveau inférieur")

  printUnder(
    " ** A chaque fois que tu entres chez le vendeur, ta progression est sauvée pour te permettre de quitter le jeu. Mais si tu descends dans le donjon, cette progression est effacée et tu devras survivre au niveau suivant.")
  printUnder("\n\n                                                                                           Bonne chance, Aventurier !!")
end

this.keypressed = function(key)
  if key == "return" or key == "kpenter" then
    doGoMenu()
  end
end

return this
