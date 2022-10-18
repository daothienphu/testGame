local petData = require("game.data.PetData")
require("game.common.Utils")
local coinManager = require("game.server.manager.ServerCoinManager")

local petStates = {
    NO_PETS_AT_ALL = 0,
    NO_CURRENT_PET = 1,
    HAS_CURRENT_PET = 2
}
local map = World.CurWorld:getOrCreateStaticMap("map001")
local PetInventories = {}

local equippedCount = 0

local PetManager = {}
--Methods
function PetManager:SanityCheck(player, petName)
    if PetInventories[player.name] == nil then
        Debug:LogWarning(player.name, "does not have any pets")
        return petStates.NO_PETS_AT_ALL
    end
    
    if PetInventories[player.name][petName] == nil then
        Debug:LogWarning(player.name, "has no pet", petName)
        return petStates.NO_CURRENT_PET
    end
    
    return petStates.HAS_CURRENT_PET
end

function PetManager:AddPet(player, petName, isFirstPet)
    if PetManager:SanityCheck(player, petName) == petStates.NO_PETS_AT_ALL then
        PetInventories[player.name] = {}
    end
    if PetInventories[player.name][petName] == nil then
        local petInfo = petData:findPetInfoWithName(petName)
        if petInfo then
            PetInventories[player.name][petName] = {
                name = petInfo.name,
                cfgName = petInfo.cfgName,
                pos = petInfo.pos,
                equipped = false,
                exp = 0,
                level = 1
            }
            Debug:Log("Added pet", petName, "for player", player.name)
            if not isFirstPet then
                PackageHandlers:SendToClient(player, Define.PETS_EVENT.ADD_PET_OK, {petName = petName})
            end
        end
    else
        Debug:LogWarning("pet", petName, "existed for player", player.name)
        Debug:LogWarning("PetManagerServer:AddPet()")
    end
end

function PetManager:EquipPet(player, petName, firstPet)
    if PetManager:SanityCheck(player, petName) ~= petStates.HAS_CURRENT_PET then
        Debug:LogWarning(player.name, "has no pet", petName)
        return
    end
    
    if PetInventories[player.name][petName].equipped == true then
        PetManager:UnEquipPet(player, petName)
        Debug:Log("Un-equipped pet", petName, "for player", player.name)
        if not firstPet then
            PackageHandlers:SendToClient(player, Define.PETS_EVENT.EQUIP_PET_OK, {petName = petName})
        end
        return
    end
    
    if equippedCount < 2 then
        --To be sure
        map = World.CurWorld:getOrCreateStaticMap("map001")
        
        local petInfo = PetInventories[player.name][petName]
        local createParams = petInfo
        createParams.map = map
        
        EntityServer.Create(createParams, function(entity)
            Debug:Log("Creating entity")
            local control = entity:getAIControl()
            if control then
                entity:setFollowTarget(player)
            else
                Debug:LogWarning("no AI control")
                Debug:LogWarning("PetManagerServer:EquipPet()")
            end
            petInfo.entity = entity
            entity:setHp(1)
        end)
        
        petInfo.equipped = true
        Debug:Log("Equipped pet", petName, "for player", player.name)
        
        if not firstPet then
            PackageHandlers:SendToClient(player, Define.PETS_EVENT.EQUIP_PET_OK, {petName = petName})
        end
        equippedCount = equippedCount + 1
        if equippedCount == 2 then
            PackageHandlers:SendToClient(player, Define.PETS_EVENT.DISABLE_EQUIP_PETS)
        end
    end
end

function PetManager:UnEquipPet(player, petName)
    local petInfo = PetInventories[player.name][petName]
    petInfo.equipped = false
    petInfo.entity:Destroy()
    if equippedCount == 2 then
        PackageHandlers:SendToClient(player, Define.PETS_EVENT.ENABLE_EQUIP_PETS)
    end
    equippedCount = equippedCount - 1
end

function PetManager:AddEXP(player, petName, expToAdd)
    if PetManager:SanityCheck(player, petName) ~= petStates.HAS_CURRENT_PET then
        Debug:LogWarning(player.name, "has no pet", petName)
        return
    end
    
    local petInfo = PetInventories[player.name][petName]
    local totalExp = petInfo.exp + expToAdd
    local level = petInfo.level
    
    local maxExpForLvl = petData.LevelThreshold[level]
    while totalExp > maxExpForLvl do
        totalExp = totalExp - maxExpForLvl
        level = level + 1
        maxExpForLvl = petData.LevelThreshold[level]
    end
    
    petInfo.exp = totalExp
    petInfo.level = level
end

function PetManager:DeduceEXP(player, petName)
    if PetManager:SanityCheck(player, petName) ~= petStates.HAS_CURRENT_PET then
        Debug:LogWarning(player.name, "has no pet", petName)
        return
    end
    
    local petInfo = PetInventories[player.name][petName]
    petInfo.exp = 0
end

function PetManager:GetEquippedPets()
    local petNames = {}
    for i, v in pairs(PetInventories) do
        if v.equipped then
            table.insert(petNames, i)
        end
    end
    Debug:Log("equipped Pets")
    Debug:Log(petNames)
    return petNames
end

--End methods

--Event Handlers
PackageHandlers:Receive(Define.GAME_EVENT.PLAYER_INIT_DONE, function(player)
    Timer.new(40, function()
        local data = {}
        for _, v in pairs(petData.AllPets) do
            data[v.name] = {
                name = v.name,
                price = v.price
            }
        end
        PackageHandlers:SendToClient(player, Define.PETS_EVENT.PET_SHOP_DATA, data)
        PetManager:AddPet(player, "Dog", true)
        PetManager:EquipPet(player, "Dog", true)
        PackageHandlers:SendToClient(player, Define.PETS_EVENT.ADD_FIRST_PET, {petName = "Dog"})
        coinManager:DisplayCoin(player)
    end):Start()
end)

PackageHandlers:Receive(Define.PETS_EVENT.ADD_PET, function(player, package)
    Debug:Log("Server receive add pet")
    PetManager:AddPet(player, package, false)
end)
PackageHandlers:Receive(Define.PETS_EVENT.EQUIP_PET, function(player, package)
    PetManager:EquipPet(player, package, false)
end)

PackageHandlers:Receive(Define.PETS_EVENT.BUY_PET, function(player, package)
    local coins = coinManager:GetCurrentCoin()
    local petInfo = petData:findPetInfoWithName(package.petName)
    Debug:Log("got buy pet")
    Debug:Log(package)
    Debug:Log(coins)
    Debug:Log(petInfo)
    if petInfo ~= nil and petInfo.price <= coins then
        coinManager:UpdateCoin(coins - petInfo.price)
        coinManager:DisplayCoin(player)
        PackageHandlers:SendToClient(player, "BuyPetOK", {petName = package.petName})
    end
end)

--end event handlers

return PetManager