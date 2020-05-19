ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
    self.collidedWith = params.collidedWith
    self.earnedMedal = 'none'
    self.isTopScore = false

    if self.score > 29 then
        self.earnedMedal = 'gold'
    elseif self.score > 14 then
        self.earnedMedal = 'silver'
    elseif self.score > 4 then
        self.earnedMedal = 'bronze'
    end

    if self.earnedMedal ~= 'none' then
        gSounds['medal']:play()
    end

    if self.score > gTopScore then
        gTopScore = self.score
        self.isTopScore = true
    end

    if self.isTopScore then
        self.scoreMessage = 'You beat the top score!'
    elseif self.collidedWith == 'pipe' then
        self.scoreMessage = 'Oh no! Face print on a pipe!'
    elseif self.collidedWith == 'ground' then
        self.scoreMessage = 'Well, you can call it ground!'
    else
        self.scoreMessage = 'Went to infinity, and beyond!'
    end
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(gFonts['big'])
    love.graphics.printf(self.scoreMessage, 0, 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 80, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Top Score: ' .. tostring(gTopScore), 0, 100, VIRTUAL_WIDTH, 'center') 

    if self.earnedMedal ~= 'none' then
        love.graphics.draw(gMedals[self.earnedMedal], 
            VIRTUAL_WIDTH / 2 - gMedals[self.earnedMedal]:getWidth() / 2, 120)

        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf((self.isTopScore and 'And' or 'But') .. ' earned a ' .. tostring(self.earnedMedal) .. ' medal for it!', 
            0, 190, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to Play Again!', 0, 240, VIRTUAL_WIDTH, 'center')
end