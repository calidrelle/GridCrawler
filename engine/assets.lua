Assets = {}

TILESIZE = 16

local sheet = nil

local createQuad = function(x, y, w, h)
    w = w or TILESIZE
    h = h or TILESIZE
    return love.graphics.newQuad(x, y, w, h, sheet:getDimensions())
end

Assets.init = function()
    -- IMAGES
    Assets.titleScreen = love.graphics.newImage("images/EcranTitre.png")
    Assets.title = love.graphics.newImage("images/title.png")
    Assets.button = love.graphics.newImage("images/button.png")
    Assets.gui = love.graphics.newImage("images/gui.png")
    Assets.gui_bottom = love.graphics.newImage("images/gui_bottom.png")
    Assets.GameOver = love.graphics.newImage("images/gameover.png")
    Assets.outside = love.graphics.newImage("images/outside.png")
    Assets.shop = love.graphics.newImage("images/shop.png")
    Assets.lowlife = love.graphics.newImage("images/lowlife.png")
    Assets.cadre_acte = love.graphics.newImage("images/cadre_actes.png")

    -- SPRITESHEET
    sheet = love.graphics.newImage("images/SpriteSheet.png")

    -- CHARACTERS
    Assets.knight_idle_anim = createQuad(0, 144)
    Assets.knight_run_anim = createQuad(0, 160)
    Assets.knight_death_anim = createQuad(288, 16)
    Assets.vendor_idle_anim = createQuad(288, 32)

    -- MOBS
    Assets.fly_anim_anim = createQuad(0, 64)
    Assets.goblin_idle_anim = createQuad(0, 80)
    Assets.goblin_run_anim = createQuad(0, 96)
    Assets.slime_idle_anim = createQuad(0, 112)
    Assets.slime_run_anim = createQuad(0, 128)
    Assets.zombie_idle_anim = createQuad(288, 48)
    Assets.zombie_run_anim = createQuad(288, 64)
    Assets.vampire_idle_anim = createQuad(288, 80)
    Assets.vampire_run_anim = createQuad(288, 96)
    Assets.squelette_run_anim = createQuad(352, 32)
    Assets.boss_run_anim = createQuad(0, 208, 32, 32)
    Assets.boss_fire_anim = createQuad(0, 208, 32, 32)

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

    Assets.vendor_topdoor = createQuad(128, 144, 32)

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
    Assets.floor_grid = createQuad(112, 32) -- EXIT
    Assets.downstairs = createQuad(16, 48)
    Assets.table = createQuad(80, 16)
    Assets.bigTable = createQuad(0, 16, 32, 16)
    Assets.books = createQuad(32, 0)
    Assets.chest = createQuad(96, 80)
    Assets.chest_open = createQuad(224, 80)
    Assets.torch = createQuad(96, 112)
    Assets.pics = createQuad(96, 128)
    Assets.weapon_sword = createQuad(224, 64)
    Assets.goblin_knife = createQuad(240, 64)
    Assets.smoke = createQuad(96, 96)
    Assets.aggro = createQuad(240, 48)
    Assets.poison = createQuad(272, 48)
    Assets.saignement = createQuad(256, 48)
    Assets.morsure = createQuad(256, 64)

    ---------- SONDS
    Assets.snd_error = love.audio.newSource("sons/error.wav", "static")
    Assets.snd_shoot = love.audio.newSource("sons/shoot.wav", "static")
    Assets.snd_loot = love.audio.newSource("sons/loot.wav", "static")
    Assets.snd_dead = love.audio.newSource("sons/dead.wav", "static")
    Assets.snd_hurt = love.audio.newSource("sons/hurt.wav", "static")
    Assets.snd_opengrid = love.audio.newSource("sons/opengrid.wav", "static")
    Assets.snd_jump = love.audio.newSource("sons/jump.wav", "static")
    Assets.snd_nostamina = love.audio.newSource("sons/nostamina.wav", "static")
    Assets.snd_deathplayer = love.audio.newSource("sons/death_player.wav", "static")
    Assets.snd_lootpage = love.audio.newSource("sons/loot_page.wav", "static")
    Assets.snd_pay = love.audio.newSource("sons/pay.wav", "static")
    Assets.snd_pics = love.audio.newSource("sons/pics.wav", "static")
    Assets.snd_outch = love.audio.newSource("sons/outch.wav", "static")
    Assets.snd_bravoure = love.audio.newSource("sons/bravoure.mp3", "static")

    Assets.snd_btnHover = love.audio.newSource("sons/btn_hover.wav", "static")
    Assets.snd_btnClicked = love.audio.newSource("sons/btn_clicked.wav", "static")

    Assets.snd_aggro_slim = love.audio.newSource("sons/aggro_slim.wav", "static")
    Assets.snd_aggro_goblin = love.audio.newSource("sons/aggro_goblin.wav", "static")
    Assets.snd_aggro_zombie = love.audio.newSource("sons/aggro_zombie.wav", "static")
    Assets.snd_aggro_vampire = love.audio.newSource("sons/aggro_vampire.wav", "static")
    Assets.snd_aggro_squlette = love.audio.newSource("sons/aggro_squelette.wav", "static")

    Assets.snd_boss_aggro = love.audio.newSource("sons/boss_aggro.wav", "static")
    Assets.snd_boss_prepare = love.audio.newSource("sons/boss_prepare.wav", "static")
    Assets.snd_boss_regen = love.audio.newSource("sons/boss_regen.wav", "static")
    Assets.snd_boss_death = love.audio.newSource("sons/boss_death.wav", "static")
    Assets.snd_spell = love.audio.newSource("sons/spell.wav", "static")

    print("Assets loaded")
end

Assets.getSheet = function()
    return sheet
end

Assets.draw = function(quad, x, y, flip, scale, rotation)
    rotation = rotation or 0
    if flip then
        love.graphics.draw(sheet, quad, x + TILESIZE, y, 0, -1, 1, 1)
    else
        if rotation == 0 then
            love.graphics.draw(sheet, quad, x, y, 0, scale, scale)
        else
            love.graphics.draw(sheet, quad, x + TILESIZE / 2, y + TILESIZE / 2, rotation, scale, scale, TILESIZE / 2, TILESIZE / 2)
        end
    end
end

return Assets
