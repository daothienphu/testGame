local BasePlayerController = require("base.player.BasePlayerController")

---@class PlayerController:BasePlayerController
local PlayerController = class("PlayerController", BasePlayerController)

function PlayerController:create()  
    local base = PlayerController.new()
    return base
end

function PlayerController:ctor()   
    Debug:Log( "PlayerController:ctor()")
end

function PlayerController:init()
    Debug:Log( "PlayerController:init()")
end

function PlayerController:onEntityStatusChange(tb)
    if (not tb) then
        return
    end
    local player = tb.obj1
    Debug:Log( "PlayerController:onPlayerChangeStatus()"
            , "tb: ", tb
            , "newState: ", tb.newState
            , "player: ", player.platformUserId
    )

    if (tb.newState == Define.PLAYER_STATE.JUMP) then
        self:onPlayerJump(player)
    end
end

function PlayerController:onPlayerJump(player)
    Debug:Log( "PlayerController:onPlayerChangeStatus()"
    , "platformUserId: ", player.platformUserId
    )
    ---@param data PlayerData
    local playerData = self:getDataController():getGameData(Define.GAME_DATA.PLAYER_DATA.KEY)
    playerData:increaseAttribute(Define.PLAYER_ATTRIBUTE_TYPE.JUMP, 2)
end

function PlayerController:onServerStartGame()
    Debug:Log( "PlayerController:onStartGame()")

end

return PlayerController