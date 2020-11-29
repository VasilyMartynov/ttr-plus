<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <UiMod name="ThankTheResserPlus" version="1.3.0" date="30/11/2020">

        <Author name="origin:Sullemunk_update:Archam" email="archamasylum@gmail.com" />
		
		<Description text="Written with inspiration from ThankTheHealer, for RoR by Sullemunk. Upgraded and enhanced by Archam for Return Of Reckoning." />
		
		<VersionSettings gameVersion="1.3.5" windowsVersion="1.0" savedVariablesVersion="1.0" />
		
		<Dependencies>
	    	<Dependency name="EA_ChatWindow" />
	    	<Dependency name="LibSlash" />
        </Dependencies>
 
		<Files>
            <File name="ThankTheResserPlus.lua" />           
        </Files>
        
		<OnInitialize>
            <CallFunction name="ThankTheResserPlus.Initialize" />
        </OnInitialize>
       
		<SavedVariables>
        	<SavedVariable name="ThankTheResserPlus.Settings" />
			<SavedVariable name="ThankTheResserPlus.Dictionary" />
        </SavedVariables> 

		<OnUpdate/>
 
		<OnShutdown>
            <CallFunction name="ThankTheResserPlus.Shutdown" />
        </OnShutdown>
        
<WARInfo>
    <Categories>
        <Category name="CHAT" />
    </Categories>
    <Careers>
        <Career name="BLACKGUARD" />
        <Career name="IRON_BREAKER" />
        <Career name="BLACK_ORC" />
        <Career name="KNIGHT" />
        <Career name="CHOSEN" />
        <Career name="SWORDMASTER" />
        <Career name="SHADOW_WARRIOR" />
    </Careers>
</WARInfo>
    </UiMod>
</ModuleFile>