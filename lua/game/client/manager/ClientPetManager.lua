local inventory = require("game.client.ui.InventoryUIController")
local PetManager = {}

function PetManager:AddPet(petName)
    PackageHandlers:SendToServer(Define.PETS_EVENT.ADD_PET, petName)
end

function PetManager:EquipPet(petName)
    PackageHandlers:SendToServer(Define.PETS_EVENT.EQUIP_PET, petName)
end

Event:GetEvent("OnClientInitDone"):Bind(function()
    PackageHandlers:SendToServer(Define.GAME_EVENT.PLAYER_INIT_DONE)
end)

PackageHandlers:Receive(Define.PETS_EVENT.ADD_PET, function(player, package)
    Event:GetEvent("CLIENT_ADD_PET"):Emit(package.petName)
end)

PackageHandlers:Receive(Define.PETS_EVENT.ADD_FIRST_PET, function(player, package)
    --Debug:Log("client got event add first pet", package.petName)
    --petInventoryUI:AddFirstPet(package.petName)
    Event:GetEvent("CLIENT_ADD_FIRST_PET"):Emit(package.petName)
end)

PackageHandlers:Receive(Define.PETS_EVENT.ADD_PET_OK, function(player, package)
    --Debug:Log("Got add pet ok form server")
    --Debug:Log("Send event add pet ok to inventory")
    --Event:RegisterCustomEvent("CLIENT_ADD_PET_OK")
    --Event:GetEvent("CLIENT_BLA", package):Emit(package)
    inventory:AddPetToSlots(package.petName)
end)

Event:RegisterCustomEvent("CLIENT_EQUIP_PET")
Event:GetEvent("CLIENT_EQUIP_PET"):Bind(function(petName)
    --Debug:Log("Got event", petName)
    PackageHandlers:SendToServer(Define.PETS_EVENT.EQUIP_PET, petName)
end)

Event:RegisterCustomEvent("CLIENT_ADD_PET")
Event:GetEvent("CLIENT_ADD_PET"):Bind(function(petName)
    --Debug:Log("Got event add pet from shop", petName)
    --Debug:Log("Send event add pet to server")
    PackageHandlers:SendToServer(Define.PETS_EVENT.ADD_PET, petName)
end)

return PetManager