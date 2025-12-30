local isMenuOpen = false
local cam = nil
local previewPed = nil
local savedPos = nil
local savedHeading = nil

local function focusPreviewArea(coords)
    SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    NewLoadSceneStartSphere(coords.x, coords.y, coords.z, 60.0, 0)
    local timeout = GetGameTimer() + 4000
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        Wait(0)
        if GetGameTimer() > timeout then break end
    end
    NewLoadSceneStop()
end

local function restorePlayer()
    local ped = PlayerPedId()
    if savedPos then
        SetEntityCoordsNoOffset(ped, savedPos.x, savedPos.y, savedPos.z, false, false, false)
        SetEntityHeading(ped, savedHeading or 0.0)
    end
    SetEntityVisible(ped, true, false)
    FreezeEntityPosition(ped, false)
    ClearFocus()
    savedPos, savedHeading = nil, nil
end

-- Open the character selection menu with character data from server
RegisterNetEvent('vMultichar:openMenu', function(characters)
    local ped = PlayerPedId()
    local camCfg = Config.Camera
    local pedCfg = Config.Ped
    local model = Config.DefaultPeds.male

    -- Keep loading screen up while we prep
    TriggerEvent('vLoadScreen:show', 'Loading characters...')

    -- Save player state and move them to preview area (hidden) to force streaming
    savedPos = GetEntityCoords(ped)
    savedHeading = GetEntityHeading(ped)
    SetEntityCoordsNoOffset(ped, pedCfg.coords.x, pedCfg.coords.y, pedCfg.coords.z + 1.0, false, false, false)
    SetEntityVisible(ped, false, false)
    FreezeEntityPosition(ped, true)
    focusPreviewArea(pedCfg.coords)

    -- Delete old cam/ped if any
    if cam then DestroyCam(cam, false) cam = nil end
    if previewPed then DeleteEntity(previewPed) previewPed = nil end

    -- Load model
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    -- Spawn preview ped
    previewPed = CreatePed(4, model, pedCfg.coords.x, pedCfg.coords.y, pedCfg.coords.z, pedCfg.heading, false, true)
    SetEntityInvincible(previewPed, true)
    FreezeEntityPosition(previewPed, true)
    SetBlockingOfNonTemporaryEvents(previewPed, true)

    -- Create camera
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, camCfg.coords.x, camCfg.coords.y, camCfg.coords.z)
    SetCamRot(cam, camCfg.rotation.x, camCfg.rotation.y, camCfg.rotation.z, 2)
    SetCamFov(cam, camCfg.fov)
    PointCamAtEntity(cam, previewPed, 0.0, 0.0, 0.8, true)
    RenderScriptCams(true, true, 500, true, true)

    -- Now hide loading screen and show menu
    TriggerEvent('vLoadScreen:hide')
    Wait(100)
    SetNuiFocus(true, true)
    DisplayRadar(false)
    SendNUIMessage({ action = "showCharacters", characters = characters })
end)

RegisterNetEvent('vMultichar:closeMenu', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hideMenu" })
    DisplayRadar(true)
    if cam then DestroyCam(cam, false) cam = nil end
    if previewPed then DeleteEntity(previewPed) previewPed = nil end
    RenderScriptCams(false, true, 500, true, true)
    restorePlayer()
end)

RegisterNUICallback('setGender', function(data, cb)
    local model = Config.DefaultPeds[data.gender] or Config.DefaultPeds.male
    -- Delete old ped if any
    if previewPed then DeleteEntity(previewPed) previewPed = nil end
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    local pedCfg = Config.Ped
    previewPed = CreatePed(4, model, pedCfg.coords.x, pedCfg.coords.y, pedCfg.coords.z, pedCfg.heading, false, true)
    SetEntityInvincible(previewPed, true)
    FreezeEntityPosition(previewPed, true)
    SetEntityAlpha(previewPed, 255, false)
    SetBlockingOfNonTemporaryEvents(previewPed, true)
    -- Optionally, update camera if needed
    cb('ok')
end)

RegisterNUICallback('submitCharCreate', function(data, cb)
    -- Clean up camera and ped for now, change this later when you return to this script
    if cam then DestroyCam(cam, false) cam = nil end
    if previewPed then DeleteEntity(previewPed) previewPed = nil end
    RenderScriptCams(false, true, 500, true, true)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hideMenu" })
    DisplayRadar(true)
    cb('ok')
end)

-- NUI Callbacks
RegisterNUICallback('selectSlot', function(data, cb)
    -- Update camera/model preview here
    TriggerEvent('vMultichar:previewCharacter', data.slot)
    cb('ok')
end)

RegisterNUICallback('playCharacter', function(data, cb)
    TriggerServerEvent('vMultichar:playCharacter', data.slot)
    cb('ok')
end)

RegisterNUICallback('createCharacter', function(data, cb)
    TriggerServerEvent('vMultichar:createCharacter', data.slot)
    cb('ok')
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
    TriggerServerEvent('vMultichar:deleteCharacter', data.slot)
    cb('ok')
end)

-- Example: Listen for preview event and update camera/model
RegisterNetEvent('vMultichar:previewCharacter', function(slot)
    -- TODO: Teleport player to preview area, spawn ped, set camera, etc.
end)