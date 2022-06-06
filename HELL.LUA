--------------------
-- Initialisation --
--------------------
local ffi = require 'ffi'
local surface = require 'gamesense/surface' 
local outlinedtext = surface.create_font("Smallest Pixel-7", 10, 300, 0x200)
local getlocalplayer = entity.get_local_player

---------------------
-- Welcome Message --
---------------------
local function multicolor_log(...)

    local args = {...}
    local len = #args

        for i=1, len do
            local arg = args[i]
            local r, g, b = unpack(arg)
    
            local msg = {}
    
            if #arg == 3 then
                table.insert(msg, " ")
            else
                for i=4, #arg do
                    table.insert(msg, arg[i])
                end
            end
            msg = table.concat(msg)
    
            if len > i then
                msg = msg .. "\0"
            end
    
            client.color_log(r, g, b, msg)
        end
        
end

---------------
-- HWID Lock --
---------------
local unload = ui.reference("MISC", "Settings", "Unload") 

local ffi = require 'ffi'
local SEXWAT = {
    "2906b728f", -- ME
    "290697093", -- ASH
    "2905eb45a", -- BABUBISLERI
    "29068e61e", -- MRIDUL
    "2906be71a", -- ZEHER
}

local MaterialAdapterInfo_t = ffi.typeof([[ 
    struct {
        char m_pDriverName[512];
        unsigned int m_VendorID;
        unsigned int m_DeviceID;
        unsigned int m_SubSysID;
        unsigned int m_Revision;
        int m_nDXSupportLevel;
        int m_nMinDXSupportLevel;
        int m_nMaxDXSupportLevel;
        unsigned int m_nDriverVersionHigh;
        unsigned int m_nDriverVersionLow;
    }                                                                                               
]])

local get_current_adapter = vtable_bind('materialsystem.dll', 'VMaterialSystem080', 25, 'int(__thiscall*)(void*)')
local get_adapter_info = vtable_bind('materialsystem.dll', 'VMaterialSystem080', 26, 'void(__thiscall*)(void*, int, void*)')

local current_adapter = get_current_adapter()

local adapter_struct = ffi.new(MaterialAdapterInfo_t)

get_adapter_info(current_adapter, adapter_struct)

local vendorId = tostring(adapter_struct['m_VendorID'])
local deviceId = tostring(adapter_struct['m_DeviceID'])

local FUCKED = vendorId..deviceId

local SEXFUSCATED = string.format("%x", FUCKED * 255)

local SEXCHECK = false

for FUCKED, value in pairs(SEXWAT) do
    if value == SEXFUSCATED then
        SEXCHECK = true
    end
end

if SEXCHECK then
    multicolor_log({255, 255, 255, 'Welcome to '}, {255, 0, 0, 'HELL'})
else ui.set(unload, true)
end

local function DoNothing()
end

-------------------
-- Menu Creation --
-------------------
--local hellbutton = ui.new_button("LUA", "B", "HELL.LUA", DoNothing)
local indicatoronref = ui.new_checkbox("LUA", "B", "HELL Indicators")
local indicatorcomboboxref = ui.new_combobox("LUA", "B", "HELL Indicator Type", {"HELL", "HELL v2", "Override"})
local helltickref = ui.new_checkbox("LUA", "B", "HELL Tick")
local helltickcomboboxref = ui.new_combobox("LUA", "B", "HELL Tick Type", {"HELL Dash", "HELL Shift"})
local hellshiftkey = ui.new_hotkey("LUA", "B", "HELL Shift Key", false)
local HellLogs = ui.new_checkbox("LUA", "B", "HELL Logs")
local HELLScreenLogs = ui.new_checkbox("LUA", "B", "HELL Onscreen Logs")
local helldt = ui.new_checkbox("LUA", "B", "HELL Tap")

