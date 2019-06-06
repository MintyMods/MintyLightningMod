Scriptname MintyMcmPatchQuestScript extends SKI_ConfigBase  
{Quest script to support SkyUI MCM config menus}

MintyConfigScript Property MintyConfig Auto

; Lightning Config Page - Control References - SkyUI OID's
int ForkEnabledCheckBox
int ForkHostileCheckBox
int ForkFrequencySlider
int ForkMinDistanceSlider
int ForkMaxDistanceSlider
int ForkBloomTimeSlider
int ForkBloomLevelSlider
int ForkSoundDelaySlider 
int SheetEnabledCheckBox
int SheetHostileCheckBox
int SheetFrequencySlider
int SheetMinDistanceSlider
int SheetMaxDistanceSlider
int SheetBloomTimeSlider
int SheetBloomLevelSlider
int SheetSoundDelaySlider

; Miscellaneous Page  - Control References - SkyUI OID's
int ForceWeatherMenu
int ForceWeatherButton
int LoggingEnabledCheckBox
int LoggingToScreenCheckBox
int LegacyConfigCheckBox

; Weather option IDs
int[] WeatherToggleOIDs 
bool[] WeatherToggleValues

; UI State
float current_weather

int weather_to_force
string[] weathersList

; Constants 
string PAGE_DEFAULT = ""
string PAGE_CONFIG = "$Lightning Config";
string PAGE_MISC = "$Miscellaneous"
string PAGE_DEBUG = "$Globals"
string PAGE_CREDITS = "$Credits"
string PAGE_WEATHERS = "$Weathers"

int function GetVersion()
	return 23 ; Default version
endFunction

Event OnConfigInit()
	ModName = "Minty Lightning"
	buildPages()
	AddBadWeathers()
endEvent

event OnVersionUpdate(int a_version)
	; a_version is the new version, CurrentVersion is the old version
	if (a_version >= 23 && CurrentVersion < 23)
		Debug.Trace("Minty Lightning : Updating to version " + a_version)
		OnConfigInit()
	endIf
endEvent

Event OnGameReload()
	Parent.OnGameReload()
EndEvent

Function buildPages()
	Pages = new String[4]
	Pages[0] = PAGE_CONFIG
	Pages[1] = PAGE_MISC
	Pages[2] = PAGE_DEBUG
	;Pages[3] = PAGE_WEATHERS
	Pages[3] = PAGE_CREDITS
EndFunction

event OnPageReset(string page_selected)
	SetCursorFillMode(TOP_TO_BOTTOM)
	UnloadCustomContent()
	if (PAGE_CONFIG == page_selected)
		buildConfigPage()
	elseif (PAGE_MISC == page_selected)
		buildMiscPage()
	elseif (PAGE_CREDITS == page_selected)
		buildCreditsPage()
	elseif (PAGE_WEATHERS == page_selected)
		buildWeathersPage()
	elseif (PAGE_DEBUG == page_selected)
		buildDebugPage()
	elseif (PAGE_DEFAULT == page_selected)
		LoadCustomContent("MintyMods/MintyLightningMod.swf")
	endif
endEvent

event OnOptionSelect(int option)
	If (option == ForkHostileCheckBox)
		if (MintyConfig.isForkLightningHostile())
			MintyConfig.setForkLightningHarmless()
		else
			MintyConfig.setForkLightningHostile()
		endif
		SetToggleOptionValue(option, MintyConfig.isForkLightningHostile())
	elseif (option == ForkEnabledCheckBox)
		if (MintyConfig.isForkEnabled())
			MintyConfig.disableFork()
		else
			MintyConfig.enableFork()
		endif
		SetToggleOptionValue(option, MintyConfig.isForkEnabled())
	elseif (option == SheetEnabledCheckBox)
		if (MintyConfig.isSheetEnabled())
			MintyConfig.disableSheet()
		else
			MintyConfig.enableSheet()
		endif
		SetToggleOptionValue(option, MintyConfig.isSheetEnabled())
	elseIf (option == SheetHostileCheckBox)
		if (MintyConfig.isSheetLightningHostile())
			MintyConfig.setSheetLightningHarmless()
		else
			MintyConfig.setSheetLightningHostile()
		endif
		SetToggleOptionValue(option, MintyConfig.isSheetLightningHostile())
	elseIf (option == LoggingEnabledCheckBox)
		if (MintyConfig.isLoggingEnabled())
			MintyConfig.disableLogging()
		else
			MintyConfig.enableLogging()
		endif
		SetToggleOptionValue(option, MintyConfig.isLoggingEnabled())
	elseIf (option == LoggingToScreenCheckBox)
		if (MintyConfig.isFeedbackEnabled())
			MintyConfig.disableFeedback()
		else
			MintyConfig.enableFeedback()
		endif
		SetToggleOptionValue(LoggingToScreenCheckBox, MintyConfig.isFeedbackEnabled())
	elseIf (option == LegacyConfigCheckBox)
		if (MintyConfig.isLegacyMenuDisabled())
			MintyConfig.enableLegacyMenu()
		else
			MintyConfig.disableLegacyMenu()
		endif
		SetToggleOptionValue(option, MintyConfig.isLegacyMenuDisabled())
	elseIf (option == ForceWeatherButton)
		ForceBadWeather()
	endIf
	
	if (CurrentPage == PAGE_WEATHERS)
		int idx = WeatherToggleOIDs.find(option);
		if (idx != -1)
			WeatherToggleValues[idx] = !WeatherToggleValues[idx]
			SetToggleOptionValue(option, WeatherToggleValues[idx])
		endIf
	endif
	
