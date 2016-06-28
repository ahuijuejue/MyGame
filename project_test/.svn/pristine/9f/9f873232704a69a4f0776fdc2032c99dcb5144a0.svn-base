
module("CommonButton", package.seeall)

-- 按钮
function button(params, text, options)
	options = options or {}
	local param = options
	param.text = param.text or text or ""
	param.size = param.size or 26

	local btn = base.PushButton.new(params)
	:setButtonLabel(base.Label.new(param):align(display.CENTER))

	return btn
end

-- 黄色按钮
function yellow(text, options)
	return button({
		normal="Button_Enter.png",
		pressed="Button_Enter_Light.png",
		disabled="Button_Gray.png"
	}, text, options)
end

-- 带字按钮（前往）
function yellow1(options)
	return button({
		normal="Button_yellow.png",
		pressed="Button_yellow_light.png",
		disabled="Button_yellow.png"
	}, options)
end

-- 黄色按钮2
function yellow2(text, options)
	return button({
		normal="Button_Enter.png",
		pressed="Button_Enter_Light.png",
		disabled="Button_Gray.png"
	}, text, options)
end

-- 带字自定义图片按钮（领取，自定义图片）()
function yellow3(text,options)
	return button({
		normal=options.image.normal,
		pressed=options.image.pressed,
		disabled=options.image.disabled
	},text, options)
end

-- 黄色按钮 长
function long_yellow(text, options)
	return button({
		normal="Button_Enter.png",
		pressed="Button_Enter_Light.png",
		disabled="Button_Gray.png"
	}, text, options)
end

-- 红色按钮
function red(text, options)
	return button({
		normal="Button_Cancel.png",
		pressed="Button_Cancel_Light.png",
		disabled="Button_Gray.png"
	}, text, options)
end

-- 红色按钮 长
function long_red(text, options)
	return button({
		normal="GearPlusAll_Button.png",
		pressed="GearPlusAll_Button_Light.png",
		disabled="GearPlusAll_Button_Gray.png"
	}, text, options)
end

-- 绿色按钮
function green(text, options)
	return button({
		normal="Award_Button.png",
		pressed="Award_Button_Light.png",
		disabled="Button_Gray.png"
	}, text, options)
end

-- 带字按钮（完成）
function green1(options)
	return button({
		normal="Button_green.png",
		pressed="Button_green_light.png",
		disabled="Button_green.png"
	}, options)
end

-- 蓝色按钮
function blue(text, options)
	return button({
		normal="Trials_Button.png",
		pressed="Trials_Button_Light.png",
		disabled="Trials_Button_Gray.png"
	}, text, options)
end

-- 关闭按钮
function close(text)
	return button({
		normal="Close.png",
		pressed="Close.png",
		disabled="Close.png"
	}, text)
end

-- 关闭按钮  开服活动
function close_()
	return button({
		normal="Close_1.png",
		pressed="Close_1.png",
		disabled="Close_1.png"
	}, text)
end

-- 返回按钮
function back(text)
	return button({
		normal="Return.png",
		pressed="Return_Light.png",
	}, text)
end

-- 开始按钮
function start(text)
	return button({
		normal = "Start.png",
		pressed="Start_Light.png",
        disabled = "Start_Gray.png",
	}, text)
end

-- 边栏按钮
function sidebar(text, options)
	options = options or {}
	options.x = options.x or 5
	options.y = options.y or 0
	options.size = options.size or 22
	options.text = options.text or text

	local grid = base.Grid.new()
		:setNormalImage("Label_Normal.png")
		:setSelectedImage("Label_Select.png")
		:addItems({
			base.Label.new(options):align(display.CENTER),
		})

	return grid
end

-- 边栏按钮 活动侧边栏（自定义图片）
function sidebar_(text, options)
	local grid
    if text  then
    	options = options or {}
		options.x = options.x or 5
		options.y = options.y or 0
		options.size = options.size or 22
		options.text = options.text or text

		grid = base.Grid.new()
			:setNormalImage(options.image.normal)
			:setSelectedImage(options.image.selected)
			:setDisabledImage(options.image.disabled)
			:addItems({
				base.Label.new(options):align(display.CENTER),
			})
    else
    	grid = base.Grid.new()
    end

	return grid
end

function sidebar_yellow(text, options)
	local grid = base.Grid.new({
		    normal="Button_Enter.png",
			selected="Button_Enter_Light.png",
			disabled="Button_Gray.png"
		})

	options = options or {}
	options.text = text
	grid:addItem(base.Label.new(options):align(display.CENTER))
	return grid
end

function sidebar_yellow1(text, options)	--活动子菜单按钮（自定义图片）
	local grid = base.Grid.new({
		    normal= options.image.normal,
			selected= options.image.selected,
			disabled= options.image.disabled
		})

	options = options or {}
	options.text = text
	if options.size then
		options.size = options.size
	end
	grid:addItem(base.Label.new(options):align(display.CENTER))
	return grid
end
