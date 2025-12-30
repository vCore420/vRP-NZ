-- Database logic for vRP NZ Core

vCore = vCore or {}
vCore.DB = vCore.DB or {}

-- Table registry for all schemas
vCore.DB.TableSchemas = {}

-- Register a table schema
function vCore.DB.RegisterTable(name, schema)
    vCore.DB.TableSchemas[name] = schema
end

-- Call this on server start to create all tables if missing
function vCore.DB.InitTables()
    for name, schema in pairs(vCore.DB.TableSchemas) do
        local sql = ("CREATE TABLE IF NOT EXISTS %s (%s)"):format(name, schema)
        exports.oxmysql:execute(sql, {}, function()
            print(("[vCore] Checked/created table: %s"):format(name))
        end)
    end
end

-- Register the players table schema
vCore.DB.RegisterTable("players", [[
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50) NOT NULL UNIQUE,
    id_name VARCHAR(50),
    player_name VARCHAR(50),
    money INT DEFAULT 0,
    xp INT DEFAULT 0,
    wanted_level INT DEFAULT 0,
    cars_owned JSON,
    houses_owned JSON,
    crew VARCHAR(50),
    inventory JSON,
    stats JSON,
    clothing JSON,
    job_type VARCHAR(50),
    job_grade INT DEFAULT 0,
    race_stats JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
]])

-- Add more tables here as needed, e.g.:
-- vCore.DB.RegisterTable("vehicles", [[ ... ]])
-- vCore.DB.RegisterTable("inventory", [[ ... ]])

-- Initialize tables on resource start
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        vCore.DB.InitTables()
    end
end)

-- Existing player data functions...
function vCore.DB.LoadPlayerData(identifier, cb)
    exports.oxmysql:execute('SELECT * FROM players WHERE identifier = ?', {identifier}, function(result)
        if result and result[1] then
            cb(result[1])
        else
            -- Create new player entry if not found
            exports.oxmysql:execute('INSERT INTO players (identifier, name) VALUES (?, ?)', {identifier, "Unknown"}, function()
                cb({identifier = identifier, name = "Unknown", money = 0, xp = 0, crew = nil})
            end)
        end
    end)
end

function vCore.DB.SavePlayerData(identifier, data)
    exports.oxmysql:execute('UPDATE players SET money = ?, xp = ?, crew = ? WHERE identifier = ?', {
        data.money, data.xp, data.crew, identifier
    })
end