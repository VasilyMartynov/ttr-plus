<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <UiMod name="ThankTheResserPlus" version="1.4.0" date="12/12/2020">
	
	<Author name="origin:Sullemunk_update:Archam" email="archamasylum@gmail.com" />
	
	<Description text="Written with inspiration from ThankTheHealer, for RoR by Sullemunk. Upgraded and enhanced by Archam for Return Of Reckoning." />
	
	<VersionSettings gameVersion="1.3.1" windowsVersion="1.00" savedVariablesVersion="1.4" />
	
	<Dependencies>
		<Dependency name="EA_ChatWindow" />
		<Dependency name="LibSlash" />
		<Dependency name="(Lib) Ira Config" />
	</Dependencies>
	
	<Files>
		<File name="ThankTheResserPlus.lua" />
		<File name="config.xml" />
		<File name="config.lua" />
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