--[[
  IraConfig ((Lib) Ira Config) version 1.05
  by Irinia of Volkmar
  This library manages a configuaration window for add-ons, as well as providing many utillity functions for controls

  This file handles spinner controls
--]]

local ic=IraConfig

ic.vSpinners={}

function ic.SetupSpinner(sEditName,nMaxValue,nMinValue,nInc)
  CreateWindowFromTemplate(sEditName.."Spinner","IraConfigSpinner",WindowGetParent(sEditName))
  WindowAddAnchor(sEditName.."Spinner","right",sEditName,"left",1,0)
  if not nMaxValue then
    nMaxValue=999999
  end
  if (not nInc) or (nInc<1) then
    nInc=1
  end
  if (not nMinValue) or (nMinValue<0) then
    nMinValue=0
  end
  ic.vSpinners[sEditName]={max=nMaxValue,min=nMinValue,inc=nInc}
  --WindowRegisterCoreEventHandler(sEditName,"OnTextChanged","IraConfig.SpinnerChange")
  --WindowRegisterCoreEventHandler(sEditName,"OnMouseWheel","IraConfig.SpinnerWheel")
end

function ic.SpinnerMinus()
  local sName=SystemData.MouseOverWindow.name
  local a,b,sParent=WindowGetAnchor(WindowGetParent(sName),1)
  local nValue=tonumber(TextEditBoxGetText(sParent))
  if nValue<=ic.vSpinners[sParent].min then
    nValue=ic.vSpinners[sParent].max
  elseif (nValue==ic.vSpinners[sParent].max) and (ic.vSpinners[sParent].inc>1) then
    --in order to keep the same increments on 0-255 spinners...
    if math.mod(ic.vSpinners[sParent].max,ic.vSpinners[sParent].inc)~=0 then
      nValue=ic.vSpinners[sParent].max-math.mod(ic.vSpinners[sParent].max,ic.vSpinners[sParent].inc)
    else
      nValue=nValue-ic.vSpinners[sParent].inc
    end
  elseif (nValue-ic.vSpinners[sParent].inc)<ic.vSpinners[sParent].min then
    nValue=ic.vSpinners[sParent].min
  else
    nValue=nValue-ic.vSpinners[sParent].inc
  end
  TextEditBoxSetText(sParent,towstring(nValue))
end

function ic.SpinnerPlus()
  local sName=SystemData.MouseOverWindow.name
  local a,b,sParent=WindowGetAnchor(WindowGetParent(sName),1)
  local nValue=tonumber(TextEditBoxGetText(sParent))
  if nValue>=ic.vSpinners[sParent].max then
    nValue=ic.vSpinners[sParent].min
  elseif (nValue+ic.vSpinners[sParent].inc)>ic.vSpinners[sParent].max then
    nValue=ic.vSpinners[sParent].max
  else
    nValue=nValue+ic.vSpinners[sParent].inc
  end
  TextEditBoxSetText(sParent,towstring(nValue))
end

function ic.SpinnerChange()
  local sName=SystemData.ActiveWindow.name
  if (not sName) or (not ic.vSpinners[sName]) then
    return
  end
  local nValue=tonumber(TextEditBoxGetText(sName))
  local bChange=false
  if nValue<ic.vSpinners[sName].min then
    nValue=ic.vSpinners[sName].min
    bChange=true
  end
  if nValue>ic.vSpinners[sName].max then
    nValue=ic.vSpinners[sName].max
    bChange=true
  end
  if bChange then
    TextEditBoxSetText(sName,towstring(nValue))
  end
end

