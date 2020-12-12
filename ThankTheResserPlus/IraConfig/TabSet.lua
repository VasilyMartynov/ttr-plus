--[[
  IraConfig ((Lib) Ira Config) version 1.07
  by Irinia of Volkmar
  This library manages a configuaration window for add-ons, as well as providing many utillity functions for controls

  This file handles tabsets
--]]

local ic=IraConfig

ic.vTabsets={}

local TIP_ANCHOR={
  Point="left",
  RelativeTo="",
  RelativePoint="left",
  XOffset=10,
  YOffset=-3
}

--nLine is the window number, nLineNum is the position
local function AnchorTabLine(sParent,nLine,nLineNum)
  local sLineName=sParent.."Line"..nLine
  WindowClearAnchors(sLineName)
  WindowAddAnchor(sLineName,"bottomleft",sParent,"bottomleft",0,(nLineNum-1)*-29)
  WindowAddAnchor(sLineName,"bottomright",sParent,"bottomright",0,(nLineNum-1)*-29)
  DynamicImageSetTextureDimensions(sLineName.."LeftDoink",9,14)
  DynamicImageSetTextureDimensions(sLineName.."RightDoink",9,14)
  if (5-nLineNum)>=0 then
    WindowSetLayer(sLineName,5-nLineNum)
  else
    WindowSetLayer(sLineName,0)
  end
end

local function CreateTabLine(sParent,nLine)
  local sLineName=sParent.."Line"..nLine
  local x,y
  CreateWindowFromTemplate(sLineName,"IraConfigTabLine",sParent)
  WindowSetDimensions(sLineName.."SepLeft",ic.vTabsets[sParent].margin,5)
  WindowAddAnchor(sLineName.."LeftDoink","bottomleft",sParent,"bottomleft",0,14)
  WindowAddAnchor(sLineName.."RightDoink","bottomright",sParent,"bottomright",0,14)
  WindowSetId(sLineName,nLine)
  x,y=WindowGetDimensions(sParent)
  WindowSetDimensions(sParent,x,nLine*29+10)
end

local function ArangeLines(sContainer)
  local j=1
  for i=ic.vTabsets[sContainer].firstline,ic.vTabsets[sContainer].lines do
    AnchorTabLine(sContainer,i,j)
    j=j+1
  end
  if ic.vTabsets[sContainer].firstline~=1 then
    for i=1,ic.vTabsets[sContainer].firstline-1 do
      AnchorTabLine(sContainer,i,j)
      j=j+1
    end
  end
end

--Simplify the code by filtering whether we have data in this function
local function SetShowing(sWindowName,bShow)
  if sWindowName and (sWindowName~="") then
    WindowSetShowing(sWindowName,bShow)
  end
end

--Perform callback if function et
local function Callback(sContainer,nTabNum,nCode)
  local fCallback=ic.vTabsets[sContainer].tabs[nTabNum].callback
  if fCallback then
    fCallback(nCode,nTabNum)
  end
end

function ic.OnLButtonUpTab()
	local sTabName=SystemData.MouseOverWindow.name
  local nTabNumber=WindowGetId(sTabName)
  local nLineNumber=WindowGetId(WindowGetParent(sTabName))
  local sContainer=WindowGetParent(WindowGetParent(sTabName))
  local nOldTab=ic.vTabsets[sContainer].selected
  ic.vTabsets[sContainer].selected=nTabNumber
  ic.vTabsets[sContainer].firstline=nLineNumber
  if nOldTab==nTabNumber then
    return
  end
	ButtonSetPressedFlag(sContainer.."Tab"..nOldTab,false)
	ButtonSetStayDownFlag(sContainer.."Tab"..nOldTab,false)
	SetShowing(ic.vTabsets[sContainer].tabs[nOldTab].window,false)
	Callback(sContainer,nOldTab,ic.CALLBACK_HIDDEN)
	ButtonSetPressedFlag(sContainer.."Tab"..nTabNumber,true)
	ButtonSetStayDownFlag(sContainer.."Tab"..nTabNumber,true)
	SetShowing(ic.vTabsets[sContainer].tabs[nTabNumber].window,true)
	Callback(sContainer,nTabNumber,ic.CALLBACK_SHOWN)
	ArangeLines(sContainer)
end

function ic.OnMouseOverTab()
	local sTabName=SystemData.MouseOverWindow.name
  local nTabNumber=WindowGetId(sTabName)
  local sContainer=WindowGetParent(WindowGetParent(sTabName))
  local sTip=ic.vTabsets[sContainer].tabs[nTabNumber].desc
  if sTip and (sTip~=L"") then
    Tooltips.CreateTextOnlyTooltip(SystemData.ActiveWindow.name,sTip)
    Tooltips.AnchorTooltip(TIP_ANCHOR)
  end
end

