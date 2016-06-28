module("ResManage", package.seeall)

resList = {}
imageList = {}

-- 纹理
function load(plist, image)
    if resList[plist] then
        resList[plist].ref = resList[plist].ref + 1
        return
    end

    resList[plist] = { ref = 1, plist = plist, image = image }
    display.addSpriteFrames(plist, image)
end

function remove(plist, image)
    if resList[plist] then
        resList[plist].ref = resList[plist].ref - 1

        if resList[plist].ref <= 0 then
            display.removeSpriteFramesWithFile(plist, image)
            resList[plist] = nil
        end

        return
    end
    display.removeSpriteFramesWithFile(plist, image)
end

function loadGaf(gafName)
    if resList[gafName] then
        resList[gafName].ref = resList[gafName].ref + 1
    end
    resList[gafName] = {ref = 1, gaf = gaf.GAFAsset:create(gafName)} 
end

function removeGaf(gafName)
    if resList[gafName] then
        resList[gafName].ref = resList[gafName].ref - 1

        if resList[gafName].ref <= 0 then
            resList[gafName] = nil
        end
    end
end

function getGafAssetByName(gafName)
    if resList[gafName] then
        return resList[gafName].gaf
    end
end

-- 独立图片
function loadImage(image)
    if imageList[image] then
        imageList[image].ref = imageList[image].ref + 1
        return
    end
    imageList[image] = { ref = 1, image = image }
    local sharedTextureCache = cc.Director:getInstance():getTextureCache()
    sharedTextureCache:addImage(image)
end

function removeImage(image)
    if imageList[image] then
        imageList[image].ref = imageList[image].ref - 1

        if imageList[image].ref <= 0 then
            local sharedTextureCache = cc.Director:getInstance():getTextureCache()
            sharedTextureCache:removeTextureForKey(image)
            imageList[image] = nil
        end

        return
    end
    sharedTextureCache:removeTextureForKey(image)
end
