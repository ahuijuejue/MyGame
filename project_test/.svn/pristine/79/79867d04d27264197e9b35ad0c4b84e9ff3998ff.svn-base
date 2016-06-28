
local AlertBar = class("AlertBar", function()
	return display.newNode()
end)

--[[
options
可用参数
text 显示文字
limit 是否屏蔽触摸事件 默认是
touch 是否支持触摸消失 默认是
time 显示事件 默认 2 秒。 若为0，则不消失

opacity 背景灰层不透明度 默认 125
background 背景图片
scale9 是否为 九宫格
size 图片尺寸
auto 自适应尺寸 默认 true

animation 动画

posX
posY 坐标 默认屏幕中心

~~ lua
AlertBar.show({
    text="条",
    animation = function(layer)
        local action = transition.sequence({
            cc.DelayTime:create(delay),
            cc.MoveBy:create(3, cc.p(0, 100)),
        })
        return action
    end 
})

~~ lua
]]

function AlertBar:ctor(options)
    self:initBar(options)
end

function AlertBar:initBar(options)
    local opacity_ = options.opacity or 125
    local touchDis_ = options.touch
    local limit_ = options.limit
    local scale9_ = options.scale9
    local size_ = options.size
    local delay_ = options.time or 2
    local text_ = options.text or ""
    local posX_ = options.posX or display.cx
    local posY_ = options.posY or display.cy
    local background_ = options.background
    local auto_ = options.auto
    local animation_ = options.animation 

    if touchDis_ == nil then touchDis_ = true end 
    if limit_ == nil then limit_ = true end 


	local blackLayer = display.newColorLayer(cc.c4f(0, 0, 0, opacity_))
    :addTo(self)
    blackLayer:setTouchEnabled(false)
    -- if limit_ then 
    --     blackLayer:onTouch(function(event)
    --         if event.name == "began" then 
    --             if touchDis_ then                 
    --             	self:stopAllActions()
    --             	self:removeSelf()
    --             end                 
    --         end 
    --     end)
    -- else 
    --     blackLayer:setTouchEnabled(false)
    -- end 

    local layer_ = display.newNode():addTo(self):pos(posX_, posY_)

    -- 背景
    if background_ then 
        if type(background_) == "string" then 
            if scale9_ then 
                self.background_ = display.newScale9Sprite(background_)
            else 
                self.background_ = display.newSprite(background_)
            end 
        else 
            self.background_ = background_ 
        end 
        self.background_:addTo(layer_)
    end 
        
    if type(text_) == "string" then 
        self.label_ = base.Label.new({
        	text = text_,
        	font = "Arial",
        }):align(display.CENTER)
    else 
        self.label_ = text_ 
    end 
    self.label_:addTo(layer_)

    if self.background_ then 
        if auto_ then 
            local size = self.label_:getContentSize()       
            local w = max(200, size.width) + 100
            local h = max(100, size.height)
            self.background_:size(w, h)
        elseif size_ then  
            self.background_:size(size_)
        end 
    end 
    if animation_ then 
        local ani = animation_(layer_)
        layer_:runAction(ani)
    end     
   
    if delay_ > 0 then 
    	self:performWithDelay(handler(self, self.removeSelf), delay_)
    end 
end

function AlertBar.show(options)
	local runScene = display.getRunningScene()
	return AlertBar.new(options)
	:zorder(101)
	:addTo(runScene)

end

function AlertBar.simpleShow(options)
    if not options.background then 
        options.background = "9_Board_Red.png"
        options.scale9 = true
        options.auto = true         
    end 
    options.limit = options.limit or false 
    options.touch = options.touch or false 
    options.time = options.time or 0.8
    options.opacity = options.opacity or 0
    
    AlertBar.show(options)
end

return AlertBar
