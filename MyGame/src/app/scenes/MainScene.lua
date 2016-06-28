
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local scheduler = require(cc.PACKAGE_NAME..".scheduler")
local MainLayer = require("app.views.MainLayer")
local TestParticleDisplay = require("app.views.TestParticleDisplay")
local RichLabel = require("app.ui.RichLabel")
local TalkLabel = require("app.ui.TalkLabel")
local RichLabelSenior = require("app.ui.RichLabelSenior")

local headBgImageName = "Banner_Name.png"


function MainScene:ctor()

    --[[
        定时器 进度条
    --]]
    -- self:scheduleTest()

    --[[
        左右移动摇杆
    --]]
    -- self:YaoGanTest()

    --[[
        随机不重复
    --]]
    -- self:randTest()

    --[[
        string 相关
    --]]
    -- self:stringOfWriteFuc()
    -- self:stringOfSplitTest()
    -- self:stringOfFindTest()
    -- self:stringOfGsubTest()

    --[[
        标准版 RichLabel
    --]]
    -- self:richLabelSenior()

    --[[
        非标准版 RichLabel
    --]]
    -- self:richLabelTest()

    --[[
        其他
    --]]
    -- self:rect()
    -- self:tween()
    -- self:tableTest()
    -- self:testUIIput()
    -- self:particleTest()
    -- self:factotialTest()
    -- self:displayTest()
    -- self:transitionTest()
    -- self:pageViewTest()
    -- self:listViewTest()
    -- self:scrollViewTest()
    -- self:sliderTest()

    --[[
        闭包
    --]]
    -- self:bibaoTest()

    display.newTTFLabel({text = " hello world ", size = 30, color = display.COLOR_RED}):addTo(self):pos(display.cx, display.cy)

end

function MainScene:bibaoTest()
    --[[
        一
    --]]
    -- function newCounter()
    --     local i = 0
    --     return function ()
    --         i = i + 1
    --         return i
    --     end
    -- end
    -- c1 = newCounter()
    -- print(c1())
    -- print(c1())

    --[[
        二
    --]]
    function fun1()
        local iVal = 10
        function InnerFunc1()
            print(iVal)
        end

        function InnerFunc2()
            iVal = iVal + 10
        end
        return InnerFunc1, InnerFunc2
    end

    local a, b = fun1()

    a()  -- 10
    b()
    a()  -- 20
    b()
    a()  -- 30
end

function MainScene:sliderTest()
    local image = {
        bar = "loading_Slip.png",
        button = "pad_bg.png",
    }
    -- LEFT_TO_RIGHT   RIGHT_TO_LEFT   TOP_TO_BUTTOM   BUTTOM_TO_TOP
    local valueLabel = cc.ui.UILabel.new({text = "",size = 24}):pos(display.cx, display.cy+100):addTo(self)
    cc.ui.UISlider.new(display.RIGHT_TO_LEFT, image, {scale9 = true})
        :onSliderValueChanged(function( event )
            valueLabel:setString(string.format("value = %0.2f", event.value))
        end)
        :setSliderSize(700, 20)
        :setSliderButtonRotation(90)
        :setSliderValue(75)
        :pos(display.cx-300, display.cy-50)
        :addTo(self)
end

function MainScene:scrollViewTest()

    --[[
        可滚动的图
    --]]
    local sprite = display.newSprite("box.jpg")
    sprite:setContentSize(400, 500)
    sprite:pos(display.cx, display.cy)

    local emptyNode = cc.Node:create()
    emptyNode:addChild(sprite)

    local bound = sprite:getBoundingBox()
    bound.width = 400
    bound.height = 500

    cc.ui.UIScrollView.new({viewRect = bound})
        :addScrollNode(emptyNode)
        :setDirection(cc.ui.UIScrollView.DIRECTION_HORIZONTAL)  -- DIRECTION_VERTICAL 竖向  DIRECTION_HORIZONTAL 横向
        :onScroll(handler(self, self.scrollListener))
        :addTo(self)

    --[[
        可拖动的图
    --]]
    -- local sprite = display.newScale9Sprite("box.jpg")
    -- sprite:setContentSize(400, 500)
    -- sprite:pos(display.cx, display.cy)
    -- sprite:addTo(self)

    -- cc(sprite):addComponent("components.ui.DraggableProtocol")
    --     :exportMethods()
    --     :setDraggableEnable(true)
