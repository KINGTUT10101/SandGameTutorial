-- Set RNG seed
math.randomseed (os.time ())

-- Loads the libraries
local push = require ("Libraries.push")
local sceneMan = require ("Libraries.sceneMan")
local lovelyToasts = require ("Libraries.lovelyToasts")

-- Declares / initializes the local variables
local windowWidth, windowHeight = 854, 480

-- Declares / initializes the global variables
GAMEWIDTH, GAMEHEIGHT = 1920, 1080

-- Defines the functions


function love.load ()
    -- Set default font
    local biggerFont = love.graphics.setNewFont (32) -- Bigger font for showing text

    -- Set up Push
    push:setupScreen(GAMEWIDTH, GAMEHEIGHT, windowWidth, windowHeight, {fullscreen = false})
    
    -- Set up Lovely Toasts
    lovelyToasts.canvasSize = {GAMEWIDTH, GAMEHEIGHT}

    -- Set up scenes and SceneMan
    sceneMan:newScene ("firstVersion", require ("Scenes.firstVersion"))
    sceneMan:newScene ("secondVersion", require ("Scenes.secondVersion"))
    sceneMan:newScene ("thirdVersion", require ("Scenes.thirdVersion"))
    sceneMan:newScene ("fourthVersion", require ("Scenes.fourthVersion"))

    sceneMan:push ("firstVersion")
end

function love.update (dt)
    sceneMan:event ("update", dt)
    lovelyToasts.update(dt)
end

function love.draw ()
    push:start()
        sceneMan:event ("draw")
        lovelyToasts.draw()
    push:finish()
end


function love.keypressed (key, scancode, isrepeat)
    sceneMan:event ("keypressed", key, scancode, isrepeat)

    if key == "1" then
        sceneMan:clearStack ()
        sceneMan:push ("firstVersion")

    elseif key == "2" then
        sceneMan:clearStack ()
        sceneMan:push ("secondVersion")

    elseif key == "3" then
        sceneMan:clearStack ()
        sceneMan:push ("thirdVersion")

    elseif key == "4" then
        sceneMan:clearStack ()
        sceneMan:push ("fourthVersion")
    end
end