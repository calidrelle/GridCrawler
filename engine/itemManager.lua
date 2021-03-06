ItemManager = {}

local items = {}

require("gameobjects.barrel")
require("gameobjects.gold")
require("gameobjects.exitGrid")
require("gameobjects.page")
require("gameobjects.sword")
require("gameobjects.vendor")
require("gameobjects.torch")
require("gameobjects.table")
require("gameobjects.downstairs")
require("gameobjects.bigtable")
require("gameobjects.books")
require("gameobjects.chest")
require("gameobjects.pics")
require("gameobjects.smoke")

-- mobs
require("gameobjects.slim")
require("gameobjects.goblin")
require("gameobjects.zombie")

MOBSTATES = {}
MOBSTATES.NONE = ""
MOBSTATES.WALK = "walk"
MOBSTATES.SEEK = "seek"
MOBSTATES.FIGHT = "fight"
MOBSTATES.CHANGEDIR = "change"

ItemManager.create = function(quad, x, y, width, height)
    local item = {}
    item.quad = quad
    item.x = x
    item.y = y
    width = width or TILESIZE
    height = height or TILESIZE
    item.width = width
    item.height = height
    item.dx = 0
    item.dy = 0
    item.solid = false
    item.actif = true
    item.state = MOBSTATES.NONE
    item.cooldown = 0
    item.click = false
    item.canBeAttacked = false
    item.canDropPage = false
    item.displayPvLost = true
    item.lootTable = {}
    item.path = nil
    item.jumpingTimer = 0
    item.isSelectable = true

    item.pv = 0
    item.pvMax = 0
    item.atkRange = 0
    item.atk = 0
    item.detectRange = 0
    item.speed = 0
    item.atkSpeed = 0
    item.auras = {}
    item.aurasToDeal = {}

    item.initStats = function(pv, atk, atkRange, detectRange, speed, atkSpeed, auraToDeal)
        item.pv = pv
        item.pvMax = pv
        item.atkRange = atkRange
        item.atk = atk
        item.detectRange = detectRange
        item.speed = speed
        item.atkSpeed = atkSpeed
        if auraToDeal ~= nil then
            item.aurasToDeal = auraToDeal
        end
    end

    item.initMobStats = function(mobData)
        item.initStats(mobData.pv, mobData.atk, mobData.atkRange, mobData.detectRange, mobData.speed, mobData.atkSpeed, mobData.auraToDeal)
    end

    item.getCenter = function()
        return item.x + item.width / 2, item.y + item.height / 2
    end

    item.getMapCell = function()
        local cx, cy = item.getCenter()
        return math.floor(cx / TILESIZE), math.floor(cy / TILESIZE)
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
        until not item.checkCollision(dt) or nbTry > 100
    end

    item.checkCollision = function(dt)
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
    end

    item.seek = function(other)
        item.dx = 0
        item.dy = 0
        local ox, oy = other.getMapCell()
        local ix, iy = item.getMapCell()
        item.path = Map.pathfinder.getPath(ix, iy, ox, oy)
        if item.path == nil then
            -- déplacement à l'ancienne
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
        else
            local dist = #item.path.path
            if dist > 1 then
                local px = item.path.path[dist - 1].x * TILESIZE
                local py = item.path.path[dist - 1].y * TILESIZE
                item.dx = math.sign(px - item.x)
                item.dy = math.sign(py - item.y)
            end
        end
    end

    -- virtual
    item.aggroSound = function()
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
                    item.aggroSound()
                end
            end
            if math.random() * 100 < 2 then
                item.state = MOBSTATES.CHANGEDIR
            end

        elseif item.state == MOBSTATES.SEEK then
            if item.target == nil then
                item.path = nil
                item.state = MOBSTATES.CHANGEDIR
            elseif distToPlay > (item.detectRange * 2) then
                item.target = nil
                item.path = nil
                item.state = MOBSTATES.CHANGEDIR
            elseif distToPlay < item.atkRange then
                -- Attaque de la target
                item.state = MOBSTATES.FIGHT
                item.path = nil
                item.dx = 0
                item.dy = 0
            else
                -- poursuite du Player
                item.seek(Player)
                --[[ avec le pathfinder, on ne vérifie pas les collisions
                if item.checkCollision(dt) then
                --     -- item.state = MOBSTATES.CHANGEDIR
                     return
                end ]] --
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
        if item.x > -1 then
            item.isHover = false
            item.update(dt)
            -- Déplacement des items (mobs) qui peuvent se dépacer
            if item.speed ~= nil and item.speed ~= 0 then
                if item.state ~= MOBSTATES.CHANGEDIR then
                    item.x = item.x + item.dx * item.speed * dt
                    item.y = item.y + item.dy * item.speed * dt
                end
                -- en se déplaçant, le mob marche-t-il sur quelque chose ?
                local others = ItemManager.getItemsAt(item.getCenter())
                for _, other in pairs(others) do
                    if other ~= nil and other ~= item and item.state == MOBSTATES.SEEK then
                        other.walkOver(item)
                    end
                end
            end
        end
    end
    for i = #items, 1, -1 do
        if items[i].actif == false then
            table.remove(items, i)
        end
    end
