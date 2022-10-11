local ClientPacketHandler = class("ClientPacketHandler")

function ClientPacketHandler:create()
    local base = ClientPacketHandler.new()
    return base
end

function ClientPacketHandler:ctor()
    Debug:Log( "ClientPacketHandler:ctor()")
end

function ClientPacketHandler:init()
    Debug:Log( "ClientPacketHandler:init()")
    PackageHandlers:Receive(Define.GAME_PACKET_TYPE.SERVER_START_GAME, Lib.handler(self, self.onServerStartGame))
end

function ClientPacketHandler:onServerStartGame()
    Debug:Log( "ClientPacketHandler:onStartGame()")

end

return ClientPacketHandler