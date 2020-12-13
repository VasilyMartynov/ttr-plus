--[[
  ThankTheResserPlus v1.4.0

  ThankTheResserPlus is an addon for Warhammer: Return of Reckoning 
  which automatically thanks the person that revived you.
  
  This file contains everything related to the config UI
--]]

local ttrp = ThankTheResserPlus
local sWin="TTRPConfig"

local function print(text)
	EA_ChatWindow.Print(towstring(text))
end

function ThankTheResserPlus.InitConfig()
	
	local x,y
	CreateWindow(sWin, false)
	ThankTheResserPlus.nConfigTab=IraConfig.RegisterAddon(L"TTRP", towstring("TTRP Config"),sWin,ThankTheResserPlus.ConfigCallback)
	
	ThankTheResserPlus.ConfigCallback(IraConfig.CALLBACK_OPEN,ThankTheResserPlus.nConfigTab)
	
end

function ThankTheResserPlus.DoConfig()
	IraConfig.Open(ThankTheResserPlus.nConfigTab)
end

function ThankTheResserPlus.ConfigCallback(nMessage,nTab)
	local x,y

    if nMessage==IraConfig.CALLBACK_OPEN then
        msg="Thank The Resser Plus Version "..ttrp.Version.."."
        aboutWord="Change the Single gratitude phrase:"
        aboutDict="Look up provided Dictionary"
        LabelSetText(sWin.."Version",towstring(msg))
        LabelSetText(sWin.."EnabledLabel",towstring("Enabled"))
        LabelSetText(sWin.."AboutWord",towstring(aboutWord))
        LabelSetText(sWin.."AboutDict",towstring(aboutDict))

    elseif nMessage==IraConfig.CALLBACK_RESET then
        ButtonSetPressedFlag(sWin.."TEnabledButton", ttrp.Settings.Enabled)
    elseif nMessage==IraConfig.CALLBACK_SAVE then
        ttrp.Settings.Enabled=ButtonGetPressedFlag(sWin.."EnabledButton")
        print("TTRP is "..ttrp.Settings.Enabled)
	end

end
