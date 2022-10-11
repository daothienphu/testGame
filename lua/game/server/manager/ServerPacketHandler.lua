local ServerPacketHandler = class("ServerPacketHandler")

function ServerPacketHandler:create()  
    local base = ServerPacketHandler.new()
    return base
end

function ServerPacketHandler:ctor()   
    Debug:Log( "ServerPacketHandler:ctor()")
end

function ServerPacketHandler:init()
    Debug:Log( "ServerPacketHandler:init()")
    PackageHandlers.registerServerHandler(Define.GAME_PACKET_TYPE.INCREASE_VALUE_1, Lib.handler(self, self.onIncreaseValue1))
end

function ServerPacketHandler:onIncreaseValue1(player, packet)

end

return ServerPacketHandler