---------------------
-- Menu References --
---------------------
local menucolor = ui.reference("MISC", "Settings", "Menu color")
local dtbutton, dtkey = ui.reference("RAGE", "Other", "Double Tap")
local hideshotbutton, hskey = ui.reference("AA", "Other", "On shot anti-aim")  
local fakeduckkey = ui.reference("RAGE", "Other", "Duck peek assist") 
local slowwalkbutton, slowwalkkey = ui.reference("AA", "Other", "Slow Motion") 
local baimkey = ui.reference("RAGE", "Other", "Force body aim") 
local mindmgref = ui.reference("RAGE", "Aimbot", "Minimum Damage")
local apbutton, apkey = ui.reference("RAGE", "Other", "Quick peek assist")
local fakelaglimit = ui.reference("AA", "Fake lag", "Limit")
local slowmotyperef = ui.reference("AA", "Other", "Slow motion type")
local pingspikeref = ui.reference("MISC", "Miscellaneous", "Ping Spike")
local dtquickstops = ui.reference("RAGE", "Other", "Double tap quick stop")
local unlocktick = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
local dtref = ui.reference("RAGE", "Other", "Double tap")
local freestanding, freestandingkey = ui.reference("AA", "Anti-Aimbot Angles", "Freestanding")
local dtmode = ui.reference("RAGE", "Other", "Double Tap Mode")
local indicatorcboxref = ui.reference("LUA", "B", "HELL Indicator Type")
local helltickcboxref = ui.reference("LUA", "B", "HELL Tick Type")
local dtfllimit = ui.reference("RAGE", "Other", "Double tap fake lag limit")
local dthitchance = ui.reference("RAGE", "Other", "Double tap hit chance")

-----------------
-- Show / Hide --
-----------------
ui.set_visible(indicatorcboxref, false)
ui.set_visible(hellshiftkey, false)
ui.set_visible(helltickcboxref, false)
ui.set_visible(unlocktick, true)

client.set_event_callback('paint_ui', function()

    local itboxvsref = ui.reference ("LUA", "B", "HELL Tick Type")
    local incboxvsref = ui.reference ("LUA", "B", "HELL Indicator Type")
    local helltickcomboboxget = ui.get(helltickcomboboxref)
    local helltickvisible = 0

    if ui.get(indicatoronref) then
        ui.set_visible(indicatorcboxref, true)
    else 
        ui.set_visible(indicatorcboxref, false)
    end

    if ui.get(helltickref) then
        ui.set_visible(helltickcboxref, true)
        helltickvisible = 1
    else 
        ui.set_visible(helltickcboxref, false)
        helltickvisible = 0
    end

    if helltickvisible and helltickcomboboxget == "HELL Shift" then
        ui.set_visible(hellshiftkey, true)
    else ui.set_visible(hellshiftkey, false)
    end

    if helltickvisible == 0 then
        ui.set_visible(hellshiftkey, false)
    end

end)

------------
-- Others --
------------
client.set_cvar("sv_party_mode", 1)

ui.set(menucolor, 137, 64, 64, 255)

---------------------------
-- Get Current Weapon --
---------------------------
local function curr_weapon(players)

    local wpn=entity.get_player_weapon(players)
    local curr_weapon
    local currentweaponenm=entity.get_prop(wpn, "m_iItemDefinitionIndex") 
    if currentweaponenm == 40 then
        curr_weapon = "Scout"
            elseif currentweaponenm == 11 or currentweaponenm == 38 then
                curr_weapon="Auto"
                elseif currentweaponenm == 9  then
                    curr_weapon="AWP"
                    elseif currentweaponenm == 64 or currentweaponenm == 1 or currentweaponenm == 61 or currentweaponenm == 4 or currentweaponenm == 2 or currentweaponenm == 36 or currentweaponenm == 63 or currentweaponenm == 3 or currentweaponenm == 30 then
                        curr_weapon="Pistol"
                        else
                            curr_weapon="Others"
    end
    return curr_weapon
    
end

local CurrentWeaponName        
client.set_event_callback("paint", function()
    CurrentWeaponName = curr_weapon(getlocalplayer())
    -- client.log (CurrentWeaponName) -- Logs Name Of Weapon In Hand
end)

