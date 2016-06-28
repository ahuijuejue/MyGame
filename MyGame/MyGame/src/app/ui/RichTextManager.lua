
RichTextManager = RichTextManager or {}
--富文本，目前只实现了 文字大小、颜色

local RichText_EnW = 10.5 		-- 英文宽度
local RichText_ChW = 20   		-- 中文宽度
local RichText_NumSizeH = 26	-- 单字高度
local baseSize = 20 			-- 基础文字大小

local RichText_cus_NumSizeH = 26	-- 单字高度
local RichText_MaxWidth = 820 		-- 文本框宽度

--获取一个富文本
function RichTextManager:getRichText(textWidth, texts)
	if texts == nil then
		texts = {}
		table.insert(texts,{text = "材料不足，缺少 面粉3个，小蛋1个是否花费42" ,textType = ft.Labels.MessageBox.MiaoShu  })
		-- table.insert(texts,{text = "欧日吐热怄气" ,textType = ft.Labels.MessageBox.MiaoShu  })
		-- table.insert(texts,{image = g_assets.ui_diamond })
		-- table.insert(texts,{text = "制作？" ,textType = ft.Labels.MessageBox.MiaoShu  })
		-- table.insert(texts,{text = "摩擦了坚实的分类" ,textType = ft.Labels.MessageBox.MiaoShu  })
		-- table.insert(texts,{image = g_assets.ui_money })
		-- table.insert(texts,{text = "摩擦了坚实的分类" ,textType = ft.Labels.MessageBox.MiaoShu  })
		-- table.insert(texts,{image = g_assets.ui_shishen })
		-- table.insert(texts,{text = "摩擦了坚实的分类" ,textType = ft.Labels.MessageBox.MiaoShu  })
		-- table.insert(texts,{image = g_assets.ui_fame })

		-- table.insert(texts,{text = "拉斯加哦我去苏东坡破千万哦",textType = ft.Labels.DiaoLuo.GeShuBuZu  })
		-- table.insert(texts,{text = "欧全文了空间被广泛地" ,textType = ft.Labels.DiaoLuo.GeShuDuoYu  })
		-- table.insert(texts,{text = "欧日图二我萨克的",textType = ft.Labels.DiaoLuo.ZhangJie  })
		-- table.insert(texts,{text = "roi孤儿儿童" ,textType = ft.Labels.DiaoLuo.ZhiXian  })
		-- table.insert(texts,{text = "欧全文了空间被广泛地" ,textType = ft.Labels.DiaoLuo.ZhiXian  })
		-- table.insert(texts,{text = "爱的发空间的了啊啊" ,textType = ft.Labels.DiaoLuo.DiDian  })
		-- table.insert(texts,{text = "爱上了罚款金额为 拉斯加哦我去苏东坡破千万哦" ,textType = ft.Labels.DiaoLuo.ZhiXian  })
	end

	RichText_MaxWidth = textWidth
	local maxSize = 0
	for i,v in ipairs(texts) do
		if v.textType and v.textType.size > maxSize then
			maxSize = v.textType.size
		end
	end
	--最高高度间距
	RichText_cus_NumSizeH = RichText_NumSizeH + (maxSize - baseSize)

	local nod = display.newNode()
	nod:setAnchorPoint(0, 0)

	curSheng = RichText_MaxWidth -- 当前行剩余空间
	curLine = 1 -- 当前行数
	curx = 0 -- 当前位置x 像素
	cury = 0 -- 当前位置y 像素

	local function createTTF(_txt,textType)
		if v ~= "" and v ~= nil then
			return
		end
		local textSize = textType.size
        xuyao = RichText_getLen(_txt,textSize) -- 需要空间像素
        cury = curLine*RichText_cus_NumSizeH

        if curSheng >= xuyao then -- 本行剩余空间可用
        	local ttf = UI_LabelCommon.new({Type = textType,  align = ui.TEXT_ALIGN_LEFT})
			ttf:setAnchorPoint(0, 0)
			ttf:setString(_txt)
        	ttf:pos(curx, cury*-1)
        	nod:addChild(ttf)

        	curx = curx + RichText_getLen(_txt,textSize)
        	curSheng = curSheng - xuyao
        else
        	if curSheng < RichText_ChW + (textSize - baseSize)  then
        		curx = 0
				curSheng = RichText_MaxWidth

				curLine = curLine + 1
				cury = curLine*RichText_cus_NumSizeH
        	end

			subtxt = RichText_getPreLen(curSheng, _txt,textSize)

			-- local subtxt = string.sub(_txt,1,jieindex)
        	local ttf1 = UI_LabelCommon.new({Type = textType,  align = ui.TEXT_ALIGN_LEFT})
			ttf1:setAnchorPoint(0, 0)
			ttf1:setString(subtxt)
        	ttf1:pos(curx, cury*-1)
        	nod:addChild(ttf1)

        	curtxtlen = RichText_getLen(subtxt,textSize)
        	curx = curx + curtxtlen
			curSheng = curSheng - curtxtlen

        	-- _txt2 = string.sub(_txt, jieindex+1, string.len(_txt))
        	_txt2 = string.sub(_txt, string.len(subtxt)+1 , string.len(_txt))
        	createTTF(_txt2,textType)
        end
	end

	local function createImage(image)
		local sp = display.newSprite(image)
		sp:setScale(0.8)
		sp:setAnchorPoint(0,0.5)
		nod:addChild(sp)
		xuyao = sp:getContentSize().width +20
		cury = curLine*RichText_cus_NumSizeH

		if curSheng >= xuyao then
		else
			curx = 0
			curSheng = RichText_MaxWidth

			curLine = curLine + 1
			cury = curLine*RichText_cus_NumSizeH
		end

		sp:pos(curx+20,(cury-sp:getContentSize().width/4-5)*-1)

		curx = curx + xuyao
        curSheng = curSheng - xuyao

	end

	local arr = texts
    for k,v in ipairs(texts) do
    	if v.text then
    		createTTF(v.text,v.textType)
    	elseif v.image  then
    		createImage(v.image)
    	elseif v.line then
    		curx = 0
			curSheng = RichText_MaxWidth

			curLine = curLine + 1
			cury = curLine*RichText_cus_NumSizeH
    	end
	end
	--设置位置
	nod:pos(0,RichText_cus_NumSizeH * curLine)

	local node = display.newNode()
	node:setContentSize(cc.size(RichText_MaxWidth,RichText_cus_NumSizeH * curLine))
	node:addChild(nod)

	--加个测试颜色，查看文本范围
	-- cc.LayerColor:create(cc.c4b(0, 200, 200, 120))
	-- 		:size(RichText_MaxWidth,RichText_cus_NumSizeH * curLine)
	-- 		:pos(0, 0)
	-- 		:addTo(node,-1)
	-- 		:setTouchEnabled(false)

	return node, curLine
