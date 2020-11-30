--Written with inspiration from ThankTheHealer, for RoR by Sullemunk.
-- Upgraded by Archam for Return Of Reckoning.
ThankTheResserPlus = {}


local function print(text)
	EA_ChatWindow.Print(towstring(text))
end


--Prints out the usage message
function ThankTheResserPlus.PrintUsage()
	print("")
	print("ThankTheResserPlus")
	print(" v1.3.0 stable")
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
	
	if (ThankTheResserPlus.Settings.Word ~= nil) then
		print(towstring("Current phrase is \"")..ThankTheResserPlus.Settings.Word..towstring("\"."))
	end
end


--This function is beeing called when the addon starts from ThankTheResserPlus.mod
function ThankTheResserPlus.Initialize()
	if (ThankTheResserPlus.Settings == nil) then
		ThankTheResserPlus.Settings = {}
		--Init options list
		ThankTheResserPlus.Settings.Enabled = false
		-- 
		ThankTheResserPlus.Settings.Mode = "word"
		ThankTheResserPlus.InitDictionary()
	end

	--Checks if Libslash is installed
	if (LibSlash == nil) then
		print("ThankTheResserPlus couldn't find LibSlash!")
		return
	end

	--Registers the /slash commands 
	LibSlash.RegisterSlashCmd("ThankTheResserPlus", function(input) ThankTheResserPlus.Command(input) end)
	LibSlash.RegisterSlashCmd("ttrp", function(input) ThankTheResserPlus.Command(input) end)

	--Prints out that the mod is loaded	
	print("<icon00057> Thank the resser Plus 1.3 Loaded.")
	print("Use /ttrp or /ThankTheResserPlus")

	--Listens for for the player to accept ressurection and calls ThankTheResserPlus.ThankThem function
	RegisterEventHandler(SystemData.Events.RESURRECTION_ACCEPT, "ThankTheResserPlus.ThankThem")
	--Debug mode 
	--RegisterEventHandler(SystemData.Events.PLAYER_BEGIN_CAST, "ThankTheResserPlus.ThankThem")
	RegisterEventHandler(SystemData.Events.PLAYER_DEATH_CLEARED, "ThankTheResserPlus.ResserName")

end


--Inits local dictionary with pregenrated ressurection phrases 
function ThankTheResserPlus.InitDictionary()
	if (ThankTheResserPlus.Dictionary == nil) then
		-- Custom strins can be added here
		ThankTheResserPlus.Dictionary = {}
		ThankTheResserPlus.Dictionary = {
			"Thank you!",
			"Cheers %p!",
			"Ressurection appreciated.",
			"%p, I owe you.",
			"You are breathtaking <3 !",
			"Next one is on me, %p!"
		}
		
	end
end


--Unregister the /slash commands if the mod is turned off so it can be used by other addons (not likely)
function ThankTheResserPlus.Shutdown()
	UnregisterEventHandler(SystemData.Events.RESURRECTION_ACCEPT, "ThankTheResserPlus.ThankThem")
	LibSlash.UnregisterSlashCmd("ttrp")
	LibSlash.UnregisterSlashCmd("ThankTheResserPlus")
end


--Listens for the /slash command from the textbox. 
-- If no additional text is applied to set the word, the usage message is shown
function ThankTheResserPlus.Command(input)
	--input = string.lower(input)
	if (input == "") then
		ThankTheResserPlus.PrintUsage()
		return
	end

	--Turns the addon on/off
	if (input == "off") then
		ThankTheResserPlus.Settings.Enabled = false
		print("Thank The Resser disabled")
	elseif (input == "on") then 
		ThankTheResserPlus.Settings.Enabled = true
		print("Thank The Resser Plus enabled")
	--Controls work mode
	elseif (input == "random") then 
		ThankTheResserPlus.Settings.Mode = "Random"
		print("TRRP mode set to "..ThankTheResserPlus.Settings.Mode)
	elseif (input == "word") then 
		ThankTheResserPlus.Settings.Mode = "Word"
		print("TRRP mode set to "..ThankTheResserPlus.Settings.Mode)
	elseif (input == "mode") then 
		print("Thank The Resser Plus current mode: "..ThankTheResserPlus.Settings.Mode )
	--reinits Dictionary
	elseif (input == "init") then
		ThankTheResserPlus.InitDictionary()
		print("Dictionary wiped and reinitialized.")
	elseif (input == "test") then 
		print(ThankTheResserPlus.GetRessPhrase())
	else
		ThankTheResserPlus.Settings.Word = towstring(input)
		print(towstring("TRRP phrase set to \"")..ThankTheResserPlus.Settings.Word..towstring("\"."))
	end
end


-- Mostly magical function that extracts Resser name form ressurection dialog window
function ThankTheResserPlus.ResserName()
	if DoesWindowExist("TwoButtonDlg1Box") then
		RessText = LabelGetText("TwoButtonDlg1BoxText")
		RessName = RessText:match(L"([%a]+).")
		d(RessName)
	end
end

--After a sucessfull ressurection this function is called
function ThankTheResserPlus.ThankThem()
	
	if DoesWindowExist("TwoButtonDlg1Box") then
		RessText = LabelGetText("TwoButtonDlg1BoxText")
		RessName = RessText:match(L"([%a]+).")
	end
	
	local ColorName = L"<LINK data=\"0\" text=\""..towstring(RessName)..L" \" color=\"25,155,255\">"
	ressPhrase = ThankTheResserPlus.GetRessPhrase()
	
	-- Original mod way
	--local sayword = ThankTheResserPlus.Settings.Word:gsub(L"%%[Pp]", ColorName)
	
	--Sends the message to chat :
	-- REMinder, convert any string to wstring type of special encoding
	local sayword = towstring(ressPhrase):gsub(L"%%[Pp]", ColorName)
	
	if ThankTheResserPlus.Settings.Enabled then
		SendChatText(towstring("/say ")..sayword, L"")
	end
	
end


-- Returns a random element of table
function ThankTheResserPlus.Randomize()
    -- a bit of overkill
    --math.randomseed(os.time())
	res = ThankTheResserPlus.Dictionary
	return res[ math.random ( 1, #res ) ]
end


-- Gets the thanks phrase dependat on mode
function ThankTheResserPlus.GetRessPhrase()
	if (ThankTheResserPlus.Settings.Mode == "Word") then
		res = ThankTheResserPlus.Settings.Word
	elseif (ThankTheResserPlus.Settings.Mode == "Random") then
		res = ThankTheResserPlus.Randomize()
	else
		res = "Ressurection Gratitude is provided by ThankTheResserPlus addon."
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