---@class BaseUIController
local BaseUIController = class("BaseUIController")
function BaseUIController:ctor()
    Debug:Log( "BaseUIController:ctor()")
    self.uiName = nil
    self.uiRoot = nil
end

function BaseUIController:init(uiName)
    Debug:Log( "BaseUIController:init()"
        , "self: ", self
        , "uiName: ", uiName
    )
    self.uiName = uiName

    ---@type UI
    self.uiRoot = nil

    -- Update tick trigger
    if (self.onUpdate ~= nil) then
        self.updateEventIndex = Lib.subscribeEvent(Define.BASE_EVENT.GAME_UPDATE_TICK, Lib.handler(self, self.onUpdate))
    end

    Debug:Log( "BaseUIController:init() finish"
    , "self: ", self.__name
    , "uiName: ", self.uiName
    , "uiRoot: ", self.uiRoot
    )
end

function BaseUIController:openWindow()
    Debug:Log( "BaseUIController:baseOpenWindow()"
    , "self: ", self.__name
    , "uiName: ", self.uiName
    , "uiRoot: ", self.uiRoot
    )
    if (self.uiRoot) then
        return
    end
    self.uiRoot = UI:openWindow(self.uiName)

    if (self.initUIComponents) then
        self:initUIComponents()
    end
end

function BaseUIController:closeWindow()
    Debug:Log( "BaseUIController:closeWindow()"
    , "self: ", self.__name
    , "uiName: ", self.uiName
    , "uiRoot: ", self.uiRoot
    )
    if (not self.uiRoot) then
        return
    end
    UI:closeWindow(self.uiName)
    self.uiRoot = nil

    -- Unsubscribe all event
    if (self.updateEventIndex) then
        Lib.unsubscribeEvent(Define.BASE_EVENT.GAME_UPDATE_TICK, self.updateEventIndex)
    end
end

function BaseUIController:setVisible(visible)
    Debug:Log( "BaseUIController:setVisible()"
    , "self: ", self.__name
    , "uiName: ", self.uiName
    , "visible: ", visible
    , "uiRoot: ", self.uiRoot
    )
    if (not self.uiRoot) then
        return
    end
    self.uiRoot:setVisible(visible)
end

function BaseUIController:isOpenWindow()
    return UI:isOpenWindow(self.uiName)
end

function BaseUIController:create()
    local base = BaseUIController.new()
    return base
end

return BaseUIController