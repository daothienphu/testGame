Lib.findObjectByName = function(objectName, map)
    for _, v in pairs(map:GetChildren(true)) do
        if v.name == objectName then
            return v
        end
    end
    return nil
end

