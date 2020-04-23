local this = {}

this.createNew = function(quad, nbFrames, secPerFrame)
    local anim = {}
    anim.quad = quad
    anim.nbFrames = nbFrames
    local duration = secPerFrame
    local timer = secPerFrame
    local frame = 1
    local x, y, w, h = quad:getViewport()

    function anim:update(dt)
        timer = timer - dt
        if timer <= 0 then
            timer = duration
            frame = frame + 1
            if frame > anim.nbFrames then
                frame = 1
            end
            quad:setViewport(x + TILESIZE * (frame - 1), y, w, h)
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
