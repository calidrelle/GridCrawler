local this = {}

this.createNew = function(quad, nbFrames, secPerFrame, loop)
    local anim = {}
    anim.quads = {}
    local qx, qy, qw, qh = quad:getViewport()
    for i = 0, nbFrames - 1 do
        table.insert(anim.quads, love.graphics.newQuad(qx + i * qw, qy, qw, qh, Assets.getSheet():getDimensions()))
    end
    anim.nbFrames = nbFrames
    anim.loop = loop
    anim.isPlaying = true
    local duration = secPerFrame
    local timer = secPerFrame
    local frame = math.random(nbFrames)

    function anim:reset()
        frame = 1
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
        end
    end

    function anim:draw(x, y, flip)
        if flip then
            love.graphics.draw(Assets.getSheet(), anim.quads[frame], x + TILESIZE, y, 0, -1, 1, 1)
        else
            love.graphics.draw(Assets.getSheet(), anim.quads[frame], x, y)
        end
    end

    return anim
end

return this
