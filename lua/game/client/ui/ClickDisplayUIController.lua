local BaseUIController = require("base.ui.BaseUIController")
---@class ClickDisplayUIController
local ClickDisplayUIController = class("ClickDisplayUIController", BaseUIController)

function ClickDisplayUIController:create()
    local base = ClickDisplayUIController.new()
    return base
end

function ClickDisplayUIController:ctor()
    Debug:Log( "ClickDisplayUIController:ctor()")
end

function ClickDisplayUIController:initUIComponents()
    Debug:Log( "ClickDisplayUIController:initUIComponents()"
    , "self: ", self.__name
    , "uiName: ", self.uiName
    , "uiRoot: ", self.uiRoot
    )
    self.widAddStrength = self.uiRoot.widAddStrength
    self.widAddChakra = self.uiRoot.widAddChakra
    self.widAddJump = self.uiRoot.widAddJump
    self.widAddSpeed = self.uiRoot.widAddSpeed
    self.addAttributeMap = {
        [Define.PLAYER_ATTRIBUTE_TYPE.STRENGTH] = self.widAddStrength,
        [Define.PLAYER_ATTRIBUTE_TYPE.CHAKRA] = self.widAddChakra,
        [Define.PLAYER_ATTRIBUTE_TYPE.JUMP] = self.widAddJump,
        [Define.PLAYER_ATTRIBUTE_TYPE.SPEED] = self.widAddSpeed,
    }


    Lib.subscribeEvent(Define.GAME_EVENT.PLAYER_ATTRIBUTE_CHANGE, Lib.handler(self, self.onChangeAttribute))
end

function ClickDisplayUIController:onChangeAttribute(data)
    Debug:Log( "ClickDisplayUIController:onChangeAttribute()"
    , "data: ", data
    )
    if (data.syncType == Define.SYNC_GAME_DATA_TYPE.UPDATE) then
        local changeValue = data.value - data.prevValue
        local widgetAdd = self.addAttributeMap[data.attributeType]
        if (widgetAdd
                and changeValue > 0
                and data.syncType == Define.SYNC_GAME_DATA_TYPE.UPDATE) then
            local cloneWidget = widgetAdd:clone()
            cloneWidget.txtValue:setText("+"..changeValue)
            cloneWidget:setVisible(true)
            local randomPos = {
                x = math.random(20, 80),
                y = math.random(10, 80)
            }
            cloneWidget:setPosition(UDim2.new(randomPos.x / 100, 0, randomPos.y / 100, 0))
            self.uiRoot:addChild(cloneWidget:getWindow())
            World.Timer(
                    20,
                    function()
                        cloneWidget:destroy()
                        return false
                    end
            )
        end
    end
end

return ClickDisplayUIController