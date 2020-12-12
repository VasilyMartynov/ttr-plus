--[[
  IraConfig ((Lib) Ira Config) version 1.06
  by Irinia of Volkmar
  This library manages a configuaration window for add-ons, as well as providing many utillity functions for controls

  This file handles the window and add-ons
--]]


IraConfig={}
local ic=IraConfig
local bIsOpen=false

ic.CALLBACK_SHOWN=1
ic.CALLBACK_HIDDEN=2
ic.CALLBACK_SAVE=3
ic.CALLBACK_CLOSE=4
ic.CALLBACK_RESET=5
ic.CALLBACK_OPEN=6
ic.CALLBACK_RESIZE=7

ic.vAddons={}

ic.nNextPane=1

local function Message(nMessage)
  for k,v in pairs(ic.vAddons) do
    v.callback(nMessage,k)
  end
end

function ic.Initialize()
  CreateWindow("IraConfig",false)
  WindowSetShowing("IraConfig",false)
  ic.CreateTabSet("IraConfigTabs",550,50)
  if StringTables.Pregame ~=nil and StringTables.Pregame.LABEL_UI_MOD_SETTINGS ~=nil then
	LabelSetText("IraConfigTitleBarText",GetPregameString(StringTables.Pregame.LABEL_UI_MOD_SETTINGS))
  else
	LabelSetText("IraConfigTitleBarText",L"Mod Settings")
  end
  ButtonSetText("IraConfigOkayButton",GetString(StringTables.Default.LABEL_OKAY))
  ButtonSetText("IraConfigApplyButton",GetString(StringTables.Default.LABEL_APPLY))
  ButtonSetText("IraConfigResetButton",GetString(StringTables.Default.LABEL_RESET))
  ButtonSetText("IraConfigCancelButton",GetString(StringTables.Default.LABEL_CANCEL))
  ic.HelpInit()
end

function ic.Open(nTabNum)
  local nOpenTab
  WindowSetShowing("IraConfig",true)
  if not bIsOpen then
    bIsOpen=true
    Message(ic.CALLBACK_OPEN)
    ic.UpdateScrollBars()
    Message(ic.CALLBACK_RESET)
  end
  if nTabNum then
    ic.SetActiveTab("IraConfigTabs",nTabNum)
  end
end

function ic.Close()
  bIsOpen=false
  Message(ic.CALLBACK_CLOSE)
  WindowSetShowing("IraConfig",false)
end

function ic.OnOkay()
  Message(ic.CALLBACK_SAVE)
  Message(ic.CALLBACK_CLOSE)
  WindowSetShowing("IraConfig",false)
end

function ic.OnApply()
  Message(ic.CALLBACK_SAVE)
end

function ic.OnReset()
  Message(ic.CALLBACK_RESET)
end

function ic.UpdateScrollBars()
  for k,v in pairs(ic.vAddons) do
    ic.vAddons[k].callback(ic.CALLBACK_RESIZE,k)
    if ic.vAddons[k].pane then
      ScrollWindowUpdateScrollRect(ic.vAddons[k].pane)
    end
  end
end

local function TabCallback(nMessage,nTab)
  if ic.vAddons[nTab] then
    ic.vAddons[nTab].callback(nMessage,nTab)
    if nMessage==ic.CALLBACK_SHOWN then
      if ic.vAddons[nTab].pane then
        ScrollWindowUpdateScrollRect(ic.vAddons[nTab].pane)
      end
    end
  end
end

function ic.RegisterAddon(sTabText,sTipText,sPanelName,fCallback)
  if (not fCallback) or (type(fCallback)~="function") then
    ERROR(L"fCallback must be a function")
  end
  local x,y=WindowGetDimensions(sPanelName)
  local sName="IraConfigPane"..ic.nNextPane
  ic.nNextPane=ic.nNextPane+1
  CreateWindowFromTemplate(sName,"IraConfigScrollTab","IraConfigClient")
  WindowSetShowing(sName,false)
  local nIndex=ic.AddTab("IraConfigTabs",sTabText,sTipText,sName,TabCallback)
  ic.vAddons[nIndex]={}
  ic.vAddons[nIndex].callback=fCallback
  ic.vAddons[nIndex].pane=sName
  WindowSetDimensions(sName.."Child",x,y)
  WindowSetParent(sPanelName,sName.."Child")
  WindowClearAnchors(sPanelName)
  WindowSetShowing(sPanelName,true)
  ic.UpdateScrollBars()
  return nIndex
end

-- BEWARE! THE CLIENT AREA CAN SHRINK!  YOU MUST PROVIDE YOUR OWN SCROLL
--  MECHANISM TO ACCOUNT FOR THIS
function ic.RegisterAddonNoScroll(sTabText,sTipText,sPanelName,fCallback)
  if (not fCallback) or (type(fCallback)~="function") then
    ERROR(L"fCallback must be a function")
  end
  WindowSetShowing(sPanelName,false)
  local x,y=WindowGetDimensions(sPanelName)
  local nIndex=ic.AddTab("IraConfigTabs",sTabText,sTipText,sPanelName,TabCallback)
  ic.vAddons[nIndex]={}
  ic.vAddons[nIndex].callback=fCallback
  WindowSetParent(sPanelName,"IraConfigClient")
  WindowClearAnchors(sPanelName)
  WindowAddAnchor(sPanelName,"topleft","IraConfigClient","topleft",0,0)
  WindowAddAnchor(sPanelName,"bottomright","IraConfigClient","bottomright",0,0)
  ic.UpdateScrollBars()
  return nIndex
end

