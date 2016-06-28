
module("CommonView", package.seeall)

-- 背景图
function background()
	-- local layer = display.newNode()
	-- display.newSprite("Sky_Left.png"):addTo(layer)
	-- display.newSprite("Background_gray.jpg"):addTo(layer)
	-- return layer
	return display.newSprite("Background_gray.jpg")
end

function background1()
	-- local layer = display.newNode()
	-- filter_blur("Background_gray.jpg", 4):addTo(layer)

	-- return layer
	return background()
end

function background_aincrad()
	return display.newSprite("Anicrad_Background.jpg")
end

-- 半透明灰层
function blackLayer(opacity)
	return display.newColorLayer(cc.c4f(0, 0, 0, opacity or 150))
end

function blackLayer1()
	return display.newColorLayer(cc.c4f(0, 0, 0, 0))
end
-- layer 用
function blackLayer2()
	return display.newColorLayer(cc.c4f(0, 0, 0, 200))
end
-- scene 用
function blackLayer3()
	return display.newColorLayer(cc.c4f(0, 0, 0, 150))
end

--[[
底板
]]
-- 底板
function boardFrame1() -- 876 x 548
	return display.newSprite("HeroBoard.png")
end

--[[
贴纸
]]

-- 不带花纹
function frame2() -- 802 x 484
	return display.newSprite("bg_001.png")
end

-- 带花纹
function frame3() -- 802 x 484
	return display.newSprite("Shop_Back.png")
end

-- 带花纹
function frame4() -- 862 x 521
	return display.newSprite("frame_b1_001.png")
end

-- 不带花纹
function frame5() -- 834 × 392
	return display.newSprite("frame_b2_001.png")
end


--*******
function mFrame1() -- 528 x 393
	return display.newSprite("Friends_Tips.png")
end

function mFrame2() -- 664 x 474
	return display.newSprite("ChangeHead_Board.png")
end

function mFrame3() -- 459 × 244
	return display.newSprite("PushSet_Shading.png")
end

-- 有花纹
function mFrame4() -- 701 × 461
	return display.newSprite("Rectangle_b_1.png")
end

-- 无花纹
function mFrame5() -- 604 × 454
	return display.newSprite("frame_m_001.png")
end

-- 有花纹
function mFrame6() -- 677 × 519
	return display.newSprite("frame_m_002.png")
end

--------------

function sFrame1() -- 646 × 158
	return display.newSprite("TeamInfo_MemberBox.png")
end

function frameScale9(width, height)
	local size = nil
	if type(width) == "table" then
        size = width
    else
        size = cc.size(width, height)
    end
	return display.newScale9Sprite("PasterScale9.png", 0, 0, size)
end

--[[
底板 + 贴纸
]]

-- 大 背景框1+2
function backgroundFrame1()
	local node1 = boardFrame1()
	frame2()
	:addTo(node1)
	:pos(438, 274)

	return node1
end

-- 大 背景框1+3
function backgroundFrame2()
	local node1 = boardFrame1()
	frame3()
	:addTo(node1)
	:pos(438, 274)

	return node1
end

function backgroundFrame3() -- 671 x 538
	return display.newSprite("board_frame3.png")
end

function backgroundFrame4() -- 612 x 549
	return display.newSprite("Register_Board.png")
end

-----------------------------------
--[[
标题背景框
]]

function titleFrame1() -- 259 x 36
	return display.newSprite("Set_Title.png")
end

function titleFrame2() -- 235 x 43
	return display.newSprite("ChangeHead_Title.png")
end

function titleFrame3() -- 235 x 43
	return display.newSprite("Idolum_Level.png")
end

--[[
带花纹的标题框
]]
function titleLinesFrame1() -- 302 x 68
	return display.newSprite("Register_Title.png")
end

function titleLinesFrame2() -- 450 x 65
	return display.newSprite("Mail_Title.png")
end

---------------------------------------------
--[[
名字框
]]
function nameFrame1() -- 354 x 55
	return display.newSprite("Castle_Title.png")
end

function nameFrame2() -- 284 x 55
	return display.newSprite("Castle_Name_Title.png")
end

---------------------------------------------
--[[
长条框
]]
-- 长条框1
function barFrame1() -- 309 x 47
	return display.newSprite("Player_name.png")
end

-- 长条框 带面板 （输入框）
function barFrame2() -- 462 × 210
	return display.newSprite("Input_Box.png")
end

-- 长条框3
function barFrame3() -- 245 × 50
	return display.newSprite("TeamInfo_NameBox.png")
end

---------------------------------------------
--[[
花纹
]]

function lines1()
	return display.newSprite("Castle_Lines.png")
end

-- 长条
function lines2()
	return display.newSprite("PlayerSet_Lines.png")
end

---------------------------------------------
--[[
箭头
]]
-- 向右的黄色箭头
function rAward1()
	return display.newSprite("TailsSkill_Next.png")
end

--[[
滤镜
]]
-- 模糊
function filter_blur(filename, num)

	local params = 	json.encode({
			frag = "shaders/example_Blur.fsh",
			shaderName = "blurShader",
			resolution = {960,640},
			blurRadius = num * 2,
			sampleNum = num
			})

	return display.newFilteredSprite(filename, "CUSTOM", params)
end

-- 灰色
function filter_gray(filename)
	local r = 0.2
	local g = 0.3
	local b = 0.5
	local a = 0.2

	return display.newFilteredSprite(filename, "GRAY", {r,g,b,a})
