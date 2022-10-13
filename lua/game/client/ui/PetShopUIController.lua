local BaseUIController = require("base.ui.BaseUIController")
---@class PetShopUIController
local PetShopUIController = class("PetShopUIController", BaseUIController)

local isPetShopOpen = false
local shopLayout = {}
local shopItemCount = 11

function PetShopUIController:create()
    local base = PetShopUIController.new()
    return base
end
function PetShopUIController:ctor()
    Debug:Log( "PetShopUIController:ctor()")
end
local uiRoot
function PetShopUIController:initUIComponents()
    self.closeBtn = self.uiRoot.Close
    self.uiRoot.Visible = false
    uiRoot = self.uiRoot
    self.closeBtn.onMouseClick = Lib.handler(self, self.onCloseShopBtnClicked)
    for i=1,shopItemCount do
        shopLayout["Item"..i] = {
            ui = self.uiRoot.Layout.GridView["Item"..i],
            bought = false
        }
    end
    for i=1,shopItemCount do
        shopLayout["Item"..i].ui.Button.Text = "Buy"
    end
    Debug:Log("shopLayout", shopLayout)
end

function PetShopUIController:HandleOpenClose(open, forced)
    if forced then
        uiRoot.Visible = false
        return
    end
    if isPetShopOpen == false and open then
        isPetShopOpen = true
        Debug:Log("Open shop")
        uiRoot.Visible = true
    end
    if isPetShopOpen and open == false then
        isPetShopOpen = false
        Debug:Log("Close shop")
        uiRoot.Visible = false
    end
end
function PetShopUIController:onCloseShopBtnClicked()
    PetShopUIController:HandleOpenClose(false, true)
end

function PetShopUIController:BuyPet(petName)
    PackageHandlers:SendToServer(Define.PETS_EVENT.BUY_PET, {petName = petName})
end

PackageHandlers:Receive(Define.PETS_EVENT.PET_SHOP_DATA, function(player, package)
    local k = 1
    for i, v in pairs(package) do
        local ID = "Item"..k
        shopLayout[ID].ui.Button.Text = "Buy ($"..v.price..")"
        shopLayout[ID].ui.PetName.Text = v.name
        shopLayout[ID].ui.Button.onMouseClick = function()
            shopLayout[ID].ui.Button.Disabled = true
            Debug:Log("Send event add pet from shop")
            Event:GetEvent("CLIENT_ADD_PET"):Emit(shopLayout[ID].ui.PetName.Text)
        end
        k = k + 1
    end
    shopLayout["Item11"].ui.Button.Text = "Buy ($100)"
    shopLayout["Item11"].ui.PetName.Text = "Random"
    shopLayout["Item11"].ui.Button.onMouseClick = function()
        shopLayout["Item11"].ui.Button.Disabled = true
    end
end)
Event:RegisterCustomEvent("OPEN_SHOP")
Event:GetEvent("OPEN_SHOP"):Bind(function()
    Debug:Log("got event openshop")
    PetShopUIController:HandleOpenClose(true, false)
end)
Event:RegisterCustomEvent("CLOSE_SHOP")
Event:GetEvent("CLOSE_SHOP"):Bind(function()
    Debug:Log("got event closeshop")
    PetShopUIController:HandleOpenClose(false, false)
end)

return PetShopUIController