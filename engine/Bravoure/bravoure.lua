Bravoure = {}

local actes = {}

ACTE_NA = "na"
ACTE_LOST = "lost" -- status utilisé pour noter temporairement qu'un acte n'est plus réalisable pour cette partie
ACTE_WIN = "win"

Bravoure.init = function()
    -- Ordre de création important car ordre de sauvegarde
    require("engine.Bravoure.savonette")
    require("engine.Bravoure.harpagon")
    require("engine.Bravoure.gouissedail")
    require("engine.Bravoure.vaccine")
    require("engine.Bravoure.sparadrap")
    require("engine.Bravoure.ecuyer")
    require("engine.Bravoure.chevalier")
    require("engine.Bravoure.paladin")
    require("engine.Bravoure.legolas")
    require("engine.Bravoure.empaleur")
    require("engine.Bravoure.kill100slimes")
    require("engine.Bravoure.kill100goblins")
    require("engine.Bravoure.kill100zombies")
    require("engine.Bravoure.kill100vampires")
    require("engine.Bravoure.kill100squelettes")
    require("engine.Bravoure.niddouillet")
    require("engine.Bravoure.grandArgentier")
    require("engine.Bravoure.monPrecieux")
    require("engine.Bravoure.surLeFil")
    require("engine.Bravoure.martyr")

    Bravoure.load()

    for _, acte in pairs(actes) do
        if acte.dateRealisation == "" or acte.dateRealisation == nil then
            acte.status = ACTE_NA
        else
            acte.status = ACTE_WIN
        end
        print("** Acte " .. acte.name .. " : " .. acte.status)
    end
    print("** Actes de bravoure initialized")
end

Bravoure.create = function(name)
    local acte = {}
    acte.name = name
    acte.description = ""
    acte.dateRealisation = ""
    acte.status = ACTE_NA
    acte.displayed = false
    acte.timerDisplay = 0
    acte.counter = 0

    acte.lost = function()
        acte.status = ACTE_LOST
        print("** Acte " .. acte.name .. " : " .. acte.status)
    end

    acte.reset = function()
        if acte.status == ACTE_LOST then
            acte.status = ACTE_NA
            print("** Acte " .. acte.name .. " initialized for the new level")
        end
    end

    acte.check = function() -- chaque acte de bravoure doit être vérifier
    end

    acte.increment = function(value)
        if value == nil then
            acte.counter = acte.counter + 1
        else
            acte.counter = acte.counter + value
        end
        print("** Acte " .. acte.name .. ", counter : " .. acte.counter)
        acte.check()
    end

    acte.achived = function()
        if acte.status == ACTE_WIN then
            return
        end
        acte.status = ACTE_WIN
        acte.dateRealisation = os.date("%d/%m/%Y %H:%M:%S")
        acte.timerDisplay = 15
        Assets.snd_bravoure:play()
        Bravoure.save()
    end

    acte.update = function(dt)
        if acte.status == ACTE_WIN and not acte.displayed then
            acte.timerDisplay = acte.timerDisplay - dt
            if acte.timerDisplay <= 0 then
                acte.displayed = true
            end
        end
    end

    acte.draw = function(numero)
        local xpos = 40
        local ypos = 40 + acte.timerDisplay * 20 + numero * (Assets.cadre_acte:getHeight() + 10)
        local width = Assets.cadre_acte:getWidth()

        love.graphics.setColor(1, 1, 1, acte.timerDisplay)
        love.graphics.draw(Assets.cadre_acte, xpos, ypos)
        love.graphics.setFont(FontVendor20)
        love.graphics.setColor(1, 0.85, 0)
        love.graphics.printf(acte.name, xpos + 5, ypos + 5, width - 10, "center")
        love.graphics.setColor(0.21, 0.21, 0.21)
        love.graphics.printf(acte.description, xpos + 5, ypos + 30, width - 10, "left")
    end

    table.insert(actes, acte)
    return acte
end

Bravoure.resetLevel = function()
    -- Fonction qui itinialise les actes par niveau
    Bravoure.Savonnette.reset()
end

Bravoure.update = function(dt)
    for _, acte in pairs(actes) do
        acte.update(dt)
    end
end

Bravoure.draw = function()
    local nb = 0
    for _, acte in pairs(actes) do
        if acte.status == ACTE_WIN and acte.displayed == false then
            acte.draw(nb)
            nb = nb + 1
        end
    end
end

Bravoure.load = function()
    if love.filesystem.getInfo("bravoure.sav") == nil then
        return
    end
    local values = {}
    for line in love.filesystem.lines("bravoure.sav") do
        table.insert(values, line)
    end

    for i, acte in pairs(actes) do
        acte.dateRealisation = values[i]
    end
    print("** Bravoure loaded")
end

Bravoure.save = function()
    local strBravoure = ""

    for i, acte in pairs(actes) do
        strBravoure = strBravoure .. wile.nvl(acte.dateRealisation) .. "\n"
    end

    love.filesystem.write("bravoure.sav", strBravoure)
    print("** Bravoure saved")
end

return Bravoure

