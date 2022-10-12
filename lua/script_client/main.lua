require("base.CommonHeader")
require("game.CommonHeader")
Debug:clearLogFiles()
Debug:Log('Main:Client Begin')

PackageHandlers:Receive(Define.BASE_PACKET_TYPE.PLAYER_ENTER_MAP, function()
    Debug:Log('Main:Client Init')
    -- Init manager
    Global.GameManager:init()
    Global.EntityManager:init()
    Global.PlayerManager:init(require("game.server.player.PlayerController"), Define.GAME_DATA)

    -- Init client manager
    Global.GameUIManager:init(Define.GAME_UI_DEFINE)
    Global.ClientPacketHandler:init()
    Global.ClientLogicManager:init()

    -- Show global UI
    Global.GameUIManager:openWindow(Define.GAME_UI_DEFINE.CLICK_DISPLAY_UI.KEY)
    Global.GameUIManager:openWindow(Define.GAME_UI_DEFINE.DEBUG_UI.KEY)
    --Global.GameUIManager:openWindow(Define.GAME_UI_DEFINE.TEST_UI.KEY)
    Global.GameUIManager:openWindow(Define.GAME_UI_DEFINE.INVENTORY_UI.KEY)

    --Begin game
    Global.ClientLogicManager:beginGame()
end)
