--[[
    变色label
    TalkLabel.new({
        text="推荐<{248,192,0}购买月卡>，领取<{248,192,0}30天\n免费钻石>福利。",
        size=20,
    })
--]]

local TalkLabel = class("TalkLabel",function()
    return display.newNode()
end)

--[[
text        字符串
numOffset   数字偏移
color       默认颜色
size        字体大小
dimensions  窗口尺寸
spacing     字间距
align       竖向对齐 "left" "center" "right"
]]

function TalkLabel:ctor(param)

	self.text = param.text or {}
	self.size = param.size or 30
    self.dimensions = param.dimensions or cc.size(0, 0)
    self.color = param.color or cc.c3b(255, 255, 255)
    self.spacing = param.spacing or 0
    self.numOffset = param.numOffset or cc.p(0, 0)
    self.alignType = param.align or "left"
    self.height = param.height or 0
    self.scale = param.scale or 1

    self.textSprite = {}
    self.lines = 0
    self.oneLineOfWidth = 0

    self.params = param

    self:showText()
end

-- 解析格式字符串 <{r,g,b},【str】>
local function parseFntString(text)

    local colorStr = string.match(text, ".{(.+)}.")  -- r,g,b
    local letterStr = string.match(text, ".}(.+)>")   --【str】
    local r,g,b = string.match(colorStr,"(%d+),(%d+),(%d+)")  -- r g b

    local data = {
        color = cc.c3b(checknumber(r), checknumber(g), checknumber(b)),
        text = letterStr,
    }

    return data
end

