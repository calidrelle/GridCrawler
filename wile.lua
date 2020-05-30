wile = {}

function wile.display2decimale(value)
    return math.floor(value * 100) / 100
end

function wile.display1decimale(value)
    return math.floor(value * 10) / 10
end

function wile.boolToStr(value)
    if value == nil then
        return "nil"
    end
    if value then
        return "true"
    elseif not value then
        return "false"
    else
        return "not a boolean : " .. value
    end
end

function wile.nvl(value)
    if value == nil then
        return ""
    else
        return value
    end
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function table.contains(tab, item)
    for key, value in pairs(tab) do
        if value == item then
            return true
        end
    end
    return false
end

function table.removeAll(tab)
    while #tab > 0 do
        tab[1] = {}
        table.remove(tab, 1)
    end
end

function table.removeFromValue(tab, value)
    for i = #tab, 1, -1 do
        if tab[i] == value then
            table.remove(tab, i)
            return true
        end
    end
    return false
end

function table.serialize(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then
        if type(name) ~= "number" then
            tmp = tmp .. name .. " = "
        end
    end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp = tmp .. table.serialize(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end

function table.save(tab, filename)
    local chunk = table.serialize(tab)
    love.filesystem.write(filename, "return " .. chunk)
end

function table.load(filename)
    local tab
    if love.filesystem.getInfo(filename) then
        tab = assert(love.filesystem.load(filename))()
    else
        tab = {}
    end
    return tab
end
