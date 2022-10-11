local BaseManager = require("base.manager.BaseManager")

---@class EntityManager: BaseManager
local EntityManager = class("EntityManager", BaseManager)
function EntityManager:ctor()
end

function EntityManager:init()
    self:baseInit()
    Debug:Log("EntityManager:init()")
    self.objectCreatorMap = {}
    self.objectControllers = {}
    self.objectCounts = {}
    self.totalObjectCount = 0
end

    ---Create Entity & Entity Controller
---@param createParam table
---@return Entity, BaseEntityController objectEntity, objectController
---@return
function EntityManager:createObject(createParam)
    Debug:Log( "EntityManager:createObject()"
      , "createParam: ", createParam
      )
    local entityType = createParam.cfgName
    ---@type Entity
    local objectEntity
    ---@type BaseEntityController
    local objectController

    -- Create object by type
    if (self.objectCreatorMap[entityType] ~= nil) then
        --TODO: Create object by type
        objectEntity = EntityServer.Create(createParam)
        objectController = self:getObjectController(entityType, objectEntity.objID)
    else
        --TODO: log error
        Debug:LogError("EntityManager:createObject() handler not found!"
            , "entityType: ", entityType
            , "createParam: ", createParam
            )
    end

    return objectEntity, objectController
end

function EntityManager:getObjectControllers(entityType)
    return self.objectControllers[entityType]
end

---get Object Controller
---@param entityType string
---@param objID number
---@return BaseEntityController objectController
function EntityManager:getObjectController(entityType, objID)
    if (self.objectControllers[entityType] ~= nil) then
        return self.objectControllers[entityType][objID]
    end
    return nil
end

---get Object Controller
---@param entity Entity
---@return BaseEntityController objectController
function EntityManager:getObjectControllerByEntity(entity)
    local entityCfg = entity:cfg()
    local entityType = entityCfg.fullName
    local objID = entity.objID
    return self:getObjectController(entityType, objID)
end

function EntityManager:removeObjectController(entityType, objID)
    Debug:Log( "EntityManager:removeObjectController()"
    , "entityType: ", entityType
    , "objID: ", objID
    )
    if (self.objectControllers[entityType] ~= nil) then
        self.objectControllers[entityType][objID] = nil
    end
end

function EntityManager:addObjectController(entityType, controllerName)
    Debug:Log( "EntityManager:addObjectController()"
      , "entityType: ", entityType
      , "controllerName: ", controllerName.__name
      )
    self.objectCreatorMap[entityType] = controllerName

    local entityCfg = Entity.GetCfg(entityType)
    Trigger.RegisterHandler(entityCfg, Define.ENTITY_EVENTS.ENTITY_ENTER, Lib.handler(self, self.onEntityEnter))
    Trigger.RegisterHandler(entityCfg, Define.ENTITY_EVENTS.ENTITY_LEAVE, Lib.handler(self, self.onEntityLeave))
    Trigger.RegisterHandler(entityCfg, Define.ENTITY_EVENTS.ENTITY_DIE, Lib.handler(self, self.onEntityDie))
    Trigger.RegisterHandler(entityCfg, Define.ENTITY_EVENTS.JOIN_TEAM, Lib.handler(self, self.onEntityJoinTeam))
end

function EntityManager:onEntityEnter(context)
    local entity = context.obj1
    local entityName = entity.name
    local entityCfg = entity:cfg()
    local entityType = entityCfg.fullName
    Debug:Log( "EntityManager:onEntityEnter()"
    , "context: ", tostring(context)
    , "entity: ", tostring(entity)
    , "objID: ", entity.objID
    , "entityName: ", entityName
    , "entityCfg: ", tostring(entityCfg)
    , "entityType: ", entityType
    )
    if (self.objectCreatorMap[entityType] == nil) then
        return
    end

    local controllerName = self.objectCreatorMap[entityType]

    --Create object
    ---@type BaseEntityController
    local objectController = controllerName:create(entityCfg, entity)

    if (objectController == nil) then
        return
    end

    --init object
    objectController:init(entity, entityCfg)

    --Add to object map
    if (self.objectControllers[entityType] == nil) then
        self.objectControllers[entityType] = {}
    end

    -- Add object to table
    local objID = objectController.objID
    self.objectControllers[entityType][objID] = objectController

    -- Increase object count
    if (self.objectCounts[entityType] == nil) then
        self.objectCounts[entityType] = 1
    else
        self.objectCounts[entityType] = self.objectCounts[entityType] + 1
    end
    self.totalObjectCount = self.totalObjectCount + 1

    Lib.emitEvent(Define.ENTITY_MANAGER_EVENTS.ENTITY_ENTER, objectController)

    Debug:Log( "EntityManager:onEntityEnter()"
    , "totalObjectCount: ", self.totalObjectCount
    , "objectControllers: ", self.objectControllers
    , "objectCount: ", self.objectCounts[entityType]
    )
end

function EntityManager:onEntityLeave(context)
    local entity = context.obj1
    local entityName = entity.name
    local entityCfg = entity:cfg()
    local entityType = entityCfg.fullName
    Debug:Log( "EntityManager:onEntityLeave()"
    , "context: ", context
    , "entity: ", entity
    , "objID: ", entity.objID
    , "entityName: ", entityName
    , "entityCfg: ", entityCfg
    , "entityType: ", entityType
    )
    self:onEntityDestroy(entityType, entity)
end

function EntityManager:onEntityDie(context)
    local entity = context.obj1
    local entityName = entity.name
    local entityCfg = entity:cfg()
    local entityType = entityCfg.fullName
    Debug:Log( "EntityManager:onEntityDie()"
    , "context: ", context
    , "entity: ", entity
    , "objID: ", entity.objID
    , "entityName: ", entityName
    , "entityCfg: ", entityCfg
    , "entityType: ", entityType
    )
    self:onEntityDestroy(entityType, entity)
end

function EntityManager:onEntityJoinTeam(context)
    local entity = context.obj1
    local entityCfg = entity:cfg()
    local entityType = entityCfg.fullName
    local joinTeam = Game.GetTeam(context.teamId)
    Debug:Log( "EntityManager:onEntityJoinTeam()"
    , "entityType: ", entityType
    , "objID: ", entity.objID
    , "joinTeam: ", joinTeam.id
    )
end

---@private
function EntityManager:onEntityDestroy(entityType, entity)
    Debug:Log( "EntityManager:onEntityDestroy()"
    , "entityType: ", entityType
    , "entity: ", entity
    , "objID: ", entity.objID
    )
    local entityController = self:getObjectController(entityType, entity.objID)
    if (entityController ~= nil and entityController.onDestroy ~= nil) then
        entityController:onDestroy()
    end
    self:removeObjectController(entityType, entity.objID)

    Lib.emitEvent(Define.ENTITY_MANAGER_EVENTS.ENTITY_DESTROY, entityController)
end

function EntityManager:create()  
    local base = EntityManager.new()
    return base
end

return EntityManager