end

ItemManager.getItemsAt = function(x, y)
    local result = {}
    for _, item in pairs(items) do
        if item.x <= x and item.x + item.width >= x and item.y <= y and item.y + item.height >= y then
            table.insert(result, item)
        end
    end
    return result
end

ItemManager.getItemAroundPlayer = function(radius)
    for _, item in pairs(items) do
        if item.isSelectable and item.distanceToOther(Player) < radius then
            return item
        end
    end
    return nil
end

ItemManager.isItemSolidAt = function(x, y)
    local lstItems = ItemManager.getItemsAt(x, y)
    for _, item in pairs(lstItems) do
        if item.solid then
            return true
        end
    end
    return false
end

ItemManager.getItems = function()
    return items
end

ItemManager.getRandomItem = function()
    local r = love.math.random(#items)
    return items[r]
end

ItemManager.draw = function()
    for _, item in pairs(items) do
        if item.x > -1 then
            love.graphics.setColor(1, 1, 1)
            if item.state == MOBSTATES.SEEK then
                Assets.draw(Assets.aggro, item.x, item.y)
            end
            -- si l'item à une animation, on l'affiche, sinon, on affiche le quad de base
            if item.currentAnim ~= nil then
                item.currentAnim.draw(item, item.x, item.y, item.flip)
            else
                Assets.draw(item.quad, item.x, item.y, item.flip, 1, item.rotation)
            end

            -- si l'item à des PV, on les affiche
            if item.pv > 0 then
                love.graphics.setColor(1, 0, 0)
                love.graphics.rectangle("fill", item.x, item.y - 1, TILESIZE * item.pv / item.pvMax, 3) -- La barre de vie à la taille d'une tile
                love.graphics.setColor(0, 0, 0)
                love.graphics.rectangle("line", item.x, item.y - 1, TILESIZE, 3) -- La barre de vie à la taille d'une tile
            end
            if DevMode() then
                if item.path ~= nil then
                    -- Map.pathfinder.draw(item.path)
                end
            end
        end
    end
end

ItemManager.getRandomPoNumber = function(objData)
    return math.random(objData.lootPoMin, objData.lootPoMax)
end

ItemManager.doAttack = function(fighter, target)
    if not target.canBeAttacked then
        return false
    end

    local damage = fighter.atk

    if target == Player then
        if OPTIONS.DIFFICULTY == 1 then
            damage = math.floor(damage * DATA.RATIO_EASY)
        end
        if OPTIONS.DIFFICULTY == 1 then
            damage = math.floor(damage * DATA.RATIO_NORMAL)
        end
        if OPTIONS.DIFFICULTY == 3 then
            damage = math.floor(damage * DATA.RATIO_HARD)
        end
    end

    if damage > 0 then
        print(fighter.name .. " hit " .. target.name .. " for " .. damage .. " damages")
        if target == Player then
            Effects.createFloatingText(damage .. "", target.x, target.y, 4, 1, 0.7, 0)
            Effects.createCamShake(0.1, 10)
        else
            if target.displayPvLost then
                Effects.createFloatingText(damage .. "", target.x, target.y, 4, 1, 1, 1)
            end
        end
        target.pv = target.pv - damage
        if target.pv > 0 then
            Assets.snd_hurt:play()
        end
        -- DOT ?
        for _, aura in pairs(fighter.aurasToDeal) do
            AurasManager.addAura(aura[1], aura[2], target)
        end
    else
        if target ~= Player then
            Effects.createFloatingText("raté", target.x, target.y, 4, 1, 1, 1)
        end
    end

    if target.pv <= 0 then
        if target == Player then
            return true -- game over dans Player
        end
        target.actif = false
        Assets.snd_dead:play()

        -- drop du loot
        ItemManager.doDrop(target)

    end
    return true
end

ItemManager.doDrop = function(mob)
    -- Les items existent déjà, mais à la position -1, -1
    -- Le but est de les positionner dans le champ de jeu
    for _, loot in pairs(mob.lootTable) do
        local lootX, lootY = mob.x, mob.y
        loot.x = lootX
        loot.y = lootY
    end
end

ItemManager.getPoInItems = function()
    local totalPo = 0
    for _, item in pairs(items) do
        for _, loot in pairs(item.lootTable) do
            if loot.name == "gold" then
                totalPo = totalPo + loot.amount
            end
        end
    end
    return totalPo
end

return ItemManager
