local utility = {}

function utility.find(table, what)
    for _, value in ipairs(table) do
        return value == what
    end
    return false
end

function utility.any(table, typename)
    local typen = nil

    for _, value in ipairs(table) do
        typen = type(value)

        if typen == typename then
            return true
        end
    end

    return false, typen
end

return utility