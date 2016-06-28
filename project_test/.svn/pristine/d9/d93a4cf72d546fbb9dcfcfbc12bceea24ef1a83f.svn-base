
local NumberData = class("NumberData") 

function NumberData:ctor()
	
end

function NumberData:convertToName(str)
	if str == "." then 
		return "dot"
	else 
		return str
	end 
end 

function NumberData:convert_(value, pre, w, h, padding)
	local str = tostring(value) 
	local node = display.newNode()
	local nStr = string.len(str) 
	if nStr > 0 then 		
		local w2 = w * 0.5 
		local h2 = h * 0.5 
		padding = padding or 0 
		local width = nStr  * (padding + w) - padding 
		local height = h 
		node:size(width, height)
		:align(display.LEFT_CENTER)
		for i=1,nStr do
			local tstr = string.format("%s_%s.png", pre, self:convertToName(string.sub(str, i, i)))
			display.newSprite(tstr):addTo(node)
			:pos(w2 + (i - 1) * (w + padding), h2)
		end
	end 
	return node 
end 

------------------------------------------------------
function NumberData:font1(value, padding)
	return self:convert_(value, "font1", 29, 40, padding)	
end

function NumberData:font2(value, padding)
	return self:convert_(value, "font2", 15, 23, padding)	
end

function NumberData:font3(value, padding)
	return self:convert_(value, "font3", 38, 38, padding)	
end

function NumberData:font4(value, padding)
	return self:convert_(value, "font4", 40, 62, padding)	
end

function NumberData:font5(value, padding)
	return self:convert_(value, "font5", 50, 54, padding)	
end

function NumberData:font6(value, padding)
	return self:convert_(value, "font6", 46, 59, padding)	
end

return NumberData 
