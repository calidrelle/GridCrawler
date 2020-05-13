-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newBoss = function(tileX, tileY)
    local ATKSTATE_SEEK = {id = "seek", duration = 0}
    local ATKSTATE_PREPARE = {id = "prepare", duration = 2}
    local ATKSTATE_ATTAQUE = {id = "attack", duration = 10}
    local ATKSTATE_REGEN = {id = "regen", duration = 7}

    local item = ItemManager.create(Assets.boss_run_anim, tileX, tileY, 32, 32)
    item.name = "boss"
    item.solid = true -- item collide with player/mob ?
    item.canBeAttacked = true
    item.canDropPage = true -- il possède les 8 pages !

    item.level = 1
    item.initMobStats(DATA.boss)
    item.animRun = require("engine.animation").createNew(Assets.boss_run_anim, 5, 0.1, true)
    item.animFire = require("engine.animation").createNew(Assets.boss_fire_anim, 3, 0.05, true)
    item.animPrepareFire = require("engine.animation").createNew(Assets.boss_fire_anim, 3, 0.15, true)
    item.animRegen = require("engine.animation").createNew(Assets.boss_run_anim, 1, 0.05, true)
    item.currentAnim = item.animRun

    item.atkStatus = ATKSTATE_SEEK
    item.atkTimer = 0
    item.coefModAttack = 4
    item.bloodTimer = 8

    item.hit = function(other)
    end

    item.addPo = function()
        -- table.insert(item.lootTable, ItemManager.newGold(-1, -1, ItemManager.getRandomPoNumber(DATA.___)))
    end

    item.walkOver = function(other)
    end

    item.draw = function()
        if DevMode() then
            -- love.graphics.print(item.atkStatus.id .. "/" .. wile.display1decimale(item.atkTimer), item.x, item.y)
            -- local cx, cy = item.getCenter()
            -- love.graphics.circle("line", cx, cy, item.atkRange)
            -- love.graphics.circle("line", cx, cy, item.atkRange * coefModAttack)
        end
    end

    item.castSpells = function()
        for i = 1, math.random(10, 45) do
            ItemManager.newSpell(item.x, item.y, math.random() * 2 * math.pi)
        end
    end

    item.update = function(dt)
        --[[
            Machine à état : 
                - le boss court après le joueur : fait très mal
                - il se prépare à attaquer, attaquable
                - il attaque : attaquable, lancement des sorts à éviter
                - il se regen : attaquable
        ]]
        if item.pv <= 0 then
            if item.bloodTimer < 2 then
                item.alpha = item.alpha - dt / 2
            end
            item.solid = false
            if item.bloodTimer >= 0 then
                item.bloodTimer = item.bloodTimer - dt
                local x, y = item.getCenter()
                Effects.createFloatingText("+", x, y, 3, 1, 0, 0, -8)
            else
                item.actif = false
            end
            return
        end

        item.updateState(dt)
        item.currentAnim:update(dt)

        if Player.pv <= 0 then
            item.state = MOBSTATES.NONE
            return
        end

        if item.state == MOBSTATES.SEEK and item.distToPlay <= item.atkRange * item.coefModAttack then
            if math.random(100) <= 2 then
                item.state = MOBSTATES.MANAGED
                return
            end
        end

        if item.state == MOBSTATES.MANAGED then
            if item.atkStatus == ATKSTATE_SEEK then
                item.dx = 0
                item.dy = 0
                item.currentAnim = item.animPrepareFire
                item.atkStatus = ATKSTATE_PREPARE
                Assets.snd_boss_prepare:play()
                item.atkTimer = item.atkStatus.duration
                item.atk = 0
                return

            elseif item.atkStatus == ATKSTATE_PREPARE then
                item.atkTimer = item.atkTimer - dt
                if item.atkTimer <= 0 then
                    item.atkStatus = ATKSTATE_ATTAQUE
                    item.atkTimer = item.atkStatus.duration
                    item.currentAnim = item.animFire
                    item.castTime = 0 -- pour tirer dès la passage à l'état ATKSTATE_ATTAQUE
                    return
                end

            elseif item.atkStatus == ATKSTATE_ATTAQUE then
                item.atkTimer = item.atkTimer - dt
                item.castTime = item.castTime - dt
                if item.castTime <= 0 then
                    item.castSpells()
                    item.castTime = item.atkSpeed
                end

                if item.atkTimer <= 0 then
                    item.atkStatus = ATKSTATE_REGEN
                    Assets.snd_boss_regen:play()
                    item.atkTimer = item.atkStatus.duration
                    item.currentAnim = item.animRegen
                    return
                end

            elseif item.atkStatus == ATKSTATE_REGEN then
                -- Phase durant laquelle il est attaquable
                item.atkTimer = item.atkTimer - dt
                if item.atkTimer <= 0 then
                    item.atkStatus = ATKSTATE_SEEK
                    Assets.snd_boss_aggro:play()
                    item.atkTimer = item.atkStatus.duration
                    item.currentAnim = item.animRun
                    item.state = MOBSTATES.NONE
                    item.atk = DATA.boss.atk
                    return
                end
            end
        end

        -- print("item.atkStatus, item.atk : " .. item.atkStatus .. ", " .. item.atk)
    end

    return item
end