end

-- 获得该字符串所占的实际像素
function RichText_getLen(_s,textSize)
	len = 0
    i = 1
	while i < #_s  do
       	local curByte = string.byte(_s, i)
	    local byteCount = 1
	    if curByte>0 and curByte<=127 then
	        byteCount = 1
	    elseif curByte>=192 and curByte<223 then
	        byteCount = 2
	    elseif curByte>=224 and curByte<239 then
	        byteCount = 3
	    elseif curByte>=240 and curByte<=247 then
	        byteCount = 4
	    end

	    local char = string.sub(_s, i, i+byteCount-1)
	    i = i + byteCount

	    if byteCount == 1 then
	        len = len + RichText_EnW + (textSize - baseSize)*0.5
	    else
	        len = len + RichText_ChW + (textSize - baseSize)
	    end
    end
    return len
end

-- 计算一个字符串按照给定长度需要截取得位置
function RichText_getPreLen(_size, _s,textSize)
	len = 0
	index = 0
    i = 1
    local jietext = ""
	while i < #_s+1  do
       	local curByte = string.byte(_s, i)
	    local byteCount = 1
	    if curByte>0 and curByte<=127 then
	        byteCount = 1
	    elseif curByte>=192 and curByte<223 then
	        byteCount = 2
	    elseif curByte>=224 and curByte<239 then
	        byteCount = 3
	    elseif curByte>=240 and curByte<=247 then
	        byteCount = 4
	    end
	    local char = string.sub(_s, i, i+byteCount-1)
	    i = i + byteCount

	    if byteCount == 1 then
	        len = len + RichText_EnW + (textSize - baseSize)*0.5
	    else
	        len = len + RichText_ChW + (textSize - baseSize)
	    end
       	if len < _size then
       		index = i
       		jietext = jietext .. char
       	else
       		break
       	end
    end
    -- 同为2，3的公倍数 (3的倍数 ，中文三个字节， 否则会乱码)(2的倍数 ，英文,数字二个字节， 否则会乱码)
    -- index = checkint(index/6)*6 -- 确保是
    return jietext
