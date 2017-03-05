require "catui"

local buttonD
local progressBarD
local progressBarE
local UIMgr

function love.load(arg)
    love.graphics.setBackgroundColor(35, 42, 50, 255)

    UIMgr = UIManager:getInstance()

    local content = UIContent:new()
    content:setPos(20, 20)
    content:setSize(300, 450)
    content:setContentSize(500, 500)
    UIMgr.rootCtrl.coreContainer:addChild(content)


    local buttonA = UIButton:new()
    buttonA:setPos(10, 10)
    buttonA:setText("A")
    buttonA:setIcon("img/icon_haha.png")
    buttonA:setAnchor(0, 0)
    content:addChild(buttonA)

    local buttonB = UIButton:new()
    buttonB:setPos(60, 20)
    buttonB:setText("B")
    buttonB:setIcon("img/icon_haha.png")
    buttonB:setAnchor(0, 0)
    content:addChild(buttonB)

    local buttonC = UIButton:new()
    buttonC:setPos(110, 30)
    buttonC:setText("C")
    buttonC:setIcon("img/icon_haha.png")
    buttonC:setIconDir("right")
    buttonC:setAnchor(0, 0)
    content:addChild(buttonC)


    local img = UIImage:new("img/gem.png")
    img:setPos(0, 50)
    buttonA:addChild(img)


    local label = UILabel:new("font/visat.ttf", "Hello World!", 24)
    label:setAnchor(0, 0.5)
    label:setAutoSize(false)
    label:setPos(100, 150/2)
    label:setFontColor({255, 255, 0, 255})
    img:addChild(label)


    local checkBoxA = UICheckBox:new()
    checkBoxA:setPos(20, 160)
    content:addChild(checkBoxA)

    local checkBoxB = UICheckBox:new()
    checkBoxB:setPos(50, 160)
    content:addChild(checkBoxB)

    local checkBoxC = UICheckBox:new()
    checkBoxC:setPos(80, 160)
    content:addChild(checkBoxC)


    local progressBarA = UIProgressBar:new()
    progressBarA:setPos(20, 200)
    progressBarA:setSize(100, 10)
    progressBarA:setValue(0)
    content:addChild(progressBarA)

    local progressBarB = UIProgressBar:new()
    progressBarB:setPos(20, 220)
    progressBarB:setSize(100, 10)
    progressBarB:setValue(50)
    content:addChild(progressBarB)

    local progressBarC = UIProgressBar:new()
    progressBarC:setPos(20, 240)
    progressBarC:setSize(100, 10)
    progressBarC:setValue(100)
    content:addChild(progressBarC)

    progressBarD = UIProgressBar:new()
    progressBarD:setPos(20, 260)
    progressBarD:setSize(100, 10)
    content:addChild(progressBarD)

    progressBarE = UIProgressBar:new()
    progressBarE:setPos(150, 260)
    progressBarE:setSize(100, 10)
    content:addChild(progressBarE)


    local editText = UIEditText:new()
    editText:setPos(20, 290)
    editText:setSize(120, 20)
    editText:setText("你好-Hello there!")
    content:addChild(editText)

    --rotation tests
    buttonD = UIButton:new()
    buttonD:setPos(150, 200)
    buttonD:setText("D")
    buttonD:setIcon("img/icon_haha.png")
    buttonD:setIconDir("right")
    buttonD:setAnchor(0, 0)
    content:addChild(buttonD)

    local editTextAng = UIEditText:new()
    editTextAng:setPos(20, 360)
    editTextAng:setSize(120, 20)
    editTextAng:setText("Angle Text!")
    editTextAng:setAngle(25)
    content:addChild(editTextAng)

    local slider = UIButton:new()
    slider:setPos(150, 310)
    slider:setSize(100, 10)
    content:addChild(slider)
end

function love.update(dt)
    local time = love.timer.getTime( )
    local sin = math.sin

    if progressBarD ~= nil then        
        --slide progress between 0 and 100%
        progressBarD:setValue( (sin(time * 0.5) * 50) + 50 )
    end

    if progressBarE ~= nil then
        --rotate between -45 and +45 deg
        progressBarE:setAngle( sin(time * 0.25) * 45 )
        --slide progress between 0 and 100%
        progressBarE:setValue( (sin(time*0.5) * 50) + 50 )
        -- progressBarE:setValue( 50 )
    end

    if buttonD ~= nil then
        --rotate between -45 and +45 deg
        buttonD:setAngle( sin(time * 0.25) * 45 )
    end
    UIMgr:update(dt)
end

function love.draw()
    UIMgr:draw()
end

function love.mousemoved(x, y, dx, dy)
    UIMgr:mouseMove(x, y, dx, dy)
end

function love.mousepressed(x, y, button, isTouch)
    UIMgr:mouseDown(x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
    UIMgr:mouseUp(x, y, button, isTouch)
end

function love.keypressed(key, scancode, isrepeat)
    UIMgr:keyDown(key, scancode, isrepeat)
end

function love.keyreleased(key)
    UIMgr:keyUp(key)
end

function love.wheelmoved(x, y)
    UIMgr:wheelMove(x, y)
end

function love.textinput(text)
    UIMgr:textInput(text)
end
