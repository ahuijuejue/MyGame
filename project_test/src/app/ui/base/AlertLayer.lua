
local AlertNode = import(".AlertNode")

--[[
	封装一个Alert弹出框
	initAlertLayer(title, msg, callBacks) 参数说明：
	title: string or node 型，弹出框的标题
	message string or node 型，弹出的信息描述
	button：按钮的回调处理函数，有几个按钮传几个回调函数

	用法示例：在StartLayer.lua 中需要弹出一个alertLayer

    base.AlertLayer.show({
        title = "友情提示",
        message = "购买宝石吧",
        background = display.newScale9Sprite("9_Board_Red.png"):size(470, 290),
        buttonposY = 30, -- 按钮的y轴坐标        
        buttons = {            
            cc.ui.UIPushButton.new({normal = "image.png"}),            
            cc.ui.UIPushButton.new({normal = "image.png"}),
        },
        listener = function(event)
            if event.index == 1 then 

            end 
        end,
        otherButtons = { -- 其他按钮，需要自定义位置
            button = cc.ui.UIPushButton({normal="img.png"})            
        },
        otherListener = function(event)
            if event.index == 1 then 

            end 
        end,
    })         

]]

local AlertLayer = class("AlertLayer", function()
	return display.newLayer()
end)

function AlertLayer:ctor(options)
    self:initAlertLayer(options)
    print("create alert layer")
    self.buttonEnable = true

    self:setNodeEventEnabled(true)
end

function AlertLayer.show(options)
    local runScene = display.getRunningScene()
    return AlertLayer.new(options)
            :zorder(100)
            :addTo(runScene)
end

function AlertLayer:initAlertLayer(options)
	self.title = options.title or ""
	self.msg = options.message or ""
    local otherButtons = options.otherButtons or {}
	local buttons = options.buttons or {}
    local background = options.background
    local buttonListener = options.listener
    local otherListener = options.otherListener

    -- 暗底色面板
	local backgroundLayer = display.newColorLayer(cc.c4f(0, 0, 0, 125))
    :addTo(self)
    :onTouch(function(event)
        
    end)

    self.layer_ = self.layer_ or display.newNode():addTo(self):center()

    self.alertNode_ = AlertNode.new():addTo(self.layer_)    
    :setBackground(background)
    :setButtonPosY(options.buttonposY)

    ---------------------------------------------
        
    function touchIndex(button, index)
        if buttonListener then 
            buttonListener({target=self, button=button, index=index})
        end 
    end
    
    print("button:", #buttons)
    for i,v in ipairs(buttons) do
        self.alertNode_:addButton(v, function()
            touchIndex(v, i) 
        end)        
    end      

     function touchIndex2(button, index)
        if otherListener then 
            otherListener({target=self, button=button, index=index})
        end 
    end 
        
    for i,v in ipairs(otherButtons) do
        v:addTo(self.layer_)
        :onButtonClicked(function()
            touchIndex2(v, i)
        end)        
    end  

    ---------------------------------------------

    self:creatTitleAndDescription() 

    print("alert layer init end ...")
end

function AlertLayer:creatTitleAndDescription()          
    local title = self.title

    function createLayer(label)
        local layer = display.newNode():align(display.CENTER)
        label:align(display.BOTTOM_LEFT):pos(0, 0):addTo(layer)
        local size = label:getContentSize()  
        layer:size(size)      
        return layer 
    end

    local title 
    if type(self.title) == "string" then 
        if #self.title > 0 then 
            title = cc.ui.UILabel.new({
                text = self.title,                        
                size = 30                            
            })
        end
    else 
        title = self.title
    end
    
    if iskindof(title, "UILabel") or iskindof(title, "Label") then 
        title = createLayer(title)                
    end         
                   
    -- msg 
    local msg 
    if type(self.msg) == "string" then 
        msg = cc.ui.UILabel.new({
            text = self.msg,            
            size = 24                    
        })
    else 
        msg = self.msg 
    end
             
    if iskindof(msg, "UILabel") or iskindof(msg, "Label") then                        
        msg = createLayer(msg)        
    end 
    self.alertNode_:setTitle(title)
    :setMessage(msg)       
     
end

--------------------------------------
function AlertLayer:onEvent(listener)
    self.eventListener_ = listener 
    return self 
end

function AlertLayer:onEvent_(event)
    if not self.eventListener_ then return end 
    event.target = self 
    self.eventListener_(event)
end

function AlertLayer:onEnter()
    
    
end

function AlertLayer:onExit()
    self:onEvent_({name="exit"})
end

--------------------------------------

return AlertLayer

