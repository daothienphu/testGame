local taskData = require("game.data.TaskData")

local TaskManager = {}
local numOfTasks = #taskData.Tasks:GetChildren()

local defaultWaitTime = 180 * 20
local waitTime = defaultWaitTime

local timer = Timer.new(waitTime, function()
    TaskManager:StartTask()
    waitTime = defaultWaitTime + math.random(20, 30 * 20)
end)
timer.Loop = true
timer:Start()

function TaskManager:StartTask()
    local taskID = math.random(1, numOfTasks)
    local currentTask = taskData.Tasks[taskID]
    
    PackageHandlers:SendToAllClient(Define.TASKS_EVENT.START_TASK, currentTask)
    
    Timer.new(currentTask.time * 20, function()
        PackageHandlers:SendToAllClients(Define.TASKS_EVENT.END_TASK, currentTask)
    end):Start()
end

function TaskManager:EndTask()

end

return TaskManager