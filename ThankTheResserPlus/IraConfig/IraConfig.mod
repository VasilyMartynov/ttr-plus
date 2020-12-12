<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
  <UiMod name="(Lib) Ira Config" version="1.08" date="19/08/2009" >
    <VersionSettings gameVersion="1.3.1" windowsVersion="1.00" savedVariablesVersion="1.00" />

    <Author name="Irinia of Volkmar" />
    <Description text="This library is used to display configuration pages for add-ons" />

    <Dependencies>
      <Dependency name="EATemplate_DefaultWindowSkin" />
    </Dependencies>

    <Files>
      <File name="IraConfig.lua" />
      <File name="TabSet.lua" />
      <File name="Spinner.lua" />
      <File name="IraConfig.xml" />
      <File name="Help.lua" />
    </Files>

    <OnInitialize>
      <CallFunction name="IraConfig.Initialize" />
    </OnInitialize>

    <WARInfo>
      <Categories>
        <Category name="SYSTEM" />
      </Categories>
    </WARInfo>
  </UiMod>

</ModuleFile>