----------------------------------------
-- Main HELL Indicator Initialisation --
----------------------------------------
local function test(r1, g1, b1, a1, r2, g2, b2, a2, str)

    local output = ''

    local len = #str

    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len

    for i=1, len do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, str:sub(i, i))

        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end

    return output

end

---------------
-- HELL Tick --
---------------

client.set_event_callback("paint", function()

    local helltickcomboboxget = ui.get (helltickcomboboxref)
    local helltickboxget = ui.get(helltickref)
    local hellshiftkeyon = ui.get(hellshiftkey)
    local is_doubletapping = ui.get(dtkey)
    local is_baiming = ui.get(baimkey)

    if helltickcomboboxget == "HELL Dash" and helltickboxget then
        
        local is_autopeeking = ui.get(apkey)
        local is_doubletapping = ui.get(dtkey)
        local slowmotype = ui.get(slowmotyperef)

        if is_autopeeking and is_doubletapping then
            helltickenable = 1
        else helltickenable = 0
        end

        ui.set(dtref, true)

        if helltickenable == 1 then
            ui.set(fakelaglimit, 1)
            ui.set(pingspikeref, true)
            ui.set(dtquickstops, {"Slow Motion", "Move between shots"})
            --ui.set(unlocktick, 19)
            ui.set(dtmode, "Defensive")
            ui.set(slowmotyperef, "Favor Anti-Aim")

        else 
            ui.set(fakelaglimit, 15)
            ui.set(pingspikeref, false)
            ui.set(dtquickstops, {"Slow Motion", "Move between shots"})
            --ui.set(unlocktick, 16)
            ui.set(dtmode, "Defensive")
            ui.set(slowmotyperef, "Favor High Speed")
        end

    elseif helltickcomboboxget == "HELL Shift" and helltickboxget then

        if hellshiftkeyon then
            ui.set(fakelaglimit, 1)
            ui.set(pingspikeref, true)
            ui.set(dtquickstops, {"Slow Motion", "Move between shots"})
            ui.set(dtref, true)
            --ui.set(unlocktick, 19)
            ui.set(freestandingkey, "Always On")
            ui.set(freestanding, "Default")
            ui.set(apbutton, true)
            ui.set(apkey, "Always On")
            ui.set(dtmode, "Defensive")
            ui.set(dtkey, "Always On")
            ui.set(slowmotyperef, "Favor Anti-Aim")

        else 
            ui.set(fakelaglimit, 15)
            ui.set(pingspikeref, false)
            ui.set(dtquickstops, {"Slow Motion", "Move between shots"})
            --ui.set(unlocktick, 16)
            ui.set(freestandingkey, "On Hotkey")
            ui.set(freestanding, "-")
            ui.set(apbutton, false)
            ui.set(apkey, "On Hotkey")
            ui.set(dtmode, "Defensive")
            ui.set(dtkey, "Toggle")
            ui.set(slowmotyperef, "Favor High Speed")
            
        end
    end

    if not helltickboxget then
        ui.set(apbutton, true)
    end

end)

---------------------
-- HELL Indicators --
---------------------

