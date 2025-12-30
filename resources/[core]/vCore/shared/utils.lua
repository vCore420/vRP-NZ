-- Shared utility functions for vRP NZ Core Framework

function TableLength(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end