end
function MainScene:scrollListener(evnet)
end

function MainScene:listViewTest()
    --[[
        普通UIListView
    --]]
    -- self.listView = cc.ui.UIListView.new({
    --         viewRect = cc.rect(40, 40, 200, 400),
    --         direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    --     })
    --     :onTouch(handler(self, self.listTouchListener))
    --     :addTo(self)

    -- for i=1,20 do
    --     local item = self.listView:newItem()
    --     local content = cc.ui.UIPushButton.new("pad_bg.png", {scale9 = true})
    --         :setButtonSize(120, 80)
    --         :setButtonLabel(cc.ui.UILabel.new({text = "button"..i, size = 24}))
    --         :onButtonPressed(function( event )
    --             event.target:getButtonLabel():setColor(display.COLOR_RED)
    --         end)
    --         :onButtonRelease(function( event )
    --             event.target:getButtonLabel():setColor(display.COLOR_BLUE)
    --         end)
    --         :onButtonClicked(function( event )
    --             local width, height = item:getItemSize()
    --             if 80 == height then
    --                 item:setItemSize(120, 120)
    --             else
    --                 item:setItemSize(120, 80)
    --             end
    --         end)

    --     content:setTouchSwallowEnabled(false)
    --     item:addContent(content)
    --     item:setItemSize(120, 80)
    --     self.listView:addItem(item)
    -- end
    -- self.listView:reload()

    --[[
        异步加载 UIListView
    --]]
    -- self.listView = cc.ui.UIListView.new({
    --     direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    --     viewRect = cc.rect(100, 50, 200, 600),
    --     async = true, -- 异步加载标识
    --     })
    --     :onTouch(handler(self, self.listTouchListener))
    --     :addTo(self)

    --  self.listView:setDelegate(handler(self, self.sourceDelegate))
    --  self.listView:reload()
end
function MainScene:listTouchListener( evnet )
end
function MainScene:sourceDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
        return 100
    elseif cc.ui.UIListView.CELL_TAG == tag then
        local item = self.listView:dequeueItem()
        local content
        if not item then
            item = self.listView:newItem()
            content = cc.ui.UILabel.new({text = "item - "..idx,size = 20})
            item:addContent(content)
        else
            content = item:getContent()
        end
        content:setString("item - "..idx)
        item:setItemSize(120, 120)
        return item
    end
end

function MainScene:pageViewTest()
    self.pageView = cc.ui.UIPageView.new({
            viewRect = cc.rect(80, 80, 500, 500),
            column = 4,
            row = 4,
            padding = {left = 20, right = 20,top = 20, bottom = 20},
            columnSpace = 10,
            rowSpace = 10
        })
        :onTouch(handler(self, self.pageTouchListener))
        :addTo(self)

    for i=1,30 do
        local item = self.pageView:newItem()
        local content = cc.LayerColor:create(cc.c4b(math.random(250),math.random(250),math.random(250),255))
        content:setContentSize(100, 100)
        content:setTouchEnabled(false)
        content:addTo(item)
        self.pageView:addItem(item)
    end
    self.pageView:reload()
end
function MainScene:pageTouchListener(event)
    if event.itemIdx == 3 then
        self.pageView:removeItem(event.item, true)
    end
end

