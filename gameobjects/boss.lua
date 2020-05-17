-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newBoss = function(tileX, tileY)
    local ATKSTATE_SEEK = {id = "seek", duration = 0}
    local ATKSTATE_PREPARE = {id = "prepare", duration = 2}
    local ATKSTATE_ATTAQUE1 = {id = "attack1", duration = 10}
    local ATKSTATE_ATTAQUE2 = {id = "attack2", duration = 10}
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

    item.slims = {} -- A détruire lors de la mort du boss

    item.atkStatus = ATKSTATE_SEEK
    if math.random(100) <= 50 then
        item.currentAttack = ATKSTATE_ATTAQUE1
    else
        item.currentAttack = ATKSTATE_ATTAQUE2
    end

    item.seekTime = DATA.boss.seekTime
    item.atkTimer = 0
    item.bloodTimer = 8

    item.angleAtk2 = 0
    item.deltaAngleAtk2 = 0

    if OPTIONS.DIFFICULTY == 2 then
        DATA.boss.addPopTimer = DATA.boss.addPopTimer + 5
    elseif OPTIONS.DIFFICULTY == 1 then
        DATA.boss.addPopTimer = DATA.boss.addPopTimer + 10
    end
    item.addPopTimer = DATA.boss.addPopTimer

    item.hit = function(other)
    end

    item.addPo = function()
    end

    item.walkOver = function(other)
    end

    item.draw = function()
    end

    item.onDie = function()
        print("BOSS DIE")
        for _, slim in pairs(item.slims) do
            slim.actif = false
        end
    end

    item.castSpells = function()
        local x, y = item.getCenter()
        x = x - 8
        y = y - 8
        for i = 1, math.random(10, 45) do
            ItemManager.newSpell(x, y, math.random() * 2 * math.pi)
        end
        Assets.snd_spell:play()
    end

    item.castSpellsEtoile = function()
        local x, y = item.getCenter()
        x = x - 8
        y = y - 8
        local dx, dy = math.cos(item.angleAtk2), math.sin(item.angleAtk2)

        for n = 10, WIDTH / 3, TILESIZE do
            ItemManager.newSpell(x + dx * n, y + dy * n, nil)
        end

        dx, dy = math.cos(item.angleAtk2 + math.pi * 2 / 3), math.sin(item.angleAtk2 + math.pi * 2 / 3)

        for n = 10, WIDTH / 3, TILESIZE do
            ItemManager.newSpell(x + dx * n, y + dy * n, nil)
        end

        dx, dy = math.cos(item.angleAtk2 + math.pi * 4 / 3), math.sin(item.angleAtk2 + math.pi * 4 / 3)

        for n = 10, WIDTH / 3, TILESIZE do
            ItemManager.newSpell(x + dx * n, y + dy * n, nil)
        end

        item.angleAtk2 = item.angleAtk2 + item.deltaAngleAtk2
        for n = 0, 360, 15 do
            local a = math.rad(n)
            ItemManager.newSpell(x + math.cos(a) * 25, y + math.sin(a) * 25, nil)
            ItemManager.newSpell(x + math.cos(a) * 50, y + math.sin(a) * 50, nil)
        end
        Assets.snd_laser:play()
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

        item.seekTime = item.seekTime - dt
        if item.state == MOBSTATES.SEEK and item.seekTime <= 0 then
            item.state = MOBSTATES.MANAGED
            return
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
                    if item.currentAttack == ATKSTATE_ATTAQUE1 then
                        item.currentAttack = ATKSTATE_ATTAQUE2
                        if math.random(100) <= 50 then
                            item.deltaAngleAtk2 = math.rad(10)
                        else
                            item.deltaAngleAtk2 = math.rad(-10)
                        end
                    else
                        item.currentAttack = ATKSTATE_ATTAQUE1
                    end

                    item.atkStatus = item.currentAttack
                    item.atkTimer = item.atkStatus.duration
                    item.currentAnim = item.animFire
                    item.castTime = 0 -- pour tirer dès la passage à l'état ATKSTATE_ATTAQUE
                    return
                end

            elseif item.atkStatus == ATKSTATE_ATTAQUE1 then
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

            elseif item.atkStatus == ATKSTATE_ATTAQUE2 then
                item.atkTimer = item.atkTimer - dt
                item.castTime = item.castTime - dt
                if item.castTime <= 0 then
                    item.castSpellsEtoile()
                    item.castTime = 0.2
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
                    item.seekTime = DATA.boss.seekTime
                    Assets.snd_boss_aggro:play()
                    item.atkTimer = item.atkStatus.duration
                    item.currentAnim = item.animRun
                    item.state = MOBSTATES.NONE
                    item.atk = DATA.boss.atk
                    return
                end
            end
        end

        -- pop des adds
        item.addPopTimer = item.addPopTimer - dt
        if item.addPopTimer <= 0 then
            item.addPopTimer = DATA.boss.addPopTimer
            local slim = ItemManager.newSlim(Map.grid.x * TILESIZE, Map.grid.y * TILESIZE, 1)
            table.insert(item.slims, slim)
        end

    end -- item.update

    return item
end
