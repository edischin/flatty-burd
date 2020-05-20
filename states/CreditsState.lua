CreditsState = Class{__includes = BaseState}

function CreditsState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('title')
    end
end

function CreditsState:render()
    love.graphics.setFont(gFonts['big'])
    love.graphics.printf('Github @edischin', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press \'Enter\' to return', 0, 100,VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf(
        'SFX created using Bfxr - https://www.bfxr.net' ..
        '\nFont assets from course reference repo (below)' ..
        '\nPush library from Ulydev - https://github.com/Ulydev/push' ..
        '\nClass library from Matthias Richter - https://github.com/vrld/hump' ..
        '\nImaging assets from course reference repo (below) and Kenney.nl - https://kenney.nl' ..
        '\nMusic by yummie on freesound - https://freesound.org/people/yummie/sounds/410574' ..
        '\n\n\nBased on HarvardX CS50G Course' .. 
        '\n(https://online-learning.harvard.edu/course/cs50s-introduction-game-development)' ..
        '\nThanks to course lecturer Colton Ogden - https://github.com/coltonoscopy' ..
        '\nCourse reference repo - https://github.com/games50/fifty-bird',
        0, 150,VIRTUAL_WIDTH, 'center')
end