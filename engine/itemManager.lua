ItemManager = {}

local items = {}

require("gameobjects.barrel")
require("gameobjects.gold")
require("gameobjects.exitGrid")
require("gameobjects.page")
require("gameobjects.sword")

-- mobs
require("gameobjects.slim")

MOBSTATES = {}
MOBSTATES.NONE = ""
MOBSTATES.WALK = "walk"
MOBSTATES.SEEK = "seek"
MOBSTATES.FIGHT = "fight"
MOBSTATES.CHANGEDIR = "change"

ItemManager.create = function(quad, x, y)
    local item = {}
    item.quad = quad
    item.x = x
    item.y = y
    item.width = TILESIZE
    item.height = TILESIZE
    item.dx = 0
    item.dy = 0
    item.solid = false
    item.actif = true
    item.state = MOBSTATES.NONE
    item.cooldown = 0

    item.initStats = function(pv, atk, def, atkRange, detectRange, speed, atkSpeed)
        item.pv = pv
        item.pvMax = pv
        item.atkRange = atkRange
        item.atk = atk
        item.def = def
        item.detectRange = detectRange
        item.speed = speed
        item.atkSpeed = atkSpeed
    end

    item.getCenter = function()
        return item.x + item.width / 2, item.y + item.height / 2
    end

    item.distanceToOther = function(other)
        local ix, iy = item.getCenter()
        local px, py = other.getCenter()
        return math.sqrt((ix - px) * (ix - px) + (iy - py) * (iy - py))
    end

    item.chooseRandomDirection = function(dt)
        local nbTry = 0
        repeat
            nbTry = nbTry + 1
            local angle = math.pi / 2 * (math.random(4) - 1)
            -- local angle = math.random() * 2 * math.pi
            item.dx = math.cos(angle)
            item.dy = math.sin(angle)
            if nbTry > 80 then
                print("bizzare : " .. nbTry)
            end
        until not item.checkCollision(dt) or nbTry > 100
    end

    item.checkCollision = function(dt)
        local collision = false
        local approx = 4 -- bounding box de l'objet
        local tdx = item.dx * item.speed * dt
        local tdy = item.dy * item.speed * dt

        local x1 = tdx + item.x + approx
        local x2 = tdx + item.x + item.width - approx
        local y1 = tdy + item.y + approx
        local y2 = tdy + item.y + item.height - approx

        local colX
        if item.dx < 0 then
            colX = Map.collideAt(x1, y1) or Map.collideAt(x1, y2)
        elseif item.dx > 0 then
            colX = Map.collideAt(x2, y1) or Map.collideAt(x2, y2)
        end
        if colX then
            tdx = 0
            item.dx = 0
        end
        x1 = tdx + item.x + approx
        x2 = tdx + item.x + item.width - approx
        y1 = tdy + item.y + approx
        y2 = tdy + item.y + item.height - approx

        local colY
        if item.dy < 0 then
            colY = Map.collideAt(x1, y1) or Map.collideAt(x2, y1)
        elseif item.dy > 0 then
            colY = Map.collideAt(x1, y2) or Map.collideAt(x2, y2)
        end
        if colY then
            tdy = 0
            item.dy = 0
        end

        return (colX or colY)

        -- les mobs se collisionnent entre eux ou avec les objets ?
        -- local px, py = item.getCenter()
        -- local other = ItemManager.getItemAt(px + tdx, py + tdy)
        -- if other ~= nil then
        --     collision = (other ~= item)
        -- end
    end

    item.seek = function(other)
        local ox, oy = other.getCenter()
        local ix, iy = item.getCenter()
        if ox > ix then
            item.dx = 1
        elseif ox < ix then
            item.dx = -1
        end
        if oy < iy then
            item.dy = -1
        elseif oy > iy then
            item.dy = 1
        end
    end

    -- certains items comme les mobs, on une AI
    item.updateState = function(dt)
        local distToPlay = item.distanceToOther(Player)
        if item.state == MOBSTATES.NONE then
            item.state = MOBSTATES.CHANGEDIR

        elseif item.state == MOBSTATES.WALK then
            if item.checkCollision(dt) then
                item.state = MOBSTATES.CHANGEDIR
            end
            if distToPlay < item.detectRange then
                if Player.pv > 0 then
                    item.target = Player
                    item.state = MOBSTATES.SEEK
                end
            end
            if math.random() * 100 < 2 then
                item.state = MOBSTATES.CHANGEDIR
            end

        elseif item.state == MOBSTATES.SEEK then
            if item.target == nil then
                item.state = MOBSTATES.CHANGEDIR
            elseif distToPlay > item.detectRange then
                item.target = nil
                item.state = MOBSTATES.CHANGEDIR
            elseif distToPlay < item.atkRange then
                -- Attaque de la target
                item.state = MOBSTATES.FIGHT
                item.dx = 0
                item.dy = 0
            else
                -- poursuite du Player
                item.seek(Player)
                if item.checkCollision(dt) then
                    item.state = MOBSTATES.CHANGEDIR
                    return
                end
            end

        elseif item.state == MOBSTATES.FIGHT then
            if Player.pv <= 0 then
                item.state = MOBSTATES.CHANGEDIR
            elseif distToPlay > item.atkRange then
                item.state = MOBSTATES.SEEK
            else
                -- attaque du Player
                if item.cooldown <= 0 then
                    ItemManager.doAttack(item, Player)
                    item.cooldown = item.atkSpeed
                else
                    item.cooldown = item.cooldown - dt
                end
            end

        elseif item.state == MOBSTATES.CHANGEDIR then
            item.chooseRandomDirection(dt)
            item.state = MOBSTATES.WALK
        else
            error("Etat non géré : " .. item.state)
        end
    end

    table.insert(items, item)
    return item
