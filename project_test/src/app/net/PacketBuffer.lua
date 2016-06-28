--[[
PacketBuffer receive the byte stream and analyze them, then pack them into a message packet.
The method name, message metedata and message body will be splited, and return to invoker.
@see https://github.com/zrong/as3/blob/master/src/org/zengrong/net/PacketBuffer.as
@author zrong(zengrong.net)
Creation: 2013-11-14
]]

local PacketBuffer = class("PacketBuffer")
cc.utils = require("framework.cc.utils.init")
-- local Protocol = require("net.Protocol")

PacketBuffer.ENDIAN = cc.utils.ByteArrayVarint.ENDIAN_BIG

PacketBuffer.PACKET_MAX_LEN = 2100000000

PacketBuffer.BODY_LEN = 4	-- length of message body, int


function PacketBuffer._createBody(__body)
	--print("getBody, body:", unpack(__body))
	local __buf = PacketBuffer.getBaseBA()
	local str=json.encode(__body) 
	-- print("json:", str)
	local __jsonB = PacketBuffer.getBaseBA()
	__jsonB:writeString(str)
	local jsonLen = __jsonB:getLen()
	-- print("_len:", jsonLen)

	__buf:writeInt(jsonLen)
	__buf:writeBytes(__jsonB)
	
	return __buf
end

function PacketBuffer._parseBody(__buf, __len)
	local lenth = __buf:readInt()
	local str = __buf:readBuf(lenth)	
	return json.decode(str)	
end

function PacketBuffer.getBaseBA()
	return cc.utils.ByteArrayVarint.new(PacketBuffer.ENDIAN)
end

--- Create a formated packet that to send server
-- @param __msgDef the define of message, a table
-- @param __msgBodyTable the message body with key&value, a table
function PacketBuffer.createPacket(__msgBodyTable)
	local __buf = PacketBuffer.getBaseBA()
	-- local __metaBA = PacketBuffer._createMeta(__msgDef.fmt)
		
	local item = PacketBuffer._createBody(__msgBodyTable)
	local __bodyLen = item:getLen()	
						
	-- print("============len:", __bodyLen)
	
	__buf:writeInt(__bodyLen)	
	__buf:writeBytes(item)
	
	return __buf
end

function PacketBuffer:ctor()
	self:init()
end

function PacketBuffer:init()
	self._buf = PacketBuffer.getBaseBA()
end

--- Get a byte stream and analyze it, return a splited table
-- Generally, the table include a message, but if it receive 2 packets meanwhile, then it includs 2 messages.
function PacketBuffer:parsePackets(__byteString)
	local __msgs = {}
	local __pos = 0
	self._buf:setPos(self._buf:getLen()+1)	
	self._buf:writeBuf(__byteString)
	self._buf:setPos(1)
	-- dump(self._buf:toString(), "aftWrite")	

	local __preLen = PacketBuffer.BODY_LEN
	-- printf("start analyzing... buffer len: %u, available: %u", self._buf:getLen(), self._buf:getAvailable())
	while self._buf:getAvailable() > __preLen do		
		local __bodyLen = self._buf:readInt()	
		local __pos = self._buf:getPos()
		--printf("__bodyLen:%u", __bodyLen)
		-- buffer is not enougth, waiting...
		-- print("pos", __pos, "avalible:", self._buf:getAvailable())
		if self._buf:getAvailable() < __bodyLen then 
			-- restore the position to the head of data, behind while loop, 
			-- we will save this incomplete buffer in a new buffer,
			-- and wait next parsePackets performation.
			printf("received data is not enough, waiting... need %u, get %u", __bodyLen, self._buf:getAvailable())
			-- print("buf:", self._buf:toString())
			self._buf:setPos(self._buf:getPos() - __preLen)
			break 
		end
		if __bodyLen <= PacketBuffer.PACKET_MAX_LEN then			
			local __msg  = PacketBuffer._parseBody(self._buf, __bodyLen)			
			__msgs[#__msgs+1] = __msg
			-- dump(__msg)
			-- printf("after get body position:%u", self._buf:getPos())
		end
			
	end
	-- clear buffer on exhausted
	if self._buf:getAvailable() <= 0 then
		self:init()
	else
		-- some datas in buffer yet, write them to a new blank buffer.
		printf("cache incomplete buff,len: %u, available: %u", self._buf:getLen(), self._buf:getAvailable())
		local __tmp = PacketBuffer.getBaseBA()
		self._buf:readBytes(__tmp, 1, self._buf:getAvailable())
		self._buf = __tmp
		printf("tmp len: %u, availabl: %u", __tmp:getLen(), __tmp:getAvailable())
		-- print("buf:", __tmp:toString())
	end
	-- dump(__msgs)
	return __msgs
end

return PacketBuffer
