local BaseManager = require("base.manager.BaseManager")
---@class ClientLogicManager: BaseManager
local ClientLogicManager = class("ClientLogicManager", BaseManager)
require("game.client.manager.ClientPetManager")
local map

function ClientLogicManager:create()  
    local base = ClientLogicManager.new()
    return base
end

function ClientLogicManager:ctor()   
    Debug:Log( "ClientLogicManager:ctor()")
end

function ClientLogicManager:init()
    self:baseInit()
    Debug:Log( "ClientLogicManager:init()")
end

function ClientLogicManager:beginGame()
    Debug:Log("ClientLogicManager:beginGame()")
    local bm = Blockman.Instance()
    self.currentPlayer = bm.player
    map = World.CurMap
    ---@type DebugUIController
    self.debugUI = Global.GameUIManager:getUI(Define.GAME_UI_DEFINE.DEBUG_UI.KEY)
end

function ClientLogicManager:onUpdate()
    self:displayPlayerPosition()
    self:FireRayCast()
end

function ClientLogicManager:FireRayCast()
    local startPos = self.currentPlayer:curBlockPos()
    local direction = self.currentPlayer:getFrontPos(1, true, true) - startPos
    local distance = 10
    local resultList = map:RayCast(startPos, direction, distance, true)
    for i, v in pairs(resultList) do
        if v.Instance ~= nil and v.Instance._cfg ~= nil and v.Instance._cfg.name == "entity_petShop" then
            Event:GetEvent("OPEN_SHOP"):Emit()
        else
            Event:GetEvent("CLOSE_SHOP"):Emit()
        end
    end

end

function ClientLogicManager:displayPlayerPosition()
    if (self.currentPlayer == nil) then
        return
    end
    ---@type Vector3
    local currentBlockPos = self.currentPlayer:curBlockPos()
    self.debugUI:setDebugText("currentBlockPos: "..tostring(currentBlockPos))
end

return ClientLogicManager