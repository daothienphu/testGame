--Tiếng Việt
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function table.count(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

function string.split(str, reps, keepBlank, toNumber)
    local result = {}
    if str == nil or reps == nil then
        return result
    end

    keepBlank = keepBlank or false
    if keepBlank then
        local startIndex = 1
        while true do
            local lastIndex = string.find(str, reps, startIndex)
            if not lastIndex then
                table.insert(result, string.sub(str, startIndex, string.len(str)))
                break
            end
            table.insert(result, string.sub(str, startIndex, lastIndex - 1))
            startIndex = lastIndex + string.len(reps)
        end
    else
        string.gsub(str, '[^' .. reps .. ']+', function(w)
            table.insert(result, w)
        end)
    end

    toNumber = toNumber or false
    if toNumber then
        for i = 1, #result do
            result[i] = tonumber(result[i])
        end
    end

    return result
end

function Lib.getCsvRowContent(file, filePath)
    if file == nil then
        assert(false, filePath .. " -----------------> is not exist.")
    end
    local content;
    local check = false
    local count = 0
    while true do
        local t = file:read()
        if not t then
            if count == 0 then
                check = true
            end
            break
        end

        if not content then
            content = t
        else
            content = content .. t
        end

        local i = 1
        while true do
            local index = string.find(t, "\n", i)
            if not index then
                break
            end
            i = index + 1
            count = count + 1
        end

        if count % 2 == 0 then
            check = true
            break
        end
    end

    if not check then
        assert(1 ~= 1)
    end

    if content then
        return string.gsub(content, "\r", "")
    end

    return content
end

function Lib.loadCsvFile(filePath, tRow, indexNumber)
    local allRows = {}
    local file = io.open(filePath, "r")
    while true do
        local line = Lib.getCsvRowContent(file, filePath)
        if not line then
            break
        end
        table.insert(allRows, line)
    end
    io.close(file)
    local titleRow = tRow or 2
    local titles = string.split(allRows[titleRow], "\t", true)
    local id = 1
    local arrays = {}
    for row = titleRow + 1, #allRows, 1 do
        local content = string.split(allRows[row], "\t", true)
        if indexNumber then
            id = tonumber(content[1])
        else
            id = tostring(content[1])
        end
        if type(id) == "string" and #id == 0 then
            break
        end
        arrays[id] = {}
        for col = 1, #titles, 1 do
            if #titles[col] > 0 then
                arrays[id][titles[col]] = content[col]
                if col <= #titles and content[col] and #content[col] == 0 then
                    assert(false, filePath .. " -----------------> " .. titles[col] .. " is nil value, row = " .. row .. " col = " .. col)
                end
            end
        end
    end
    return arrays
end

---Get a global variable
---@param key string
function World.getGlobalVar(key)
    local data = World.vars
    if not key or not data then
        return nil
    end
    return data[key]
end

---Set a global variable
---@param key string
---@param value any
function World.setGlobalVar(key, value)
    local data = World.vars
    if not key or not value then
        return false
    end
    data[key] = value
    return true
end

function Lib.handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

function Lib.getDateString(time)
    local time = time or os.time()
    local objectDate = os.date("*t", time)

    return string.format("%04d-%02d-%02d %02d:%02d:%02d", objectDate.year, objectDate.month, objectDate.day, objectDate.hour, objectDate.min, objectDate.sec)
end

function math.newRandomSeed()
    math.randomseed(os.time())
    math.random()
    math.random()
    math.random()
    math.random()
end

function io.exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

function io.readFile(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end

function io.writeFile(path, content, mode)    
    mode = mode or "w+b"
    local file = io.open(path, mode)    
    if file then
        if file:write(content) == nil then             
            return false 
        end
        io.close(file)
        return true
    else
        return false
    end
end

function Lib.subscribeGameDataChange(saveKey, func, ...)
    Lib.subscribeEvent(Define.BASE_EVENT.GAME_DATA_CHANGE, function(data)
        if (data.saveKey == saveKey) then
            func(data)
        end
    end)
end