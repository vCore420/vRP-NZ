-- vCore Server Utilities

vCore = vCore or {}

-- Debug print (only if Config.Debug is true)
function vCore.Debug(msg)
    if Config and Config.Debug then
        print("[vCore Debug] " .. tostring(msg))
    end
end

-- Simple event registration helper
function vCore.OnNet(event, cb)
    RegisterNetEvent(event)
    AddEventHandler(event, cb)
end

-- Send notification to a specific player
function vCore.Notify(src, msg, msgtype, duration)
    TriggerClientEvent('vCore:notify', src, msg, msgtype or "info", duration or 3000)
end

-- Broadcast notification to all players
function vCore.NotifyAll(msg, msgtype, duration)
    TriggerClientEvent('vCore:notify', -1, msg, msgtype or "info", duration or 3000)
end

-- Permission/group check stub (expand later)
function vCore.HasPermission(src, perm)
    -- Placeholder: always true for now
    return true
end