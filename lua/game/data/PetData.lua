local PetData = {
    AllPets = {},
    LevelThreshold = {}
}

PetData.LevelThreshold = {
    10,
    15,
    25,
    50,
    100,
    200,
    500,
    1000,
    5000
}

PetData.AllPets = {
    Dog = {
        name = "Dog",
        cfgName = "myplugin/petDog",
        pos = Lib.v3(1, 1, 0),
        price = 0
    },
    Cat = {
        name = "Cat",
        cfgName = "myplugin/petDog",
        pos = Lib.v3(2, 5, 0),
        price = 10,
    },
    Monkey = {
        name = "Monkey",
        cfgName = "myplugin/petDog",
        pos = Lib.v3(2, 5, 0),
        price = 20
    },
    Crab = {
        name = "Crab",
        cfgName = "myplugin/petDog",
        pos = Lib.v3(2, 5, 0),
        price = 30
    },
    Rabbit = {
        name = "Rabbit",
        cfgName = "myplugin/petDog",
        pos = Lib.v3(2, 5, 0),
        price = 40
    },
    God = {
        name = "God",
        cfgName = "myplugin/petDog",
        pos = Lib.v3(2, 5, 0),
        price = 50
    },
    Phoenix = {
        name = "Phoenix",
        cfgName = "myplugin/petDog",
        pos = Lib.v3(2, 5, 0),
        price = 60
    },
    Amoeba = {
        name = "Amoeba",
        cfgName = "myplugin/petDog",
        pos = Lib.v3(2, 5, 0),
        price = 70
    },
    UnNamedPet = {
        name = "UnNamedPet",
        cfgName = "myplugin/petDog",
        pos = Lib.v3(2, 5, 0),
        price = 80
    },
    Duck = {
        name = "Duck",
        cfgName = "myplugin/petDog",
        pos = Lib.v3(2, 5, 0),
        price = 90
    },
}

function PetData:findPetInfoWithName(petName)
    for _, v in pairs(PetData.AllPets) do
        if v.name == petName then
            return v
        end
    end
    return nil
end

return PetData