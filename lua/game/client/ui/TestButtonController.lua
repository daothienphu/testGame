local BaseUIController = require("base.ui.BaseUIController")
---@class TestButtonController
local TestButtonController = class("TestButtonController", BaseUIController)
local petManager = require("game.client.manager.ClientPetManager")

function TestButtonController:create()
    local base = TestButtonController.new()
    return base
end

function TestButtonController:ctor()
    Debug:Log( "TestButtonController:ctor()")
end

function TestButtonController:initUIComponents()
    --Debug:Log( "TestButtonController:initUIComponents()"
    --, "self: ", self.__name
    --, "uiName: ", self.uiName
    --, "uiRoot: ", self.uiRoot
    --)
    
    self.btn = self.uiRoot.testBtn
    self.btn.onMouseClick = Lib.handler(self, self.onBtnClicked)
end

function TestButtonController:onBtnClicked()
    --Debug:Log( "TestButtonController:onBtnClicked()"
    --, "self: ", self.__name
    --, "uiName: ", self.uiName
    --, "uiRoot: ", self.uiRoot
    --)
    petManager:EquipPet("Dog")
end

return TestButtonController