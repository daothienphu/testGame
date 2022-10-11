local cjson = require("cjson")
---@class BasePlayerData
---@field onUpdate fun(self: BasePlayerData): void
local BasePlayerData = class("BasePlayerData")
function BasePlayerData:ctor()
    Debug:Log( "BasePlayerData:ctor()")
    self.saveKey = nil
    self.userId = -1
    self.keyIndex = 0
    self.data = {}
    self.configTable = {}
end

function BasePlayerData:init(userId, configTable, callback)
    Debug:Log( "BasePlayerData:init()"
            , ", World.isClient: ", World.isClient
            , ", userId: ", userId
            , ", configTable: ", configTable
            , ", callback: ", callback
    )
    self.configTable = configTable
    self.userId = userId
    self.saveKey = self.configTable[Define.GAME_DATA_CONFIG_KEY.KEY]
    if (not World.isClient) then
        self.dataStore = Engine.DataService:GetGlobalDataStore(self.saveKey)
    end

    Debug:Log( "BasePlayerData:init()"
    , ", self.userId: ", self.userId
    , ", self.saveKey: ", self.saveKey
    , ", self.dataStore: ", self.dataStore
    )

    -- init all key
    self:initKey()

    -- register sync packet from server
    if (World.isClient) then
        Debug:Log( "BasePlayerData:init()"
        , ", registerClientHandler"
        )
        PackageHandlers:Receive(Define.BASE_PACKET_TYPE.SYNC_PLAYER_DATA, Lib.handler(self, self.onSyncGameData))
    end
end

---Get value of game data by key
---@param key string
function BasePlayerData:getValue(key)
    key = tostring(key)
    local data = self.data[key]
    if (data == nil) then
        Debug:LogError("BasePlayerData:setValue"
        , ", [WARNING]don't have key"
        , ", key: ", key
        )
        -- don't have key
        return
    end
    return data.value
end

---Set value of game data by key
---@param key string
---@param value any
function BasePlayerData:setValue(key, value, syncType)
    syncType = syncType or Define.SYNC_GAME_DATA_TYPE.UPDATE
    key = tostring(key)
    Debug:Log("BasePlayerData:setValue"
    , ", self.userId: ", self.userId
    , ", key: ", key
    , ", value: ", value
    )
    local data = self.data[key]
    if (data == nil) then
        -- don't have key
        Debug:Log("BasePlayerData:setValue"
        , ", [WARNING]don't have key"
        , ", key: ", key
        , ", value: ", value
        )
        return
    end

    if data.value == tostring(value) then
        -- data don't need update
        return
    end

    data.prevValue = data.value
    data.value = tostring(value)

    -- Save data
    self:saveDB()

    -- Sync data to client
    self:syncData(data, Define.SYNC_GAME_DATA_TYPE.UPDATE)

    -- Dispatch event for UI if needed
    Lib.emitEvent(Define.BASE_EVENT.GAME_DATA_CHANGE, {
        userId = self.userId,
        saveKey = self.saveKey,
        key = key,
        prevValue = data.prevValue,
        value = value,
        syncType = syncType,
    })
end

---@private
function BasePlayerData:initKey()
    Debug:Log("BasePlayerData:initKey"
    , ", self.userId: ", self.userId
    , ", self.dataStore: ", self.dataStore
    , ", self.saveKey: ", self.saveKey
    , ", self.configTable: ", self.configTable
    )
    local allData = self.configTable[Define.GAME_DATA_CONFIG_KEY.DATA]
    Debug:Log("BasePlayerData:initKey"
    , "allData: ", allData
    )
    for _, data in pairs(allData) do
        Debug:Log("BasePlayerData:initKey"
        , ", key: ", data.key
        , ", defaultValue: ", data.defaultValue
        , ", needSync: ", data.needSync
        , ", needSave: ", data.needSave
        , ", data: ", data
        )
        self:addKey(data.key, data.defaultValue, data.needSync, data.needSave)
    end
end

---@private
function BasePlayerData:getSaveData()
    local rawData = {}
    for key, data in pairs(self.data) do
        if (data.needSave == true) then
            rawData[key] = data.value
        end
    end

    return rawData
end