function MainScene:transitionTest()
    local sprite = display.newSprite("box.jpg")
    sprite:pos(display.cx, display.cy)
    sprite:addTo(self)

    --[[
        transition.execute()
    ]]
    local sequence = cc.Sequence:create({
        cc.ScaleTo:create(2, 0.4, 0.4, 0.4),
        cc.MoveTo:create(2, cc.p(display.cx-150, display.cy)),
        cc.JumpBy:create(4, cc.p(display.cx+150, display.cy), 50, 5)
        })
    transition.execute(sprite, sequence, {
            delay = 2,
            -- easing = "backout",
            onComplete = function()
                sprite:scaleTo(3, 0.5)
            end
            })

    --[[
        transition.rotateTo()
    ]]
    -- transition.rotateTo(sprite, {rotate = 90, time = 2})

    --[[
        transition.sequence()
    ]]
    -- local sequence = transition.sequence({
    --     cc.ScaleTo:create(2, 0.5, 0.5, 0.5),
    --     cc.MoveTo:create(2, cc.p(display.cx+150, display.cy)),
    --     })
    -- sprite:runAction(sequence)

    --[[
        -- 暂停显示对象上正在执行的动作
        transition.pauseTarget()

        -- 恢复显示对象上所有暂停的动作
        transition.resumeTarget()
    ]]
    -- self.times = 0
    -- function update()
    --     if self.times == 4 then
    --         transition.resumeTarget(sprite)
    --         scheduler.unscheduleGlobal(self.schedule)
    --     else
    --         transition.pauseTarget(sprite)
    --         self.times = self.times + 4
    --     end
    -- end
    -- self.schedule = scheduler.scheduleGlobal(update, 4)
end

function MainScene:displayTest()

    --[[
        layer
    --]]
    local layer = cc.Layer:create()                                   -- 不可返回点击事件
    layer:pos(display.cx, display.cy)
    layer:addTo(self)
    layer:setTouchEnabled(true)
    layer:setTouchSwallowEnabled(false)
    layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            return true
        elseif event.name == "moved" then
            print("-- layer --")
        elseif event.name == "ended" then
            print("-- layer --")
        end
    end)

    local layer1 = display.newColorLayer(cc.c4b(255, 255, 255 ,255))  -- 可返回点击事件
    layer1:pos(display.cx-200, display.cy-200)
    layer1:addTo(self)
    layer1:setTouchEnabled(true)
    layer1:setTouchSwallowEnabled(false)
    layer1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function( event )
        if event.name == "began" then
            return true
        elseif event.name == "moved" then
            print("-- layer1 --")
        elseif event.name == "ended" then
            print("-- layer1 --")
        end
    end)

    local layer2 = cc.LayerColor:create(cc.c4b(100, 100, 100 ,255))   -- 不可返回点击事件
    layer2:pos(display.cx-900, display.cy-500)
    layer2:addTo(self)
    layer2:setTouchEnabled(true)
    layer2:setTouchSwallowEnabled(false)
    layer2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function( event )
        if event.name == "began" then
            return true
        elseif event.name == "moved" then
            print("-- layer2 --")
        elseif event.name == "ended" then
            print("-- layer2 --")
        end
    end)

    --[[
        label   cc.Label:createWithCharMap("number.png",11,17,48)
    --]]
    local label = display.newTTFLabel({
        text   = "测试字段\n   测试字段\n",
        size   = 24,
        color  = cc.c3b(255, 0, 0),
        align  = cc.TEXT_ALIGNMENT_LEFT,
        valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,  -- 多行文字顶部对齐
        })
    label:setPosition(cc.p(display.cx, display.cy))
    label:addTo(self)

    local label1 = cc.ui.UILabel.new({
        text   = "测试字段\n   测试字段\n",
        size   = 24,
        color  = cc.c3b(255, 0, 0),
        })
    label1:setPosition(cc.p(display.cx, display.cy-100))
    label1:addTo(self)

    local label2 = cc.Label:createWithSystemFont("测试字段", "Arial", 24)
    label2:setColor(cc.c3b(255,255,0))
    label2:pos(display.cx-200, display.cy)
    label2:addTo(self)
end