end

--弹窗提示，有图文混排，每段文字从这里转格式
--text 描述文字 ，false的时候传入图片路径
-- type 1文字，2图片，3换行
function RichTextManager:getMessageTextFormat(text,_type)
	if type(_type) == "boolean" then
		if _type then
			return {text = text ,textType = ft.Labels.MessageBox.MiaoShu  }
		else
			return {image = text }
		end
	else
		if _type == 1 then
			return {text = text ,textType = ft.Labels.MessageBox.MiaoShu  }
		elseif _type == 2 then
			return {image = text }
		elseif _type == 3 then
			return {line = text }
		end
	end
end


return RichTextManager






--获得每个精灵的位置
-- function RichTextManager:getPointOfSprite_(widthArr, heightArr, dimensions)
--     local totalWidth = dimensions.width
--     local totalHight = dimensions.height

--     local maxWidth = 0
--     local maxHeight = 0

--     local spriteNum = #widthArr

--     --从左往右，从上往下拓展
--     local curX = 0 --当前x坐标偏移

--     local curIndexX = 1 --当前横轴index
--     local curIndexY = 1 --当前纵轴index

--     local pointArrX = {} --每个精灵的x坐标

--     local rowIndexArr = {} --行数组，以行为index储存精灵组
--     local indexArrY = {} --每个精灵的行index

--     --计算宽度，并自动换行
--     for i, spriteWidth in ipairs(widthArr) do
--         local nexX = curX + spriteWidth
--         local pointX
--         local rowIndex = curIndexY

--         local halfWidth = spriteWidth * 0.5
--         if nexX > totalWidth and totalWidth ~= 0 then --超出界限了
--             pointX = halfWidth
--             if curIndexX == 1 then --当前是第一个，
--                 curX = 0-- 重置x
--             else --不是第一个，当前行已经不足容纳
--                 rowIndex = curIndexY + 1 --换行
--                 curX = spriteWidth
--             end
--             curIndexX = 1 --x坐标重置
--             curIndexY = curIndexY + 1 --y坐标自增
--         else
--             pointX = curX + halfWidth --精灵坐标x
--             curX = pointX + halfWidth --精灵最右侧坐标
--             curIndexX = curIndexX + 1
--         end
--         pointArrX[i] = pointX --保存每个精灵的x坐标

--         indexArrY[i] = rowIndex --保存每个精灵的行

--         local tmpIndexArr = rowIndexArr[rowIndex]

--         if not tmpIndexArr then --没有就创建
--             tmpIndexArr = {}
--             rowIndexArr[rowIndex] = tmpIndexArr
--         end
--         tmpIndexArr[#tmpIndexArr + 1] = i --保存相同行对应的精灵

--         if curX > maxWidth then
--             maxWidth = curX
--         end
--     end

--     local curY = 0
--     local rowHeightArr = {} --每一行的y坐标

--     --计算每一行的高度
--     for i, rowInfo in ipairs(rowIndexArr) do
--         local rowHeight = 0
--         for j, index in ipairs(rowInfo) do --计算最高的精灵
--             local height = heightArr[index]
--             if height > rowHeight then
--                 rowHeight = height
--             end
--         end
--         local pointY = curY + rowHeight * 0.5 --当前行所有精灵的y坐标（正数，未取反）
--         rowHeightArr[#rowHeightArr + 1] = - pointY --从左往右，从上到下扩展，所以是负数
--         curY = curY + rowHeight --当前行的边缘坐标（正数）

--         if curY > maxHeight then
--             maxHeight = curY
--         end
--     end

--     self._maxWidth = maxWidth
--     self._maxHeight = maxHeight

--     local pointArrY = {}

--     for i = 1, spriteNum do
--         local indexY = indexArrY[i] --y坐标是先读取精灵的行，然后再找出该行对应的坐标
--         local pointY = rowHeightArr[indexY]
--         pointArrY[i] = pointY
--     end

--     return pointArrX, pointArrY
-- end

