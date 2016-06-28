import(".NodeEx")
import(".UICheckBoxButtonEx")
import(".UIPushButtonEx")
import(".SceneEx")
import(".UIInputEx")
-- import(".testData")

base = {}
base.GridSize = import(".GridSize")
base.TableNode = import(".TableNode")
base.TouchNode = import(".TouchNode")
base.LinkNode = import(".LinkNode")
base.LinkList = import(".LinkList")
base.SceneVisitor = import(".SceneVisitor")
base.SceneElement = import(".SceneElement")
base.Scene = import(".Scene")
base.ListView = import(".ListView")
base.TableView = import(".TableView")
base.GridView = import(".GridView")
base.GridViewOne = import(".GridView1")
base.PageView = import(".PageView")
base.CheckBoxButton = import(".CheckBoxButton")
base.BoxLayout = import(".BoxLayout")
base.Grid = import(".Grid")
base.Label = import(".Label")
base.ScrollBar = import(".ScrollBar")
base.AlertLayer = import(".AlertLayer")
base.AlertBar = import(".AlertBar")
base.RotateGrid = import(".RotateGrid")
base.ButtonGroup = import(".ButtonGroup")
base.PushButton = import(".PushButton")
base.TalkLabel = import(".TalkLabel")

-- import(".shortcodes")


function table_copy(table_param)	
	if type(table_param) == "table" then
		local cpy = {}
		for k,v in pairs(table_param) do			
			cpy[k] = table_copy(v)
		end
		return cpy
	else		
		return table_param 
	end
end

function table.index(table_param, func)
	for i,v in ipairs(table_param) do
		if func(v) then 
			return i
		end 
	end
	return 0
end

function table.item(table_param, func)
	for i,v in ipairs(table_param) do
		if func(v) then 
			return v
		end 
	end
	return nil
end

function string_split(str, split)
	split = split or ","	
	local t = {}      -- table to store the indices
	local start = 1
	while true do
	    local i,j = string.find(str, split, start)   -- find 'next' newline
	    if i == nil then 
	    	if start <= #str then 
	    		table.insert(t, string.sub(str, start, #str))
	    	end 
	    	break
	    end
	    local subStr = string.sub(str, start, i - 1)
	    if subStr and #subStr > 0 then --去除空白
	    	table.insert(t, subStr)
	    end 
	    start = j + 1
	end
	return t
end 

function max(a, b)
	if a > b then 
		return a 
	else 
		return b 
	end 
end

function min(a, b)
	if a < b then 
		return a 
	else 
		return b 
	end 
end