function MainScene:richLabelSenior()
    -- [image=System_Tip.png scale=0.7][/image][fontColor=FF2C2C fontSize=18][公告][/fontColor]%s
    local msg = string.format("[image=box.jpg scale=0.1][/image][fontColor=FF2C2C fontSize=20]测试字段||||||[/fontColor]%s",toChatStr("和哈哈哈哈哈哈(哈哈)"))
    local param = {
        dimensions = cc.size(340,0),
        text = msg,
        fontSize = 18,
    }
    local label = RichLabelSenior:create(param)
    label:addTo(self)
    label:pos(display.cx, display.cy)
end

function MainScene:stringOfGsubTest( )
    local a = "one string"
    local b = string.gsub(a,"one","two")
    a = "hello "
    print(a)
    print(b)
end

function MainScene:stringOfFindTest()
    local key_ = "(hello)"
    local s = "哈(hello)哈哈(hello)哈哈哈"
    local i = 0
    local j = 0
    local lastPos = 0
    local tab = {}
    local len = string.len(s)

    while true do
        i,j = string.find(s,"%b()",i+1)
        if i and j then
            print(i.." -- "..j)
        end

        if i then
            table.insert(tab,string.sub(s,lastPos+1,i-1))
            table.insert(tab,string.sub(s,i,j))
            lastPos = j
        else
            table.insert(tab,string.sub(s,lastPos+1,len))
            break
        end
    end

    local stirng_ = ""
    local isConnect = false
    for i,v in ipairs(tab) do
        if v == key_ then

        end
    end
end

function MainScene:stringOfSplitTest()
    -- one
    local string_ = "123|456||789|000"
    local talbe1 = {}
    local table2 = {}

    table1 = string.split(string_, "||")
    for i,v in ipairs(table1) do
        local table_ = string.split(v, "|")
        for i1,v1 in ipairs(table_) do
            table.insert(table2, v1)
        end
    end

    for i,v in ipairs(table2) do
        print(i.." -- "..v)
    end

    -- two
    local s = "1,3,10"
    local t = string.split(s, ",")
    dump(t)
end

function MainScene:stringOfWriteFuc()
    --[[
        字符串的三种表示方法
    --]]
    local a = "abc" --abc
    local b = 'abc' --abc
    local c = [[abc]] --abc
    print(a)
    print(b)
    print(c)
end


function MainScene:factotialTest()
    --[[
        输出n的阶乘的最后一位不是0的数
    --]]
    local number = 15
    local n_ = 1
    for i=1,number-1 do
        n_ = n_ * (i+1)
    end
    print(n_.." 15的阶乘")

    local result = 0
    local a = n_ % 10
    local b = n_ / 10
    if a == 0 then
        while a == 0 do
            a = b % 10
            b = b / 10
        end
        result = a
    else
        result = a
    end
    print(result)
end


function MainScene:particleTest()
    --[[
        layer中的动画
    --]]
    local button = cc.ui.UIPushButton.new({normal = "bg.jpg",pressed = "box.jpg"}, {scale9 = true})
    button:pos(display.cx,display.cy)
    button:addTo(self)
    button:setScale(0.3)
    button:onButtonClicked(function()
        local layer = TestParticleDisplay.new()
        layer:pos(0,0)
        layer:addTo(self)
    end)
end


function MainScene:tableTest()
    local table_ = {"1", "2", "3", "4", "5"}
    dump(table_)
    table.remove(table_, 3)
    dump(table_)

    local s = "0.0"
    print(math.ceil(tonumber(s)))
end


function MainScene:testUIIput()
    display.newSprite("ChatView_Bg.png"):addTo(self):pos(480,322)

    local function onEdit( event, editbox )
        if event == "began" then
            print("开始输入")
        elseif event == "changed" then
            local text = editbox:getText()
            print(text)
        elseif event == "ended" then
            print("输入结束")
        elseif event == "return" then
            print("从输入框返回")
        end
    end

    local editbox = cc.ui.UIInput.new({
        UIInputType = 1,
        image = "Chat_Bg_Self.png",
        size = cc.size(550,35),
        x = 363,
        y = 600,
        listener = onEdit,
        })
    editbox:addTo(self)
    editbox:setMaxLength(10)

    editbox:setPlaceHolder("请输入内容")
