local ClientPlayerController = class("ClientPlayerController")

function ClientPlayerController:create()  
    local base = ClientPlayerController.new()
    return base
end

function ClientPlayerController:ctor()   
    Debug:Log( "ClientPlayerController:ctor()")
end

function ClientPlayerController:init()
    Debug:Log( "ClientPlayerController:init()")
    Lib.subscribeEvent(Event.EVENT_UPDATE_JUMP_PROGRESS, Lib.handler(self, self.onUpdateJumpProgress))
end

function ClientPlayerController:onUpdateJumpProgress(tb)
    Debug:Log( "ClientPlayerController:onUpdateJumpProgress()"
            , "tb: ", tb
    )
end

function ClientPlayerController:onServerStartGame()
    Debug:Log( "ClientPlayerController:onStartGame()")

end

return ClientPlayerController