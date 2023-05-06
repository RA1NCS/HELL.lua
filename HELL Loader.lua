-------------------------
-- Author : demonlxrd --
-- Date : 03/08/2022 --
-- Welcome to HELL  --
---------------------
--
--
--  ▄  █ ▄███▄   █    █            █       ▄   ██       
-- █   █ █▀   ▀  █    █            █        █  █ █      
-- ██▀▀█ ██▄▄    █    █            █     █   █ █▄▄█     
-- █   █ █▄   ▄▀ ███▄ ███▄         ███▄  █   █ █  █     
--    █  ▀███▀       ▀    ▀   ██       ▀ █▄ ▄█    █     
--   ▀                                    ▀▀▀    █      
--                                              ▀       
--------------------
-- Initialisation --
--------------------
local http = require "gamesense/http"

-----------------
-- Load String --
-----------------


local function loadstringowo()
    http.get("https://raw.githubusercontent.com/RA1NCS/GameSenseLUAScripting/main/HELL.LUA", function(success, response)
        if not success or response.status ~= 200   then
            return
        end
        loadstring(response.body)()
    end)
end

ui.new_button("LUA", "B", "HELL.LUA", loadstringowo)