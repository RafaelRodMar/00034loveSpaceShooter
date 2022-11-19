objectbullet = {}

objectbullet_mt = { __index = objectbullet }

function objectbullet:new(name, tex, x, y, w, h, u, v, nFrames, ang, rad)
    local entity = {}
    setmetatable(entity, objectbullet_mt)
    
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

    for i=0, entity.numFrames do
        table.insert(entity.frames, love.graphics.newQuad(u,v,w,h,tex:getWidth(), tex:getHeight()))
        u = u + entity.width
    end

    return entity
end

function objectbullet:update(dt)
    self.posx = self.posx + 20 * dt * 50

    if self.posx > gameWidth or self.posx < 0 or
        self.posy > gameHeight or self.posy < 0 then
            self.destroy = true --remove it from game
    end

    if self.numFrames > 1 then
        self.currentFrame = self.currentFrame + dt * 15 --number is speed
        if self.currentFrame >= self.numFrames then
            self.currentFrame = self.currentFrame - self.numFrames
        end
    end
end

function objectbullet:draw()
    local cFrame = math.floor(self.currentFrame / self.numFrames * #self.frames)
    if cFrame < 1 then 
        cFrame = 1
    elseif cFrame > self.numFrames then
        cFrame = self.numFrames
    end
    love.graphics.draw(self.texture, self.frames[cFrame],self.posx,self.posy, math.rad(self.angle), 1, 1, 20, 20, 0, 0)
end