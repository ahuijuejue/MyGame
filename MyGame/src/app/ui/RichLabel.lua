--[[
    变色label
--]]

local RichLabel = class("RichLabel",function()
    return display.newNode()
end)

function RichLabel:ctor(param)

    self.text = param.text or {}
    self.size = param.size or 30
    self.dimensions = param.dimensions or cc.size(400, 300)
    self.color = param.color or cc.c3b(255, 255, 255)
    self.height = param.height or 0

    self:showText()
end

function RichLabel:showText()

    local t = {}
    local t1 = {}
    local i = 0
    local i1 = 0
    while true do
         i = string.find(self.text, "<", i+1)
         if i == nil then break end
         t[#t+1] = i
         i1 = string.find(self.text, ">", i1+1)
         if i1 == nil then break end
         t1[#t1+1] = i1
    end

    local keyTable = {}
    local strTable = {}
    local rTable = {}
    local gTable = {}
    local bTable = {}
    local s
    for i=1,#t do
        local key = string.sub(self.text, t[i], t1[i])  -- <{r,g,b},【str】>
        local value1 = string.match(key, ".{(.+)}.")  -- r,g,b
        local str2 = string.match(key, ".}(.+)>")   --【str】
        local r,g,b = string.match(value1,"(%d+),(%d+),(%d+)")  -- r g b
        table.insert(keyTable,key)
        table.insert(strTable,str2)
        table.insert(rTable,r)
        table.insert(gTable,g)
        table.insert(bTable,b)
    end

    if #keyTable>0 then
        for i=1,#keyTable do
            s = string.gsub(self.text, keyTable[i], strTable[i])
            self.text = s
        end
    else
        s = self.text
    end

    local i,j = string.find(s,"$")
    if i  then
        s = string.gsub(s,"%$","%%")
    end
    if #strTable>0 then
        for i=1,#strTable do
            local k,j = string.find(strTable[i],"$")
            if k  then
                strTable[i] = string.gsub(strTable[i],"%$","%%")
            end
        end
    end


    local labelTable = {}
    local list,len = self:widthTatol(s)
    for i=1,#list do
        local posX = 30
        local label3 = cc.ui.UILabel.new({text = list[i], size = self.size})
        label3:addTo(self)
        label3:setColor(self.color)
        table.insert(labelTable, label3)
    end

    self.i = 0
    if #keyTable>0 then
        for j=1,#list do
            for k=1,#strTable do
                local colorText,len_ = self:widthTatol(strTable[k])
                local j_
                if k == 1 then
                    j_ = j+1
                elseif k == #strTable then
                    j_ = j+1
                else
                    j_ = j+#strTable[k]-1
                end
                if j>self.i then
                    for i=1,#colorText do
                        if i==1 then
                            if colorText[1] == list[j] then
                                labelTable[j]:setColor(cc.c3b(rTable[k],gTable[k],bTable[k]))
                                self.i = j
                            end
                        else
                            if colorText[i] == list[j_] then
                                labelTable[j_]:setColor(cc.c3b(rTable[k],gTable[k],bTable[k]))
                                j_ = j_+1
                                self.i = j_-1
                            else
                                self.i = 0
                                for i=0,j_-j do
                                    labelTable[j]:setColor(self.color)
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    local alllines = self:adjustLineBreak_(labelTable, len/(#list))
    for index, line in pairs(alllines) do
        local linewidth, lineheight = self:layoutLine_(cc.p(0,0), line, 1, len/(#list))
        self:layoutLine_(cc.p(200,200-lineheight*index), line, 1, len/(#list))
    end
    self.lines = alllines
end

function RichLabel:getLines()
    return #self.lines
end

-- -- 布局单行中的节点的位置，并返回行宽和行高
function RichLabel:layoutLine_(basepos, line, anchorpy, charspace)
    local pos_x = basepos.x
    local pos_y = basepos.y
    local lineheight = 0
    local linewidth = 0
    for index, node in pairs(line) do
        local box = node:getBoundingBox()
        -- 设置位置
        if self:isNum(node) then
            node:setPosition(pos_x + linewidth + box.width/2 + 5, pos_y)
        else
            -- 设置位置
            node:setPosition(pos_x + linewidth + box.width/2, pos_y)
        end

        -- 累加行宽度
        linewidth = linewidth + box.width + charspace
        -- 查找最高的元素，为行高
        if lineheight < box.height then
            lineheight = box.height+self.height
        end
    end
    return linewidth, lineheight
end

function RichLabel:widthTatol(str)
    local list = {}
    local len = string.len(str)
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
    end
    return list, len
end

function RichLabel:adjustLineBreak_(allnodelist, charspace)
  -- 如果maxwidth等于0则不自动换行
    local maxwidth = self.dimensions.width
    if maxwidth <= 0 then maxwidth = 999999999999
    end

    -- 存放每一行的nodes
    local alllines = {{}, {}, {},{}}

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
    return alllines
end

-- 判断是否为文本换行符
function RichLabel:adjustContentLinebreak_(node)
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
function RichLabel:isNum(node)
  -- 若为Label则有此方法
  if node.getString then
    local str = node:getString()
    return tonumber(str)
  end
  return false
end

return RichLabel