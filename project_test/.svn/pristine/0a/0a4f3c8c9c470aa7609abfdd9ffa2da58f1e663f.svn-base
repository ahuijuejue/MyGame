if LOAD_UPDATE then 
	local UpdateScene = require("update.UpdateScene")
	local scene = UpdateScene.new()
	display.replaceScene(scene)
else
	if not app then
		require("app.MyApp").new():run()
	end
	app:enterToScene("StartScene")
end