end

--[[
颜色
]]
-- 白色
function color_white()
	return cc.c3b(255,255,255)
end

-- 黑色
function color_black()
	return cc.c3b(50,20,0)
end

-- 绿色
function color_green()
	return cc.c3b(80,239,0)
end
-- 蓝色
function color_blue()
	return cc.c3b(52,152,255)
end

-- 紫色
function color_purple()
	return cc.c3b(224,111,255)
end

-- 橙色
function color_orange()
	return cc.c3b(252,189,38)
end

-- 红色
function color_red()
	return cc.c3b(255,44,44)
end

-- 黄色
function color_yellow()
	return cc.c3b(255,255,10)
end

-- 灰色1
function color_gray1()
	return cc.c3b(190,160,100)
end

--------------------------------------
-- 红点
function redPoint()
	return display.newSprite("Point_Red.png"):zorder(10)
end

--福禄丸特效--按钮
function animation_wealth_btn()
	local aniSprite = display.newSprite()
    local animation = createAnimation("wealth_btn%d.png",10,0.06)
	transition.playAnimationForever(aniSprite,animation)

	return aniSprite
end

--福禄丸特效--星星
function animation_wealth_star()
	local aniSprite = display.newSprite()
    local animation = createAnimation("wealth_star%d.png",8,0.06)
	transition.playAnimationForever(aniSprite,animation)

	return aniSprite
end

--福禄丸特效--数字框
function animation_wealth_ring()
	local aniSprite = display.newSprite()
    local animation = createAnimation("wealth_ring%d.png",20,0.06)
	transition.playAnimationForever(aniSprite,animation)

	return aniSprite
end

--老虎机特效--光圈
function animation_tiger_light()
	local aniSprite = display.newSprite()
    local animation = createAnimation("tiger_ring%d.png",6,0.06)
	transition.playAnimationForever(aniSprite,animation)

	return aniSprite
end

--充值回馈特效--箱子特效
function animation_backfeed()
	local aniSprite = display.newSprite()
    local animation = createAnimation("box_pay%d.png",7,0.06)
	transition.playAnimationForever(aniSprite,animation)

	return aniSprite
end

--翻翻乐特效--牌特效
function animation_flip()
	newrandomseed()	
	local rmd = math.random(5,8)
	local delayT = math.random(3,6)
	local aniSprite = display.newSprite()
    local animation = createAnimation("flip_ring%d.png",16,0.01*rmd)
	transition.playAnimationForever(aniSprite,animation,delayT)

	return aniSprite
end

-- 城建升级特效
function animation_lvup_light(target, params)
	local aniSprite = display.newSprite()
	:pos(params.x or 0, params.y or 0)
	:addTo(target, params.zorder or 0)

	local animation = createAnimation("up%d.png",13,0.1)
	transition.playAnimationOnce(aniSprite, animation, true)
end

-- 弹窗弹出效果
function animation_show_out(target)
	target:hide()
    local seq = transition.sequence({
    	cc.ScaleTo:create(0, 0.3),
    	cc.CallFunc:create(function()
    		target:show()
    	end),
    	transition.create(cc.ScaleTo:create(0.15, 1), {easing="backout"}),
        })
    target:runAction(seq)
end

-- 按钮特效
function animation_btn1()
	local aniSprite = display.newSprite()
	aniSprite:setScaleX(1.15)

    local animation = createAnimation("anniu%04d.png",30,0.03)
	transition.playAnimationForever(aniSprite,animation)

	return aniSprite
end

-- 活动按钮特效 ** 比正常坐标低4像素
function animation_btn2()
	local aniSprite = display.newSprite()
    local animation = createAnimation("Ain_Activity_%d.png",25,0.06)
	transition.playAnimationForever(aniSprite,animation)

	return aniSprite
end

-- 数字上升
function view_num_up()
	return display.newSprite("aincrad_number_up.png")
	:align(display.CENTER_TOP)
end

-- 数字上升
function animation_move_b2u(params)
	params.zorder = params.zorder or 0
	params.speed = params.speed or 0.01
	params.scale = params.scale or 1
	params.space = params.space or 0

	local fromX = params.fromX
	local fromY = params.fromY
	local toX = params.toX
	local toY = params.toY

	local spr = view_num_up()
	:addTo(params.target)
	:zorder(params.zorder)
	:scale(params.scale)
	spr:pos(fromX, fromY)

	local height = spr:getBoundingBox().height
	local toEndY = toY + height + params.space

	local toYm = fromY + height + params.space
	local toXm = fromX
	if toX ~= fromX then
		toXm = fromX + (toX - fromX) * toYm / (toEndY - fromY)
	end
	local len1 = math.sqrt(math.pow(toYm-fromY, 2) + math.pow(toXm-fromX, 2))
	local len2 = math.sqrt(math.pow(toYm-toEndY, 2) + math.pow(toXm-toX, 2))

	local seq = transition.sequence({
		cc.MoveTo:create(len1 * params.speed, cc.p(toXm, toYm)),
		cc.CallFunc:create(function()
			animation_move_b2u(params)
		end),
		cc.MoveTo:create(len2 * params.speed, cc.p(toX, toEndY)),
		cc.CallFunc:create(function()
			spr:removeSelf()
		end),
	})

	spr:runAction(seq)

end

---------------------------------------