endEvent


function buildWeathersPage()
	WeatherToggleOIDs = new int[128]
	WeatherToggleValues = new bool[128]
	FormList MintyBadWeathers = Game.GetFormFromFile(0x0101D776, "MintyLightningMod.esp") As FormList
	int count = 0
	
	AddHeaderOption("$Enabled")
	if (MintyBadWeathers) 
		int index = MintyBadWeathers.GetSize() 
		count = index
		While(index > 0)
			index -= 1
			Weather BadWeather = MintyBadWeathers.GetAt(index) as Weather
			WeatherToggleValues[index] = true
			WeatherToggleOIDs[index] = AddToggleOption(BadWeather.GetFormID(), true)
		EndWhile
	endif
	
	SetCursorPosition(1)
	AddHeaderOption("$Disabled")
	FormList MintyBadWeathersRemoved = Game.GetFormFromFile(0x0104026F, "MintyLightningMod.esp") As FormList
	if (MintyBadWeathersRemoved) 
		int index = MintyBadWeathersRemoved.GetSize() 
		While(index > 0)
			index -= 1
			Weather BadWeather = MintyBadWeathersRemoved.GetAt(index) as Weather
			WeatherToggleValues[count + index] = false
			WeatherToggleOIDs[count + index] = AddToggleOption(BadWeather.GetFormID(), false)
		EndWhile
	endif	
endfunction


