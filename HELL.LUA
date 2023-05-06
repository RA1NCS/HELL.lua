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
local ffi = require "ffi"
local surface = require "gamesense/surface"
local bit = require "bit"
local outlinedtext = surface.create_font("Smallest Pixel-7", 10, 300, 0x200)
local getlocalplayer = entity_get_local_player

---------------------
-- Welcome Message --
---------------------
local function multicolor_log(...)
	local args = {...}
	local len = #args

	for i = 1, len do
		local arg = args[i]
		local r, g, b = unpack(arg)

		local msg = {}

		if #arg == 3 then
			table_insert(msg, " ")
		else
			for i = 4, #arg do
				table_insert(msg, arg[i])
			end
		end
		msg = table_concat(msg)

		if len > i then
			msg = msg .. "\0"
		end

		client_color_log(r, g, b, msg)
	end
end

-- ---------------
-- -- HWID Lock --
-- ---------------
-- local unload = ui_reference("MISC", "Settings", "Unload")

-- local ffi = require "ffi"
-- local SEXWAT = {
-- 	"2906b728f" -- ME
-- }

-- local MaterialAdapterInfo_t =
-- ffi.typeof(
-- [[
-- struct {
-- 	char m_pDriverName[512];
-- 	unsigned int m_VendorID;
-- 	unsigned int m_DeviceID;
-- 	unsigned int m_SubSysID;
-- 	unsigned int m_Revision;
-- 	int m_nDXSupportLevel;
-- 	int m_nMinDXSupportLevel;
-- 	int m_nMaxDXSupportLevel;
-- 	unsigned int m_nDriverVersionHigh;
-- 	unsigned int m_nDriverVersionLow;
-- }
-- ]]
-- )

-- local get_current_adapter = vtable_bind("materialsystem.dll", "VMaterialSystem080", 25, "int(__thiscall*)(void*)")
-- local get_adapter_info =
-- vtable_bind("materialsystem.dll", "VMaterialSystem080", 26, "void(__thiscall*)(void*, int, void*)")

-- local current_adapter = get_current_adapter()

-- local adapter_struct = ffi.new(MaterialAdapterInfo_t)

-- get_adapter_info(current_adapter, adapter_struct)

-- local vendorId = tostring(adapter_struct["m_VendorID"])
-- local deviceId = tostring(adapter_struct["m_DeviceID"])

-- local FUCKED = vendorId .. deviceId

-- local SEXFUSCATED = string_format("%x", FUCKED * 255)

-- local SEXCHECK = false

-- for FUCKED, value in pairs(SEXWAT) do
-- 	if value == SEXFUSCATED then
-- 		SEXCHECK = true
-- 	end
-- end

-- if SEXCHECK then
-- 	multicolor_log({255, 255, 255, "Welcome to "}, {255, 0, 0, "HELL"})
-- else
-- 	ui_set(unload, true)
-- end

-- local function DoNothing()
-- end

-------------------
-- Menu Creation --
-------------------
--local hellbutton = ui.new_button("LUA", "B", "HELL.LUA", DoNothing)
local indicatoronref = ui_new_checkbox("LUA", "B", "HELL Indicators")
local indicatorcomboboxref = ui_new_combobox("LUA", "B", "HELL Indicator Type", {"HELL", "HELL v2", "Override"})
local helltickref = ui_new_checkbox("LUA", "B", "HELL Tick")
local helltickcomboboxref = ui_new_combobox("LUA", "B", "HELL Tick Type", {"HELL Dash", "HELL Shift"})
local hellshiftkey = ui_new_hotkey("LUA", "B", "HELL Shift Key", false)
local HellLogs = ui_new_checkbox("LUA", "B", "HELL Logs")
local HELLScreenLogs = ui_new_checkbox("LUA", "B", "HELL Onscreen Logs")
local helldt = ui_new_checkbox("LUA", "B", "HELL Tap")

