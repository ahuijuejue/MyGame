
local MatchWord = class("MatchWord")

function MatchWord:ctor()
	local cfg = GameConfig["ShieldingWords"] 
	self.word = table.keys(cfg)
end 

function MatchWord:format(input)
	local str = input 
	for i,v in ipairs(self.word) do
		str = string.gsub(str, v, "!@#$")
	end

	return str 
end

function MatchWord:check(input)
	local str = input 
	for i,v in ipairs(self.word) do
		local _, index = string.gsub(str, v, "!@#$")
		if index > 0 then 
			return false 
		end 
	end

	return true 
end

return MatchWord 
