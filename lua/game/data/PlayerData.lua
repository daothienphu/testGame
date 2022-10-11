local BasePlayerData = require("base.player.BasePlayerData")

---@class PlayerData: BasePlayerData
local PlayerData = class("PlayerData", BasePlayerData)
function PlayerData:ctor()
    self.super:ctor()
    Debug:Log( "PlayerData:ctor()"
    , "self: ", tostring(self)
      )
    self.DATA_KEY = {
        [Define.PLAYER_ATTRIBUTE_TYPE.STRENGTH] = Define.GAME_DATA.PLAYER_DATA.DATA.STRENGTH.key,
        [Define.PLAYER_ATTRIBUTE_TYPE.CHAKRA] = Define.GAME_DATA.PLAYER_DATA.DATA.CHAKRA.key,
        [Define.PLAYER_ATTRIBUTE_TYPE.JUMP] = Define.GAME_DATA.PLAYER_DATA.DATA.JUMP.key,
        [Define.PLAYER_ATTRIBUTE_TYPE.SPEED] = Define.GAME_DATA.PLAYER_DATA.DATA.SPEED.key,
    }
    if (World.isClient) then
        Lib.subscribeGameDataChange(Define.GAME_DATA.PLAYER_DATA.KEY, Lib.handler(self, self.onChangeData))
    end
end

function PlayerData:onChangeData(data)
    Debug:Log( "ClickDisplayUIController:onChangeAttribute()"
    , "data: ", data
    )
    if (Me.platformUserId ~= data.userId) then
        return
    end

    for attributeType, dataKey in pairs(self.DATA_KEY) do
        if (data.key == dataKey) then
            Lib.emitEvent(Define.GAME_EVENT.PLAYER_ATTRIBUTE_CHANGE, {
                attributeType = attributeType,
                value = data.value,
                prevValue = data.prevValue,
                syncType = data.syncType
            })
        end
    end
end

function PlayerData:increaseAttribute(attributeType, value)
    local dataKey = self.DATA_KEY[attributeType]
    local maxValue = 10000 -- TODO: Get max Value

    local valueBefore = self:getValue(dataKey)
    local valueAfter = math.min(valueBefore + value, maxValue)
    Debug:Log( "PlayerData:increaseAttribute()"
    , ", dataKey: ", dataKey
    , ", attributeType: ", attributeType
    , ", value: ", value
    , ", maxValue: ", maxValue
    , ", valueBefore: ", valueBefore
    , ", valueAfter: ", valueAfter
    )
    self:setValue(dataKey, valueAfter)
end

function PlayerData:getAttribute(attributeType)
    local dataKey = self.DATA_KEY[attributeType]
    self:getValue(dataKey)
end

function PlayerData:setAttribute(attributeType, value)
    local dataKey = self.DATA_KEY[attributeType]
    self:setValue(dataKey, value)
end

function PlayerData:create()
    local base = PlayerData.new()
    return base
end

return PlayerData