client.set_event_callback("paint", function()

    local screenx, screeny = client.screen_size()
    local slowwalkon = 0
    local mindmgon = 0

    local hellblue = test(255, 0, 0, 255, 74, 185, 255, 255, 'HELL')
    local hellgrey = test(255, 255, 255, 255, 108, 112, 112, 255, 'HELL')
    local str2 = test(255, 255, 255, 255, 108, 112, 112, 255, 'MINIMUM   DAMAGE')
    local strdtia = test(255, 255, 255, 255, 108, 112, 112, 255, 'EXPLOITS   OFF')
    local strdta = test(255, 255, 255, 255, 108, 112, 112, 255, 'DT   ACTIVE')
    local strhs = test(255, 255, 255, 255, 108, 112, 112, 255, 'HIDE   SHOTS')
    local strfl = test(255, 255, 255, 255, 108, 112, 112, 255, 'FAKELAG')
    local strfd = test(255, 255, 255, 255, 108, 112, 112, 255, 'FAKE   DUCK')
    local strswalk = test(255, 255, 255, 255, 108, 112, 112, 255, 'SLOW   WALK')
    local strmindmg = test(255, 255, 255, 255, 108, 112, 112, 255, 'MINIMUM   DAMAGE')
    local strfbaim = test(255, 255, 255, 255, 108, 112, 112, 255, 'FORCE   BAIM')
    local stridealtick = test(255, 255, 255, 255, 108, 112, 112, 255, 'HELL   SHIFT')

    local is_doubletapping = ui.get(dtkey)
    local is_hideshotting = ui.get(hskey)
    local is_fakeducking = ui.get(fakeduckkey)
    local is_walking = ui.get(slowwalkkey)
    local is_baiming = ui.get(baimkey)
    local indicatorcboxget = ui.get(indicatorcomboboxref)
    local mindmg = ui.get(mindmgref)
    local indicatorsonref = ui.get(indicatoronref)
    local helltickcomboboxget = ui.get (helltickcomboboxref)
    local hellshiftkeyon = ui.get(hellshiftkey)

    local fdon = 0
    local slowwalkon = 0
    local mindmgon = 0

-----------------------------
-- MultiColored Indicators --
-----------------------------

    if indicatorcboxget == "HELL" and indicatorsonref then

        if(entity.is_alive(getlocalplayer())) then
            
            -- HELL --
            renderer.text(screenx / 2 - 10, screeny / 2 + 21, 255, 255, 255, 255, '-', 0, hellblue)

            -- DOUBLETAP --
            if helltickcomboboxget == "HELL Dash" then
                if is_doubletapping then
                    surface.draw_text(screenx / 2 - 22, screeny / 2 + 33, 57, 151, 117, 255, outlinedtext, "DOUBLETAP")
                else surface.draw_text(screenx / 2 - 22, screeny / 2 + 33, 255, 0, 102, 255, outlinedtext, "DOUBLETAP")
                end

            elseif helltickcomboboxget == "HELL Shift" then
                if hellshiftkeyon and is_doubletapping then
                    surface.draw_text(screenx / 2 - 24, screeny / 2 + 33, 57, 151, 117, 255, outlinedtext, "HELL SHIFT")

                elseif is_doubletapping then
                    surface.draw_text(screenx / 2 - 22, screeny / 2 + 33, 57, 151, 117, 255, outlinedtext, "DOUBLETAP")

                else
                    surface.draw_text(screenx / 2 - 27, screeny / 2 + 33, 255, 0, 102, 255, outlinedtext, "EXPLOITS OFF")
                    
                end
            end

            
            -- HIDE SHOTS / FAKELAG --
            if is_hideshotting then
                surface.draw_text(screenx / 2 - 24, screeny / 2 + 44, 90, 113, 191, 255, outlinedtext, "HIDE SHOTS")
            else surface.draw_text(screenx / 2 - 18, screeny / 2 + 44, 255, 153, 0, 255, outlinedtext, "FAKELAG")
            end

            -- FAKEDUCK --
            if is_fakeducking then
                surface.draw_text(screenx / 2 - 23, screeny / 2 + 55, 161, 76, 158, 255, outlinedtext, "FAKE DUCK")
                fdon = 1
            else fdon = 0
            end

            -- SLOWWALK --
            if is_walking then
                slowwalkon = 1
                surface.draw_text(screenx / 2 - 24, screeny / 2 + 55, 199, 165, 0, 255, outlinedtext, "SLOW WALK")
            else slowwalkon = 0
            end

            -- MINDMG OVERRIDE --
            if CurrentWeaponName == "AWP"and mindmg <= 30 or CurrentWeaponName == "Scout" and mindmg <= 30 or CurrentWeaponName == "Pistol" and mindmg <= 8 or CurrentWeaponName == "Auto" and mindmg <= 10 then
                if fdon == 1 or slowwalkon == 1 then
                        surface.draw_text(screenx / 2 - 35, screeny / 2 + 66, 255, 0, 102, 255, outlinedtext, "MINIMUM DAMAGE")
                            elseif fdon == 0 or slowwalkon == 0 then
                                surface.draw_text(screenx / 2 - 35, screeny / 2 + 55, 255, 0, 102, 255, outlinedtext, "MINIMUM DAMAGE")
                    else mindmgon = 0
                end
            end

            if CurrentWeaponName == "AWP" and mindmg <= 30 or CurrentWeaponName == "Scout" and mindmg <= 30 or CurrentWeaponName == "Pistol" and mindmg <= 8 or CurrentWeaponName == "Auto" and mindmg <= 10 then 
                    mindmgon = 1
            else    mindmgon = 0
            end

            -- FORCE BAIM --
            if is_baiming then
                if slowwalkon == 0 and fdon == 0 and mindmgon == 0 then
                    surface.draw_text(screenx / 2 - 26, screeny / 2 + 55, 76, 50, 219, 255, outlinedtext, "FORCE BAIM")
                elseif slowwalkon == 1 and mindmgon == 0 then
                    surface.draw_text(screenx / 2 - 26, screeny / 2 + 66, 76, 50, 219, 255, outlinedtext, "FORCE BAIM")
                elseif fdon == 1 and mindmgon == 0 then
                    surface.draw_text(screenx / 2 - 26, screeny / 2 + 66, 76, 50, 219, 255, outlinedtext, "FORCE BAIM")
                elseif slowwalkon == 0 and fdon == 0 and mindmgon == 1 then
                    surface.draw_text(screenx / 2 - 26, screeny / 2 + 66, 76, 50, 219, 255, outlinedtext, "FORCE BAIM")
                elseif fdon == 1 or slowwalkon == 1 and mindmgon == 1 then
                    surface.draw_text(screenx / 2 - 26, screeny / 2 + 77, 76, 50, 219, 255, outlinedtext, "FORCE BAIM")
                end
            end
        end

        -------------------------------
        -- Grey Indicators (HELL v2) --
        -------------------------------

    elseif indicatorcboxget == "HELL v2" and indicatorsonref then

        if(entity.is_alive(getlocalplayer())) then
            
            -- HELL --
            renderer.text(screenx / 2 - 10, screeny / 2 + 21, 255, 255, 255, 255, '-', 0, hellgrey) 

            -- DOUBLETAP --

            if helltickcomboboxget == "HELL Dash" then
                if is_doubletapping then
                    renderer.text(screenx / 2 - 20, screeny / 2 + 33, 179, 86, 86, 255, '-', 0, strdta)
                else renderer.text(screenx / 2 - 25, screeny / 2 + 33, 179, 86, 86, 255, '-', 0, strdtia)
                end

            elseif helltickcomboboxget == "HELL Shift" then

                
                if hellshiftkeyon and is_doubletapping then
                    renderer.text(screenx / 2 - 21, screeny / 2 + 33, 179, 86, 86, 255, '-', 0, stridealtick)

                elseif is_doubletapping then
                    renderer.text(screenx / 2 - 20, screeny / 2 + 33, 179, 86, 86, 255, '-', 0, strdta)
            
                else
                    renderer.text(screenx / 2 - 25, screeny / 2 + 33, 179, 86, 86, 255, '-', 0, strdtia)

                end

            end
            
            -- HIDE SHOTS / FAKELAG --
            if is_hideshotting then
                renderer.text(screenx / 2 - 23, screeny / 2 + 44, 179, 86, 86, 255, '-', 0, strhs)
            else renderer.text(screenx / 2 - 18, screeny / 2 + 44, 179, 86, 86, 255, '-', 0, strfl)
            end

            -- FAKEDUCK --
            if is_fakeducking then
                renderer.text(screenx / 2 - 22, screeny / 2 + 55, 179, 86, 86, 255, '-', 0, strfd)
                fdon = 1
            else fdon = 0
            end

            -- SLOWWALK --
            if is_walking then
                renderer.text(screenx / 2 - 24, screeny / 2 + 55, 179, 86, 86, 255, '-', 0, strswalk)
                slowwalkon = 1
            else slowwalkon = 0
            end

            -- MINDMG OVERRIDE --
            if CurrentWeaponName == "AWP"and mindmg <= 30 or CurrentWeaponName == "Scout" and mindmg <= 30 or CurrentWeaponName == "Pistol" and mindmg <= 8 or CurrentWeaponName == "Auto" and mindmg <= 10 then
                if fdon == 1 or slowwalkon == 1 then
                    renderer.text(screenx / 2 - 35, screeny / 2 + 66, 179, 86, 86, 255, '-', 0, strmindmg)

                elseif fdon == 0 or slowwalkon == 0 then
                    renderer.text(screenx / 2 - 35, screeny / 2 + 55, 179, 86, 86, 255, '-', 0, strmindmg)

                else mindmgon = 0
                end
            end

            if CurrentWeaponName == "AWP" and mindmg <= 30 or CurrentWeaponName == "Scout" and mindmg <= 30 or CurrentWeaponName == "Pistol" and mindmg <= 8 or CurrentWeaponName == "Auto" and mindmg <= 10 then 
                    mindmgon = 1
            else    mindmgon = 0
            end

            -- FORCE BAIM --
            if is_baiming then
                if slowwalkon == 0 and fdon == 0 and mindmgon == 0 then
                    renderer.text(screenx / 2 - 25, screeny / 2 + 55, 179, 86, 86, 255, '-', 0, strfbaim)
                elseif slowwalkon == 1 and mindmgon == 0 then
                    renderer.text(screenx / 2 - 25, screeny / 2 + 66, 179, 86, 86, 255, '-', 0, strfbaim)
                elseif fdon == 1 and mindmgon == 0 then
                    renderer.text(screenx / 2 - 25, screeny / 2 + 66, 179, 86, 86, 255, '-', 0, strfbaim)
                elseif slowwalkon == 0 and fdon == 0 and mindmgon == 1 then
                    renderer.text(screenx / 2 - 25, screeny / 2 + 66, 179, 86, 86, 255, '-', 0, strfbaim)
                elseif fdon == 1 or slowwalkon == 1 and mindmgon == 1 then
                    renderer.text(screenx / 2 - 25, screeny / 2 + 77, 179, 86, 86, 255, '-', 0, strfbaim)
                end
            end
        end

        -------------------------
        -- Override Indicators --
        -------------------------

    elseif indicatorcboxget == "Override" and indicatorsonref then

        if(entity.is_alive(getlocalplayer())) then

            if CurrentWeaponName == "AWP" and mindmg <= 30 or CurrentWeaponName == "Scout" and mindmg <= 30 or CurrentWeaponName == "Pistol" and mindmg <= 8 or CurrentWeaponName == "Auto" and mindmg <= 10 then

                    if(entity.is_alive(entity.get_local_player())) then
                        local screenx, screeny = client.screen_size()
                            renderer.text(screenx / 2 - 33, screeny / 2 - 26, 255, 255, 255, 255, '-', 0, str2)
                    end

            end
    
            if CurrentWeaponName == "AWP"and mindmg <= 30 or CurrentWeaponName == "Scout" and mindmg <= 30 or CurrentWeaponName == "Pistol" and mindmg <= 8 or CurrentWeaponName == "Auto" and mindmg <= 10 then 
                    mindmgon = 1
            else    mindmgon = 0
            
            end

        end

    end

end)

