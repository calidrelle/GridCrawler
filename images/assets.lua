Assets = {}

local sheet = nil

local createQuad = function(x, y)
    return love.graphics.newQuad(x, y, TILESIZE, TILESIZE, sheet:getDimensions()) -- 6
end

Assets.init = function()
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

    Assets.corridor = {}
    Assets.corridor[1] = createQuad(80, 32)
    Assets.corridor[2] = createQuad(80, 48)

    -- Items
    Assets.weapon_sword_1 = createQuad(224, 128)
    Assets.goblin_knife = createQuad(240, 128)

    print("Assets loaded")
end

Assets.getSheet = function()
    return sheet
end

Assets.draw = function(quad, x, y, flip)
    if flip then
        love.graphics.draw(sheet, quad, x + TILESIZE, y, 0, -1, 1, 1)
    else
        love.graphics.draw(sheet, quad, x, y)
    end
end

return Assets
