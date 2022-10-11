local BaseManager = require("base.manager.BaseManager")

---@class PlayerManager: BaseManager
local PlayerManager = class("PlayerManager", BaseManager)
function PlayerManager:ctor()
    Debug:Log("PlayerManager:ctor()")
end

function PlayerManager:init(playerControllerClass, dataConfigTables)
    self:baseInit()
    Debug:Log("PlayerManager:init()")
    self.playerControllers = {}
    self.playerControllerClass = playerControllerClass
    self.dataConfigTables = dataConfigTables

    for entityEvent, entityFunction in pairs(Define.PLAYER_CONTROLLER_FUNCTIONS) do
        if (self[entityFunction]) then
            Debug:Log("PlayerManager:init()"
                  , "entityEvent: ", entityEvent
                  , "entityFunction: ", entityFunction
                  , "self[entityFunction]: ", self[entityFunction]
            )
            Trigger.addHandler(Entity.GetCfg(Define.PLAYER_ENTITY), entityEvent, function(eventData)
               self:onEntityEvent(entityFunction, eventData)
            end)
        end
    end
end

function PlayerManager:onEntityEvent(entityFunction, eventData)
    Debug:Log("PlayerManager:onEntityEvent()"
    , "entityFunction: ", entityFunction
    , "eventData: ", eventData
    )
    ---@type EntityServerPlayer
    local player = tb.obj1
    if (not player) then
        return
    end

    local playerController = self:getPlayer(player.platformUserId)
    if (playerController[entityFunction]) then
        playerController[entityFunction](eventData)
    end
end

function PlayerManager:getPlayer(userId)
    local playerController = self.playerControllers[userId]
    if (not playerController) then
        -- Create player controller
        playerController = self.playerControllerClass:create(userId, self.dataConfigTables)

        self.playerControllers[userId] = playerController
    end

    return playerController
end

if (World.isClient) then
    function PlayerManager:getCurrentPlayer()
        return self:getPlayer(Me.platformUserId)
    end
end

function PlayerManager:create()  
    local base = PlayerManager.new()
    return base
end

return PlayerManager