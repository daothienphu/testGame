require("game.common.Define")
require("game.common.GameDataDefine")
require("game.common.PacketDefine")

if (World.isClient) then
    require("game.client.common.Global")
    require("game.client.common.UIDefine")
else
    require("game.server.common.Global")
end