end


function MainScene:tween()
    local sp = display.newSprite("pad.png")
    sp:pos(display.cx,display.cy)
    sp:addTo(self)
    sp:setScale(0.5)

    local function cudic(pos)
        ---------------------------------------------------------
        -- pos = pos/0.5
        -- if (pos < 1) then return 0.5*math.pow(pos,3) end
        -- return 0.5 * (math.pow((pos-2),3) + 2)
        ---------------------------------------------------------
        -- return math.pow(pos, 4)
        ---------------------------------------------------------
        -- pos = pos/0.5
        -- if (pos < 1) then return 0.5*math.pow(pos,2) end
        -- pos = pos -2
        -- return -0.5 * (pos*pos - 2)
        ---------------------------------------------------------
        -- pos = pos/0.5
        -- if (pos< 1) then return 0.5*math.pow(pos,4) end
        -- pos = pos -2
        -- return -0.5 * (pos*math.pow(pos,3) - 2)
        ---------------------------------------------------------
        -- return (-.5 * (math.cos(3.1415*pos) -1))
        ---------------------------------------------------------
        -- if(pos==0) then return 0 end
        -- if(pos==1) then return 1 end
        -- pos = pos/0.5
        -- if(pos < 1) then return 0.5 * math.pow(2,10 * (pos-1)) end
        -- pos = pos-1
        -- return 0.5 * (-math.pow(2, -10 * pos) + 2)
        ---------------------------------------------------------
        pos = pos/0.5
        if(pos < 1) then return -0.5 * (math.sqrt(1 - pos*pos) - 1) end
        pos = pos -2
        return 0.5 * (math.sqrt(1 - pos*pos) + 1)
        ---------------------------------------------------------
        ---------------------------------------------------------
        ---------------------------------------------------------
    end

    local seq = cc.Sequence:create({cc.ScaleTo:create(cudic(0.5), 1),cc.DelayTime:create(0.2),cc.ScaleTo:create(cudic(1), 0.5)})
    sp:runAction(cc.RepeatForever:create(seq))
end


function MainScene:rect()
    local sp = display.newSprite(headBgImageName)
    sp:pos(display.cx,display.cy)
    sp:addTo(self)
    sp:setTouchEnabled(true)
    sp:setTouchSwallowEnabled(false)
    local tableRect = sp:getBoundingBox()
    local center = tableRect.x+90

    sp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "began" then
            return true
        elseif event.name == "moved" then
        elseif event.name == "ended" then
            if event.x < center then
                print("event.x < center")
            elseif event.x > center then
                print("event.x > center")
            end
        end
    end)

    -- getBoudingBox()只能拿到x.y。你要判断点击位置是不是在var中，得写一个函数：
    -- local function contains(node, x, y)
    --         local b = node:getBoundingBox()
    --         return  x > b.x and x < (b.x + 80) and y > b.y and y < (b.y + 80) --80为var的宽高
    -- end

    -- sp:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function (event)
    --     if event.name == "began" then
    --         print("sp capture began")
    --     elseif event.name == "moved" then
    --         print("sp capture moved")
    --     elseif event.name == "ended" then
    --         print("sp capture ended")
    --     end

    --     return true
    -- end)
end


function MainScene:randTest()

    -- 随机选出不重复
    function rand( tabNum, indexNum )
        indexNum = indexNum or tabNum
        local t = {}
        local rt = {}
        for i = 1,indexNum do
            newrandomseed()  -------------------------- Common中的
            local ri = math.random(1,tabNum + 1 - i)
            local v = ri
            for j = 1,tabNum do
                if not t[j] then
                    ri = ri - 1
                    if ri == 0 then
                        table.insert(rt,j)
                        t[j] = true
                    end
                end
            end
        end
        return rt
    end

    tab = {"1","2","3","4","5","10001","3903","009"}
    s = rand(8,5)
    for i = 1,5 do
        print(tab[s[i]])
    end
