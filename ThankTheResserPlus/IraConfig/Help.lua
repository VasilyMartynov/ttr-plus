--[[
  IraConfig ((Lib) Ira Config) version 1.05
  by Irinia of Volkmar
  This library manages a configuaration window for add-ons, as well as providing many utillity functions for controls

  This file handles the context help system
--]]

local ic=IraConfig

ic.vHelpWindows={}
ic.vHelpWinIndex={}

local function IsWindowVisible(sWindowName)
  local sWin=sWindowName
  while sWin~="Root" do
    if not WindowGetShowing(sWin) then
      return false
    end
    sWin=WindowGetParent(sWin)
  end
  return true
end

local function AnchorWindow(sWindowName,vAnchorList)
  local vAnchor
  WindowClearAnchors(sWindowName)
  for k,v in ipairs(vAnchorList) do
    if k==1 then
      vAnchor={
        point="topleft",
        relativePoint="topleft",
        relativeTo=WindowGetParent(sWindowName),
        ["x"]=0,
        ["y"]=0
      }
    else
      vAnchor={
        point="bottomright",
        relativePoint="bottomright",
        relativeTo=WindowGetParent(sWindowName),
        ["x"]=0,
        ["y"]=0
      }
    end
    WindowAddAnchor(sWindowName,v.point or vAnchor.point,v.relativeTo or vAnchor.relativeTo,v.relativePoint or vAnchor.relativePoint,v.x or vAnchor.x,v.y or vAnchor.y)
  end
end

function ic.HelpInit()
  CreateWindow("IraConfigHelpTip",false)
  WindowSetShowing("IraConfigHelpTip",false)
end

function ic.HelpCreateContext(sParentWindow)
  local nContextId=#ic.vHelpWinIndex+1
  ic.vHelpWindows[sParentWindow]={
    index=nContextId,
    areas={},
    showingtext=false
  }
  ic.vHelpWinIndex[nContextId]=sParentWindow
  CreateWindowFromTemplate("IraConfigHelpCanvas"..nContextId,"IraConfigHelpCanvas",sParentWindow)
  WindowSetId("IraConfigHelpCanvas"..nContextId,nContextId)
  WindowSetShowing("IraConfigHelpCanvas"..nContextId,false)
end

function ic.HelpShow(sParentWindow)
  if not ic.vHelpWindows[sParentWindow] then
    d("Help context "..sParentWindow.." doesn't exist")
    return
  end
  if ic.sActiveContext then
    ic.HelpHide(ic.sActiveContext)
  end
  for k,v in ipairs(ic.vHelpWindows[sParentWindow].areas) do
    WindowSetShowing("IraConfigHelpCanvas"..ic.vHelpWindows[sParentWindow].index.."Area"..k,IsWindowVisible(v.ref))
  end
  ic.sActiveContext=sParentWindow
  WindowSetShowing("IraConfigHelpCanvas"..ic.vHelpWindows[sParentWindow].index,true)
end

function ic.HelpHide(sParentWindow)
  if not sParentWindow then
    return
  end
  if not ic.vHelpWindows[sParentWindow] then
    d("Help context "..sParentWindow.." doesn't exist")
    return
  end
  if ic.sActiveContext~=sParentWindow then
    return
  end
  ic.sActiveContext=nil
  ic.vHelpWindows[sParentWindow].showingtext=false
  WindowSetShowing("IraConfigHelpCanvas"..ic.vHelpWindows[sParentWindow].index,false)
  WindowSetShowing("IraConfigHelpTip",false)
end

function ic.HelpToggle(sParentWindow)
  if not ic.vHelpWindows[sParentWindow] then
    d("Help context "..sParentWindow.." doesn't exist")
    return
  end
  if ic.sActiveContext==sParentWindow then
    ic.HelpHide(sParentWindow)
  else
    ic.HelpShow(sParentWindow)
  end
end

function ic.HelpCreateSimpleArea(sParentWindow,sReferenceWindow,nLevel,fTextCallback,vParam1,vParam2,vParam3,vParam4)
  local vAnchors={
    [1]={relativeTo=sReferenceWindow},
    [2]={relativeTo=sReferenceWindow},
  }
  ic.HelpCreateComplexArea(sParentWindow,sReferenceWindow,vAnchors,nLevel,fTextCallback,vParam1,vParam2,vParam3,vParam4)
end

function ic.HelpCreateComplexArea(sParentWindow,sReferenceWindow,vAnchors,nLevel,fTextCallback,vParam1,vParam2,vParam3,vParam4)
  local nAreaId
  local sAreaName
  if not ic.vHelpWindows[sParentWindow] then
    d("Help context "..sParentWindow.." doesn't exist")
    return
  end
  if nLevel<1 then
    nLevel=1
  end
  if nLevel>4 then
    nLevel=4
  end
  nAreaId=#ic.vHelpWindows[sParentWindow].areas+1
  ic.vHelpWindows[sParentWindow].areas[nAreaId]={
    ref=sReferenceWindow,
    callback=fTextCallback,
    param1=vParam1,
    param2=vParam2,
    param3=vParam3,
    param4=vParam4,
  }
  sAreaName="IraConfigHelpCanvas"..ic.vHelpWindows[sParentWindow].index.."Area"..nAreaId
  CreateWindowFromTemplate(sAreaName,"IraConfigHelpSpot","IraConfigHelpCanvas"..ic.vHelpWindows[sParentWindow].index)
  AnchorWindow(sAreaName,vAnchors)
  WindowSetLayer(sAreaName,nLevel)
  WindowSetId(sAreaName,nAreaId)
  if nLevel==1 then
    WindowSetTintColor(sAreaName,192,255,128)
  elseif nLevel==2 then
    WindowSetTintColor(sAreaName,255,128,192)
  elseif nLevel==3 then
    WindowSetTintColor(sAreaName,128,192,255)
  else
    WindowSetTintColor(sAreaName,255,255,255)
  end
