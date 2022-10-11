---@class BasePlayerController
---@field getDataController fun(self: BasePlayerController): PlayerDataController
local BasePlayerController = class("BasePlayerController")
function BasePlayerController:ctor()
    Debug:Log("BasePlayerController:ctor()")
end

function BasePlayerController:init(userId, dataConfigTables)
    Debug:Log("BasePlayerController:init()")
    self.userId = userId

    -- Init data controller for player
    ---@type PlayerDataController
    self.playerDataController = require("base.player.PlayerDataController"):create(self.userId, dataConfigTables)
end

---get data controller for player
---@return PlayerDataController
function BasePlayerController:getDataController()
    return self.playerDataController
end

function BasePlayerController:create(userId, dataConfigTables)
    local base = BasePlayerController.new()
    base:init(userId, dataConfigTables)
    return base
end

return BasePlayerController