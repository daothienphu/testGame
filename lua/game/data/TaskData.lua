local TaskData = {
    Tasks = {}
}

TaskData.Tasks = {
    COLLECTOR = {
        exp = 10,
        coin = 10,
        time = 100,
        name = "Collector",
        desc = "Collect the required amount of coins in time."
    },
    ADVENTURER = {
        exp = 20,
        coin = 20,
        time = 200,
        name = "Adventurer",
        desc = "Walk the required amount of distance in time."
    },
    RACER = {
        exp = 30,
        coin = 30,
        time = 300,
        name = "Racer",
        desc = "Complete the obstacle course in time."
    }
}

return TaskData