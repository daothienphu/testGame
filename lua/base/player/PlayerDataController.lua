---@class PlayerDataController
local PlayerDataController = class("PlayerDataController")
function PlayerDataController:ctor()
    Debug:Log("PlayerDataController:ctor()")
end

function PlayerDataController:init(userId, dataConfigTables)
    self.userId = userId
    self.dataConfigTables = {}
    self.playerData = {}

    self.dataConfigTables = dataConfigTables
    Debug:Log( "PlayerDataController:init()"
    , ", userId: ", self.userId
    , ", dataConfigTables: ", self.dataConfigTables
    )

    for dataType, _ in pairs(self.dataConfigTables) do
        self:getGameData(dataType)
    end
end

function PlayerDataController:loadAllData(callback)
    local currentLoad = 0
    local dataCount = table.count(self.dataConfigTables)
    for dataType, _ in pairs(self.dataConfigTables) do
        ---@type BasePlayerData
        local playerData = self:getGameData(dataType)
        playerData:loadDB(function()
            currentLoad = currentLoad + 1
            if (currentLoad >= dataCount) then
                callback()
            end
        end)
    end
end

---get game data of user
---@param dataType string
---@return BasePlayerData
function PlayerDataController:getGameData(dataType)
    Debug:Log( "PlayerDataController:getGameData()"
    , ", userId: ", self.userId
    , ", dataType: ", dataType
    , ", self.playerData: ", self.playerData
    )
    ---@type BasePlayerData
    local playerData = self.playerData[dataType]
    if (playerData == nil) then
        -- Create & load data
        local configTable = self.dataConfigTables[dataType]
        if (configTable == nil) then
            Debug:LogError("PlayerDataController:getGameData"
                    , ", configTable not found!"
                    , ", userId: ", self.userId
                    , ", dataType: ", dataType
            )
            return
        end

        local key = configTable[Define.GAME_DATA_CONFIG_KEY.KEY]
        local controllerName = configTable[Define.GAME_DATA_CONFIG_KEY.CLASS]
        Debug:Log("PlayerDataController:getGameData"
        , ", KEY: ", key
        , ", CLASS: ", controllerName.__name
        , ", configTable: ", configTable
        )

        playerData = controllerName:create()
        Debug:Log("PlayerDataController:getGameData"
        , ", playerData: ", playerData
        )
        playerData:init(self.userId, configTable)
        self.playerData[dataType] = playerData
        return
    end
    Debug:Log( "PlayerDataController:getGameData()"
    , " playerData: ", playerData
    , " userId: ", self.userId
    , " dataType: ", dataType
    )

    return playerData
end

function PlayerDataController:create(userId, dataConfigTables)
    local base = PlayerDataController.new()
    base:init(userId, dataConfigTables)
    return base
end

return PlayerDataController