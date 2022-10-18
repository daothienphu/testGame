local taskData = require("game.data.TaskData")
local petManager = require("game.server.manager.ServerPetManager")
local TaskManager = {}
local numOfTasks = 3

local defaultWaitTime = 20
local waitTime = defaultWaitTime
local taskCount = 1

local timer = Timer.new(waitTime, function()
    TaskManager:StartTask(taskCount)
    taskCount = taskCount + 1
    waitTime = defaultWaitTime + math.random(10) * 20
end)
timer.Loop = true
timer:Start()

function TaskManager:StartTask(taskCount)
    local taskID = math.random(numOfTasks)
    local currentTask = taskData.Tasks[taskID]
    currentTask.ID = currentTask.name ..taskCount
    PackageHandlers:SendToAllClients(Define.TASKS_EVENT.START_TASK, currentTask)
    
    Timer.new(currentTask.time * 20, function()
        PackageHandlers:SendToAllClients(Define.TASKS_EVENT.END_TASK, currentTask)
    end):Start()
end

PackageHandlers:Receive(Define.TASKS_EVENT.COMPLETED_TASK, function(player, package)
    local petNames = petManager:GetEquippedPets()
    for i, v in ipairs(petNames) do
        petManager:AddEXP(player, v, 10)
    end
end)

PackageHandlers:Receive(Define.TASKS_EVENT.FAILED_TASK, function(player, package)

end)


return TaskManager