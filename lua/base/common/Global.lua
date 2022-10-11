-- We will define all global here
if (Global.GameManager == nil) then
    Global.GameManager = require("base.manager.GameManager"):create()
end

if (Global.EntityManager == nil) then
    Global.EntityManager = require("base.entity.EntityManager"):create()
end

if (Global.PlayerManager == nil) then
    Global.PlayerManager = require("base.player.PlayerManager"):create()
end

if (World.isClient) then
    -- Client Manager
    if (Global.GameUIManager == nil) then
        Global.GameUIManager = require("base.ui.GameUIManager"):create()
    end
else
    -- Server Manager
end