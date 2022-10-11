if (Global.ServerLogicManager == nil) then
    Global.ServerLogicManager = require("game.server.manager.ServerLogicManager"):create()
end

if (Global.ServerPacketHandler == nil) then
    Global.ServerPacketHandler = require("game.server.manager.ServerPacketHandler"):create()
end