local BaseManager = require("base.manager.BaseManager")
local ClientPetManager = require("game.client.manager.ClientPetManager")
---@class ClientLogicManager: BaseManager
local ClientLogicManager = class("ClientLogicManager", BaseManager)

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
    
    ---@type DebugUIController
    self.debugUI = Global.GameUIManager:getUI(Define.GAME_UI_DEFINE.DEBUG_UI.KEY)
end

function ClientLogicManager:onUpdate()
    --ClientPetManager:MovePet(self.currentPlayer:curBlockPos())
    self:displayPlayerPosition()
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