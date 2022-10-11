local TABLE_MAX_LEVEL = 1
local MAX_TABLE_LENGTH = 10
local LOG_LEVEL = {
    DEBUG = 1,
    INFO = 2,
    WARNING = 3,
    ERROR = 4,
    FATAL = 5,
}
local LOG_LEVEL_TAGS = {
    [LOG_LEVEL.DEBUG] = "[DEBUG]",
    [LOG_LEVEL.INFO] = "[INFO]",
    [LOG_LEVEL.WARNING] = "[WARNING]",
    [LOG_LEVEL.ERROR] = "[ERROR]",
    [LOG_LEVEL.FATAL] = "[FATAL]",
}

-- TODO: Config log level
local GAME_LOG_LEVEL = LOG_LEVEL.DEBUG

local oldDebugLog = Debug.Log
function Debug:Log(...)
    Debug:outputToFile(LOG_LEVEL.DEBUG, ...)
    oldDebugLog(oldDebugLog, ...)
end

local oldErrorLog = Debug.LogError
function Debug:LogError(...)
    Debug:outputToFile(LOG_LEVEL.ERROR, ...)
    oldErrorLog(...)
end

local SERVER_LOG_FILES = {
    DEBUG_SERVER = "debug_server.log",
    ERROR_SERVER = "error_server.log",
}

local CLIENT_LOG_FILES = {
    DEBUG_CLIENT = "debug_client.log",
    ERROR_CLIENT = "error_client.log",
}

local LOG_FOLDER = "logs/"

function Debug:clearLogFiles()
    local logsFiles = SERVER_LOG_FILES
    if (World.isClient) then
        logsFiles = CLIENT_LOG_FILES
    end
    for _, logFiles in pairs(logsFiles) do
        io.writeFile(LOG_FOLDER..logFiles,  Lib.getDateString(), "w+b")
    end
end

function Debug:getCalleeMethodName()
    local methodName = "[unknown]"
    local excludeFile = {
        "world.lua",
        "game.lua",
        "Common.lua",
        "LogCommon.lua",
    }
    for i = 1, 10 do
        local debugInfo = debug.getinfo(i)
        if (debugInfo ~= nil and debugInfo.source ~= nil and debugInfo.name ~= nil) then
            local fileName = debugInfo.source:match("^.+/(.+)$")
            local valid = fileName ~= nil

            -- Check exclude file
            if (table.contains(excludeFile, fileName) == true) then
                valid = false
            end

            if (valid) then
                methodName = "["..i..":"..fileName..":"..debugInfo.name.."]: "
            end
        end
        if (methodName ~= "[unknown]") then
            break
        end
    end

    return methodName
end

function Debug:outputToFile(logLevel, ...)
    if logLevel < GAME_LOG_LEVEL then
        return
    end
    local tbArgs = {...}
    local strLogFile = SERVER_LOG_FILES.DEBUG_SERVER
    if World.isClient then
        strLogFile = CLIENT_LOG_FILES.DEBUG_CLIENT
    end

    -- Build message
    local tbMsg = {}
    for _, v in ipairs(tbArgs) do
        if type(v) == "table" then
            if (table.count(v) <= MAX_TABLE_LENGTH) then
                table.insert(tbMsg, Lib.v2s(v, TABLE_MAX_LEVEL))
            else
                table.insert(tbMsg, tostring(v))
            end
        else
            if (not v) then
                table.insert(tbMsg, "nil")
            else
                table.insert(tbMsg, tostring(v))
            end
        end
    end

    local message = table.concat(tbMsg, "\t")

    -- Write to file
    local tag = LOG_LEVEL_TAGS[logLevel]
    local methodName = Debug:getCalleeMethodName()
    local errMsg = tag..":\t"..methodName.."\t"..message

    if logLevel >= LOG_LEVEL.ERROR then
        -- Write error log
        errMsg = errMsg .. "\n" .. debug.traceback("", 0)
        local strErrorFile = SERVER_LOG_FILES.ERROR_SERVER
        if World.isClient then
            strErrorFile = CLIENT_LOG_FILES.ERROR_CLIENT
        end
        io.writeFile(LOG_FOLDER..strErrorFile, "\n[".. Lib.getDateString() .."] "..errMsg, "a+")
    end

    -- Write to debug log too
    io.writeFile(LOG_FOLDER..strLogFile, "\n["..Lib. getDateString() .."]\t"..errMsg, "a+")
end