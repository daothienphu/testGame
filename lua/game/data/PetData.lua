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
        uniqueKey = "Dog",
        name = "Dog",
        cfgName = "myplugin/petDog",
        pos = Lib.v3(1, 5, 0)
    },
    Cat = {
        uniqueKey = "Cat",
        name = "Cat",
        cfgName = nil,
        pos = Lib.v3(2, 5, 0)
    }
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