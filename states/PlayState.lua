PlayState = Class{__includes = BaseState}

BACKGROUND_SCROLL_SPEED = 20
BACKGROUND_LOOPING_POINT = 413

GROUND_SCROLL_SPEED = 60

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0
    self.spawnTime = 1
    self.lastY = -PIPE_HEIGHT + math.random(80) + 40
    self.score = 0
    self.paused = false
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('p') then
        self.paused = not self.paused
        if self.paused then
            gSounds['pause']:play()
            gSounds['bg']:pause()
        else
            gSounds['bg']:play()
        end
    end

    if self.paused == true then
        return nil
    end

    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer > self.spawnTime then
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))
        self.spawnTimer = 0
        self.spawnTime = math.random(2, 5)
    end

    for k, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                gSounds['score']:play()
            end
        end

        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do
        for j, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gSounds['hit']:play()

                gStateMachine:change('score', {
                    score = self.score,
                    collidedWith = 'pipe'
                })
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gSounds['hit']:play()

        gStateMachine:change('score', {
            score = self.score,
            collidedWith = 'ground'
        })
    end

    if self.bird.y < -3 * BIRD_HEIGHT then
        gSounds['hit']:play()

        gStateMachine:change('score', {
            score = self.score,
            collidedWith = 'sky'
        })
    end

    gBackgroundScroll = (gBackgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT
    gGroundScroll = (gGroundScroll + GROUND_SCROLL_SPEED * dt) 
        % VIRTUAL_WIDTH
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(gFonts['big'])
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Top Score: ' .. tostring(gTopScore), 8, 35)
    
    self.bird:render()

    if self.paused then
        love.graphics.setFont(gFonts['big'])
        love.graphics.printf('PAUSED', 0, 40, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('Press \'P\' to continue', 0, 80, VIRTUAL_WIDTH, 'center')
    end
end