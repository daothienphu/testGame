local BaseUIController = require("base.ui.BaseUIController")
---@class DebugUIController
local DebugUIController = class("DebugUIController", BaseUIController)

function DebugUIController:create()
    local base = DebugUIController.new()
    return base
end

function DebugUIController:ctor()
    Debug:Log( "DebugUIController:ctor()")
end

function DebugUIController:initUIComponents()
    Debug:Log( "DebugUIController:initUIComponents()"
    , "self: ", self.__name
    , "uiName: ", self.uiName
    , "uiRoot: ", self.uiRoot
    )

    ---@type CEGUIStaticText
    self.txtDebug = self.uiRoot.txtDebug

    ---@type CEGUIButton
    self.btnDebug1 = self.uiRoot.btnDebug1


    self.btnDebug1.onMouseClick = Lib.handler(self, self.onBtnDebug1Clicked)
end

function DebugUIController:onBtnDebug1Clicked()
    Debug:Log( "DebugUIController:onBtnDebug1Clicked()"
    , "self: ", self.__name
    , "uiName: ", self.uiName
    , "uiRoot: ", self.uiRoot
    )
    print("hahahahahaha")
    Global.GameUIManager:openWindow(Define.GAME_UI_DEFINE.POPUP_UI.KEY)
end

function DebugUIController:setDebugText(debugText)
    if (not self:isOpenWindow()) then
        return
    end
    self.txtDebug:setText(debugText)
end

return DebugUIController