local TaskData = {
    Tasks = {}
}

TaskData.Tasks = {
    {
        exp = 10,
        coin = 10,
        time = 100,
        requirement = 100,
        name = "Collector",
        desc = "Collect the required amount of coins in time."
    },
    {
        exp = 20,
        coin = 20,
        time = 200,
        requirement = 100,
        name = "Adventurer",
        desc = "Walk the required amount of distance in time."
    },
    {
        exp = 30,
        coin = 30,
        time = 300,
        requirement = 100,
        name = "Racer",
        desc = "Complete the obstacle course in time."
    }
}

return TaskData