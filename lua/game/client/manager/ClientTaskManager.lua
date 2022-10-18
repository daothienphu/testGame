local TaskManager = {}

local onGoingTasks = {}

PackageHandlers:Receive(Define.TASKS_EVENT.START_TASK, function(player, package)
    onGoingTasks[package.ID] = {
        exp = package.exp,
        coin = package.coin,
        time = package.time,
        name = package.name,
        desc = package.desc,
        requirement = package.requirement,
        completionCounter = 0
    }
end)

PackageHandlers:Receive(Define.TASKS_EVENT.END_TASK, function(player, package)
    if onGoingTasks[package.ID] ~= nil then
        onGoingTasks[package.ID] = nil
    end
end)

Timer.new(100, function()
    PackageHandlers.SendToServer(Define.TASKS_EVENT.COMPLETED_TASK, onGoingTasks[1].ID)
end)
return TaskManager