---@private
function BasePlayerData:addKey(key, defaultValue, needSync, needSave)
    Debug:Log( "BasePlayerData:addKey()"
    , ", key: ", key
    , ", defaultValue: ", defaultValue
    , ", needSync: ", needSync
    , ", needSave: ", needSave
    )
    self.keyIndex = self.keyIndex + 1
    local data = {}
    data.key = tostring(key)
    data.keyIndex = self.keyIndex
    data.prevValue = defaultValue
    data.value = defaultValue
    data.needSync = needSync
    data.needSave = needSave
    self.data[tostring(key)] = data
end

---@private
function BasePlayerData:loadDB(callback)
    -- Load data from database
    Debug:Log("BasePlayerData:loadDB"
    , ", self.userId: ", self.userId
    , ", self.dataStore: ", self.dataStore
    , ", self.saveKey: ", self.saveKey
    )

    -- Only load data from server
    if (World.isClient) then
        callback(self)
        return
    end

    if (self.dataStore ~= nil) then
        self.dataStore:RequestData(self.userId, function(dbData)
            local rawData = { }
            if dbData ~= nil and dbData ~= "" then
                rawData = cjson.decode(dbData)
            end

            Debug:Log( "BasePlayerData:loadDB()"
            , ", dbData: ", dbData
            , ", rawData: ", rawData
            )

            --Add raw data to self.data
            for key, value in pairs(rawData) do
                local currentData = self.data[key]
                if (currentData ~= nil) then
                    -- Update value
                    currentData.key = tostring(key)
                    currentData.prevValue = value
                    currentData.value = value

                    -- Sync data to client at the first time
                    self:syncData(currentData, Define.SYNC_GAME_DATA_TYPE.LOAD_DB)
                else
                    -- TODO: Create new & warning
                    Debug:LogError( "BasePlayerData:init()"
                    , ", Data not init!"
                    , ", dbData: ", dbData
                    , ", key: ", key
                    , ", value: ", value
                    )
                end
            end

            callback(self)
        end)
    end
end

---@private
function BasePlayerData:syncData(data, syncType)
    -- Only send from server
    if (World.isClient) then
        return
    end
    Debug:Log("BasePlayerData:syncData")

    if (not data.needSync) then
        return
    end

    -- Sync data to client
    local player = Game.GetPlayerByUserId(self.userId)
    if not player then
        return
    end

    local packet = {
        userId = self.userId,
        saveKey = self.saveKey,
        key = data.key,
        value = data.value,
        syncType = syncType,
    }

    Debug:Log("BasePlayerData:syncData"
    , ", self.userId: ", self.userId
    , ", player: ", player.platformUserId
    , ", packet: ", packet
    )

    PackageHandlers:SendToClient(player, Define.BASE_PACKET_TYPE.SYNC_PLAYER_DATA, packet)
end

---@private
function BasePlayerData:onSyncGameData(player, packet)
    local userId = packet.userId
    local saveKey = packet.saveKey
    local key = packet.key
    local value = packet.value
    local syncType = packet.syncType
    Debug:Log("BasePlayerData:onSyncGameData"
    , ", saveKey: ", saveKey
    , ", self.saveKey: ", self.saveKey
    , ", userId: ", userId
    , ", self.userId: ", self.userId
    , ", key: ", key
    , ", value: ", value
    , ", syncType: ", syncType
    )
    if (self.saveKey == saveKey and self.userId == userId) then
        --Update data
        self:setValue(key, value, syncType)
    end
end

---@private
function BasePlayerData:saveDB()
    if (World.isClient) then
        -- Only save in server side
        return
    end
    Debug:Log("BasePlayerData:saveDB")

    if (self.dataStore ~= nil and self.saveKey ~= nil) then
        -- Save data
        local saveValue = cjson.encode(self:getSaveData())
        Debug:Log("BasePlayerData:saveDB"
        , ", save data"
        , ", self.userId: ", self.userId
        , ", self.saveKey: ", self.saveKey
        , ", saveValue: ", saveValue
        )
        self.dataStore:SetData(self.userId, saveValue)
    else
        Debug:LogError("BasePlayerData:saveDB"
        , ", save data failed!"
        , ", self.userId: ", self.userId
        , ", self.dataStore: ", self.dataStore
        , ", self.saveKey: ", self.saveKey
        )
    end
end


function BasePlayerData:create()  
    local base = BasePlayerData.new()
    return base
end

return BasePlayerData