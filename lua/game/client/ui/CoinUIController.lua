local BaseUIController = require("base.ui.BaseUIController")
---@class CoinUIController
local CoinUIController = class("CoinUIController", BaseUIController)

function CoinUIController:create()
    local base = CoinUIController.new()
    return base
end

function CoinUIController:ctor()
    Debug:Log( "CoinUIController:ctor()")
end

function CoinUIController:initUIComponents()

    ---@type CEGUIStaticText
    self.txtDebug = self.uiRoot.txtDebug
    
    ---@type CEGUIButton
    self.btnDebug1 = self.uiRoot.btnDebug1
    
    self.btnDebug1.onMouseClick = Lib.handler(self, self.onBtnDebug1Clicked)
end




return CoinUIController