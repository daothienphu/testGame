if (Global.ClientLogicManager == nil) then
    Global.ClientLogicManager = require("game.client.manager.ClientLogicManager"):create()
end

if (Global.ClientPacketHandler == nil) then
    Global.ClientPacketHandler = require("game.client.manager.ClientPacketHandler"):create()
end