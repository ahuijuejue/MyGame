-- 返回时间 mm:ss
function formatTime1(nSec)
    return string.format("%02d:%02d",math.floor((nSec % 3600) / 60), nSec % 60)
end

-- 返回时间 hh:mm:ss
function formatTime2(nSec)
	return string.format("%02d:%02d:%02d",math.floor(nSec/3600),math.floor((nSec % 3600) / 60), nSec % 60)
end

function convertSecToDate(t)
	local dt = {}
	dt.s = t
	dt.day = math.floor(t / 86400)
	t = math.mod(t, 86400)

	dt.hour = math.floor(t / 3600)
	t = math.mod(t, 3600)

	dt.min = math.floor(t / 60)
	t = math.mod(t, 60)

	dt.sec = t

	return dt
end

function convertDateToSec(dt)
	return dt.day * 86400 + dt.hour * 3600 + dt.min * 60 + dt.sec
end

--觉醒等级转换
function getAwakeLevel(awakeLevel)
	local level = 0
	local num = 0
	local range = {{0},{1},{2,3},{4,5,6},{7,8,9,10,11}}
	for i,v in ipairs(range) do
		local index = table.indexof(v,awakeLevel)
		if index then
			level = i - 1
			num = index - 1
		end
	end
	return {level,num}
end

--品质等级转换
function getQualityLevel(colorLevel)
	local level = 0
	local num = 0
	local range = {{1},{2},{3,4},{5,6,7},{8,9,10,11,12}}
	for i,v in ipairs(range) do
		local index = table.indexof(v,colorLevel)
		if index then
			level = i
			num = index - 1
		end
	end
	return {level,num}
end

-- 将时间字符串转换成秒数 (格式 时：分)
function encodeTime(tStr)
	local arrTime = string.split(tStr or "", ":")
	local nTime = table.nums(arrTime)
	local sec = 0
	for i,v in ipairs(arrTime) do
		local vType = nTime - i
		local value = checknumber(v)
		if vType == 0 then -- 分
			sec = sec + value * 60
		elseif vType == 1 then -- 时
			sec = sec + value * 3600
		end
	end

	return sec
end

--从列表中移除元素
function removeObject(list,obj)
	if obj then
		local index = table.indexof(list,obj)
		table.remove(list,index)
	end
end

--合并table
function mergeTable(tb1,tb2)
	local tb = {}
	if type(tb1) == "table" then
		for i=1,#tb1 do
			table.insert(tb,tb1[i])
		end
	else
		table.insert(tb,tb1)
	end

	if type(tb2) == "table" then
		for i=1,#tb2 do
			table.insert(tb,tb2[i])
		end
	else
		table.insert(tb,tb2)
	end

	return tb
end

function formatString(str)
	str = str or ""
	str = string.gsub(str, "\\t", "\t")
	str = string.gsub(str, "\\n", "\n")

	return str
end

-- 截取字符串长度，clen 为一个中文占的长度
function parseString(input, _len, clen)
	clen = clen or 1
    local len  = string.len(input)
    local left = len
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        local addLen = i > 1 and clen or 1

        if cnt + addLen <= _len then
        	cnt = cnt + addLen
        else
        	return string.sub(input, 1, len - left - i)
        end
    end
    return input
end


-- 连接服务器，增加屏蔽点击层
function showLimitLayer()
	if display.getRunningScene() then
		local limitLayer_ = display.getRunningScene():getChildByTag(9999)
		if not limitLayer_ then
			limitLayer_ = display.newNode():size(display.width, display.height)
			:addTo(display.getRunningScene(), 99999, 9999)
			:onTouch(function(event)
				if event.name == "began" then
					return false
				end
			end)

			display.newColorLayer(cc.c4f(0,0,0,100)):addTo(limitLayer_)
		end
		limitLayer_:show()
	end

	return self
end
-- 连接服务器结束，隐藏 屏蔽点击层
function hideLimitLayer()
	if display.getRunningScene() then
		local limitLayer_ = display.getRunningScene():getChildByTag(9999)
		if limitLayer_ then
			limitLayer_:hide()
		end
	end

	return self
end
-- 获取 类 或 table 名
function getClassName(obj)
    local t = type(obj)
    local mt
    if t == "table" then
        mt = getmetatable(obj)
    elseif t == "userdata" then
        mt = tolua.getpeer(obj)
    end
    return mt.__cname