end


function MainScene:YaoGanTest()

    local layer = display.newLayer()
    layer:size(display.width, display.height)
    layer:pos(0, 0)
    layer:addTo(self)
    layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then

            self.pad_bg = display.newSprite("pad_bg.png")
            self.pad_bg:pos(event.x, event.y)
            self.pad_bg:setScale(1.5)
            self.pad_bg:setOpacity(50)
            self.pad_bg:addTo(layer)

            self.pad = display.newSprite("pad.png")
            self.pad:pos(event.x, event.y)
            self.pad:setScale(0.4)
            self.pad:zorder(1)
            self.pad:addTo(layer)

            return true
        elseif event.name == "moved" then

            local borderX_ = self.pad_bg:getPositionX()
            local borderY_ = self.pad_bg:getPositionY()
            local leftX = borderX_ - self.pad_bg:getContentSize().width/2
            local rightX = borderX_ + self.pad_bg:getContentSize().width/2

            if event.x < self.pad:getPositionX() or event.x > self.pad:getPositionX() then
                if event.x > leftX and event.x < rightX then
                    self.pad:pos(event.x,borderY_)
                elseif event.x < leftX then
                    self.pad:pos(leftX,borderY_)
                elseif event.x > rightX then
                    self.pad:pos(rightX,borderY_)
                end
            end

        elseif event.name == "ended" then
            self.pad:removeFromParent()
            self.pad_bg:removeFromParent()
            self.pad = nil
            self.pad_bg = nil
        end
    end)
end


function MainScene:scheduleTest()

    --[[
       计时器，需require("scheduler")
    --]]
    -- function update1(dt)
    --     print("----")
    -- end
    -- function stop1()
    --     print("stop")
    --     scheduler.unscheduleGlobal(self.schedule)
    -- end
    -- scheduler.performWithDelayGlobal(stop1, 11)
    -- self.schedule = scheduler.scheduleGlobal(update1, 1)


    --[[
        节点帧事件，每一次刷新界面前都会触发事件，不必require("scheduler")
    --]]
    -- self:scheduleUpdate()
    -- self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
    --  print(dt)
    -- end)
    -- self:performWithDelay(function()
    --     print("stop")
    --  self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
    -- end,1)


    --[[
        进度条  cc.ui.UILoadingBar
    --]]
        -- local sprite = display.newSprite("loading_Slip.png")
        -- sprite:pos(display.cx,display.cy)
        -- sprite:addTo(self)

        -- local load_progress = cc.ui.UILoadingBar.new({
        --         scale9 = false,
        --         image = "Loading_Progress.png",
        --         percent = 0,
        --         viewRect = cc.rect(0,0,690,14)
        --         })
        -- load_progress:pos(3,4)
        -- load_progress:addTo(sprite)
        -- load_progress:setPercent(0)

        -- local label = display.newTTFLabel({
        --         text = "0 / 690",
        --         font = "Marker Felt",
        --         size =24,
        --         color = cc.c3b(255,0,0),
        --         align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
        --     })
        -- label:addTo(self)
        -- label:pos(display.cx-sprite:getContentSize().width/2,display.cy+56)

        -- self.s = 0
        -- function update()
        --     self.t = 10
        --     if self.s ~= 69 then
        --         self.s = self.s + 1
        --         self.a = self.t * self.s
        --         load_progress:setPercent(self.a / 690 * 100)
        --         local x = display.cx-sprite:getContentSize().width/2
        --         label:setString(string.format("%d / 690", self.a))
        --         label:pos(x + self.a,display.cy+56)

        --     else
        --         scheduler.unscheduleGlobal(self.schedule)
        --     end
        -- end
        -- self.schedule = scheduler.scheduleGlobal(update,0.05)


    --[[
        进度条  cc.ProgressTimer  横向进度
    --]]
    -- local sprite_ = display.newSprite("loading_Slip.png")
    -- sprite_:pos(display.cx,display.cy-100)
    -- sprite_:addTo(self)

    -- local load_timer = cc.ProgressTimer:create(display.newSprite("Loading_Progress.png"))
    -- load_timer:setType(1)
    -- load_timer:setPosition(349, 12)
    -- load_timer:setMidpoint(cc.p(1, 0))
    -- load_timer:setBarChangeRate(cc.p(1, 0))
    -- load_timer:addTo(sprite_)
    -- load_timer:setPercentage(0)

    -- self.s_ = 0
    -- function update_()
        -- self.t_ = 10
        -- if self.s_ ~= 69 then
        --     self.s_ = self.s_ + 1
        --     self.a_ = self.t_ * self.s_
        --     load_timer:setPercentage(self.a_ / 690 * 100)
        -- else
        --     scheduler.unscheduleGlobal(self.schedule_)
        -- end
    -- end
    -- self.schedule_ = scheduler.scheduleGlobal(update_, 0.05)


    --[[
        进度条  cc.ProgressTimer  旋转进度
    --]]
    local load_timer1 = cc.ProgressTimer:create(display.newSprite("Skill_Circle.png"))
    load_timer1:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    load_timer1:setPercentage(0)
    load_timer1:pos(display.cx, display.cy - 150)
    load_timer1:addTo(self)

    self.s_ = 0
    function update1()
        self.t_ = 10
        if self.s_ ~= 69 then
            self.s_ = self.s_ + 1
            self.a_ = self.t_ * self.s_
            load_timer1:setPercentage(self.a_ / 690 * 100)
        else
            scheduler.unscheduleGlobal(self.schedule1)
        end
    end
    self.schedule1 = scheduler.scheduleGlobal(update1, 0.05)

    print(load_timer1:getType().. " type of load_timer1 ")

