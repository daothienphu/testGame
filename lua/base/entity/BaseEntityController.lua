---@class BaseEntityController
---@field public objID int
---@field public entityCfg table
---@field public entityType string
---@field private _objectHandlerMap table
---@field private _entityEvents table
---@field setObjectHandler fun(self: BaseEntityController, name: string, handler: func): void
---@field getEntity fun(self: BaseEntityController): Entity
---@field init fun(self: BaseEntityController, entity: Entity, entityCfg: table): Entity
---@field onDestroy fun(self: BaseEntityController): void
---@field onEnter fun(self: BaseEntityController): void
---@field onUpdate fun(self: BaseEntityController): void
local BaseEntityController = class("BaseEntityController")
function BaseEntityController:ctor()
    self._objectHandlerMap = {}
    
    Debug:Log( "BaseEntityController:ctor()"
      , "objID: ", self.objID
      , "entityCfg: ", self.entityCfg
      )    
      
    self:registerHandler()
end

function BaseEntityController:init(entity, entityCfg)
    self.entityCfg = entityCfg
    self.objID = entity.objID
    self.entityType = entityCfg.fullName
    Debug:Log( "BaseEntityController:init()"
        , "objID: ", self.objID
        , "self.onUpdate: ", self.onUpdate
        , "self.onObjectEnter: ", self.onObjectEnter
    )

    if (self.onEnter ~= nil) then
        --self:setObjectHandler("ENTITY_ENTER", Lib.handler(self, self.onObjectEnter))
        self:onEnter()
    end

    -- Update tick trigger
    if (self.onUpdate ~= nil) then
        Lib.subscribeEvent(Define.BASE_EVENT.GAME_UPDATE_TICK, Lib.handler(self, self.onUpdate))
    end
end

---@private
function BaseEntityController:registerHandler()
    for eventEnum, eventName in ipairs(Define.ENTITY_EVENTS) do
        if (self._objectHandlerMap[eventName] == nil) then
            return
        end

        -- Add trigger
        Trigger.RegisterHandler(self.entityCfg, eventName, function(context)
            Debug:Log( "BaseEntityController:receiveHandler ", eventName
            , "objID: ", self.objID
            , "context.objID: ", context.obj1.objID
            )
            if (context.obj1.objID ~= self.objID) then
                return
            end

            self._objectHandlerMap[eventName](context)
        end)
    end
end

---setObjectHandler
---@param name string
---@param handler function
---@private
function BaseEntityController:setObjectHandler(name, handler)
    Debug:Log( "BaseEntityController:setObjectHandler"
        , "name: ", name
        , "handler: ", handler
    )
    self._objectHandlerMap[name] = handler;
end

function BaseEntityController:getEntity()
    return World.CurWorld:getEntity(self.objID)
end

return BaseEntityController