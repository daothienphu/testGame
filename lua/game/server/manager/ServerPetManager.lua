local petData = require("game.data.PetData")
require("game.common.Utils")
-- Requirements

-- Local vars
local map = World.CurWorld:GetStaticMap("map001").Root
local petsFolder
Timer.new(20, function()
    petsFolder = Lib.findObjectByName("Pets", map)
end):Start()
-- End local vars


local PetManagerServer = {}

Event:GetEvent("OnPlayerLogin"):Bind(function(entity)
    Timer.new(40, function()
        PetManagerServer:AddPet(entity, "Dog")
        PetManagerServer:EquipPet(entity, "Dog")
    end):Start()
end)

function PetManagerServer:AddPet(player, petName)
    local petInfo = petData:findPetInfoWithName(petName)
    PackageHandlers:SendToClient(player, Define.PETS_EVENT.ADD_PET, petInfo)
end

PackageHandlers:Receive(Define.PETS_EVENT.ADD_PET, function(player, petName)
    PetManagerServer:AddPet(player, petName)
end)

function PetManagerServer:EquipPet(player, petName)
    --local petInfo = petData:findPetInfoWithName(petName)
    PackageHandlers:SendToClient(player, Define.PETS_EVENT.EQUIP_PET, petName)
end

PackageHandlers:Receive(Define.PETS_EVENT.EQUIP_PET, function(player, petName)
    PetManagerServer:EquipPet(player, petName)
end)

PackageHandlers:Receive(Define.PETS_EVENT.ADD_EXP, function(player, package)
    local totalExp = package.currentExp + package.expAdded
    local level = package.currentLevel
    local maxExpForLvl = petData.LevelThreshold[level]
    while totalExp > maxExpForLvl do
        totalExp = totalExp - maxExpForLvl
        level = level + 1
        maxExpForLvl = petData.LevelThreshold[level]
    end
    local result = {
        currentExp = totalExp,
        currentLevel = level,
        petName = package.petName
    }
    PackageHandlers:SendToClient(player, Define.PETS_EVENT.ADD_EXP, result)
end)

return PetManagerServer