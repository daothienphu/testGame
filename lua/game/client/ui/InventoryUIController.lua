local BaseUIController = require("base.ui.BaseUIController")

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
    self.root = self.uiRoot
    for i=1, 10 do
        petSlots["Pet"..i] = {
            ui = self.root["Pet"..i],
            empty = true,
            equipped = false
        }
    end
    
    InventoryUIController:HideAllInventorySlots()
    InventoryUIController:SetUpButtonHandlers()
    --self.btn.onMouseClick = Lib.handler(self, self.onBtnClicked)
end

--Utils
function InventoryUIController:FindIDWithPetName(petName)
    for i, v in pairs(petSlots) do
        if v.ui.PetName.Text == petName then
            return i
        end
    end
    return nil
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
    Debug:Log("Unhiding", ID)
    if petSlots[ID] ~= nil and petSlots[ID].empty == true then
        petSlots[ID].ui.Button.Alpha = 1
        petSlots[ID].ui.Viewport.Alpha = 1
        petSlots[ID].ui.PetName.Alpha = 1
    end
end
function InventoryUIController:SetUpButtonHandlers()
    for _, v in pairs(petSlots) do
        v.ui.Button.onMouseClick = Lib.handler(self, self.onEquipButtonClicked)
    end
end
function InventoryUIController:FindEmptySlots()
    for i, v in pairs(petSlots) do
        if v.empty == true then
            return i
        end
    end
    return -1
end

--For adding the first dog only
function InventoryUIController:AddPetToSlots(petName)
    local ID = InventoryUIController:FindEmptySlots()
    Debug:Log(ID)
    
    if ID ~= -1 and petSlots[ID] ~= nil then
        InventoryUIController:UnHideInventorySlot(ID)
        petSlots[ID].empty = false
        petSlots[ID].equipped = false
        petSlots[ID].ui.PetName.Text = petName
        petSlots[ID].ui.Button.Text = "Equip"
        Debug:Log("adding to", petSlots[ID])
    end
end

--Handler
Event:RegisterCustomEvent("CLIENT_ADD_FIRST_PET")
Event:GetEvent("CLIENT_ADD_FIRST_PET"):Bind(function(petName)
    local ID = InventoryUIController:FindEmptySlots()
    
    if ID ~= -1 and petSlots[ID] ~= nil then
        InventoryUIController:UnHideInventorySlot(ID)
        petSlots[ID].empty = false
        petSlots[ID].equipped = true
        petSlots[ID].ui.PetName.Text = petName
        petSlots[ID].ui.Button.Text = "Unequip"
        Debug:Log("adding to", petSlots[ID])
    end
end)

function InventoryUIController:onEquipButtonClicked(ctx)
    local ID = ctx.Parent.__windowName
    if petSlots[ID] ~= nil and petSlots[ID].empty == false then
        Event:GetEvent("CLIENT_EQUIP_PET"):Emit(petSlots[ID].ui.PetName.Text)
    end
end

PackageHandlers:Receive(Define.PETS_EVENT.DISABLE_EQUIP_PETS, function()
    for _, v in pairs(petSlots) do
        if v.equipped == false then
            v.ui.Button.Disabled = true
        end
    end
end)

PackageHandlers:Receive(Define.PETS_EVENT.ENABLE_EQUIP_PETS, function()
    for _, v in pairs(petSlots) do
        v.ui.Button.Disabled = false
    end
end)

PackageHandlers:Receive(Define.PETS_EVENT.EQUIP_PET_OK, function(player, package)
    local ID = InventoryUIController:FindIDWithPetName(package.petName)
    if petSlots[ID].equipped == true then
        petSlots[ID].equipped = false
        petSlots[ID].ui.Button.Text = "Equip"
        Debug:Log("Unequip")
    else
        petSlots[ID].equipped = true
        petSlots[ID].ui.Button.Text = "Unequip"
        Debug:Log("Equip")
    end
end)

return InventoryUIController