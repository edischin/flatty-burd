TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end

    if love.keyboard.wasPressed('c') then
        gStateMachine:change('credits')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(gFonts['big'])
    love.graphics.printf('Flatty Burd', 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press \'Enter\' to play!', 0, 130,VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press \'C\' to see the credits!', 0, 240,VIRTUAL_WIDTH, 'center')
end