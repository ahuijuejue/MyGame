
module("CommonSound", package.seeall) 

-- 声效
function sound(fileName)
	AudioManage.playSound(fileName)
end

-- 获得领取奖励
function award()
	sound("Award.mp3")
end

-- 点击返回
function back()
	sound("Back.mp3")
end

-- 点击
function click()
	sound("Click.mp3")
end

-- 点击关闭
function close()
	sound("Close.mp3")
end
