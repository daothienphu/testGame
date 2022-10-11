local BaseManager = require("base.manager.BaseManager")

---@class GameUIManager: BaseManager
local GameUIManager = class("GameUIManager", BaseManager)

function GameUIManager:create()  
    local base = GameUIManager.new()
    return base
end

function GameUIManager:ctor()   
    Debug:Log( "GameUIManager:ctor()")
end

function GameUIManager:init(configTables)
    self:baseInit()
    Debug:Log( "GameUIManager:init()")
    self.uiControllers = {}
    self.uiCreatorMap = {}
    self.configTables = configTables
    Debug:Log( "GameUIManager:initGameData()"
    , ", configTables: ", configTables
    )
    for _, uiConfig in pairs(self.configTables) do
        self:addUIConfig(uiConfig.KEY, uiConfig)
    end
end

function GameUIManager:openWindow(uiName)
    Debug:Log( "GameUIManager:openWindow()"
    , "uiName: ", uiName
    )
    local uiController = self:getUI(uiName)
    if (not uiController) then
        return
    end

    -- Show UI
    if (not uiController.openWindow) then
        return nil
    end
    Debug:Log( "GameUIManager:openWindow() open"
    , "uiName: ", uiName
    , "uiController: ", uiController.__name
    )
    uiController:openWindow()
end


function GameUIManager:closeWindow(uiName)
    Debug:Log( "GameUIManager:closeWindow()"
    , "uiName: ", uiName
    )
    local uiController = self:getUI(uiName)
    if (not uiController) then
        return
    end

    if (not uiController.closeWindow) then
        return
    end

    uiController:closeWindow()
    self.uiControllers[uiName] = nil
end

---Get UI controller by UI name
---@param uiName string
---@return BaseUIController
function GameUIManager:getUI(uiName)
    Debug:Log( "GameUIManager:getUI()"
    , "uiName: ", uiName
    )
    ---@type BaseUIController
    local uiController = self.uiControllers[uiName]

    if (not uiController) then
        -- Don't have UI, create if have controller
        local uiConfig = self.uiCreatorMap[uiName]
        if (uiConfig ~= nil) then
            uiController = uiConfig.CLASS:create()
            uiController:init(uiConfig.UI_ROOT)

            -- Add to controller list
            self.uiControllers[uiName] = uiController

            Debug:Log( "GameUIManager:getUI()"
            , "self.uiControllers: ", self.uiControllers
            )
        else
            return nil
        end
    end
    Debug:Log( "GameUIManager:getUI()"
    , "uiName: ", uiName
    , "uiController: ", uiController.__name
    )
    return uiController
end

---@private
function GameUIManager:addUIConfig(uiName, uiConfig)
    Debug:Log( "GameUIManager:addUIConfig()"
    , "uiName: ", uiName
    , "uiConfig: ", uiConfig
    )
    self.uiCreatorMap[uiName] = uiConfig
end

return GameUIManager