end


function MainScene:richLabelTest()

    local string = "那就让<{0,248,0}【前排】>吧！那就让你承认我的力量吧！<{248,110,110}【后排】>吧！"
    local label = RichLabel.new({
        text = string,
        size = 24,
        dimensions = cc.size(500,300)
    })
    label:pos(0,100)
    label:addTo(self)

    local string1 = [[需要充值<{0,248,0} 100000>钻石即可享受相应特权
V14超值大礼包：
<{248,110,110}每天可以点金 50次，最高倍率 5倍
每天可以购买体力<{200,10,110} 13>次
每天每个精英副本可重置<{130,28,110} 12>次
抢夺多获得<{0,248,0} 70% >的灵能值
包含<{248,170,130} V13>及以下所有内容]]

    local string2 = [[需要充值<{0,248,0}25000>钻石即可享受相应特权
V11超值大礼包：
每天可以点金<{0,248,0}50>次，最高倍率<{0,248,0}5>倍
每天可以购买体力<{0,248,0}13>次
每天每个精英副本可重置<{0,248,0}12>次
抢夺多获得<{0,248,0}70$>的灵能值
包含V10及以下所有内容]]

    local string3 = [[需要充值<{0,248,0}50000>钻石即可享受相应特权
V12超值大礼包：
每天可以点金<{0,248,0}60>次，最高倍率<{0,248,0}5>倍
每天可以购买体力<{0,248,0}14>次
每天每个精英副本可重置<{0,248,0}13>次
抢夺多获得<{0,248,0}70$>的灵能值
包含V11及以下所有内容]]

    local string4 = "英灵们都有各自独特的<{0,144,248}技能>，我们可以用<{0,144,248}灵能升级>它！"

    local label = TalkLabel.new({
        text = string3,
        size = 24,
        dimensions = cc.size(400,300),
        numOffset = cc.p(0,0)
    })
    label:pos(300,500)
    label:addTo(self)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
