Config = {}

-- Camera settings for character selection viewport
Config.Camera = {
    coords = vector3(882.4136, -2435.1488, 28.1137),   -- Camera position (x, y, z)
    rotation = vector3(0.0, 0.0, 60.0),     -- Camera rotation (pitch, roll, yaw)
    fov = 40.0                                 -- Field of view
}

-- Ped spawn location for preview
Config.Ped = {
    coords = vector3(880.8757, -2430.2529, 27.0848),   -- Ped position (x, y, z)
    heading = 197.6873                                 -- Ped heading (facing direction)
}

-- Default ped models
Config.DefaultPeds = {
    male = "mp_m_freemode_01",
    female = "mp_f_freemode_01"
}