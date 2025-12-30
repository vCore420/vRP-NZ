-- vCore Client Utilities

vCore = vCore or {}

-- Send notification to NUI
function vCore.Notify(msg, msgtype, duration)
    SendNUIMessage({
        action = "notify",
        data = {
            message = msg,
            type = msgtype or "info",
            duration = duration or 3000
        }
    })
end

-- Listen for server notifications
RegisterNetEvent('vCore:notify', function(msg, msgtype, duration)
    vCore.Notify(msg, msgtype, duration)
end)

-- NUI message helper (for other UI actions)
function vCore.SendNUI(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

function vCore.RegisterNUICallback(action, cb)
    RegisterNUICallback(action, cb)
end

function vCore.Debug(msg)
    if Config and Config.Debug then
        print("[vCore Debug] " .. tostring(msg))
    end
end

exports('Notify', function(src, msg, msgtype, duration)
    vCore.Notify(src, msg, msgtype, duration)
end)