---------------
-- HELL Logs --
---------------

client.set_event_callback("paint", function()
    HellLogsGet = ui.get(HellLogs)
end)

local function MultiColorLog(...)

    local args = {...}
    local len = #args
    for i=1, len do
        local arg = args[i]
        local r, g, b = unpack(arg)
    local msg = {}

    if #arg == 3 then
        table.insert(msg, " ")

    else
        for i=4, #arg do
            table.insert(msg, arg[i])
        end
    end

    msg = table.concat(msg)

    if len > i then
        msg = msg .. "\0"
    end

    client.color_log(r, g, b, msg)
    end

end

local hitgroup_names = { "Body", "Head", "Chest", "Stomach", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Neck", "Unknown", "Gear" }

local function on_player_hurt(hurt)

    local userid = hurt.userid
    local attacker = hurt.attacker
    local health = hurt.health
    local armor = hurt.armor
    local weapon = hurt.weapon
    local dmg_health = hurt.dmg_health
    local dmg_armor = hurt.dmg_armor
    local hitgroup = hurt.hitgroup

    if userid == nil or attacker == nil or hitgroup < 0 or hitgroup > 10 or dmg_health == nil or health == nil then
        return
    end

    if client.userid_to_entindex(userid) == entity.get_local_player() then

        local damager = entity.get_player_name(client.userid_to_entindex(attacker))
        
        local hitbox_hit = hitgroup_names[hitgroup + 1]
        
        if hitbox_hit and HellLogsGet then
            MultiColorLog({110, 172, 254, "[HELL] "}, {255, 255, 255, "Got hit by "}, {255, 255, 255, damager}, {255, 255, 255, "for "}, {255, 255, 255, dmg_health}, {255, 255, 255, " in "}, {255, 255, 255, hitbox_hit}, {255, 255, 255, " | Remaining HP: "}, {255, 255, 255, health})
        end
    end

end

local BackTrackInfo = {}

local function time_to_ticks(t)

    return math.floor(0.5 + (t / globals.tickinterval()))

end

local function shot_logs (fired)

    BackTrackInfo = globals.tickcount()-fired.tick > 0 and (((globals.tickcount()-fired.tick) * globals.tickinterval()) * 1000) or 0
    AimFireDamage = fired.damage
    AimFireGroup = hitgroup_names[fired.hitgroup + 1] or 'unknown'
    AimFireBacktrack = fired.backtrack

end

local function hit_logs (hit)

    local target = hit.target
    local nameofenemyhit = entity.get_player_name(hit.target)
    local damagegiven = hit.damage
    local hitbox = hitgroup_names[hit.hitgroup + 1] or 'unknown'
    local remaininghp = entity.get_prop(hit.target, 'm_iHealth')
    local predicteddamage = AimFireDamage
    local predictedhitbox = AimFireGroup
    local predictedbacktrackticks = AimFireBacktrack
    local angleshotat = math.floor(entity.get_prop(target, "m_flPoseParameter", 11) * 120 - 60)
    local btshotflt = math.max(0, BackTrackInfo)
    local btshotinms = math.floor (btshotflt)
    local btshotinseconds = btshotinms / 1000
    local btshot = math.floor ((btshotinseconds / globals.tickinterval()) + 0.5)

    if HellLogsGet == true then
        MultiColorLog({180, 228, 20, "[HELL] "}, {255, 255, 255, "Damaged "}, {255, 255, 255, nameofenemyhit}, {255, 255, 255, " for "}, {255, 255, 255, damagegiven}, {255, 255, 255, " in the "}, {255, 255, 255, hitbox}, {255, 255, 255, " (HP Remaining: "}, {255, 255, 255, remaininghp}, {255, 255, 255, ") | Shot For "}, {255, 255, 255, predicteddamage}, {255, 255, 255, " HP in "}, {255, 255, 255, predictedhitbox}, {255, 255, 255, " | Backtrack: "}, {255, 255, 255, btshot}, {255, 255, 255, " ticks | Angle: "}, {255, 255, 255, angleshotat}, {255, 255, 255,"°"})
    end

end

local function miss_logs (miss)

    local target = miss.target
    local nameofenemymissed = entity.get_player_name(miss.target)
    local predicteddamage = AimFireDamage
    local predictedhitbox = AimFireGroup
    local missreason = miss.reason
    local predictedbacktrackticks = AimFireBacktrack
    local angleshotat = math.floor(entity.get_prop(target, "m_flPoseParameter", 11) * 120 - 60 )
    local btmissflt = math.max(0, BackTrackInfo)
    local btmissinms = math.floor (btmissflt)
    local btmissinseconds = btmissinms / 1000
    local btmiss = math.floor ((btmissinseconds / globals.tickinterval()) + 0.5)

    if missreason == '?' then
        missreason = 'unknown'
    end

    if HellLogsGet == true then
        MultiColorLog({200, 50, 50, "[HELL] "}, {255, 255, 255, "Missed "}, {255, 255, 255, nameofenemymissed}, {255, 255, 255, " for "}, {255, 255, 255, predicteddamage}, {255, 255, 255, " in the "}, {255, 255, 255, predictedhitbox}, {255, 255, 255, " due to "}, {255, 255, 255, missreason}, {255, 255, 255, " | Backtrack: "}, {255, 255, 255, btmiss}, {255, 255, 255, " ticks | Angle: "}, {255, 255, 255, angleshotat}, {255, 255, 255,"°"})
    end

end


------------------------
-- HELL Onscreen Logs --
------------------------
local screenx, screeny = client.screen_size()
local shottable = {}


local function aim_hit(hit)

    local group = hitgroup_names[hit.hitgroup + 1] or '?'
    local curtime = globals.curtime()
    
    hitlog = ('\aFFFFFFFFHit  \a6EEB34FF%s  \aFFFFFFFFin  the  \a6EEB34FF%s  \aFFFFFFFFfor  \a6EEB34FF%d  \aFFFFFFFFdamage  (\a6EEB34FF%d  \aFFFFFFFFhealth  remaining)'):format(entity.get_player_name(hit.target), group, hit.damage, entity.get_prop(hit.target, 'm_iHealth')):upper()

    table.insert(shottable, {
        time = curtime,
        info = hitlog
    })

end


local function aim_miss(miss)

    if miss.reason == '?' then
        miss.reason = 'unknown'
    end

    if miss.reason == 'prediction error' then
        miss.reason = 'prediction  error'
    end

    local group = hitgroup_names[miss.hitgroup + 1] or '?'
    local curtime = globals.curtime()

    misslog = ("\aFFFFFFFFMissed  \aF06565FF%s\aFFFFFFFF's  \aF06565FF%s  \aFFFFFFFFdue  to  \aF06565FF%s"):format(entity.get_player_name(miss.target), group, miss.reason):upper()

    table.insert(shottable, {
        time = curtime,
        info = misslog
    })
 
end


local function renderlog(render)

    local curtime = globals.curtime()
    local y1 = 0

    if ui.get(HELLScreenLogs) then

        for key, log in ipairs(shottable) do
            local elapsed = curtime - log.time
            if elapsed >= 3 then
                table.remove(shottable, key)
            end
            local pct = math.max(0, math.min(1, (3 - elapsed) / 3))
            
            alpha = 255 * pct
            renderer.text(screenx / 2, (screeny / 2 + 300) + y1, 255, 255, 255, alpha, 'c-', 0, log.info)
            y1 = y1 + 12

        end 
    
    end
    
end


local function level_init()
    shottable = {}
end

---------------
-- CallBacks --
---------------
client.set_event_callback('aim_hit', hit_logs)
client.set_event_callback('aim_miss', miss_logs)
client.set_event_callback("player_hurt", on_player_hurt)
client.set_event_callback("aim_fire", shot_logs)
client.set_event_callback('aim_hit', aim_hit)
client.set_event_callback('aim_miss', aim_miss)
client.set_event_callback('paint', renderlog)
client.set_event_callback('level_init', level_init)

--------------------
-- HELL DoubleTap --
--------------------

client.set_event_callback('paint', function()

    if ui.get(helldt) then

        local ping = client.latency() * 1000

        if ping <= 65 then

            ui.set(unlocktick, 18)
            cvar.cl_clock_correction:set_int(0)
            ui.set(dtfllimit, 1)
            ui.set(dthitchance, 15)
            
        elseif ping >= 65 and ping <= 150  then
            ui.set(unlocktick, 17)
            cvar.cl_clock_correction:set_int(0)
            ui.set(dtfllimit, 1)
            ui.set(dthitchance, 25)
            
        else
            
            ui.set(unlocktick, 16)
            cvar.cl_clock_correction:set_int(1)
            ui.set(dtfllimit, 1)
            ui.set(dthitchance, 20)
        
        end

    else
        
        ui.set(unlocktick, 16)

    end

end)