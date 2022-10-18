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

local coinDisplay

function CoinUIController:initUIComponents()
    Debug:Log("bbbbbbbbbbbbbb")

    coinDisplay = self.uiRoot.Image.Coin
    Debug:Log(coinDisplay)
end

PackageHandlers:Receive(Define.COIN_EVENT.DISPLAY_COIN, function(player, package)
    Debug:Log("aaaaaaaaaaaaaaaaaa")
    coinDisplay.Text = "$"..package.coin
end)

return CoinUIController