end

--[[
	math.newrandomseed android下不能生成新种子
	在32位机器上socket.gettime() * 1000 这个数作为种子会超过最大值，导致设置新种子无效。
--]]
function newrandomseed()
    math.randomseed(tostring(os.time()+os.clock()):reverse():sub(1, 6))
    math.random()
    math.random()
    math.random()
    math.random()
end

function randInt(min, max)
	local randV = math.random() * (max - min)
	randV = math.round(randV)
	return randV + min
end

function randFloat(min, max)
	local randV = math.random() * (max - min)
	return randV + min
end

function convertPosition(fromNode, toNode, pos)
	local point = fromNode:convertToWorldSpace(pos or cc.p(0, 0))
	point = toNode:convertToNodeSpace(point)
	return point
end

-- 转换成希腊数字 1-12
local greekNums = {"I", "II", "III", "IV", "V",
"VI", "VII", "VIII", "IX", "X", "XI", "XII",
}
function convertToGreekNum(num)
	return greekNums[num]
end

function copyItems(totable, fromtable)
	for k,v in pairs(fromtable) do
		table.insert(totable, v)
	end
	return totable
end

--[[
将字符串转换成日期table
-- 支持格式
"2015-09-22 11:22:30"
]]
function string.time(timestring)
	local strArr = string.split(timestring, " ")
	local dateArr = {}
	local timeArr = {}
	if #strArr == 2 then
		dateArr = string.split(strArr[1], "-")
		timeArr = string.split(strArr[2], ":")
	elseif #strArr == 1 then
		if string.find(strArr[1], "-") then
			dateArr = string.split(strArr[1], "-")
		else
			timeArr = string.split(strArr[1], ":")
		end
	end
	local tab = {
		year  = checknumber(dateArr[1]),
		month = checknumber(dateArr[2]),
		day   = checknumber(dateArr[3]),
		hour  = checknumber(timeArr[1]),
		min   = checknumber(timeArr[2]),
		sec   = checknumber(timeArr[3]),
		isdst = false,
	}

	return tab
end

--物品数据转换
function dataToItem(str)
	local arr = {}
	local strArr =  string.split(str, "_")		-- id_数量 的数组
	for i,v in ipairs(strArr) do
	 	local nCount = string.split(v, "#")
	 	if #nCount == 2 then
	 		arr[nCount[1]] = tonumber(nCount[2])
	 	end
	end
	return arr
end

-- 尾兽星级信息 解析
function parseTailsStar(str)
	local tails = {}
	local arrStar = string.split(str or "", "_")
	if table.nums(arrStar) == 2 then
		local ids = string.split(arrStar[1], ",")
		local nums = string.split(arrStar[2], ",")
		for i,v in ipairs(ids) do
			if string.len(v) > 0 then
				tails[v] = nums[i]
			end
		end
	end
	return tails
end
-- 尾兽id列表 解析
function convertTailsList(str)
	local arr = {}
	local arrTails = string.split(str or "", ",")
	for i,v in ipairs(arrTails) do
		if string.len(v) > 0 then
			table.insert(arr, v)
		end
	end
	return arr
end

--聊天文本转换
function toChatStr(s , scale_, size_ , color_)
	local scale = scale_ or 0.3
	local size = size_ or 18
	local color = color_ or "FFFFFF"
	local len = string.len(s)
    local i,j = 0
    local lastPos = 0
    local tab = {}
    local newStr = ""
    while true do
    	i,j = string.find(s,"%b()",i+1)
    	if i then
    		table.insert(tab,string.sub(s,lastPos+1,i-1))
			table.insert(tab,string.sub(s,i,j))
			lastPos = j
    	else
    		table.insert(tab,string.sub(s,lastPos+1,len))
    		break
    	end
    end
    for i,v1 in ipairs(tab) do
    	local isFace = false
    	local faceStr = ""
    	for j,v2 in pairs(require("app.config.ChatExpression")) do
    		if v2.Name == v1 then
    			isFace = true
    			faceStr = string.format("[image=%s scale=%0.1f][/image]",v2.Img, scale)
    			break
    		end
    	end
    	if isFace then
    		newStr = newStr..faceStr
    	else
    		if v1 ~= "" then
    			newStr = newStr..string.format("[fontColor=%s fontSize=%d]%s[/fontColor]", color, size, v1)
    		end
    	end
    end
    return newStr
end