-- 解析格式字符串 [str]
local function parseFntString_(text)

    local t = {}
    local t_ = {}
    local i = 0
    local j = 0
    while true do
         i = string.find(text, "%(", i+1)
         if i == nil then break end
         t[#t+1] = i
         j = string.find(text, "%)", j+1)
         if j == nil then break end
         t_[#t_+1] = j
    end
    local express = string.sub(text, t[1], t_[1])
    local data = {
        text = express,
    }

    return data
end

--[[
--解析字符串
text = table.concat(strTable), -- 解析后字符串
font = fntTable, -- index1与index2之间字符的格式
index1 = index1, -- 左索引
index2 = index2, -- 右索引
]]

function TalkLabel:parseText(text)

    local index1    = {} -- 左索引 <
    local index2    = {} -- 右索引 >
    local index_1   = {} -- 左索引 [
    local index_2   = {} -- 右索引 ]
    local strTable  = {} -- 字符集
    local fntTable  = {} -- 格式集
    local expTable  = {} -- 表情集

    local isFntLatter = false -- 是否是格式字符
    local ftnStr = ""
    local list,len = self:widthTatol(text)
    local index = 1
    for i,v in ipairs(list) do
        if v == "<" then
            table.insert(index1, index)
            isFntLatter = true
            ftnStr = ftnStr..v

        elseif v == ">" then
            isFntLatter = false
            ftnStr = ftnStr..v
            local ftnData = parseFntString(ftnStr)
            table.insert(fntTable, ftnData)
            ftnStr = ""

            table.insert(strTable, ftnData.text)

            index = index + #self:widthTatol(ftnData.text)
            table.insert(index2, index-1)
        elseif v == "(" then
            table.insert(index_1, index)
            isFntLatter = true
            ftnStr = ftnStr..v
        elseif v == ")" then
            isFntLatter = false
            ftnStr = ftnStr..v
            local ftnData = parseFntString_(ftnStr)
            table.insert(expTable, ftnData)
            ftnStr = ""

            table.insert(strTable, ftnData.text)

            index = index + #self:widthTatol(ftnData.text)
            table.insert(index_2, index-1)
        else
            if isFntLatter then
                ftnStr = ftnStr..v
            else
                table.insert(strTable, v)
                index = index + 1
            end
        end

    end

    text = table.concat(strTable)

    local i,j = string.find(text,"$")
    if i  then
        text = string.gsub(text,"%$","%%")
    end

    local info = {
        text = text,
        font = fntTable,
        express = expTable,
        index1 = index1,
        index2 = index2,
        index_1 = index_1,
        index_2 = index_2,
    }

    return info
end

function TalkLabel:setLabelFont(label, data)
    label:setColor(data.color)
end

function TalkLabel:createLabel(info)
    local labelTable = {}
    local index1 = info.index1 or {}
    local index2 = info.index2 or {}
    local index_1 = info.index_1 or {}
    local index_2 = info.index_2 or {}
    local expTable = info.express

    local list = self:widthTatol(info.text)

    local function createLabel(i, v)
        local label = cc.ui.UILabel.new({text = v, size = self.size})
        self:addChild(label)
        table.insert(labelTable, label)

        local isFntString = false -- 是否是需要修改格式的字符串
        for i2,v2 in ipairs(index1) do
            if i >= v2 and i <= index2[i2] then
                isFntString = true
                self:setLabelFont(label, info.font[i2])
                break
            end
        end
        if not isFntString then
            self:setLabelFont(label, self)
        end
    end

    local a = 0
    local b = 0
    for i,v in ipairs(list) do
        if a > 0 then
            if i < a+3 then
            elseif i == a+3 then
                for k,v_ in pairs(GameConfig["ChatExpression"]) do
                    if expTable[b].text == v_.Name then
                        local sprite = display.newSprite(v_.Img)
                        sprite:scale(self.scale)
                        self:addChild(sprite)
                        table.insert(labelTable, sprite)
                        break
                    end
                end
            elseif i > a+3 then
                createLabel(i, v)
            end
        else
            if v ~= "(" then
                createLabel(i ,v)
            end
        end
        if v == "(" then
            a = i
            b = b + 1
        end
    end

    return labelTable
end

function TalkLabel:showText()

    local info = self:parseText(self.text)
    self.textSprite = self:createLabel(info)


    local alllines,totalwidth = self:adjustLineBreak_(self.textSprite, self.spacing)

    local allHeight = 0
    local maxWidth = 0

    local lineSize = {}
    for i,v in ipairs(alllines) do
        local linewidth, lineheight = self:getLineSize(v, self.spacing)
        table.insert(lineSize, cc.size(linewidth, lineheight))

        allHeight = allHeight + lineheight
        if maxWidth < linewidth then
            maxWidth = linewidth
        end
    end

    self:updateItemsPosition(alllines, lineSize, maxWidth, allHeight, self.spacing)

    self.lines = #alllines
    if totalwidth then
        self.oneLineOfWidth = totalwidth
    end

    if self.dimensions.width == 0 then
        self:setContentSize(maxWidth, allHeight)
    else
        self:setContentSize(self.dimensions)
    end

    self:setAnchorPoint(cc.p(0, 0.5))
end

function TalkLabel:getLines()
    return self.lines
end

function TalkLabel:getTotalWidth()
    if self.oneLineOfWidth then
        return self.oneLineOfWidth
    end
    return
end

function TalkLabel:updateItemsPosition(lineTable, sizeTable, maxWidth, allHeight, charspace)
    if self.alignType == "left" then
        self:layoutL_B(lineTable, sizeTable, maxWidth, allHeight, charspace)
    elseif self.alignType == "center" then
        self:layoutC_B(lineTable, sizeTable, maxWidth, allHeight, charspace)
    elseif self.alignType == "right" then
        self:layoutR_B(lineTable, sizeTable, maxWidth, allHeight, charspace)
    end
end

function TalkLabel:layoutL_B(lineTable, sizeTable, maxWidth, allHeight, charspace)
    for i,v in ipairs(lineTable) do
        local lineSize = sizeTable[i]
        allHeight = allHeight-lineSize.height
        self:layoutLine_(cc.p(0, allHeight), v, 0.5, lineSize.height, charspace)
    end
end

function TalkLabel:layoutC_B(lineTable, sizeTable, maxWidth, allHeight, charspace)
    for i,v in ipairs(lineTable) do
        local lineSize = sizeTable[i]
        local posX = (maxWidth - lineSize.width) * 0.5
        allHeight = allHeight-lineSize.height
        self:layoutLine_(cc.p(posX, allHeight), v, 0.5, lineSize.height, charspace)
    end
end

function TalkLabel:layoutR_B(lineTable, sizeTable, maxWidth, allHeight, charspace)
    for i,v in ipairs(lineTable) do
        local lineSize = sizeTable[i]
        local posX = maxWidth - lineSize.width
        allHeight = allHeight-lineSize.height
        self:layoutLine_(cc.p(posX, allHeight), v, 0.5, lineSize.height, charspace)
    end
end

-- -- 布局单行中的节点的位置，并返回行宽和行高
function TalkLabel:layoutLine_(basepos, line, anchorpy, lineHeight, charspace)
    local pos_x = basepos.x
    local pos_y = basepos.y
    local linewidth = 0
    local posY = lineHeight * anchorpy + pos_y

    for index, node in ipairs(line) do
        local box = node:getBoundingBox()
        node:setAnchorPoint(cc.p(0.5, anchorpy))

        -- 设置位置
        if self:isNum(node) then
            node:setPosition(pos_x + linewidth + box.width * 0.5 + self.numOffset.x, posY + self.numOffset.y)
        else
            node:setPosition(pos_x + linewidth + box.width * 0.5, posY)
        end
        -- 累加行宽度
        linewidth = linewidth + box.width + charspace
    end
end

function TalkLabel:getLineSize(line, charspace)
    local lineheight = 0
    local linewidth = 0
    for index, node in ipairs(line) do
        local box = node:getBoundingBox()
        -- 累加行宽度
        linewidth = linewidth + box.width + charspace
        -- 查找最高的元素，为行高
        if lineheight < box.height then
            lineheight = box.height + self.height
        end
    end
    if linewidth > 0 then
        linewidth = linewidth - charspace
    end
    return linewidth, lineheight
end

function TalkLabel:widthTatol(str)
    local list = {}
    local len = string.len(str)
    local listLen = 0
    local i = 1
    while i <= len do
        local c = string.byte(str, i)
        local shift = 1
        if c > 0 and c <= 127 then
            shift = 1
        elseif (c >= 192 and c <= 223) then
            shift = 2
        elseif (c >= 224 and c <= 239) then
            shift = 3
        elseif (c >= 240 and c <= 247) then
            shift = 4
        end
        local char = string.sub(str, i, i+shift-1)
        i = i + shift
        table.insert(list, char)
        listLen = listLen + 1
    end
    return list, listLen
end

function TalkLabel:adjustLineBreak_(allnodelist, charspace)
  -- 如果maxwidth等于0则不自动换行
    local maxwidth = self.dimensions.width
    if maxwidth <= 0 then maxwidth = 999999999999
    end

    charspace = charspace or 0

    -- 存放每一行的nodes
    local alllines = {}

    -- 当前行的累加的宽度
    local addwidth = 0
    local rowindex = 1
    local colindex = 0

    for _, node in pairs(allnodelist) do
        colindex = colindex + 1
        -- 为了防止存在缩放后的node
        local box = node:getBoundingBox()
        addwidth = addwidth + box.width
        local totalwidth = addwidth + (colindex - 1) * charspace
        local breakline = false
        -- 若累加宽度大于最大宽度
        -- 则当前元素为下一行第一个元素
        if totalwidth > maxwidth then
          rowindex = rowindex + 1
          addwidth = box.width -- 累加数值置当前node宽度(为下一行第一个)
          colindex = 1
          breakline = true
        end

        -- 在当前行插入node
        local curline = alllines[rowindex] or {}
        alllines[rowindex] = curline
        table.insert(curline, node)

        -- 若还没有换行，并且换行符存在，则下一个node直接转为下一行
        if not breakline and self:adjustContentLinebreak_(node) then
          rowindex = rowindex + 1
          colindex = 0
          addwidth = 0 -- 累加数值置0
        end
    end

    if #alllines == 1 then
        return alllines, addwidth
    end
    return alllines
end

-- 判断是否为文本换行符
function TalkLabel:adjustContentLinebreak_(node)
  -- 若为Label则有此方法
  if node.getString then
    local str = node:getString()
    -- 查看是否为换行符
    if str == "\n" then
      return true
    end
  end
  return false
end

-- 判断是否为数字
function TalkLabel:isNum(node)
  -- 若为Label则有此方法
  if node.getString then
    local str = node:getString()
    return tonumber(str)
  end
  return false
end

return TalkLabel