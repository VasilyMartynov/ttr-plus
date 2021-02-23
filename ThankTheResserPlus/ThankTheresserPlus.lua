--Written with inspiration from ThankTheHealer, for RoR by Sullemunk.
-- Upgraded by Archam for Return Of Reckoning.

-- This is global
ThankTheResserPlus = {}

ThankTheResserPlus.Version = "1.4.0"

ThankTheResserPlus.defaultSettings={
	Enabled = false,
	Mode = "word",
}
local ttrp = ThankTheResserPlus


local function print(text)
	EA_ChatWindow.Print(towstring(text))
end


--Prints out the usage message
function ttrp.PrintUsage()
	print("")
	print("ThankTheResserPlus")
	print(ttrpVersion)
	print("")
	print("Usage:")
	print("/ttrp off - turns Thank The Resser off")
	print("/ttrp on  - turns Thank The Resser on")
	print("")
	print("/ttrp mode   - shows current mode (random | word)")
	print("/ttrp word   - sets the mode to custom phrase, default unless provided.")
	print("/ttrp random - sets the mode to random pregenerated set of messages.")
	print("    Custom phrases coming sometime, maybe.")
	print("")
	print("/ttrp <phrase> - sets thanks phrase upon resurrection")
	print("    Use %p to insert the resurrector's name")
	print("")
	print("/ttrp init - wipe and reinitialize random dictionary.")
	print("/ttrp test - prints TRRP message, depending on mode.")
	print("")
	print("To add custom phrases Edit ThankTheResserPlus.Dictionary variable in folder")
	print("%game_root%\user\settings\Martyrs Square\%username%\%char_name%\ThankTheResserPlus\SavedVariables.lua")
	print("Better do it before you start the game.")
	print("")
	print("/ThankTheResserPlus can be used instead of /trrp if you are not bored typing.")
	
	if (ttrp.Settings.Word ~= nil) then
		print(towstring("Current phrase is \"")..ttrp.Settings.Word..towstring("\"."))
	end
end


--This function is being called when the addon starts from ThankTheResserPlus.mod
function ThankTheResserPlus.Initialize()

	if (ttrp.Settings == nil) then
		ttrp.Settings = ttrp.defaultSettings
		ttrp.InitDictionary()
	end

	--Checks if Libslash is installed
	if (LibSlash == nil) then
		print("ThankTheResserPlus couldn't find LibSlash!")
		return
	end

	--Registers the /slash commands 
	LibSlash.RegisterSlashCmd("ThankTheResserPlus", function(input) ttrp.Command(input) end)
	LibSlash.RegisterSlashCmd("ttrp", function(input) ttrp.Command(input) end)

	--Prints out that the mod is loaded	
	print("<icon00057> Thank the Resser Plus Loaded.")
	--print("<icon00057> Thank the Resser Plus"..towstring(ttrp.Version)..L"Loaded.")
	print("Use /ttrp or /ThankTheResserPlus")

	--Listens for for the player to accept resurrection and calls ThankTheResserPlus.ThankThem function
	RegisterEventHandler(SystemData.Events.RESURRECTION_ACCEPT, "ThankTheResserPlus.ThankThem")
	--Debug mode 
	--RegisterEventHandler(SystemData.Events.PLAYER_BEGIN_CAST, "ThankTheResserPlus.ThankThem")
	RegisterEventHandler(SystemData.Events.PLAYER_DEATH_CLEARED, "ThankTheResserPlus.ResserName")
	
	ttrp.InitConfig()
end


--Inits local dictionary with pregenerated resurrection phrases
function ttrp.InitDictionary()
	if (ttrp.Dictionary == nil) then
		-- Custom strings can be added here
		ttrp.Dictionary = {}
		ttrp.Dictionary = {
			"Thank you!",
			"Cheers %p!",
			"Resurrection appreciated.",
			"%p, I owe you.",
			"You are breathtaking <3 !",
			"Next one is on me, %p!"
		}
		
	end
end


--Unregister the /slash commands if the mod is turned off so it can be used by other addons (not likely)
function ttrp.Shutdown()
	UnregisterEventHandler(SystemData.Events.RESURRECTION_ACCEPT, "ThankTheResserPlus.ThankThem")
	LibSlash.UnregisterSlashCmd("ttrp")
	LibSlash.UnregisterSlashCmd("ThankTheResserPlus")