function buildDebugPage() 
	
	AddHeaderOption("$Fork Lightning")
	AddTextOption("MintyIsForkEnabled", MintyConfig.isForkEnabled(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyIsForkLightningHostile", MintyConfig.isForkLightningHostile(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyForkSoundDelay", MintyConfig.getForkSoundDelay(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyForkDistanceMin", MintyConfig.getForkDistanceMin(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyForkDistanceMax", MintyConfig.getForkDistanceMax(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyForkFrequency", MintyConfig.getForkFrequency(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyForkBloom", MintyConfig.getForkBloom(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyForkWait", MintyConfig.getForkWait(), OPTION_FLAG_DISABLED)
	AddEmptyOption()
	
	AddHeaderOption("$Debugging")
	AddTextOption("MintyVersion", MintyConfig.getVersion(), OPTION_FLAG_DISABLED)	
	AddTextOption("MintyLoggingEnabled", MintyConfig.isLoggingEnabled(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyFeedBackEnabled", MintyConfig.isFeedbackEnabled(), OPTION_FLAG_DISABLED)
	
	SetCursorPosition(1) ; Move cursor to top right position
	
	AddHeaderOption("$Sheet Lightning")
	AddTextOption("MintyIsSheetEnabled", MintyConfig.isSheetEnabled(), OPTION_FLAG_DISABLED)	
	AddTextOption("MintyIsSheetLightningHostile", MintyConfig.isSheetLightningHostile(), OPTION_FLAG_DISABLED)
	AddTextOption("MintySheetSoundDelay", MintyConfig.getSheetSoundDelay(), OPTION_FLAG_DISABLED)
	AddTextOption("MintySheetDistanceMin", MintyConfig.getSheetDistanceMin(), OPTION_FLAG_DISABLED)
	AddTextOption("MintySheetDistanceMax", MintyConfig.getSheetDistanceMax(), OPTION_FLAG_DISABLED)
	AddTextOption("MintySheetFrequency", MintyConfig.getSheetFrequency(), OPTION_FLAG_DISABLED)
	AddTextOption("MintySheetBloom", MintyConfig.getSheetBloom(), OPTION_FLAG_DISABLED)
	AddTextOption("MintySheetWait", MintyConfig.getSheetWait(), OPTION_FLAG_DISABLED)
	AddEmptyOption()
	
	AddHeaderOption("$Advanced")
	AddTextOption("MintyWeatherCheckFrequency", MintyConfig.getUpdateFrequencyWeatherCheck(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyCellSize", MintyConfig.getCellSize(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyCellHeight", MintyConfig.GetCellHeight(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyStrikeDistance", MintyConfig.getStrikeDistance(), OPTION_FLAG_DISABLED)
	AddEmptyOption()
	
	AddHeaderOption("$Experimental")
	AddTextOption("MintyDisableLegacyMenu", MintyConfig.isLegacyMenuDisabled(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyStrikeHeightByRegion", MintyConfig.shouldPlaceStrikeHeightsByRegion(), OPTION_FLAG_DISABLED)
	AddTextOption("MintyFaceTarget", MintyConfig.shouldFaceTarget(), OPTION_FLAG_DISABLED)

endfunction 



event OnOptionMenuOpen(int option)
	if (option == ForceWeatherMenu)
		SetMenuDialogOptions(weathersList)
		SetMenuDialogStartIndex(weather_to_force)
		SetMenuDialogDefaultIndex(1)
	endIf
endEvent




function buildConfigPage()
	AddHeaderOption("$Fork Lightning Options")
	ForkEnabledCheckBox = AddToggleOption("$Enabled", MintyConfig.isForkEnabled())
	ForkHostileCheckBox = AddToggleOption("$Hostile", MintyConfig.isForkLightningHostile()) 
	ForkFrequencySlider = AddSliderOption("$Frequency Delay", MintyConfig.getForkFrequency(), "{2}")
	ForkSoundDelaySlider = AddSliderOption("$Sound Delay", MintyConfig.getForkSoundDelay(), "{2}",OPTION_FLAG_DISABLED)
	ForkMinDistanceSlider = AddSliderOption("$Minimum distance", MintyConfig.getForkDistanceMin(), "{0} cells")
	ForkMaxDistanceSlider = AddSliderOption("$Maximum distance", MintyConfig.getForkDistanceMax(), "{0} cells")
	AddEmptyOption()
	AddHeaderOption("$Fork Bloom Options")
	ForkBloomTimeSlider = AddSliderOption("$Animation time", MintyConfig.getForkWait(), "{2}")
	ForkBloomLevelSlider = AddSliderOption("$Bloom level", MintyConfig.getForkBloom(), "{2}")
	SetCursorPosition(1) ; Move cursor to top right position
	AddHeaderOption("$Sheet Lightning Options")
	SheetEnabledCheckBox = AddToggleOption("$Enabled", MintyConfig.isSheetEnabled())
	SheetHostileCheckBox = AddToggleOption("$Hostile", MintyConfig.isSheetLightningHostile())
	SheetFrequencySlider = AddSliderOption("$Frequency Delay", MintyConfig.getSheetFrequency(), "{2}")
	SheetSoundDelaySlider = AddSliderOption("$Sound Delay", MintyConfig.getSheetSoundDelay(), "{2}",OPTION_FLAG_DISABLED)
	SheetMinDistanceSlider = AddSliderOption("$Minimum distance", MintyConfig.getSheetDistanceMin(), "{0} cells")
	SheetMaxDistanceSlider = AddSliderOption("$Maximum distance", MintyConfig.getSheetDistanceMax(), "{0} cells")
	AddEmptyOption()
	AddHeaderOption("$Sheet Bloom Options")
	SheetBloomTimeSlider = AddSliderOption("$Animation time", MintyConfig.getSheetWait(), "{2}")
	SheetBloomLevelSlider = AddSliderOption("$Bloom level", MintyConfig.getSheetBloom(), "{2}")	
endfunction

function buildMiscPage()
	AddHeaderOption("$Logging Options")
	LoggingEnabledCheckBox = AddToggleOption("$Logging Enabled", MintyConfig.isLoggingEnabled())
	LoggingToScreenCheckBox = AddToggleOption("$Show in game", MintyConfig.isFeedbackEnabled())
	AddEmptyOption()
	AddHeaderOption("$Weather Options")
	AddTextOption("$Current Weather", Weather.GetCurrentWeather().GetFormID(), OPTION_FLAG_DISABLED)
	ForceWeatherMenu = AddMenuOption("$Force Weather", weathersList[weather_to_force])
	ForceWeatherButton = AddTextOption("$Force", "")
	AddEmptyOption()
	AddHeaderOption("$Miscellaneous")
	LegacyConfigCheckBox = AddToggleOption("$Legacy Config Menu", MintyConfig.isLegacyMenuDisabled())
	SetCursorPosition(1) ; Move cursor to top right position
	AddHeaderOption("$Information")
	AddTextOption("$Version", MintyConfig.getVersion(), OPTION_FLAG_DISABLED)
	AddEmptyOption()
endfunction

function buildCreditsPage() 
	AddHeaderOption("$Author")
	AddTextOption("$Lightning during Thunder Storms", "Minty", OPTION_FLAG_DISABLED)
	AddEmptyOption()
	
	AddHeaderOption("$Contributors")
	AddTextOption("Real Rain", "Player Two", OPTION_FLAG_DISABLED)
	AddTextOption("Climates of Tamriel", "jjc71/James", OPTION_FLAG_DISABLED)
	AddTextOption("SkyUI", "SkyUI Team", OPTION_FLAG_DISABLED)
	AddEmptyOption()
	
	AddHeaderOption("$Translators")
	AddTextOption("$English", "Minty :D", OPTION_FLAG_DISABLED)
	AddTextOption("$Czech", "Vanilka", OPTION_FLAG_DISABLED)
	AddTextOption("$French", "Bufle", OPTION_FLAG_DISABLED)
	AddTextOption("$Polish", "olbins", OPTION_FLAG_DISABLED)
	AddTextOption("$Polish", "Magdalena Maria Monika", OPTION_FLAG_DISABLED)
	AddTextOption("$Spanish", "Gomstor! Original", OPTION_FLAG_DISABLED)
	AddTextOption("$Italian", "Lucasssvt", OPTION_FLAG_DISABLED)
	AddTextOption("$German", "Mahlzeit88", OPTION_FLAG_DISABLED)
	AddTextOption("$Russian", "Still needed...", OPTION_FLAG_DISABLED)
	AddTextOption("$Japanese", "Still needed...", OPTION_FLAG_DISABLED)
	AddEmptyOption()
	
	SetCursorPosition(1) 
	AddHeaderOption("$Credits")
	AddTextOption("Papyrus", "RandomNoob", OPTION_FLAG_DISABLED)
	AddTextOption("Papyrus", "JustinOther", OPTION_FLAG_DISABLED)
	AddEmptyOption()
	
	AddHeaderOption("$Thanks")
	AddTextOption("Jim", "©?©K??©??®", OPTION_FLAG_DISABLED)
	AddTextOption("Darren", "Jet-Set-Willy", OPTION_FLAG_DISABLED)
	AddTextOption("Lewis", "Lugar", OPTION_FLAG_DISABLED)
	AddEmptyOption()
	
	AddHeaderOption("$Resources")
	AddTextOption("http://www.creationkit.com","", OPTION_FLAG_DISABLED)
	AddTextOption("http://forums.bethsoft.com","", OPTION_FLAG_DISABLED)

endfunction 



event OnOptionDefault(int option)
	if (option == ForkEnabledCheckBox)
		SetToggleOptionValue(option, MintyConfig.isForkEnabledDefault())
	elseIf (option == ForkHostileCheckBox)
		SetToggleOptionValue(option, MintyConfig.isForkLightningHostileDefault())
	elseIf (option == SheetEnabledCheckBox)
		SetToggleOptionValue(option, MintyConfig.isSheetEnabledDefault())
	elseIf (option == SheetHostileCheckBox)
		SetToggleOptionValue(option, MintyConfig.isSheetLightningHostileDefault())
	elseIf (option == LoggingEnabledCheckBox)
		SetToggleOptionValue(option, false)
	elseIf (option == LoggingToScreenCheckBox)
		SetToggleOptionValue(option, false)
	elseIf (option == LegacyConfigCheckBox)
		SetToggleOptionValue(option, true)
	endIf
endEvent


event OnOptionMenuAccept(int option, int index)
	if (option == ForceWeatherMenu)
		weather_to_force = index
		SetMenuOptionValue(ForceWeatherMenu, weathersList[weather_to_force])
	endIf
endEvent




event OnOptionSliderOpen(int option)
	if (option == ForkBloomLevelSlider)
		SetSliderDialogStartValue(MintyConfig.getForkBloom())
		SetSliderDialogDefaultValue(MintyConfig.getForkBloomDefault())
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)
	elseIf (option == SheetBloomLevelSlider)
		SetSliderDialogStartValue(MintyConfig.getSheetBloom())
		SetSliderDialogDefaultValue(MintyConfig.getSheetBloomDefault())
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)
	elseIf (option == SheetSoundDelaySlider)
		SetSliderDialogStartValue(MintyConfig.getSheetSoundDelay())
		SetSliderDialogDefaultValue(0.5000)
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)
	elseIf (option == ForkSoundDelaySlider)
		SetSliderDialogStartValue(MintyConfig.getForkSoundDelay())
		SetSliderDialogDefaultValue(0.5000)
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)
	elseIf (option == ForkFrequencySlider)
		SetSliderDialogStartValue(MintyConfig.getForkFrequency())
		SetSliderDialogDefaultValue(MintyConfig.getForkFrequencyDefault())
		SetSliderDialogRange(0.0, 50.0)
		SetSliderDialogInterval(1.0)
	elseIf (option == SheetFrequencySlider)
		SetSliderDialogStartValue(MintyConfig.getSheetFrequency())
		SetSliderDialogDefaultValue(MintyConfig.getSheetFrequencyDefault())
		SetSliderDialogRange(0.0, 50.0)
		SetSliderDialogInterval(1.0)
	elseIf (option == ForkBloomTimeSlider)
		SetSliderDialogStartValue(MintyConfig.getForkWait())
		SetSliderDialogDefaultValue(MintyConfig.getForkWaitDefault())
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)
	elseIf (option == SheetBloomTimeSlider)
		SetSliderDialogStartValue(MintyConfig.getSheetWait())
		SetSliderDialogDefaultValue(MintyConfig.getSheetWaitDefault())
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)
	elseIf (option == ForkMinDistanceSlider)
		SetSliderDialogStartValue(MintyConfig.getForkDistanceMin())
		SetSliderDialogDefaultValue(MintyConfig.getForkDistanceMinDefault())
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(1.0)
	elseIf (option == ForkMaxDistanceSlider)
		SetSliderDialogStartValue(MintyConfig.getForkDistanceMax())
		SetSliderDialogDefaultValue(MintyConfig.getForkDistanceMaxDefault())
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(1.0)
	elseIf (option == SheetMinDistanceSlider)
		SetSliderDialogStartValue(MintyConfig.getSheetDistanceMin())
		SetSliderDialogDefaultValue(MintyConfig.getSheetDistanceMinDefault())
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(1.0)
	elseIf (option == SheetMaxDistanceSlider)
		SetSliderDialogStartValue(MintyConfig.getSheetDistanceMax())
		SetSliderDialogDefaultValue(MintyConfig.getSheetDistanceMaxDefault())
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(1.0)
	endIf
endEvent


event OnOptionSliderAccept(int option, float value)
	if (option == ForkBloomLevelSlider)
		MintyConfig.setForkBloom(value)
		SetSliderOptionValue(option, MintyConfig.getForkBloom(), "{2}")
	elseIf (option == SheetBloomLevelSlider)
		MintyConfig.setSheetBloom(value)
		SetSliderOptionValue(option, MintyConfig.getSheetBloom(), "{2}")
	elseIf (option == SheetSoundDelaySlider)
		MintyConfig.setSheetSoundDelay(value)
		SetSliderOptionValue(option, MintyConfig.getSheetSoundDelay(), "{2}")
	elseIf (option == ForkSoundDelaySlider)
		MintyConfig.setForkSoundDelay(value)
		SetSliderOptionValue(option, MintyConfig.getForkSoundDelay(), "{2}")
	elseIf (option == ForkFrequencySlider)
		MintyConfig.setForkFrequency(value)
		SetSliderOptionValue(option, MintyConfig.getForkFrequency(), "{2}")
	elseIf (option == SheetFrequencySlider)
		MintyConfig.setSheetFrequency(value)
		SetSliderOptionValue(option, MintyConfig.getSheetFrequency(), "{2}")
	elseIf (option == ForkBloomTimeSlider)
		MintyConfig.setForkWait(value)
		SetSliderOptionValue(option, MintyConfig.getForkWait(), "{2}")
	elseIf (option == SheetBloomTimeSlider)
		MintyConfig.setSheetWait(value)
		SetSliderOptionValue(option, MintyConfig.getSheetWait(), "{2}")	
	elseIf (option == ForkMinDistanceSlider)
		MintyConfig.setForkMinDistance(value as int)
		SetSliderOptionValue(option, MintyConfig.getForkDistanceMin(), "{0} cells")
	elseIf (option == ForkMaxDistanceSlider)
		MintyConfig.setForkMaxDistance(value as int)
		SetSliderOptionValue(option, MintyConfig.getForkDistanceMax(), "{0} cells")
	elseIf (option == SheetMinDistanceSlider)
		MintyConfig.setSheetMinDistance(value as int)
		SetSliderOptionValue(option, MintyConfig.getSheetDistanceMin(), "{0} cells")
	elseIf (option == SheetMaxDistanceSlider)
		MintyConfig.setSheetMaxDistance(value as int)
		SetSliderOptionValue(option, MintyConfig.getSheetDistanceMax(), "{0} cells")
	endIf
endEvent


Function ForceBadWeather()
	FormList MintyBadWeathers = Game.GetFormFromFile(0x0101D776, "MintyLightningMod.esp") As FormList
	Weather BadWeather = MintyBadWeathers.GetAt(weather_to_force) as Weather
	BadWeather.ForceActive()
	ShowMessage("Weather Forced " + BadWeather.GetFormID())
EndFunction


Function AddBadWeathers()
	FormList MintyBadWeathers = Game.GetFormFromFile(0x0101D776, "MintyLightningMod.esp") As FormList
	if (MintyBadWeathers) 
		int index = MintyBadWeathers.GetSize() 
		weathersList = new string[128]
		While(index > 0)
			index -= 1
			Weather BadWeather = MintyBadWeathers.GetAt(index) as Weather
			weathersList[index] = BadWeather.GetFormID() 
		EndWhile
	endif
EndFunction


event OnOptionHighlight(int option)
	if (CurrentPage == PAGE_CONFIG)
		OnOptionHighlightToolTipConfigPage(option)
	elseif  (CurrentPage == PAGE_MISC)
		OnOptionHighlightToolTipMiscPage(option)
	elseif  (CurrentPage == PAGE_DEBUG)
		OnOptionHighlightToolTipDebugPage(option)
	else
		; default "" page, shows .swf
	endif
endEvent


function OnOptionHighlightToolTipDebugPage(int option)
	SetInfoText("$Global Variable names I use, and they can be set via console if you want even more control, If you find a good fit, let me know and I will make them my defaults :D")
endfunction

function OnOptionHighlightToolTipConfigPage(int option)
	if (option == ForkEnabledCheckBox)
		SetInfoText("$When enabled strikes will fork from the sky and hit the ground")
	elseIf (option == ForkHostileCheckBox || option == SheetHostileCheckBox)
		SetInfoText("$When enabled strikes will be hostile and gives damage to anything hit")
	elseIf (option == ForkFrequencySlider || option == SheetFrequencySlider)
		SetInfoText("$This is the delay between strikes")
	elseIf (option == ForkMinDistanceSlider || option == SheetMinDistanceSlider)
		SetInfoText("$The mimimum distance a strike can land, measured in game cells")
	elseIf (option == ForkMaxDistanceSlider || option == SheetMaxDistanceSlider)
		SetInfoText("$The maximum distance a strike can land, measured in game cells")
	elseIf (option == ForkBloomTimeSlider || option == SheetBloomTimeSlider)
		SetInfoText("$How long the bloom effect will be applied for during a Lightning strike")
	elseIf (option == ForkBloomLevelSlider || option == SheetBloomLevelSlider)
		SetInfoText("$How bright the bloom will be applied")
	elseIf (option == SheetEnabledCheckBox)
		SetInfoText("$When enabled Sheet Lightning strikes in the sky")
	elseIf (option == SheetSoundDelaySlider || option == ForkSoundDelaySlider)
		SetInfoText("$Delay before the sound is played after the strike has hit")
	endif
endfunction

function OnOptionHighlightToolTipMiscPage(int option)
	if (option == ForceWeatherMenu)
		SetInfoText("$Select one of the available 'Bad' weathers and force it to play")
	elseIf (option == LoggingEnabledCheckBox)
		SetInfoText("http://www.creationkit.com/FAQ:_My_Script_Doesn't_Work")
	elseIf (option == LoggingToScreenCheckBox)
		SetInfoText("$Show the high level logging messages on the screen as in game notifications")
	elseIf (option == LegacyConfigCheckBox)
		SetInfoText("$Add or remove the original configuration menus")
	elseIf (option == ForceWeatherButton)		
		SetInfoText("$Force the selected bad weather")
	endif
endfunction