---------------------
-- Menu References --
---------------------
local menucolor = ui_reference("MISC", "Settings", "Menu color")
local dtbutton, dtkey = ui_reference("RAGE", "Other", "Double Tap")
local hideshotbutton, hskey = ui_reference("AA", "Other", "On shot anti-aim")
local fakeduckkey = ui_reference("RAGE", "Other", "Duck peek assist")
local slowwalkbutton, slowwalkkey = ui_reference("AA", "Other", "Slow Motion")
local baimkey = ui_reference("RAGE", "Other", "Force body aim")
local mindmgref = ui_reference("RAGE", "Aimbot", "Minimum Damage")
local apbutton, apkey = ui_reference("RAGE", "Other", "Quick peek assist")
local fakelaglimit = ui_reference("AA", "Fake lag", "Limit")
local slowmotyperef = ui_reference("AA", "Other", "Slow motion type")
local pingspikeref = ui_reference("MISC", "Miscellaneous", "Ping Spike")
local dtquickstops = ui_reference("RAGE", "Other", "Double tap quick stop")
local unlocktick = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks")
local dtref = ui_reference("RAGE", "Other", "Double tap")
local edgeyawref = ui_reference("AA", "Anti-Aimbot Angles", "Edge yaw")
local freestanding, freestandingkey = ui_reference("AA", "Anti-Aimbot Angles", "Freestanding")
local dtmode = ui_reference("RAGE", "Other", "Double Tap Mode")
local indicatorcboxref = ui_reference("LUA", "B", "HELL Indicator Type")
local helltickcboxref = ui_reference("LUA", "B", "HELL Tick Type")
local dtfllimit = ui_reference("RAGE", "Other", "Double tap fake lag limit")
local dthitchance = ui_reference("RAGE", "Other", "Double tap hit chance")

-----------------
-- Show / Hide --
-----------------
ui_set_visible(indicatorcboxref, false)
ui_set_visible(hellshiftkey, false)
ui_set_visible(helltickcboxref, false)
ui_set_visible(unlocktick, true)

local function showHide(hide)
	local itboxvsref = ui_reference("LUA", "B", "HELL Tick Type")
	local incboxvsref = ui_reference("LUA", "B", "HELL Indicator Type")
	local helltickcomboboxget = ui_get(helltickcomboboxref)
	local helltickvisible = 0

	if ui_get(indicatoronref) then
		ui_set_visible(indicatorcboxref, true)
	else
		ui_set_visible(indicatorcboxref, false)
	end

	if ui_get(helltickref) then
		ui_set_visible(helltickcboxref, true)
		helltickvisible = 1
	else
		ui_set_visible(helltickcboxref, false)
		helltickvisible = 0
	end

	if helltickvisible and helltickcomboboxget == "HELL Shift" then
		ui_set_visible(hellshiftkey, true)
	else
		ui_set_visible(hellshiftkey, false)
	end

	if helltickvisible == 0 then
		ui_set_visible(hellshiftkey, false)
	end
end

------------
-- Others --
------------
client_set_cvar("sv_party_mode", 1)

-- ui_set(menucolor, 137, 64, 64, 255)

