
module("AlertShow", package.seeall)


-----------------------------------------

function label1(text, labelSize, color)
	return base.Label.new({text=text, size=labelSize or 20, color=color or cc.c3b(255,255,255)})
end

function label2(text, labelSize, color)
	local layer = display.newNode():align(display.CENTER)
	local label = label1(text, labelSize, color):align(display.BOTTOM_LEFT):pos(0, 0):addTo(layer)
    local size = label:getContentSize()  
    layer:size(size)      
    return layer 
end

------------------------------------------

function createLayer(nodes, width, height)
	local layer = display.newNode():size(width, height):align(display.CENTER)
	if type(nodes) == "table" then
		for k,v in pairs(nodes) do
		 	v:addTo(layer)
		end 		
	else 
		nodes:addTo(layer):pos(width * 0.5, height * 0.5)
	end 

	return layer
end

-----------------------------------------

function show(options)	
	return base.AlertLayer.show(options)
end

function createTitle(type, text)
	if type == 1 then 
		return text
	elseif type == 2 then 
		local node = display.newNode():size(200, 100)		
		base.Label.new({text=text, size=26}):addTo(node):align(display.CENTER):pos(100, 50)
		return node 
	end 
end
-----------------------------------------------------------------------
--[[
@param params table 
-backgroundType 	背景框
-opening 			点击确定后保持不关闭
]]
function show1(title, msg, okButton, okListener, params, cancelListener)	
	if type(title) == "string" then 
		title = createTitle(2, title)
	end 

	if type(msg) == "string" then 
		msg = base.Label.new({
			text=msg, 
			size=20, 
			-- color=cc.c3b(50,10,10),
			valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
			dimensions = cc.size(400, 200)
		}):align(display.CENTER)
	end 

	if type(params) == "function" then 
		cancelListener = params 
		params = {}
	end 
	
	params = params or {}
	return show({
		title 		= 	title,
		message 	= 	createLayer(msg, 400, 200), 
		background 	= 	display.newSprite("Friends_Tips.png"), 
		buttons 	= {
			CommonButton.red("取消"),
			okButton,
		},
		listener 	= 	function(event)
			if event.index == 1 then 
				CommonSound.click() -- 音效
				if cancelListener then 
					cancelListener(event)
				end 
				event.target:removeSelf()
			elseif event.index == 2 then 
				CommonSound.click() -- 音效
				if okListener then 
					okListener(event)
					if params.opening ~= true then 
						event.target:removeSelf()
					end  
				end 
			end 
		end,
		buttonposY 	= 	55,
	})
end
-- 普通确定按钮
function show2(title, msg, okLabel, okListener, params, cancelListener)	
	print("show2 ....")
	return show1(title, msg, CommonButton.yellow(okLabel), okListener, params, cancelListener)
end
-- 长确定按钮
function show3(title, msg, okLabel, okListener, params, cancelListener)
	print("show3 ....")
	return show1(title, msg, CommonButton.long_yellow(okLabel), okListener, params, cancelListener)
end


-------------------------------------------------------

function showBar(text, time)
	return base.AlertBar.show({
		text=base.Label.new({text=text, size=22, color=cc.c3b(255,255,0)}):align(display.CENTER),
		animation = function(layer)
	        local action = transition.sequence({            
	            cc.MoveBy:create(1, cc.p(0, 50)),
	        })
	        return action
	    end,
	    time 	= time or 1,
	    touch 	= false,
	    limit 	= false,
	    opacity = 0,
	})
end

-------------------------------------------------------