function ic.CreateTabSet(sContainer,nWidth,nLeftMargin)
  if not nLeftMargin then
    nLeftMargin=1
  end
  ic.vTabsets[sContainer]={}
  ic.vTabsets[sContainer]['width']=nWidth
  ic.vTabsets[sContainer]['margin']=nLeftMargin
  ic.vTabsets[sContainer]['tabs']={}
  ic.vTabsets[sContainer]['lines']=1
  ic.vTabsets[sContainer]['firstline']=1
  ic.vTabsets[sContainer]['tabcount']=0
  ic.vTabsets[sContainer]['selected']=1
  ic.vTabsets[sContainer]['linelen']=0
  CreateTabLine(sContainer,1)
  AnchorTabLine(sContainer,1,1)
end

function ic.DestroyTabSet(sContainer)
  for i=1,ic.vTabsets[sContainer].lines do
    DestroyWindow(sContainer.."Line"..i)
  end
end

function ic.AddTab(sContainer,sTabText,sTabDescription,sToggleWindow,fCallback)
  local vTabSet=ic.vTabsets[sContainer]
  vTabSet.tabcount=vTabSet.tabcount+1
  vTabSet.tabs[vTabSet.tabcount]={}
  vTabSet.tabs[vTabSet.tabcount].text=sTabText
  vTabSet.tabs[vTabSet.tabcount].desc=sTabDescription
  vTabSet.tabs[vTabSet.tabcount].window=sToggleWindow
  vTabSet.tabs[vTabSet.tabcount].callback=fCallback
  local sTabName=sContainer.."Tab"..vTabSet.tabcount
  CreateWindowFromTemplate(sTabName,"IraConfigTab",sContainer)
  WindowSetId(sTabName,vTabSet.tabcount)
  ButtonSetText(sTabName,sTabText)
  local nWidth=ButtonGetTextDimensions(sTabName)+40
  vTabSet.tabs[vTabSet.tabcount].width=nWidth
  WindowSetDimensions(sTabName,nWidth,35)
  if (vTabSet.linelen+vTabSet.margin+nWidth+16)>vTabSet.width then
    --New line
    vTabSet.lines=vTabSet.lines+1
    vTabSet.linelen=0
    CreateTabLine(sContainer,vTabSet.lines)
    ArangeLines(sContainer)
    WindowSetParent(sTabName,sContainer.."Line"..vTabSet.lines)
    WindowAddAnchor(sTabName,"bottomright",sContainer.."Line"..vTabSet.lines.."SepLeft","bottomleft",0,0)
    SetShowing(sToggleWindow,false)
  else
    --Add to existing line
    WindowSetParent(sTabName,sContainer.."Line"..vTabSet.lines)
    if vTabSet.tabcount==1 then
      WindowAddAnchor(sTabName,"bottomright",sContainer.."Line"..vTabSet.lines.."SepLeft","bottomleft",0,0)
	    ButtonSetPressedFlag(sTabName,true)
	    ButtonSetStayDownFlag(sTabName,true)
	    SetShowing(sToggleWindow,true)
	    Callback(sContainer,1,ic.CALLBACK_SHOWN)
    else
	    SetShowing(sToggleWindow,false)
      WindowAddAnchor(sTabName,"bottomright",sContainer.."Tab"..(vTabSet.tabcount-1),"bottomleft",0,0)
    end
  end
  vTabSet.linelen=vTabSet.linelen+nWidth
  WindowClearAnchors(sContainer.."Line"..vTabSet.lines.."SepRight")
  WindowAddAnchor(sContainer.."Line"..vTabSet.lines.."SepRight","bottomright",sTabName,"bottomleft",0,0)
  WindowAddAnchor(sContainer.."Line"..vTabSet.lines.."SepRight","bottomright",sContainer.."Line"..vTabSet.lines,"bottomright",-8,0)
  vTabSet.tabs[vTabSet.tabcount].line=vTabSet.lines
  return vTabSet.tabcount
end

function ic.SetActiveTab(sContainer,nTabNumber)
	local sTabName=sContainer.."Tab"..nTabNumber
  local nLineNumber=WindowGetId(WindowGetParent(sTabName))
  local nOldTab=ic.vTabsets[sContainer].selected
  ic.vTabsets[sContainer].selected=nTabNumber
  ic.vTabsets[sContainer].firstline=nLineNumber
  if nOldTab==nTabNumber then
    return
  end
	ButtonSetPressedFlag(sContainer.."Tab"..nOldTab,false)
	ButtonSetStayDownFlag(sContainer.."Tab"..nOldTab,false)
	SetShowing(ic.vTabsets[sContainer].tabs[nOldTab].window,false)
	Callback(sContainer,nOldTab,ic.CALLBACK_HIDDEN)
	ButtonSetPressedFlag(sContainer.."Tab"..nTabNumber,true)
	ButtonSetStayDownFlag(sContainer.."Tab"..nTabNumber,true)
	SetShowing(ic.vTabsets[sContainer].tabs[nTabNumber].window,true)
	Callback(sContainer,nTabNumber,ic.CALLBACK_SHOWN)
	ArangeLines(sContainer)
end
