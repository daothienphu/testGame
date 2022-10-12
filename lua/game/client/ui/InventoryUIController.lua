local BaseUIController = require("base.ui.BaseUIController")
local petManager = require("game.client.manager.ClientPetManager")

---@class InventoryUIController
local InventoryUIController = class("InventoryUIController", BaseUIController)

local petSlots = {}

function InventoryUIController:create()
    local base = InventoryUIController.new()
    return base
end

function InventoryUIController:ctor()
    Debug:Log( "InventoryUIController:ctor()")
end

function InventoryUIController:initUIComponents()
    --self.root = self.uiRoot
    --petSlots = {
    --    pet1 =
    --    {
    --        ui = self.root.Pet1,
    --        empty = true,
    --        equipped = false,
    --    },
    --    pet2 =
    --    {
    --        ui = self.root.Pet2,
    --        empty = true,
    --        equipped = false,
    --    },
    --    pet3 =
    --    {
    --        ui = self.root.Pet3,
    --        empty = true,
    --        equipped = false,
    --    },
    --    pet4 =
    --    {
    --        ui = self.root.Pet4,
    --        empty = true,
    --        equipped = false,
    --    },
    --    pet5 =
    --    {
    --        ui = self.root.Pet5,
    --        empty = true,
    --        equipped = false,
    --    },
    --}
    --
    --InventoryUIController:HideAllInventorySlots()
    --InventoryUIController:SetUpButtonHandlers()
    --self.btn.onMouseClick = Lib.handler(self, self.onBtnClicked)
end

function InventoryUIController:FindEmptySlots()
    for _, v in pairs(petSlots) do
        if v.empty == true then
            return v
        end
    end
    return -1
end
function InventoryUIController:FindIDWithPetName(petName)
    for i, v in pairs(petSlots) do
        if v.ui.PetName == petName then
            return i
        end
    end
    return
end
--function InventoryUIController:AddPetToSlots(petName)
--    local ID = InventoryUIController:FindIDWithPetName(petName)
--    InventoryUIController:UnHideInventorySlot(ID)
--    petSlots[ID].ui.PetName = petName
--end

----For adding the first dog only
--function InventoryUIController:EquipPet(petName)
--    local ID = InventoryUIController:FindIDWithPetName(petName)
--    petSlots[ID].equipped = true
--    petSlots[ID].ui.Button.Text = "Equip"
--end

function InventoryUIController:SetUpButtonHandlers()
    for i, v in pairs(petSlots) do
        v.ui.Button.onMouseClick = Lib.handler(self, self.onEquipButtonClicked, i)
    end
end
function InventoryUIController:HideAllInventorySlots()
    Debug:Log("Searching all slots")
    for _, v in pairs(petSlots) do
        v.ui.Button.Alpha = 0
        v.ui.Viewport.Alpha = 0
        v.ui.PetName.Alpha = 0
        v.empty = true
    end
end
function InventoryUIController:UnHideInventorySlot(ID)
    if petSlots[ID] ~= nil and petSlots[ID].empty == true then
        petSlots[ID].Button.Alpha = 1
        petSlots[ID].Viewport.Alpha = 1
        petSlots[ID].PetName.Alpha = 1
        petSlots[ID].empty = false
    end
end

function InventoryUIController:onEquipButtonClicked(ID)
    if petSlots[ID] ~= nil and petSlots[ID].empty == false then
        if petSlots[ID].equipped == true then
            petSlots[ID].equipped = false
            petSlots[ID].ui.Button.Text = "Unequip"
        else
            petSlots[ID].equipped = true
            petSlots[ID].ui.Button.Text = "Equip"
        end
        petManager:EquipPet(petSlots[ID].petName)
    end
end

return InventoryUIController