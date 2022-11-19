objectasteroid = {}

objectasteroid_mt = { __index = objectasteroid }

function objectasteroid:new(name, tex, x, y, w, h, u, v, nFrames, ang, rad)
    local entity = {}
    setmetatable(entity, objectasteroid_mt)
    
    entity.name = name
    entity.texture = tex
    entity.posx = x
    entity.posy = y
    entity.width = w
    entity.height = h
    entity.velx = 0
    entity.vely = 0
    entity.angle = ang
    entity.radius = rad
    entity.alpha = 0
    entity.frames = {}
    entity.currentRow = 0
    entity.currentFrame = 1
    entity.numFrames = nFrames
    entity.thrust = 0
    entity.destroy = false

    entity.velx = love.math.random(20,150)

    for i=0, entity.numFrames do
        table.insert(entity.frames, love.graphics.newQuad(u,v,w,h,tex:getWidth(), tex:getHeight()))
        u = u + entity.width
    end

    return entity
end

function objectasteroid:update(dt)
    self.posx = self.posx - self.velx * dt
    
    if self.posx < 0 then
        self.destroy = true
    end

    if self.numFrames > 1 then
        self.currentFrame = self.currentFrame + dt * 10 --number is speed
        if self.currentFrame >= self.numFrames then
            self.currentFrame = self.currentFrame - self.numFrames
        end
    end
end

function objectasteroid:draw()
    local cFrame = math.floor(self.currentFrame / self.numFrames * #self.frames)
    if cFrame < 1 then 
        cFrame = 1
    elseif cFrame > self.numFrames then
        cFrame = self.numFrames
    end
    love.graphics.draw(self.texture, self.frames[cFrame],self.posx,self.posy, math.rad(self.angle), 1, 1, 20, 20, 0, 0)
end
