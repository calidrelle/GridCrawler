Assets = {}

local sheet = nil

local createQuad = function(x, y)
    return love.graphics.newQuad(x, y, TILESIZE, TILESIZE, sheet:getDimensions())
end

Assets.init = function()
    Assets.titleScreen = love.graphics.newImage("images/EcranTitre.png")
    Assets.button = love.graphics.newImage("images/button.png")

    Assets.gui = love.graphics.newImage("images/gui.png")
    Assets.gui_bottom = love.graphics.newImage("images/gui_bottom.png")

    -- Chargement de la spritesheet
    sheet = love.graphics.newImage("images/SpriteSheet.png")

    -- CHARACTERS
    Assets.knight_idle_anim = createQuad(0, 144)
    Assets.knight_run_anim = createQuad(0, 160)

    Assets.fly_anim_anim = createQuad(0, 64)
    Assets.goblin_idle_anim = createQuad(0, 80)
    Assets.goblin_run_anim = createQuad(0, 96)
    Assets.slime_idle_anim = createQuad(0, 112)
    Assets.slime_run_anim = createQuad(0, 128)

    -- DONJONS
    Assets.empty_gray = createQuad(144, 0)
    Assets.empty_brown = createQuad(160, 0)

    Assets.wall = {}
    Assets.wall[1] = createQuad(240, 0)
    Assets.wall[2] = createQuad(256, 0)
    Assets.wall[3] = createQuad(272, 0)
    Assets.wall[4] = createQuad(240, 16)
    Assets.wall[5] = createQuad(272, 16)
    Assets.wall_grid = createQuad(256, 16)

    Assets.floor = {}
    Assets.floor[1] = createQuad(96, 16)
    Assets.floor[2] = createQuad(112, 16)
    Assets.floor[3] = createQuad(128, 16)
    Assets.floor[4] = createQuad(96, 32)
    Assets.floor[5] = createQuad(128, 32)
    Assets.floor[6] = createQuad(96, 48)
    Assets.floor[7] = createQuad(128, 48)

    Assets.floor_grid = createQuad(112, 32) -- EXIT
    Assets.stairs = createQuad(16, 48)

    Assets.corridor = {}
    Assets.corridor[1] = createQuad(80, 32)
    Assets.corridor[2] = createQuad(80, 48)

    -- Parchemins
    Assets.page = {}
    Assets.page[1] = createQuad(288, 0)
    Assets.page[2] = createQuad(304, 0)
    Assets.page[3] = createQuad(320, 0)
    Assets.page[4] = createQuad(336, 0)
    Assets.page[5] = createQuad(352, 0)
    Assets.page[6] = createQuad(368, 0)
    Assets.page[7] = createQuad(384, 0)
    Assets.page[8] = createQuad(400, 0)

    -- Items
    Assets.gold = createQuad(0, 0)
    Assets.barrel = createQuad(16, 0)
    Assets.key = createQuad(80, 0)

    Assets.weapon_sword = createQuad(224, 64)
    Assets.goblin_knife = createQuad(240, 64)

    ---------- SONDS
    Assets.snd_error = love.audio.newSource("sons/error.wav", "static")
    Assets.snd_shoot = love.audio.newSource("sons/shoot.wav", "static")
    Assets.snd_loot = love.audio.newSource("sons/loot.wav", "static")
    Assets.snd_dead = love.audio.newSource("sons/sfx1.wav", "static")
    Assets.snd_hurt = love.audio.newSource("sons/sfx2.wav", "static")
    Assets.snd_opengrid = love.audio.newSource("sons/opengrid.wav", "static")

    print("Assets loaded")
end

Assets.getSheet = function()
    return sheet
end

Assets.draw = function(quad, x, y, flip, scale, rotation)
    rotation = rotation or 0
    if flip then
        love.graphics.draw(sheet, quad, x + TILESIZE, y, rotation, -1, 1, 1)
    else
        love.graphics.draw(sheet, quad, x, y, rotation, scale, scale)
    end
end

return Assets
