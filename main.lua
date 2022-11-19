require("statemenu")
require("stategame")
require("stategameover")

function love.load()
    --variables
    state = "MENU"
    gameWidth = 640
    gameHeight = 180
    lives = 0
    score = 0
    saveFile = "hiscores.txt"
    hiscores = {}

    entities = {} --collection of entities

    love.window.setMode(gameWidth, gameHeight, {resizable=false, vsync=false})
    love.graphics.setBackgroundColor(1,1,1) --white
    --load font
    font = love.graphics.newFont("assets/fnt/hour5.ttf",25)
    love.graphics.setFont(font)
    --load images
    background = love.graphics.newImage("assets/img/background.png")
    asteroid = love.graphics.newImage("assets/img/asteroid.png")
    explosion = love.graphics.newImage("assets/img/explosion.png")
    player = love.graphics.newImage("assets/img/player.png")
    shot = love.graphics.newImage("assets/img/shot.png")
    --load sounds
    shipexplosion = love.audio.newSource("assets/snd/explosion+3.wav","static")
    explosionsound = love.audio.newSource("assets/snd/explosion+6.wav","static")
    laser = love.audio.newSource("assets/snd/laserblasts.wav","static")
    laser:setVolume(0.2)
    explosionsound:setVolume(0.2)
    shipexplosion:setVolume(0.2)

    info = love.filesystem.getInfo( saveFile, nil )
    if info == nil then
        --create file
        for i=5,1,-1 do
            data = string.format("%05d", i)
            success, errormsg = love.filesystem.append( saveFile, data, 5 )
            hiscores[i] = i
        end
    else
        --read file
        contents, size = love.filesystem.read( saveFile, info.size )
        hiscores[1] = tonumber(string.sub(contents,0,5))
        hiscores[2] = tonumber(string.sub(contents,6,10))
        hiscores[3] = tonumber(string.sub(contents,11,15))
        hiscores[4] = tonumber(string.sub(contents,16,20))
        hiscores[5] = tonumber(string.sub(contents,21,25))
    end
    
    bkgposx = 0
    bkgspeed = 150
end

function writeHiScores()
    
    table.sort(hiscores, function(a,b) return a > b end)

    --remove file
    love.filesystem.remove( saveFile )
    --write the 5 first elements
    for i=1,5 do
        data = string.format("%05d", hiscores[i])
        success, errormsg = love.filesystem.append( saveFile, data, 5 )
    end
end

function love.keypressed(key)
    if state == "MENU" then statemenu:keypressed(key) end
    if state == "GAME" then stategame:keypressed(key) end
    if state == "GAMEOVER" then stategameover:keypressed(key) end
end

function love.keyreleased(key)
    if state == "MENU" then statemenu:keyreleased(key) end
    if state == "GAME" then stategame:keyreleased(key) end
    if state == "GAMEOVER" then stategameover:keyreleased(key) end
end

function love.update(dt)
    if state == "MENU" then statemenu:update(dt) end
    if state == "GAME" then stategame:update(dt) end
    if state == "GAMEOVER" then stategameover:update(dt) end

    bkgposx = (bkgposx - bkgspeed * dt) % background:getWidth()
end

function love.draw()
    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(background, bkgposx, 0)
    love.graphics.draw(background, bkgposx - background:getWidth(), 0)

    --the states system
    if state == "MENU" then statemenu:draw() end
    if state == "GAME" then stategame.draw() end
    if state == "GAMEOVER" then stategameover:draw() end
end
