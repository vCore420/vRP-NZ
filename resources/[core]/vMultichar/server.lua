local oxmysql = exports.oxmysql

RegisterNetEvent('vMultichar:requestMenu', function()
    local src = source
    local identifier = GetPlayerIdentifier(src, 0) -- Use license/steam for production

    -- Fetch up to 5 characters for this player
    oxmysql:execute('SELECT * FROM players WHERE identifier = ? LIMIT 5', {identifier}, function(result)
        local characters = {}
        for i = 1, 5 do
            characters[i] = result[i] or nil
        end
        TriggerClientEvent('vMultichar:openMenu', src, characters)
    end)
end)

RegisterNetEvent('vMultichar:playCharacter', function(slot)
    local src = source
    -- TODO: Load character data, spawn player, close menu
    TriggerClientEvent('vMultichar:closeMenu', src)
end)

RegisterNetEvent('vMultichar:createCharacter', function(slot)
    local src = source
    -- TODO: Open character creation UI for this slot
    TriggerClientEvent('vMultichar:closeMenu', src)
end)

RegisterNetEvent('vMultichar:deleteCharacter', function(slot)
    local src = source
    -- TODO: Delete character from DB, refresh menu
    -- After deletion, re-send updated character list:
    -- TriggerClientEvent('vMultichar:openMenu', src, updatedCharacters)
end)