end

ItemManager.reset = function()
    items = {}
end

ItemManager.update = function(dt)
    for _, item in pairs(items) do
        item.update(dt)
        -- Déplacement des items (mobs) qui peuvent se dépacer
        if item.speed ~= nil then
            if item.state ~= MOBSTATES.CHANGEDIR then
                item.x = item.x + item.dx * item.speed * dt
                item.y = item.y + item.dy * item.speed * dt
            end
        end
    end
    for i = #items, 1, -1 do
        if items[i].actif == false then
            table.remove(items, i)
        end
    end
end

ItemManager.getItemAt = function(x, y)
    for _, item in pairs(items) do
        if item.x <= x and item.x + TILESIZE >= x and item.y <= y and item.y + TILESIZE >= y then
            return item
        end
    end
    return nil
end

ItemManager.isItemSolidAt = function(x, y)
    local item = ItemManager.getItemAt(x, y)
    if item == nil then
        return false
    else
        return item.solid == true
    end
end

ItemManager.getItems = function()
    return items
end

ItemManager.draw = function()
    for _, item in pairs(items) do
        -- si l'item à une animation, on l'affiche, sinon, on affiche le quad de base
        love.graphics.setColor(1, 1, 1)
        if item.currentAnim ~= nil then
            item.currentAnim.draw(item, item.x, item.y, item.flip)
        else
            -- scale = 1 car on est sur l'écran, donc le zoom est géré globalement
            Assets.draw(item.quad, item.x, item.y, item.flip, 1, item.rotation)
        end

        -- si l'item à des PV, on les affiche
        if item.pv > 0 then
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", item.x, item.y, TILESIZE * item.pv / item.pvMax, 3) -- La barre de vie à la taille d'une tile
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("line", item.x, item.y, TILESIZE, 3) -- La barre de vie à la taille d'une tile
        end
    end
end

ItemManager.doAttack = function(fighter, target)
    if target.name == "exit" or target.name == "sword" or target.name == "gold" or target.name:sub(1, 4) == "page" then
        return false
    end

    local damage = math.random(fighter.atk) - target.def
    if damage > 0 then
        print(fighter.name .. " hit " .. target.name .. " for " .. damage .. " damages")
        if target == Player then
            Effects.createFloatingText(damage .. "", target.x, target.y, 4, 1, 0.7, 0)
        else
            Effects.createFloatingText(damage .. "", target.x, target.y, 4, 1, 1, 1)
        end
        target.pv = target.pv - damage
        if target.pv > 0 then
            Assets.snd_hurt:play()
        end
    else
        print(fighter.name .. " missed " .. target.name)
    end

    if target.pv <= 0 then
        if target == Player then
            return true -- game over dans Player
        end
        target.actif = false
        Assets.snd_dead:play()

        if target.loot == nil then
            ItemManager.newGold(target.x, target.y)
        else
            if string.sub(target.loot, 1, 4) == "page" then
                ItemManager.newPage(target.x, target.y, string.sub(target.loot, 5) + 0)
            end
        end
    end
    return true
end

return ItemManager
