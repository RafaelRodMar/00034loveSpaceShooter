require("objectplayer")
require("objectasteroid")
require("objectbullet")
require("objectexplosion")

stategame = {}

function stategame:load()
end

function stategame:reset()
    lives = 3
    score = 0

    entities = {}

    --create the player
    local player = objectplayer:new("player", player, 20,  gameHeight / 2, 16, 16,
    0, 0, 2, 0, 20)
    table.insert(entities, player)
end

function stategame:keypressed(key)
    if key == 'space' and not entities[1].isDying then
        local bullet = objectbullet:new("bullet", shot, entities[1].posx, entities[1].posy,
        16, 16, 0, 0, 2, 0, 16)
        table.insert(entities, bullet)
        cl = laser:clone()
        cl:play()
    end
end

function stategame:keyreleased(key)
end

function isCollide(a,b)
    if a.posx < b.posx + b.width and
        a.posx + a.width > b.posx and
        a.posy < b.posy + b.height and
        a.posy + a.height > b.posy then
            return true
        end

    return false
end

function isCollideRadius(a,b)
	return (b.posx - a.posx)*(b.posx - a.posx) +
		(b.posy - a.posy)*(b.posy - a.posy) <
		(a.radius + b.radius)*(a.radius + b.radius)
end

function stategame:update(dt)
    --create the asteroids
    if love.math.random(0,100) <= 1 and #entities < 6 then
        local ast = objectasteroid:new("asteroid", asteroid, gameWidth + 1, love.math.random(0,gameHeight), 16, 16,
        0,0,2, 0, 25)
        table.insert(entities, ast)
    end

    for i,v in ipairs(entities) do
        v:update(dt)
    end

    for i,v in ipairs(entities) do
        for j,w in ipairs(entities) do
            if v.name == "bullet" and v.destroy == false and w.name == "asteroid" and w.destroy == false then
                if(isCollide(v,w)) then
                    explosionsound:play()

                    --mark them for being destroyed later
                    v.destroy = true
                    w.destroy = true

                    local exp = objectexplosion:new("explosion", explosion, w.posx, w.posy,
                    32, 32, 0,0, 1, 0,0)
                    table.insert(entities, exp)
                    
                    score = score + 10
                    break
                end
            end

            if v.name == "player" and w.name == "asteroid" and w.destroy == false then
                if(isCollide(v,w)) then
                    w.destroy = true

                    local shipexp = objectexplosion:new("shipexplosion", explosion, w.posx, w.posy,
                    32,32,0,0,1,0,0)
                    table.insert(entities, shipexp)

                    shipexplosion:play()
                    entities[1].isDying = true
                    lives = lives - 1
                    if lives <= 0 then
                        entities[1].isDying = false
                        table.insert(hiscores, score)
                        writeHiScores()
                        state = "GAMEOVER"
                    end

                    entities[1].posx = 20
                    entities[1].posy = love.math.random(0,gameHeight)
                end
            end
        end
    end

    --destroy marked elements
    for i=#entities, 1, -1 do
        if entities[i].destroy == true then
            if entities[i].name == "shipexplosion" then
                entities[1].isDying = false
            end
            table.remove(entities,i)
        end
    end
end

function stategame:draw()
    love.graphics.setColor(1,1,1)
    for i,v in ipairs(entities) do
        v:draw()
    end

    --draw UI
    love.graphics.setColor(1,0,0)
    love.graphics.print("LIVES: " .. lives .. "   SCORE: " .. score, 5, 10)
end