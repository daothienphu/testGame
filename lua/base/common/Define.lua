-- We will define all define/enum here

Define.GAME_LOGIC_FPS = 20
Define.UPDATE_INTERVAL = 1

Define.PLAYER_ENTITY = "myplugin/player1"

Define.ENTITY_EVENTS = {
    ENTITY_ENTER = "ENTITY_ENTER",
    ENTITY_LEAVE = "ENTITY_LEAVE",
    ENTITY_DIE = "ENTITY_DIE",
    ENTITY_CLICK = "ENTITY_CLICK",
    ENTITY_REBIRTH = "ENTITY_REBIRTH",
    ENTITY_STATUS_CHANGE = "ENTITY_STATUS_CHANGE",
    ENTER_MAP = "ENTER_MAP",
    LEAVE_MAP = "LEAVE_MAP",
    JOIN_TEAM = "JOIN_TEAM",
}

Define.PLAYER_CONTROLLER_FUNCTIONS = {
    [Define.ENTITY_EVENTS.ENTITY_ENTER] = "onEntityEnter",
    [Define.ENTITY_EVENTS.ENTITY_LEAVE] = "onEntityLeave",
    [Define.ENTITY_EVENTS.ENTITY_DIE] = "onEntityDie",
    [Define.ENTITY_EVENTS.ENTITY_CLICK] = "onEntityClick",
    [Define.ENTITY_EVENTS.ENTITY_REBIRTH] = "onEntityRebirth",
    [Define.ENTITY_EVENTS.ENTITY_STATUS_CHANGE] = "onEntityStatusChange",
    [Define.ENTITY_EVENTS.ENTER_MAP] = "onEnterMap",
    [Define.ENTITY_EVENTS.LEAVE_MAP] = "onLeaveMap",
    [Define.ENTITY_EVENTS.JOIN_TEAM] = "onJoinTeam",
}

Define.PLAYER_STATE = {
    IDLE = "IDLE",
    RUN = "RUN",
    WALK = "WALK",
    SPRINT = "SPRINT",
    SWIMMING = "SWIMMING",
    SWIMMING_IDLE = "SWIMMING_IDLE",
    AERIAL = "AERIAL",
    JUMP = "JUMP",
    IDLE = "IDLE",
    CLIMB = "CLIMB",
}

Define.ENTITY_MANAGER_EVENTS = {
    ENTITY_ENTER = "EntityEnter",
    ENTITY_DESTROY = "EntityDestroy"
}

Define.BASE_EVENT = {
    GAME_UPDATE_TICK = "GameUpdateTick",
    GAME_DATA_CHANGE = "GameDateChange",
}

Define.GAME_DATA_CONFIG_KEY = {
    KEY = "KEY",
    CLASS = "CLASS",
    DATA = "DATA",
}

Define.SYNC_GAME_DATA_TYPE = {
    LOAD_DB = 1,
    UPDATE = 2,
}