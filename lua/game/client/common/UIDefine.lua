Define.GAME_UI_DEFINE = {
    DEBUG_UI = {
        KEY = "DEBUG_UI",
        CLASS = require("game.client.ui.DebugUIController"),
        UI_ROOT = "UI/DebugUI"
    },
    CLICK_DISPLAY_UI = {
        KEY = "CLICK_DISPLAY_UI",
        CLASS = require("game.client.ui.ClickDisplayUIController"),
        UI_ROOT = "UI/ClickDisplayUI"
    },
    POPUP_UI = {
        KEY = "POPUP_UI",
        CLASS = require("game.client.ui.PopupUIController"),
        UI_ROOT = "UI/PopupUI"
    },
    TEST_UI = {
        KEY = "TEST_UI",
        CLASS = require("game.client.ui.TestButtonController"),
        UI_ROOT = "UI/TestUI"
    }
}