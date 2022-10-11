---@class GameManager
local GameManager = class("GameManager")
function GameManager:ctor()
end

function GameManager:init()
    Debug:Log( "GameManager:init()")
    if (not World.isClient) then
        Trigger.addHandler(Entity.GetCfg(Define.PLAYER_ENTITY), Define.ENTITY_EVENTS.ENTITY_ENTER, Lib.handler(self, self.onPlayerEnter))
    end
    self.updateTimer = World.Timer(0, Lib.handler(self, self.onUpdate))
end

function GameManager:onPlayerEnter(context)
    Debug:Log( "GameManager:onPlayerEnter()"
        , "player: ", context.obj1
    )
    if (not World.isClient) then
        PackageHandlers:SendToClient(context.obj1, Define.BASE_PACKET_TYPE.PLAYER_ENTER_MAP)
    end
end

function GameManager:onUpdate()
    Lib.emitEvent(Define.BASE_EVENT.GAME_UPDATE_TICK)
    return Define.UPDATE_INTERVAL
end

function GameManager:create()  
    local base = GameManager.new()
    return base
end

return GameManager