end


--Listens for the /slash command from the textbox. 
-- If no additional text is applied to set the word, the usage message is shown
function ttrp.Command(input)
	--input = string.lower(input)
	if (input == "") then
		ttrp.PrintUsage()
		return
	end

	--Turns the addon on/off
	if (input == "off") then
		ttrp.Settings.Enabled = false
		print("Thank The Resser disabled")
	elseif (input == "on") then 
		ttrp.Settings.Enabled = true
		print("Thank The Resser Plus enabled")
	--Controls work mode
	elseif (input == "random") then 
		ttrp.Settings.Mode = "Random"
		print("TRRP mode set to "..ttrp.Settings.Mode)
	elseif (input == "word") then 
		ttrp.Settings.Mode = "Word"
		print("TRRP mode set to "..ttrp.Settings.Mode)
	elseif (input == "mode") then 
		print("Thank The Resser Plus current mode: "..ttrp.Settings.Mode )
	--reinits Dictionary
	elseif (input == "init") then
		ttrp.InitDictionary()
		print("Dictionary wiped and reinitialized.")
	elseif (input == "test") then 
		print(ttrp.GetRessPhrase())
	elseif (input == "ui") then 
		ttrp.DoConfig()
	else
		ttrp.Settings.Word = towstring(input)
		print(towstring("TRRP phrase is set to \"")..ttrp.Settings.Word..towstring("\"."))
	end
end


-- Mostly magical function that extracts Resser name form resurrection dialog window
function ttrp.ResserName()
	if DoesWindowExist("TwoButtonDlg1Box") then
		RessText = LabelGetText("TwoButtonDlg1BoxText")
		RessName = RessText:match(L"([%a]+).")
		d(RessName)
	end
end

--After a successful resurrection this function is called
function ttrp.ThankThem()
	
	if DoesWindowExist("TwoButtonDlg1Box") then
		RessText = LabelGetText("TwoButtonDlg1BoxText")
		RessName = RessText:match(L"([%a]+).")
	end
	
	local ColorName = L"<LINK data=\"0\" text=\""..towstring(RessName)..L"\" color=\"25,155,255\">"
	ressPhrase = ttrp.GetRessPhrase()
	
	-- Original mod way
	--local sayword = ttrp.Settings.Word:gsub(L"%%[Pp]", ColorName)
	
	--Sends the message to chat :
	-- REMinder, convert any string to wstring type of special encoding
	local sayword = towstring(ressPhrase):gsub(L"%%[Pp]", ColorName)
	
	if ttrp.Settings.Enabled then
		SendChatText(towstring("/say ")..sayword, L"")
	end
	
end


-- Returns a random element of table
function ttrp.Randomize()
    -- a bit of overkill
    --math.randomseed(os.time())
	res = ttrp.Dictionary
	return res[ math.random ( 1, #res ) ]
end


-- Gets the thanks phrase depending on mode
function ttrp.GetRessPhrase()
	if (ttrp.Settings.Mode == "Word") then
		res = ttrp.Settings.Word
	elseif (ttrp.Settings.Mode == "Random") then
		res = ttrp.Randomize()
	else
		res = "Resurrection Gratitude is provided by ThankTheResserPlus addon."
	end
	return res
end


-- Debug section for online lua tests

-- Test random output
--ThankTheResserPlus.Initialize()
--print(ThankTheResserPlus.Dictionary)
--ThankTheResserPlus.Command("random")
--print(ThankTheResserPlus.GetRessPhrase())
--print(ThankTheResserPlus.GetRessPhrase())
--print(ThankTheResserPlus.GetRessPhrase())


--ThankTheResserPlus.Initialize()
--ThankTheResserPlus.PrintUsage()
--ThankTheResserPlus.Command("random")
--print(ThankTheResserPlus.GetRessPhrase())
--ThankTheResserPlus.Command("word")
--print(ThankTheResserPlus.GetRessPhrase())
--ThankTheResserPlus.Settings.Mode = nil
--print(ThankTheResserPlus.GetRessPhrase())