end

function ic.HelpClickedCanvas()
	local sCanvas=SystemData.MouseOverWindow.name
	local nCanvasIndex=WindowGetId(sCanvas)
	if ic.vHelpWinIndex[nCanvasIndex] and (ic.vHelpWinIndex[nCanvasIndex]==WindowGetParent(sCanvas)) then
	  ic.HelpHide(ic.vHelpWinIndex[nCanvasIndex])
  end
end


function ic.HelpClickedSpot()
	local sSpot=SystemData.MouseOverWindow.name
	local nSpotIndex=WindowGetId(sSpot)
	local sCanvas=WindowGetParent(sSpot)
	local nCanvasIndex=WindowGetId(sCanvas)
	local sContext=ic.vHelpWinIndex[nCanvasIndex]
	local vArea
	local sHelp
	if sContext and (sContext==WindowGetParent(sCanvas)) then
	  vArea=ic.vHelpWindows[sContext].areas[nSpotIndex]
	  sHelp=vArea.callback(vArea.param1,vArea.param2,vArea.param3,vArea.param4)
	  if type(sHelp)=="wstring" then
	    for k,v in ipairs(ic.vHelpWindows[sContext].areas) do
	      if k~=nSpotIndex then
	        WindowSetShowing("IraConfigHelpCanvas"..nCanvasIndex.."Area"..k,false)
	      end
	    end
	    ic.HelpTip(sContext,sSpot,sHelp)
	  else
	    ic.HelpHide(ic.vHelpWinIndex[nCanvasIndex])
	  end
  end
end

function ic.HelpTip(sContext,sArea,sString)
  local x,y
  local wCurrent,wNext
  local xRoot,yRoot
  local xBind,yBind
  local xTip,yTip
  local xArea,yArea
  local nScale
  local bRight=false
  --In case it's already showing, hide and unanchor it
  WindowSetShowing("IraConfigHelpTip",false)
  WindowClearAnchors("IraConfigHelpTip")

  --Set tip and size it  
  LabelSetText("IraConfigHelpTipLabel",sString)
  x,y=LabelGetTextDimensions("IraConfigHelpTipLabel")
  WindowSetDimensions("IraConfigHelpTip",300,y+20)
  
  --Find the highest ancestor of the context
  wCurrent=sContext
  wNext=WindowGetParent(wCurrent)
  while wNext~="Root" do
    wCurrent=wNext
    wNext=WindowGetParent(wCurrent)
  end
  
  --Find out sizes and positions then anchor the tip
  xRoot,yRoot=WindowGetDimensions("Root")
  nScale=WindowGetScale("Root")
  --xRoot=xRoot*nScale
  yRoot=yRoot*nScale
  
  xBind,yBind=WindowGetDimensions(wCurrent)
  nScale=WindowGetScale(wCurrent)
  --xBind=xBind*nScale
  yBind=yBind*nScale
  
  xTip,yTip=WindowGetDimensions("IraConfigHelpTip")
  nScale=WindowGetScale("IraConfigHelpTip")
  xTip=xTip*nScale
  yTip=yTip*nScale

  xArea,yArea=WindowGetScreenPosition(sArea)
  x,y=WindowGetScreenPosition(wCurrent)
  
  if x<xTip then
    bRight=true
  end
  
  if yTip>yBind then
    --Tip is bigger than ancestor
    if (y+yTip)>yRoot then
      --Tip would go off bottom of screen if anchored to top
      if bRight then
        WindowAddAnchor("IraConfigHelpTip","bottomright",wCurrent,"bottomleft",0,0)
      else
        WindowAddAnchor("IraConfigHelpTip","bottomleft",wCurrent,"bottomright",0,0)
      end
    else
      if bRight then
        WindowAddAnchor("IraConfigHelpTip","topright",wCurrent,"topleft",0,0)
      else
        WindowAddAnchor("IraConfigHelpTip","topleft",wCurrent,"topright",0,0)
      end
    end
  elseif (yArea+yTip)>(y+yBind) then
    --Tip would hang off if positioned by area
    if bRight then
      WindowAddAnchor("IraConfigHelpTip","bottomright",wCurrent,"bottomleft",0,0)
    else
      WindowAddAnchor("IraConfigHelpTip","bottomleft",wCurrent,"bottomright",0,0)
    end
  else
    --Tip would fit
    y=(yArea-y)/WindowGetScale(wCurrent)
    if bRight then
      WindowAddAnchor("IraConfigHelpTip","topright",wCurrent,"topleft",0,y)
    else
      WindowAddAnchor("IraConfigHelpTip","topleft",wCurrent,"topright",0,y)
    end
  end

  --Show it, setup other stuff
  WindowSetShowing("IraConfigHelpTip",true)
  ic.sActiveArea=sArea
  ic.vHelpWindows[sContext].showingtext=true
end

function ic.HelpCheckMouseOut()
  if SystemData.MouseOverWindow.name~=ic.sActiveArea then
    ic.HelpHide(ic.sActiveContext)
  end
end

function ic.HelpBtnInit()
  local sBtn=SystemData.ActiveWindow.name
  ButtonSetText(sBtn,L"?")
  for i=0,5 do
    ButtonSetTextColor(sBtn,i,128,0,0)
  end
end