---------------------------
-- Get Current Weapon --
---------------------------
local function curr_weapon(players)
	local wpn = entity_get_player_weapon(players)
	local curr_weapon
	local currentweaponenm = entity_get_prop(wpn, "m_iItemDefinitionIndex")
	if currentweaponenm == 40 then
		curr_weapon = "Scout"
	elseif currentweaponenm == 11 or currentweaponenm == 38 then
		curr_weapon = "Auto"
	elseif currentweaponenm == 9 then
		curr_weapon = "AWP"
	elseif
		currentweaponenm == 64 or currentweaponenm == 1 or currentweaponenm == 61 or currentweaponenm == 4 or
		currentweaponenm == 2 or
		currentweaponenm == 36 or
		currentweaponenm == 63 or
		currentweaponenm == 3 or
		currentweaponenm == 30
		then
			curr_weapon = "Pistol"
		else
			curr_weapon = "Others"
		end
		return curr_weapon
	end

	local CurrentWeaponName

	local function getCurWeaponName(weaponGet)
		CurrentWeaponName = curr_weapon(getlocalplayer())
		-- client.log (CurrentWeaponName) -- Logs Name Of Weapon In Hand
	end

	----------------------------------------
	-- Main HELL Indicator Initialisation --
	----------------------------------------
	local function test(r1, g1, b1, a1, r2, g2, b2, a2, str)
		local output = ""

		local len = #str

		local rinc = (r2 - r1) / len
		local ginc = (g2 - g1) / len
		local binc = (b2 - b1) / len
		local ainc = (a2 - a1) / len

		for i = 1, len do
			output = output .. ("\a%02x%02x%02x%02x%s"):format(r1, g1, b1, a1, str:sub(i, i))

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
	local function hellTickFunction()
		local helltickcomboboxget = ui_get(helltickcomboboxref)
		local helltickboxget = ui_get(helltickref)
		local hellshiftkeyon = ui_get(hellshiftkey)
		local is_doubletapping = ui_get(dtkey)
		local is_baiming = ui_get(baimkey)

		if helltickcomboboxget == "HELL Dash" and helltickboxget then
			local is_autopeeking = ui_get(apkey)
			local is_doubletapping = ui_get(dtkey)
			local slowmotype = ui_get(slowmotyperef)

			if is_autopeeking and is_doubletapping then
				helltickenable = 1
			else
				helltickenable = 0
			end

			ui_set(dtref, true)

			if helltickenable == 1 then
				ui_set(fakelaglimit, 1)
				-- ui_set(pingspikeref, true)
				ui_set(dtquickstops, {"Move between shots"})
				--ui_set(unlocktick, 19)
				ui_set(dtmode, "Defensive")
				ui_set(slowmotyperef, "Favor Anti-Aim")
			else
				ui_set(fakelaglimit, 15)
				-- ui_set(pingspikeref, false)
				ui_set(dtquickstops, {"Move between shots"})
				--ui_set(unlocktick, 16)
				ui_set(dtmode, "Defensive")
				ui_set(slowmotyperef, "Favor Anti-Aim")
			end
		elseif helltickcomboboxget == "HELL Shift" and helltickboxget then
			if hellshiftkeyon then
				ui_set(fakelaglimit, 1)
				-- ui_set(pingspikeref, true)
				ui_set(dtquickstops, {"Move between shots"})
				ui_set(dtref, true)
				--ui_set(unlocktick, 19)
				ui_set(freestandingkey, "Always On")
				ui_set(freestanding, "Default")
				ui_set(apbutton, true)
				ui_set(apkey, "Always On")
				ui_set(dtmode, "Defensive")
				ui_set(dtkey, "Always On")
				ui_set(slowmotyperef, "Favor Anti-Aim")
				-- ui_set(edgeyawref, false)
			else
				ui_set(fakelaglimit, 15)
				-- ui_set(pingspikeref, false)
				ui_set(dtquickstops, {"Move between shots"})
				--ui_set(unlocktick, 16)
				ui_set(freestandingkey, "On Hotkey")
				ui_set(freestanding, "-")
				ui_set(apbutton, false)
				ui_set(apkey, "On Hotkey")
				ui_set(dtmode, "Defensive")
				ui_set(dtkey, "Toggle")
				ui_set(slowmotyperef, "Favor Anti-Aim")
				-- ui_set(edgeyawref, false)
			end
		end

		if not helltickboxget then
			ui_set(apbutton, true)
		end
	end

	---------------------
	-- HELL Indicators --
	---------------------

	local function hellIndicators()
		local auto = 0

		local screenx, screeny = client_screen_size()
		local slowwalkon = 0
		local mindmgon = 0

		local hellblue = test(255, 0, 0, 255, 74, 185, 255, 255, "HELL")
		local hellgrey = test(255, 255, 255, 255, 108, 112, 112, 255, "HELL")
		local str2 = test(255, 255, 255, 255, 108, 112, 112, 255, "MINIMUM   DAMAGE")
		local strdtia = test(255, 255, 255, 255, 108, 112, 112, 255, "EXPLOITS   OFF")
		local strdta = test(255, 255, 255, 255, 108, 112, 112, 255, "DT   ACTIVE")
		local strhs = test(255, 255, 255, 255, 108, 112, 112, 255, "HIDE   SHOTS")
		local strfl = test(255, 255, 255, 255, 108, 112, 112, 255, "FAKELAG")
		local strfd = test(255, 255, 255, 255, 108, 112, 112, 255, "FAKE   DUCK")
		local strswalk = test(255, 255, 255, 255, 108, 112, 112, 255, "SLOW   WALK")
		local strmindmg = test(255, 255, 255, 255, 108, 112, 112, 255, "MINIMUM   DAMAGE")
		local strfbaim = test(255, 255, 255, 255, 108, 112, 112, 255, "FORCE   BAIM")
		local stridealtick = test(255, 255, 255, 255, 108, 112, 112, 255, "HELL   SHIFT")

		local is_doubletapping = ui_get(dtkey)
		local is_hideshotting = ui_get(hskey)
		local is_fakeducking = ui_get(fakeduckkey)
		local is_walking = ui_get(slowwalkkey)
		local is_baiming = ui_get(baimkey)
		local indicatorcboxget = ui_get(indicatorcomboboxref)
		local mindmg = ui_get(mindmgref)
		local indicatorsonref = ui_get(indicatoronref)
		local helltickcomboboxget = ui_get(helltickcomboboxref)
		local hellshiftkeyon = ui_get(hellshiftkey)

		local fdon = 0
		local slowwalkon = 0
		local mindmgon = 0

		-----------------------------
		-- MultiColored Indicators --
		-----------------------------

		if indicatorcboxget == "HELL" and indicatorsonref then
			-------------------------------
			-- Grey Indicators (HELL v2) --
			-------------------------------
			if (entity_is_alive(getlocalplayer())) then
				-- HELL --
				renderer_text(screenx / 2 - 10, screeny / 2 + 21, 255, 255, 255, 255, "-", 0, hellblue)

				-- DOUBLETAP --
				if helltickcomboboxget == "HELL Dash" then
					if is_doubletapping then
						surface.draw_text(screenx / 2 - 22, screeny / 2 + 33, 57, 151, 117, 255, outlinedtext, "DOUBLETAP")
					else
						surface.draw_text(screenx / 2 - 22, screeny / 2 + 33, 255, 0, 102, 255, outlinedtext, "DOUBLETAP")
					end
				elseif helltickcomboboxget == "HELL Shift" then
					if hellshiftkeyon and is_doubletapping then
						surface.draw_text(screenx / 2 - 24, screeny / 2 + 33, 57, 151, 117, 255, outlinedtext, "HELL SHIFT")
					elseif is_doubletapping then
						surface.draw_text(screenx / 2 - 22, screeny / 2 + 33, 57, 151, 117, 255, outlinedtext, "DOUBLETAP")
					else
						surface.draw_text(
						screenx / 2 - 27,
						screeny / 2 + 33,
						255,
						0,
						102,
						255,
						outlinedtext,
						"EXPLOITS OFF"
						)
					end
				end

				-- HIDE SHOTS / FAKELAG --
				if is_hideshotting then
					surface.draw_text(screenx / 2 - 24, screeny / 2 + 44, 90, 113, 191, 255, outlinedtext, "HIDE SHOTS")
				else
					surface.draw_text(screenx / 2 - 18, screeny / 2 + 44, 255, 153, 0, 255, outlinedtext, "FAKELAG")
				end

				-- FAKEDUCK --
				if is_fakeducking then
					surface.draw_text(screenx / 2 - 23, screeny / 2 + 55, 161, 76, 158, 255, outlinedtext, "FAKE DUCK")
					fdon = 1
				else
					fdon = 0
				end

				-- SLOWWALK --
				if is_walking then
					slowwalkon = 1
					surface.draw_text(screenx / 2 - 24, screeny / 2 + 55, 199, 165, 0, 255, outlinedtext, "SLOW WALK")
				else
					slowwalkon = 0
				end

				-- MINDMG OVERRIDE --

				if mindmg == auto then
					return
				else
					if
					CurrentWeaponName == "AWP" and mindmg <= 30 or CurrentWeaponName == "Scout" and mindmg <= 30 or
					CurrentWeaponName == "Pistol" and mindmg <= 8 or
					CurrentWeaponName == "Auto" and mindmg <= 10 or
					mindmg == 0
					then
						if fdon == 1 or slowwalkon == 1 then
							surface.draw_text(
							screenx / 2 - 35,
							screeny / 2 + 66,
							255,
							0,
							102,
							255,
							outlinedtext,
							"MINIMUM DAMAGE"
							)
						elseif fdon == 0 or slowwalkon == 0 then
							surface.draw_text(
							screenx / 2 - 35,
							screeny / 2 + 55,
							255,
							0,
							102,
							255,
							outlinedtext,
							"MINIMUM DAMAGE"
							)
						else
							mindmgon = 0
						end
					end
				end

				if mindmg == auto then
					mindmgon = 0
				else
					if
					CurrentWeaponName == "AWP" and mindmg <= 30 or CurrentWeaponName == "Scout" and mindmg <= 30 or
					CurrentWeaponName == "Pistol" and mindmg <= 8 or
					CurrentWeaponName == "Auto" and mindmg <= 10 or
					mindmg == 0
					then
						mindmgon = 1
					else
						mindmgon = 0
					end
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
		elseif indicatorcboxget == "HELL v2" and indicatorsonref then
			-------------------------
			-- Override Indicators --
			-------------------------
			if (entity_is_alive(getlocalplayer())) then
				-- HELL --
				renderer_text(screenx / 2 - 10, screeny / 2 + 21, 255, 255, 255, 255, "-", 0, hellgrey)

				-- DOUBLETAP --

				if helltickcomboboxget == "HELL Dash" then
					if is_doubletapping then
						renderer_text(screenx / 2 - 20, screeny / 2 + 33, 179, 86, 86, 255, "-", 0, strdta)
					else
						renderer_text(screenx / 2 - 25, screeny / 2 + 33, 179, 86, 86, 255, "-", 0, strdtia)
					end
				elseif helltickcomboboxget == "HELL Shift" then
					if hellshiftkeyon and is_doubletapping then
						renderer_text(screenx / 2 - 21, screeny / 2 + 33, 179, 86, 86, 255, "-", 0, stridealtick)
					elseif is_doubletapping then
						renderer_text(screenx / 2 - 20, screeny / 2 + 33, 179, 86, 86, 255, "-", 0, strdta)
					else
						renderer_text(screenx / 2 - 25, screeny / 2 + 33, 179, 86, 86, 255, "-", 0, strdtia)
					end
				end

				-- HIDE SHOTS / FAKELAG --
				if is_hideshotting then
					renderer_text(screenx / 2 - 23, screeny / 2 + 44, 179, 86, 86, 255, "-", 0, strhs)
				else
					renderer_text(screenx / 2 - 18, screeny / 2 + 44, 179, 86, 86, 255, "-", 0, strfl)
				end

				-- FAKEDUCK --
				if is_fakeducking then
					renderer_text(screenx / 2 - 22, screeny / 2 + 55, 179, 86, 86, 255, "-", 0, strfd)
					fdon = 1
				else
					fdon = 0
				end

				-- SLOWWALK --
				if is_walking then
					renderer_text(screenx / 2 - 24, screeny / 2 + 55, 179, 86, 86, 255, "-", 0, strswalk)
					slowwalkon = 1
				else
					slowwalkon = 0
				end

				-- MINDMG OVERRIDE --

				if mindmg == auto then
					return
				else
					if
					CurrentWeaponName == "AWP" and mindmg <= 30 or CurrentWeaponName == "Scout" and mindmg <= 30 or
					CurrentWeaponName == "Pistol" and mindmg <= 8 or
					CurrentWeaponName == "Auto" and mindmg <= 10 or
					mindmg == 0
					then
						if fdon == 1 or slowwalkon == 1 then
							renderer_text(screenx / 2 - 35, screeny / 2 + 66, 179, 86, 86, 255, "-", 0, strmindmg)
						elseif fdon == 0 or slowwalkon == 0 then
							renderer_text(screenx / 2 - 35, screeny / 2 + 55, 179, 86, 86, 255, "-", 0, strmindmg)
						else
							mindmgon = 0
						end
					end
				end

				if mindmg == auto then
					mindmgon = 0
				else
					if
					CurrentWeaponName == "AWP" and mindmg <= 30 or CurrentWeaponName == "Scout" and mindmg <= 30 or
					CurrentWeaponName == "Pistol" and mindmg <= 8 or
					CurrentWeaponName == "Auto" and mindmg <= 10 or
					mindmg == 0
					then
						mindmgon = 1
					else
						mindmgon = 0
					end
				end

				-- FORCE BAIM --
				if is_baiming then
					if slowwalkon == 0 and fdon == 0 and mindmgon == 0 then
						renderer_text(screenx / 2 - 25, screeny / 2 + 55, 179, 86, 86, 255, "-", 0, strfbaim)
					elseif slowwalkon == 1 and mindmgon == 0 then
						renderer_text(screenx / 2 - 25, screeny / 2 + 66, 179, 86, 86, 255, "-", 0, strfbaim)
					elseif fdon == 1 and mindmgon == 0 then
						renderer_text(screenx / 2 - 25, screeny / 2 + 66, 179, 86, 86, 255, "-", 0, strfbaim)
					elseif slowwalkon == 0 and fdon == 0 and mindmgon == 1 then
						renderer_text(screenx / 2 - 25, screeny / 2 + 66, 179, 86, 86, 255, "-", 0, strfbaim)
					elseif fdon == 1 or slowwalkon == 1 and mindmgon == 1 then
						renderer_text(screenx / 2 - 25, screeny / 2 + 77, 179, 86, 86, 255, "-", 0, strfbaim)
					end
				end
			end
		elseif indicatorcboxget == "Override" and indicatorsonref then
			if (entity_is_alive(getlocalplayer())) then
				if mindmg == auto then
					return
				else
					if
					CurrentWeaponName == "AWP" and mindmg <= 30 or CurrentWeaponName == "Scout" and mindmg <= 30 or
					CurrentWeaponName == "Pistol" and mindmg <= 8 or
					CurrentWeaponName == "Auto" and mindmg <= 10
					then
						if (entity_is_alive(entity_get_local_player())) then
							local screenx, screeny = client_screen_size()
							renderer_text(screenx / 2 - 33, screeny / 2 - 26, 255, 255, 255, 255, "-", 0, str2)
						end
					end
				end

				if mindmg == auto then
					mindmgon = 0
				else
					if
					CurrentWeaponName == "AWP" and mindmg <= 30 or CurrentWeaponName == "Scout" and mindmg <= 30 or
					CurrentWeaponName == "Pistol" and mindmg <= 8 or
					CurrentWeaponName == "Auto" and mindmg <= 10
					then
						mindmgon = 1
					else
						mindmgon = 0
					end
				end
			end
		end
	end

	---------------
	-- HELL Logs --
	---------------

	local function hellLogs()
		HellLogsGet = ui_get(HellLogs)
	end

	local function MultiColorLog(...)
		local args = {...}
		local len = #args
		for i = 1, len do
			local arg = args[i]
			local r, g, b = unpack(arg)
			local msg = {}

			if #arg == 3 then
				table_insert(msg, " ")
			else
				for i = 4, #arg do
					table_insert(msg, arg[i])
				end
			end

			msg = table_concat(msg)

			if len > i then
				msg = msg .. "\0"
			end

			client_color_log(r, g, b, msg)
		end
	end

	local hitgroup_names = {
		"Body",
		"Head",
		"Chest",
		"Stomach",
		"Left Arm",
		"Right Arm",
		"Left Leg",
		"Right Leg",
		"Neck",
		"Unknown",
		"Gear"
	}

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

		if client_userid_to_entindex(userid) == entity_get_local_player() then
			local damager = entity_get_player_name(client_userid_to_entindex(attacker))

			local hitbox_hit = hitgroup_names[hitgroup + 1]

			if hitbox_hit and HellLogsGet then
				MultiColorLog(
				{110, 172, 254, "[HELL] "},
				{255, 255, 255, "Got hit by "},
				{255, 255, 255, damager},
				{255, 255, 255, " for "},
				{255, 255, 255, dmg_health},
				{255, 255, 255, " in "},
				{255, 255, 255, hitbox_hit},
				{255, 255, 255, " | Remaining HP: "},
				{255, 255, 255, health}
				)
			end
		end
	end

	local BackTrackInfo = {}

	local function time_to_ticks(t)
		return math_floor(0.5 + (t / globals_tickinterval()))
	end

	local function shot_logs(fired)
		BackTrackInfo =
		globals_tickcount() - fired.tick > 0 and (((globals_tickcount() - fired.tick) * globals_tickinterval()) * 1000) or
		0
		AimFireDamage = fired.damage
		AimFireGroup = hitgroup_names[fired.hitgroup + 1] or "unknown"
		AimFireBacktrack = fired.backtrack
	end

	local function hit_logs(hit)
		local target = hit.target
		local nameofenemyhit = entity_get_player_name(hit.target)
		local damagegiven = hit.damage
		local hitbox = hitgroup_names[hit.hitgroup + 1] or "unknown"
		local remaininghp = entity_get_prop(hit.target, "m_iHealth")
		local predicteddamage = AimFireDamage
		local predictedhitbox = AimFireGroup
		local predictedbacktrackticks = AimFireBacktrack
		local angleshotat = math_floor(entity_get_prop(target, "m_flPoseParameter", 11) * 120 - 60)
		local btshotflt = math_max(0, BackTrackInfo)
		local btshotinms = math_floor(btshotflt)
		local btshotinseconds = btshotinms / 1000
		local btshot = math_floor((btshotinseconds / globals_tickinterval()) + 0.5)

		if HellLogsGet == true then
			MultiColorLog(
			{180, 228, 20, "[HELL] "},
			{255, 255, 255, "Damaged "},
			{255, 255, 255, nameofenemyhit},
			{255, 255, 255, " for "},
			{255, 255, 255, damagegiven},
			{255, 255, 255, " in the "},
			{255, 255, 255, hitbox},
			{255, 255, 255, " (HP Remaining: "},
			{255, 255, 255, remaininghp},
			{255, 255, 255, ") | Shot For "},
			{255, 255, 255, predicteddamage},
			{255, 255, 255, " HP in "},
			{255, 255, 255, predictedhitbox},
			{255, 255, 255, " | Backtrack: "},
			{255, 255, 255, btshot},
			{255, 255, 255, " ticks | Angle: "},
			{255, 255, 255, angleshotat},
			{255, 255, 255, "°"}
			)
		end
	end

	local function miss_logs(miss)
		local target = miss.target
		local nameofenemymissed = entity_get_player_name(miss.target)
		local predicteddamage = AimFireDamage
		local predictedhitbox = AimFireGroup
		local missreason = miss.reason
		local predictedbacktrackticks = AimFireBacktrack
		local angleshotat = math_floor(entity_get_prop(target, "m_flPoseParameter", 11) * 120 - 60)
		local btmissflt = math_max(0, BackTrackInfo)
		local btmissinms = math_floor(btmissflt)
		local btmissinseconds = btmissinms / 1000
		local btmiss = math_floor((btmissinseconds / globals_tickinterval()) + 0.5)

		if missreason == "?" then
			missreason = "unknown"
		end

		if HellLogsGet == true then
			MultiColorLog(
			{200, 50, 50, "[HELL] "},
			{255, 255, 255, "Missed "},
			{255, 255, 255, nameofenemymissed},
			{255, 255, 255, " for "},
			{255, 255, 255, predicteddamage},
			{255, 255, 255, " in the "},
			{255, 255, 255, predictedhitbox},
			{255, 255, 255, " due to "},
			{255, 255, 255, missreason},
			{255, 255, 255, " | Backtrack: "},
			{255, 255, 255, btmiss},
			{255, 255, 255, " ticks | Angle: "},
			{255, 255, 255, angleshotat},
			{255, 255, 255, "°"}
			)
		end
	end

	------------------------
	-- HELL Onscreen Logs --
	------------------------
	local screenx, screeny = client_screen_size()
	local shottable = {}

	local function aim_hit(hit)
		local group = hitgroup_names[hit.hitgroup + 1] or "?"
		local curtime = globals_curtime()

		hitlog =
		("\aFFFFFFFFHit  \a6EEB34FF%s  \aFFFFFFFFin  the  \a6EEB34FF%s  \aFFFFFFFFfor  \a6EEB34FF%d  \aFFFFFFFFdamage  (\a6EEB34FF%d  \aFFFFFFFFhealth  remaining)"):format(
		entity_get_player_name(hit.target),
		group,
		hit.damage,
		entity_get_prop(hit.target, "m_iHealth")
		):upper()

		table_insert(
		shottable,
		{
			time = curtime,
			info = hitlog
		}
		)
	end

	local function aim_miss(miss)
		if miss.reason == "?" then
			miss.reason = "unknown"
		end

		if miss.reason == "prediction error" then
			miss.reason = "prediction  error"
		end

		local group = hitgroup_names[miss.hitgroup + 1] or "?"
		local curtime = globals_curtime()

		misslog =
		("\aFFFFFFFFMissed  \aF06565FF%s\aFFFFFFFF's  \aF06565FF%s  \aFFFFFFFFdue  to  \aF06565FF%s"):format(
		entity_get_player_name(miss.target),
		group,
		miss.reason
		):upper()

		table_insert(
		shottable,
		{
			time = curtime,
			info = misslog
		}
		)
	end

	local function renderlog()
		local curtime = globals_curtime()
		local y1 = 0

		if ui_get(HELLScreenLogs) then
			for key, log in ipairs(shottable) do
				local elapsed = curtime - log.time
				if elapsed >= 3 then
					table_remove(shottable, key)
				end
				local pct = math_max(0, math_min(1, (3 - elapsed) / 3))

				alpha = 255 * pct
				renderer_text(screenx / 2, (screeny / 2 + 300) + y1, 255, 255, 255, alpha, "c-", 0, log.info)
				y1 = y1 + 12
			end
		end
	end

	local function level_init()
		shottable = {}
	end

	local rollref = ui_reference("AA", "Anti-aimbot angles", "Roll")
	local checkOn = ui_new_checkbox("LUA", "B", "HELL Roll")

	local function randomSet(random)
		local checkGet = ui_get(checkOn)
		if checkGet then
			local rand = client_random_int(-50, 50)
			ui_set(rollref, rand)
		end
	end

	--------------------
	-- HELL DoubleTap --
	--------------------

	local function hellDTFunction()
		if ui_get(helldt) then
			local ping = client_latency() * 1000

			if ping <= 65 then
				ui_set(unlocktick, 18)
				cvar.cl_clock_correction:set_int(0)
				ui_set(dtfllimit, 1)
				ui_set(dthitchance, 15)
			elseif ping >= 65 and ping <= 150 then
				ui_set(unlocktick, 17)
				cvar.cl_clock_correction:set_int(0)
				ui_set(dtfllimit, 1)
				ui_set(dthitchance, 25)
			else
				ui_set(unlocktick, 16)
				cvar.cl_clock_correction:set_int(1)
				ui_set(dtfllimit, 1)
				ui_set(dthitchance, 20)
			end
		else
			ui_set(unlocktick, 16)
		end
	end

	---------------
	-- CallBacks --
	---------------
	client_set_event_callback("paint_ui", showHide)
	client_set_event_callback("paint", hellLogs)
	client_set_event_callback("paint", getCurWeaponName)
	client_set_event_callback("paint", hellIndicators)
	client_set_event_callback("paint", hellTickFunction)
	client_set_event_callback("aim_hit", hit_logs)
	client_set_event_callback("aim_miss", miss_logs)
	client_set_event_callback("player_hurt", on_player_hurt)
	client_set_event_callback("aim_fire", shot_logs)
	client_set_event_callback("aim_hit", aim_hit)
	client_set_event_callback("aim_miss", aim_miss)
	client_set_event_callback("paint", renderlog)
	client_set_event_callback("level_init", level_init)
	client_set_event_callback("paint", randomSet)
	client_set_event_callback("paint", hellDTFunction)