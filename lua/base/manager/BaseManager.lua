---@class BaseManager
---@field onUpdate fun(self: BaseManager): void
local BaseManager = class("BaseManager")
function BaseManager:ctor()
end

function BaseManager:baseInit()
    Debug:Log( "BaseManager:baseInit()"
            , "self.onUpdate: ", self.onUpdate
    )

    -- Update tick trigger
    if (self.onUpdate ~= nil) then
        Lib.subscribeEvent(Define.BASE_EVENT.GAME_UPDATE_TICK, Lib.handler(self, self.onUpdate))
    end
end

function BaseManager:create()  
    local base = BaseManager.new()
    return base
end

return BaseManager