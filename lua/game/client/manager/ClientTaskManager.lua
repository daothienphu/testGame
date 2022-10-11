local TaskManager = {}

local onGoingTasks = {}

PackageHandlers:Receive(Define.TASKS_EVENT.START_TASK, function(player, package)
    local collisionCounter = 0
    local key = package.name + tostring(collisionCounter)
    while onGoingTasks[key] ~= nil do
        collisionCounter = collisionCounter + 1
        key = package.name + tostring(collisionCounter)
    end
    onGoingTasks[key] = {
        exp = package.exp,
        coin = package.coin,
        time = package.time,
        name = package.name,
        desc = package.desc,
        amount = package.amount,
        completionCounter = 0
    }
end)

PackageHandlers:Receive(Define.TASKS_EVENT.END_TASK, function(player, package)

end)

PackageHandlers:SendToServer(Define.TASKS_EVENT.COMPLETED_TASK, function(player, package)

end)

return TaskManager