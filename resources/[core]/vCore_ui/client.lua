function ShowMulticharMenuAfterLoading()
    -- Hide loading screen NUI
    TriggerEvent('vLoadScreen:hide') -- Or use SendNUIMessage if that's your method
    -- Wait a short moment to ensure it's hidden
    Citizen.Wait(500)
    -- Now request/show the multichar menu
    TriggerServerEvent('vMultichar:requestMenu')
end

-- Example: Call this after player has spawned and data is ready
AddEventHandler('playerSpawned', function()
    ShowMulticharMenuAfterLoading()
end)