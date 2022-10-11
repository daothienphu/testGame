local BaseManager = require("base.manager.BaseManager")
local PetManagerServer = require("game.server.manager.ServerPetManager")
---@class ServerLogicManager: BaseManager
local ServerLogicManager = class("ServerLogicManager", BaseManager)

function ServerLogicManager:create()  
    local base = ServerLogicManager.new()
    return base
end

function ServerLogicManager:ctor()   
    Debug:Log( "ServerLogicManager:ctor()")
end

function ServerLogicManager:init()
    self:baseInit()
    Debug:Log( "ServerLogicManager:init()")
    self.plants = {}
    Lib.subscribeEvent(Define.ENTITY_MANAGER_EVENTS.ENTITY_ENTER, Lib.handler(self, self.onEntityEnter))
    Lib.subscribeEvent(Define.ENTITY_MANAGER_EVENTS.ENTITY_DESTROY, Lib.handler(self, self.onEntityDestroy))
end

function ServerLogicManager:beginGame()
    Debug:Log( "ServerLogicManager:beginGame()")
    PackageHandlers.sendServerHandlerToAll(Define.GAME_PACKET_TYPE.SERVER_START_GAME)
end

---on Entity Enter
---@param entityController BaseEntityController
function ServerLogicManager:onEntityEnter(entityController)
    if (entityController == nil) then
        return
    end
    local entity = entityController:getEntity()
    Debug:Log( "ServerLogicManager:onEntityEnter()"
    ,"objID: ", entityController.objID
    ,"entityType: ", entityController.entityType
    ,"entity: ", tostring(entity)
    )
    if (entity == nil) then
        return
    end

    -- TODO

end

---on Entity Destroy
---@param entityController BaseEntityController
function ServerLogicManager:onEntityDestroy(entityController)
    if (entityController == nil) then
        return
    end
    local entity = entityController:getEntity()
    Debug:Log( "ServerLogicManager:onEntityDestroy()"
    ,"objID: ", entityController.objID
    ,"entityType: ", entityController.entityType
    ,"entity: ", entity
    )
    if (entity == nil) then
        return
    end

    -- TODO

end

return ServerLogicManager