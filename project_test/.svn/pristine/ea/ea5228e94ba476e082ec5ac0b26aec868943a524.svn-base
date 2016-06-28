local EncryptValue = class("EncryptValue")

function EncryptValue:ctor()
	self.mValue = 0
	self.mEncryptKey = 0
end

function EncryptValue:getValue()
	return bit.bxor(self.mValue,self.mEncryptKey)
end

function EncryptValue:setValue(value)
	newrandomseed()
	self.mEncryptKey = math.random(1,99999)
	self.mValue = bit.bxor(value,self.mEncryptKey)
end

function EncryptValue:offset(value)
	self:setValue(self:getValue()+value)
end

return EncryptValue