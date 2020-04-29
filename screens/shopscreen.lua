local this = {}

local stats = {}
local mx, my = 0, 0
local vendor
local staires
local selectedItem = nil

local function addStat(id, name, cost, value, item)
    local stat = {}
    stat.id = id
    stat.name = name
    stat.cost = cost
    stat.value = value
    stat.item = item
    table.insert(stats, stat)
end

this.load = function()

    Inventory.removePages() -- On vide les pages de l'inventaire
    ItemManager.reset()

    --- SCENERY    
    vendor = ItemManager.newVendor(6.5 * TILESIZE, 5 * TILESIZE)
    staires = ItemManager.newDownstairs(112, 64)
    ItemManager.newTorch(4 * TILESIZE, 1 * TILESIZE)
    ItemManager.newTorch(9 * TILESIZE, 1 * TILESIZE)

    Player.currentAnim = Player.animRun
    Player.setPosition(6.5 * TILESIZE, 16 * TILESIZE)

    addStat(1, "Vie max +1", 30, Player.pvMax, ItemManager.newTable(3 * TILESIZE, 5 * TILESIZE))
    addStat(2, "Attaque +1", 30, Player.atk, ItemManager.newTable(3 * TILESIZE, 7 * TILESIZE))
    addStat(3, "Défense +1", 30, Player.def, ItemManager.newTable(3 * TILESIZE, 9 * TILESIZE))
    addStat(4, "Distance d'attaque +5%", 30, Player.atkRange, ItemManager.newTable(10 * TILESIZE, 5 * TILESIZE))
    addStat(5, "Régénération de vie +5%", 30, Player.regenPv, ItemManager.newTable(10 * TILESIZE, 7 * TILESIZE))
    addStat(6, "Régénération d'endurence +5%", 30, Player.regenStamina, ItemManager.newTable(10 * TILESIZE, 9 * TILESIZE))
end

local function doSelect()
    if selectedItem == nil then
        return
    end
    if selectedItem == staires then
        Player.pv = Player.pvMax
        Player.level = Player.level + 1
        ScreenManager.setScreen("NEXTLEVEL")
    elseif selectedItem.name then
        -- Le joueur à choisi une amélioration
        for _, stat in pairs(stats) do
            if stat.item == selectedItem then
                if Inventory.removePo(stat.cost) then
                    if stat.id == 1 then
                        stat.value = stat.value + 1
                        Player.pvMax = stat.value
                    elseif stat.id == 2 then
                        stat.value = stat.value + 1
                        Player.atk = stat.value
                    elseif stat.id == 3 then
                        stat.value = stat.value + 1
                        Player.def = stat.value
                    elseif stat.id == 4 then
                        stat.value = stat.value * 1.05
                        Player.atkRange = stat.value
                    elseif stat.id == 5 then
                        stat.value = stat.value * 1.05
                        Player.regenPv = stat.value
                    elseif stat.id == 6 then
                        stat.value = stat.value * 1.05
                        Player.regenPv = stat.value
                    else
                        print("Amélioration inconnue !!!")
                    end
                else
                    this.drawHover("Pas assez d'argent")
                    Assets.snd_error:play()
                end
            end
        end

    end
end

this.update = function(dt)
    -- on n'update que l'animation du Player
    if Player.y > 7 * TILESIZE then
        Player.y = Player.y - Player.speed / 2 * dt
    else
        Player.currentAnim = Player.animIdle
    end
    Player.currentAnim.update(Player, dt)
    ItemManager.update(dt)

    local item = ItemManager.getItemAt(mx, my)
    if item ~= nil then
        item.isHover = true
    end

    if love.mouse.isDown(1) then
        selectedItem = item
    else
        if selectedItem ~= nil then
            doSelect()
            selectedItem = nil
        end
    end
end

this.drawHover = function(text)
    local large = WIDTH / 2
    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", (WIDTH - large) / 2, 50, large, 140)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(text, (WIDTH - large) / 2, 56, large, "center")
end

this.draw = function()
    love.graphics.push()
    love.graphics.scale(SCALE)
    love.graphics.translate((-Player.x + (WIDTH / SCALE) / 2), (-Player.y + (HEIGHT / SCALE) / 2))

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(FontVendor12)

    love.graphics.draw(Assets.shop)

    ItemManager.draw()
    Player.draw()
    Assets.draw(Assets.vendor_topdoor, TILESIZE * 6, TILESIZE * 11)

    love.graphics.setColor(0.867, 0.835, 0.251)
    love.graphics.print(Inventory.getPo() .. " po", 96, 160)

    local x, y = love.mouse.getPosition()
    love.graphics.setColor(1, 1, 1, 1)
    mx, my = love.graphics.inverseTransformPoint(x, y)
    love.graphics.rectangle("fill", mx, my, 2, 2)

    love.graphics.pop() -------------------------------------

    love.graphics.setFont(FontVendor32)
    if vendor.isHover then
        this.drawHover(
            "Bonjour Aventurier, fait ton choix sur les tables, et prends les escaliers derrière moi pour continuer ton aventure.")
    end
    if staires.isHover then
        this.drawHover("Si tu as fait tous tes choix, tu peux descendre à l'étage inférieur.")
    end
    for i, stat in pairs(stats) do
        if stat.item.isHover then
            this.drawHover(stat.name .. "=" .. stat.cost .. " po\nValeur actuelle : " .. stat.value)
        end
    end
end

this.keypressed = function(key)

end

return this
