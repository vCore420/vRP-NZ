function ShowLoadingScreen(text)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "showLoading", text = text or "Loading, please wait..." })
end

function HideLoadingScreen()
    SendNUIMessage({ action = "hideLoading" })
end

RegisterNetEvent('vLoadScreen:show', function(text)
    ShowLoadingScreen(text)
end)

RegisterNetEvent('vLoadScreen:hide', function()
    SendNUIMessage({ action = "hideLoading" })
    SetNuiFocus(false, false)
end)