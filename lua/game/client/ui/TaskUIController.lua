local BaseUIController = require("base.ui.BaseUIController")
---@class TaskUIController
local TaskUIController = class("TaskUIController", BaseUIController)

function TaskUIController:create()
    local base = TaskUIController.new()
    return base
end
local uiRoot
function TaskUIController:ctor()
    Debug:Log( "TaskUIController:ctor()")
end

function TaskUIController:initUIComponents()
    uiRoot = self.uiRoot

    
end

return TaskUIController