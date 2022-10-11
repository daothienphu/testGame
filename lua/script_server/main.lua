require("base.CommonHeader")
require("game.CommonHeader")
Debug:clearLogFiles()
Debug:Log( 'Main:Server Begin')
Trigger.RegisterHandler(World.cfg, "GAME_START", function()
    Debug:Log( "Main:Server", "GAME_START")

    --Start game
    ServerLogicManager:beginGame()
end)

Trigger.RegisterHandler(World.cfg, "GAME_INIT", function()
    Debug:Log( 'Main:Server GAME_INIT')
    --Init manager
    Global.GameManager:init()
    Global.EntityManager:init()
    Global.PlayerManager:init(require("game.server.player.PlayerController"), Define.GAME_DATA)

    --Init server manager

end)