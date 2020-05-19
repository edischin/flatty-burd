-- Based on HarvardX CS50G Course (https://online-learning.harvard.edu/course/cs50s-introduction-game-development?delta=0)
-- Course reference repo (https://github.com/games50/fifty-bird)
-- Music by https://freesound.org/people/yummie/sounds/410574/
-- SFX generated created using Bfxr (https://www.bfxr.net/)
-- Some imaging assets obtained from Kenney.nl (https://kenney.nl/)

push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 720
WINDOW_HEIGHT = 405

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flatty Burd')

    gTopScore = 0

    gBackground = love.graphics.newImage('img/background.png')
    gBackgroundScroll = 0

    gGround = love.graphics.newImage('img/ground.png')
    gGroundScroll = 0

    gFonts = {
        ['small'] = love.graphics.newFont('font/font.ttf', 8),
        ['medium'] = love.graphics.newFont('font/flappy.ttf', 14),
        ['big'] = love.graphics.newFont('font/flappy.ttf', 28),
        ['huge'] = love.graphics.newFont('font/flappy.ttf', 56)
    }
    love.graphics.setFont(gFonts['big'])

    gMedals = {
        ['bronze'] = love.graphics.newImage('img/coin_bronze.png'),
        ['silver'] = love.graphics.newImage('img/coin_silver.png'),
        ['gold'] = love.graphics.newImage('img/coin_gold.png')
    }

    gSounds = {
        ['jump'] = love.audio.newSource('sfx/toot.wav', 'static'),
        ['hit'] = love.audio.newSource('sfx/hit.wav', 'static'),
        ['score'] = love.audio.newSource('sfx/score.wav', 'static'),
        ['pause'] = love.audio.newSource('sfx/pause.wav', 'static'),
        ['medal'] = love.audio.newSource('sfx/medal.wav', 'static'),
        ['bg'] = love.audio.newSource('sfx/410574__yummie.mp3', 'static')
    }

    gSounds['medal']:setVolume(0.5)

    gSounds['bg']:setLooping(true)
    gSounds['bg']:setVolume(0.2)
    gSounds['bg']:play()

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')
    
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if (key == 'escape') then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(gBackground, -gBackgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(gGround, -gGroundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end