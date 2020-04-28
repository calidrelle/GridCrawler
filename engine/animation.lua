local this = {}

this.createNew = function(quad, nbFrames, secPerFrame, loop)
    local anim = {}
    anim.quad = quad
    anim.nbFrames = nbFrames
    anim.loop = loop
    anim.isPlaying = true
    local duration = secPerFrame
    local timer = secPerFrame
    local frame = 1
    local qx, qy, qw, qh = quad:getViewport() -- si on recréé le player, le viewport se décale

    function anim:reset()
        quad:setViewport(qx, qy, qw, qh)
    end

    function anim:update(dt)
        timer = timer - dt
        if timer <= 0 then
            timer = duration
            frame = frame + 1
            if frame > anim.nbFrames then
                if anim.loop then
                    frame = 1
                else
                    frame = anim.nbFrames
                    anim.isPlaying = false
                end
            end
            quad:setViewport(qx + TILESIZE * (frame - 1), qy, qw, qh)
        end
    end

    function anim:draw(x, y, flip)
        if flip then
            love.graphics.draw(Assets.getSheet(), quad, x + TILESIZE, y, 0, -1, 1, 1)
        else
            love.graphics.draw(Assets.getSheet(), quad, x, y)
        end
    end

    return anim
end

return this
