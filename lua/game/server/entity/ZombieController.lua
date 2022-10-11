local BaseEntityController = require("base.entity.BaseEntityController")

---@class ZombieController: BaseEntityController
local ZombieController = class("ZombieController", BaseEntityController)
function ZombieController:ctor()
    self.super:ctor()
    self.targetPos = nil
    self.currentTargetObjID = nil
    Debug:Log( "ZombieController:ctor()"
    , "self: ", tostring(self)
    , "entity: ", tostring(self:getEntity())
      , "objID: ", self.objID
      )
end

function ZombieController:setTargetPos(pos)
    Debug:Log( "ZombieController:setTargetPos()"
    , "pos: ", pos
    )
    self.targetPos = pos
end

function ZombieController:detectNextTarget()
    --Reset target
    self.currentTargetObjID = 0

    --Find next target
    local plantControllers = Global.EntityManager:getObjectControllers(Define.GAME_ENTITY_TYPE.PLANT)
    Debug:Log( "ZombieController:detectNextTarget()"
    , "self: ", tostring(self)
    , "entity: ", tostring(self:getEntity())
    , "objID: ", self.objID
    )
    local zombieEntity = self:getEntity()
    local zombiePosition = zombieEntity:getPosition()
    if (plantControllers == nil) then
        return
    end

    ---@type PlantController
    local plantTargetController

    ---@type Vector3
    local plantTargetPosition

    for objID, plantController in pairs(plantControllers) do
        local plantEntity = plantController:getEntity()
        local plantPosition = plantEntity:getPosition()

        Debug:Log( "ZombieController:detectNextTarget()"
        , "objID: ", objID
        , "plantController: ", plantController.objID
        , "plantEntity: ", plantEntity
        , "zombiePosition: ", zombiePosition
        , "plantPosition: ", plantPosition
        )

        --Update plant target
        if (zombiePosition.z == plantPosition.z) then
            if (plantTargetController == nil) then
                plantTargetController = plantController
                plantTargetPosition = plantPosition
            elseif (plantPosition.x > plantTargetPosition.x) then
                plantTargetController = plantController
                plantTargetPosition = plantPosition
            end
        end
    end

    if (plantTargetController ~= nil and plantTargetPosition ~= nil) then
        --Target found: move to target pos
        Debug:Log( "ZombieController:detectNextTarget()"
        , "Target found! "
        , "objID: ", self.objID
        , "plantTargetController objID: ", plantTargetController.objID
        , "plantTargetPosition: ", plantTargetPosition
        )

        self.currentTargetObjID = plantControllers.objID

        local zombieAIController = zombieEntity:getAIControl()

        -- Clear hatred of all entities
        zombieAIController:clearHatred()

        --Set target of Zombie
        zombieAIController:addHatred(plantTargetController.objID, 100, 1)
    else
        --Target not found: Zombie move to farm Pos
        zombieEntity:setAITargetPos(self.targetPos, true)
    end
end

function ZombieController:onEnter()
    Debug:Log( "ZombieController:onEnter()"
    , "self: ", tostring(self)
    , "entity: ", tostring(self:getEntity())
        , "objID: ", self.objID
    )
    local entity = self:getEntity()
    local team = Game.GetTeam(Define.TEAM_ID.ZOMBIE_TEAM, true)
    Game.TryJoinTeamByPlayer(entity, team.id)
end

function ZombieController:onUpdate()
    local zombieEntity = self:getEntity()
    if not zombieEntity or not zombieEntity:isValid() then
        return
    end
end

function ZombieController:create(entityCfg, entity)  
    local base = ZombieController.new(entity, entityCfg)
    return base
end

return ZombieController