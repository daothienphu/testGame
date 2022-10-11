Define.SPAWN_ZOMBIE_INTERVAL = Define.GAME_LOGIC_FPS * 5

Define.PLAYER_ATTRIBUTE_TYPE = {
    STRENGTH = 1,
    CHAKRA = 2,
    JUMP = 3,
    SPEED = 4,
}

Define.TEAM_ID = {
    PLAYER_TEAM = 1,
    PLANT_TEAM = 1,
    ZOMBIE_TEAM = 2,
}

Define.GAME_EVENT = {
    PLAYER_ATTRIBUTE_CHANGE = "PlayerAttributeChange",
}

Define.ZOMBIE_POSITION = {
    Lib.v3(11, 1, 30),
    Lib.v3(11, 1, 31),
    Lib.v3(11, 1, 32),
}

Define.FARM_POSITION = {
    Lib.v3(0, 1, 30),
    Lib.v3(0, 1, 31),
    Lib.v3(0, 1, 32),
}

Define.FARM_ZONE = {
    BEGIN = Lib.v3(1, 1, 30),
    END = Lib.v3(11, 1, 32),
}

Define.PETS_EVENT = {
    GET_ALL_PETS = "GetAllPets",
    EQUIP_PET = "EquipPet",
    ADD_PET = "AddPet",
    ADD_EXP = "AddEXP",
}

Define.TASKS_EVENT = {
    START_TASK = "StartTask",
    END_TASK = "EndTask",
    UPDATE_TASK = "UpdateTask",
    FAILED_TASK = "FailedTask",
    COMPLETED_TASK = "CompletedTask",
}
