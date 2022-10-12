local petInventoryUI = require("game.client.ui.InventoryUIController")
local PetManager = {}

function PetManager:AddPet(petName)
    PackageHandlers:SendToServer(Define.PETS_EVENT.ADD_PET, petName)
end

function PetManager:EquipPet(petName)
    PackageHandlers:SendToServer(Define.PETS_EVENT.EQUIP_PET, petName)
end

Event:GetEvent("OnClientInitDone"):Bind(function()
    PackageHandlers:SendToServer(Define.GAME_EVENT.PLAYER_INIT_DONE)
    Debug:Log("client done init")
end)

--PackageHandlers:Receive(Define.PETS_EVENT.ADD_PET, function(player, package)
--    petInventoryUI:AddPetToSlots(package.petName)
--end)
--PackageHandlers:Receive(Define.PETS_EVENT.EQUIP_PET, function(player, package)
--    petInventoryUI:EquipPet(package.petName)
--end)

return PetManager