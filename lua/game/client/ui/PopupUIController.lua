local BaseUIController = require("base.ui.BaseUIController")
---@class PopupUIController
local PopupUIController = class("PopupUIController", BaseUIController)

function PopupUIController:create()
    local base = PopupUIController.new()
    return base
end

function PopupUIController:ctor()
    Debug:Log( "PopupUIController:ctor()")
end

function PopupUIController:initUIComponents()
    Debug:Log( "PopupUIController:initUIComponents()"
    , "self: ", self.__name
    , "uiName: ", self.uiName
    , "uiRoot: ", self.uiRoot
    )

    ---@type CEGUIButton
    self.btnClose = self.uiRoot.btnClose

    self.btnClose.onMouseClick = Lib.handler(self, self.onBtnCloseClicked)
end

function PopupUIController:onBtnCloseClicked()
    Debug:Log( "PopupUIController:onBtnCloseClicked()"
    , "self: ", self.__name
    , "uiName: ", self.uiName
    , "uiRoot: ", self.uiRoot
    )
    self:closeWindow()
end

return PopupUIController