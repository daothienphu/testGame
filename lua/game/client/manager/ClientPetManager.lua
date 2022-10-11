local ClientPetManager = {}
local petInventory = {}

PackageHandlers:Receive(Define.PETS_EVENT.EQUIP_PET, function(player, petName)
    if petInventory[petName] ~= nil then
        if petInventory[petName].equipped == false then
            petInventory[petName].entity = EntityClient.CreateClientEntity({cfgName = petInventory[petName].cfgName, name = petInventory[petName].name, pos = petInventory[petName].pos})
            petInventory[petName].equipped = true
        else
            petInventory[petName].entity:destroy()
            petInventory[petName].equipped = false
        end
    end
end)

PackageHandlers:Receive(Define.PETS_EVENT.ADD_PET, function(player, packet)
    if Lib.tableContain(petInventory, packet.uniqueKey) then
        return
    end
    local key = packet.uniqueKey
    petInventory[key] = {
        name = packet.name,
        cfgName = packet.cfgName,
        pos = packet.pos,
        equipped = false,
        exp = 0,
        level = 1
    }
    
    
    Debug:Log("pet ", packet.name, " added for player ", player.name)
    Debug:Log(petInventory)
end)

function ClientPetManager:EquipPet(name)
    PackageHandlers:SendToServer(Define.PETS_EVENT.EQUIP_PET, name)
end

function ClientPetManager:MovePet(toPosition)
    if not Lib.table_is_empty(petInventory) then
        for _, v in pairs(petInventory:GetChildren()) do
            if v.equipped then
                v.Position = toPosition
            end
        end
    end
end

function ClientPetManager:AddExp(petName, exp)
    local info = {
        currentExp = petInventory[petName].exp,
        currentLevel = petInventory[petName].level,
        expAdded = exp,
        petName = petName
    }
    PackageHandlers:SendToServer(Define.PETS_EVENT.ADD_EXP, info)
end

PackageHandlers:Receive(Define.PETS_EVENT.ADD_EXP, function(player, package)
    petInventory[package.petName].exp = package.currentExp
    petInventory[package.petName].level = package.currentLevel
end)


return ClientPetManager