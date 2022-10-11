local taskData = require("game.data.TaskData")

local TaskManager = {}
local numOfTasks = #taskData.Tasks:GetChildren()

local defaultWaitTime = 180 * 20
local waitTime = defaultWaitTime

local timer = Timer.new(waitTime, function()
    TaskManager:StartTask()
    waitTime = defaultWaitTime + math.random(30) * 20
end)
timer.Loop = true
timer:Start()

function TaskManager:StartTask()
    local taskID = math.random(numOfTasks)
    local currentTask = taskData.Tasks[taskID]
    
    PackageHandlers:SendToAllClient(Define.TASKS_EVENT.START_TASK, currentTask)
    
    Timer.new(currentTask.time * 20, function()
        PackageHandlers:SendToAllClients(Define.TASKS_EVENT.END_TASK, currentTask)
    end):Start()
end

PackageHandlers:Receive(Define.TASKS_EVENT.COMPLETED_TASK, function(player, package)

end)

PackageHandlers:Receive(Define.TASKS_EVENT.FAILED_TASK, function(player, package)

end)


return TaskManager