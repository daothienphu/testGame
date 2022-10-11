-- Define all game data here
Define.GAME_DATA = {
    PLAYER_DATA = {
        KEY = "PLAYER_DATA",
        CLASS = require("game.data.PlayerData"),
        DATA = {
            STRENGTH_LVL    = { key = "strength_lvl"    , defaultValue = 1, needSync = true , needSave = true },
            CHAKRA_LVL      = { key = "chakra_lvl"      , defaultValue = 1, needSync = true , needSave = true },
            JUMP_LVL        = { key = "jump_lvl"        , defaultValue = 1, needSync = true , needSave = true },
            SPEED_LVL       = { key = "speed_lvl"       , defaultValue = 1, needSync = true , needSave = true },
            STRENGTH        = { key = "strength"        , defaultValue = 1, needSync = true , needSave = true },
            CHAKRA          = { key = "chakra"          , defaultValue = 1, needSync = true , needSave = true },
            JUMP            = { key = "jump"            , defaultValue = 1, needSync = true , needSave = true },
            SPEED           = { key = "speed"           , defaultValue = 1, needSync = true , needSave = true },
        }
    },
}