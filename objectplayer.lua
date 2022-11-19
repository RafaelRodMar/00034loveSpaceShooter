objectplayer = {}

objectplayer_mt = { __index = objectplayer }

function objectplayer:new(name, tex, x, y, w, h, u, v, nFrames, ang, rad)
    local entity = {}
    setmetatable(entity, objectplayer_mt)
    
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
    entity.isDying = false

    for i=0, entity.numFrames do
        table.insert(entity.frames, love.graphics.newQuad(u,v,w,h,tex:getWidth(), tex:getHeight()))
        u = u + entity.width
    end

    return entity
end

function objectplayer:update(dt)
    if self.isDying then return end

    self.currentFrame = self.currentFrame + dt * 15 --number is speed
    if self.currentFrame >= self.numFrames then
        self.currentFrame = self.currentFrame - self.numFrames
    end

    if love.keyboard.isDown( 'left' ) and (self.posx - 300 * dt) >= 20 then
        self.posx = self.posx - 300 * dt
    end
    if love.keyboard.isDown( 'right' ) and (self.posx + 300 * dt) <= (gameWidth - self.width) then
        self.posx = self.posx + 300 * dt
    end
    if love.keyboard.isDown( 'up' ) and (self.posy - 300 * dt) >= 20 then
        self.posy = self.posy - 300 * dt
    end
    if love.keyboard.isDown( 'down' ) and (self.posy + 300 * dt) <= (gameHeight) then
        self.posy = self.posy + 300 * dt
    end
end

function objectplayer:draw()
    local cFrame = math.floor(self.currentFrame / self.numFrames * #self.frames)
    if cFrame < 1 then 
        cFrame = 1
    elseif cFrame > self.numFrames then
        cFrame = self.numFrames
    end

    if not self.isDying then
        love.graphics.draw(self.texture, self.frames[cFrame],self.posx,self.posy, math.rad(self.angle), 1, 1, 20, 20, 0, 0)
    end
end