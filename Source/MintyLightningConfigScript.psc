Scriptname MintyLightningConfigScript extends activemagiceffect  
{Script to allow in-game user configuration of the global variables}

import Game
import debug
import utility
import weather
;import message

MintyConfigScript Property MintyConfig Auto
MintyLogging Property Log Auto

Weather Property SkyrimStormRainTU Auto ; 10a241
Weather Property SkyrimStormRainFF Auto ; 10a23c
Weather Property SkyrimStormRain Auto ; C8220
Weather Property SkyrimOvercastRainVT Auto ; 10A746
Weather Property FXMagicStormRain Auto ; D4886

Message Property MintyMsgMainMenu Auto
Message Property MintyMsgDamageMenu Auto
Message Property MintyMsgDebugMenu Auto
Message Property MintyMsgForkMainMenu Auto
Message Property MintyMsgDistanceMinForkMenu Auto
Message Property MintyMsgDistanceMaxForkMenu Auto
Message Property MintyMsgFrequencyForkMenu Auto
Message Property MintyMsgSheetMainMenu Auto
Message Property MintyMsgDistanceMinSheetMenu Auto
Message Property MintyMsgDistanceMaxSheetMenu Auto
Message Property MintyMsgFrequencySheetMenu Auto
Message Property MintyMsgDbgForceWeatherMenu Auto
Message Property MintyMsgDbgFeedBackMenu Auto
Message Property MintyMsgDbgBloomMenu Auto
Message Property MintyMsgDbgAnimMenu Auto


Event OnEffectStart(Actor Target, Actor Caster)
	ShowMainMenu()
EndEvent 


Function ShowMainMenu(Bool abMenu = True, Int aiButton = 0)
	While abMenu
		If (aiButton != -1) ; Wait for input
			aiButton = MintyMsgMainMenu.Show() 
			If (aiButton == 0)
				ShowStatusMenu()
			ElseIf (aiButton == 1)
				ShowForkMainMenu()	
			ElseIf (aiButton == 2)
				ShowSheetMainMenu()
			ElseIf (aiButton == 3)
				ShowDamageMenu()
			ElseIf (aiButton == 4)
				ShowDebugMainMenu()
			Else
				abMenu = False 
			EndIf
		EndIf
	EndWhile
EndFunction


Function ShowForkMainMenu(Bool abMenu = True, Int aiButton = 0)
	While abMenu
		aiButton = MintyMsgForkMainMenu.Show()
		If (aiButton == 0)
			ShowFrequencyForkMenu()
		ElseIf (aiButton == 1) 
			ShowMinDistanceForkMenu()
		ElseIf (aiButton == 2) 
			ShowMaxDistanceForkMenu()
		ElseIf (aiButton == 3) 
			ShowBloomForkMenu()
		ElseIf (aiButton == 4) 
			ShowAnimationTimeForkMenu()
		Else
			abMenu = False
		EndIf
	EndWhile
EndFunction


Function ShowSheetMainMenu(Bool abMenu = True, Int aiButton = 0)
	While abMenu
		aiButton = MintyMsgSheetMainMenu.Show()
		If (aiButton == 0)
			ShowFrequencySheetMenu()
		ElseIf (aiButton == 1) 
			ShowMinDistanceSheetMenu()
		ElseIf (aiButton == 2) 
			ShowMaxDistanceSheetMenu()
		ElseIf (aiButton == 3) 
			ShowBloomSheetMenu()
		ElseIf (aiButton == 4) 
			ShowAnimationTimeSheetMenu()
		Else
			abMenu = False
		EndIf
	EndWhile
EndFunction


Function ShowDebugMainMenu(Bool abMenu = True, Int aiButton = 0)
	While abMenu
		aiButton = MintyMsgDebugMenu.Show()
		If (aiButton == 0)
			ShowForceWeatherMenu()
		ElseIf (aiButton == 1)
			ShowDebugFeedBackMenu()
		ElseIf (aiButton == 2)
			ShowCredits()
		Else
			abMenu = False
		EndIf
	EndWhile
EndFunction


Function ShowDamageMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDamageMenu.Show()
	If (aiButton == 0)
		MintyConfig.setLightningHostile()
	ElseIf (aiButton == 1)
		MintyConfig.setLightningHarmless()
	EndIf
EndFunction


Function ShowMinDistanceForkMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDistanceMinForkMenu.Show()
	MintyConfig.setForkMinDistance(aiButton)
	Log.Info("Min Fork Distance = " + MintyConfig.getForkDistanceMin())	
EndFunction


Function ShowMaxDistanceForkMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDistanceMaxForkMenu.Show()
	MintyConfig.setForkMaxDistance(aiButton)
	Log.Info("Max Fork Distance = " + MintyConfig.getForkDistanceMax())	
EndFunction


Function ShowMinDistanceSheetMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDistanceMinSheetMenu.Show()
	MintyConfig.setSheetMinDistance(aiButton)
	Log.Info("Min Sheet Distance = " + MintyConfig.getSheetDistanceMin())	
EndFunction


Function ShowMaxDistanceSheetMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDistanceMaxSheetMenu.Show()
	MintyConfig.setSheetMaxDistance(aiButton)
	Log.Info("Max Sheet Distance = " + MintyConfig.getSheetDistanceMax())	
EndFunction


Function ShowFrequencyForkMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgFrequencyForkMenu.Show()
	If (aiButton == 0) 
		MintyConfig.disableFork()
		Log.Info("No Fork strikes")
	ElseIf (aiButton == 1)
		MintyConfig.setForkFrequency(10.0)
		MintyConfig.enableFork()
		Log.Info("Low chance for a Fork strike")
	ElseIf (aiButton == 2)
		MintyConfig.setForkFrequency(5.0)
		MintyConfig.enableFork()
		Log.Info("Medium chance for a Fork strike")
	ElseIf (aiButton == 3)
		MintyConfig.setForkFrequency(1.0)
		MintyConfig.enableFork()
		Log.Info("High chance for a Fork strike")
	EndIf
EndFunction


Function ShowFrequencySheetMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgFrequencySheetMenu.Show()
	If (aiButton == 0)
		MintyConfig.disableSheet()		
		Log.Info("No Sheet strikes")
	ElseIf (aiButton == 1)
		MintyConfig.setSheetFrequency(10.0)
		MintyConfig.enableSheet()
		Log.Info("Low chance for a Sheet strike")
	ElseIf (aiButton == 2)
		MintyConfig.setSheetFrequency(5.0)
		MintyConfig.enableSheet()
		Log.Info("Medium chance for a Sheet strike")
	ElseIf (aiButton == 3)
		MintyConfig.setSheetFrequency(1.0)
		MintyConfig.enableSheet()
		Log.Info("High chance for a Sheet strike")
	EndIf
EndFunction


Function SetRandomWeather()
	int random = RandomInt(1,5)
	if (random == 1)
		SkyrimStormRainTU.ForceActive()
	elseif (random == 2)
		SkyrimStormRainFF.ForceActive()							
	elseif (random == 3)
		SkyrimStormRain.ForceActive()
	elseif (random == 4)
		SkyrimOvercastRainVT.ForceActive()							
	elseif (random == 5)
		FXMagicStormRain.ForceActive()
	endif
	Log.Info("Random Weather : " + GetCurrentWeather())
EndFunction


Function ShowForceWeatherMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDbgForceWeatherMenu.Show()
	if (aiButton == 0) 
		SetRandomWeather()
	elseif (aiButton == 1)
		SkyrimStormRainTU.ForceActive()
		Log.Info("Weather forced to SkyrimStormRainTU - 10a241")
	elseif (aiButton == 2)
		SkyrimStormRainFF.ForceActive()
		Log.Info("Weather forced to SkyrimStormRainFF - 10a23c")
	elseif (aiButton == 3)
		SkyrimStormRain.ForceActive()
		Log.Info("Weather forced to SkyrimStormRain - C8220")
	elseif (aiButton == 4)
		SkyrimOvercastRainVT.ForceActive()
		Log.Info("Weather forced to SkyrimOvercastRainVT - 10A746")
	elseif (aiButton == 5)					
		FXMagicStormRain.ForceActive()
		Log.Info("Weather forced to FXMagicStormRain - D4886")
	endif		
EndFunction


Function ShowDebugFeedBackMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDbgFeedBackMenu.Show()
	If (aiButton == 0)
		MintyConfig.disableLogging()
		MintyConfig.disableFeedBack()
	elseIf (aiButton == 1)
		MintyConfig.enableLogging()
		MintyConfig.enableFeedBack()
	elseIf (aiButton == 2)
		MintyConfig.enableLogging()
		MintyConfig.disableFeedBack()
	else
		abMenu = False 
	endif
	Log.Info("Showing Feedback")
EndFunction


Function ShowBloomForkMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDbgBloomMenu.Show()
	If (aiButton == 0) 
		MintyConfig.setForkBloom(0.0)
	elseIf (aiButton == 1) 
		MintyConfig.setForkBloom(0.2)
	elseIf (aiButton == 2)
		MintyConfig.setForkBloom(0.5)
	elseIf (aiButton == 3)
		MintyConfig.setForkBloom(0.7)
	elseIf (aiButton == 4) 
		MintyConfig.setForkBloom(1.0)
	else
		abMenu = False 
	endif
	Log.Info("Fork Bloom = " + MintyConfig.getForkBloom())
EndFunction


Function ShowBloomSheetMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDbgBloomMenu.Show()
	If (aiButton == 0) 
		MintyConfig.setSheetBloom(0.0)
	elseIf (aiButton == 1) 
		MintyConfig.setSheetBloom(0.2)
	elseIf (aiButton == 2)
		MintyConfig.setSheetBloom(0.5)
	elseIf (aiButton == 3)
		MintyConfig.setSheetBloom(0.7)
	elseIf (aiButton == 4) 
		MintyConfig.setSheetBloom(1.0)
	else
		abMenu = False
	endif
	Log.Info("Sheet Bloom = " + MintyConfig.getSheetBloom())
EndFunction


Function ShowAnimationTimeForkMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDbgAnimMenu.Show() ; Show Wait Time
	If (aiButton == 0) 
		MintyConfig.setForkWait(0.0)
	elseIf (aiButton == 1) 
		MintyConfig.setForkWait(0.01)
	elseIf (aiButton == 2) 
		MintyConfig.setForkWait(0.03)
	elseIf (aiButton == 3)
		MintyConfig.setForkWait(0.05)
	elseIf (aiButton == 4)
		MintyConfig.setForkWait(0.1)
	elseIf (aiButton == 5) 
		MintyConfig.setForkWait(0.5)
	else
		abMenu = False
	endif				
	Log.Info("Fork Anim Time = " + MintyConfig.getForkWait())
EndFunction


Function ShowAnimationTimeSheetMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDbgAnimMenu.Show() ; Show Wait Time
	If (aiButton == 0) 
		MintyConfig.setSheetWait(0.0)
	elseIf (aiButton == 1) 
		MintyConfig.setSheetWait(0.01)
	elseIf (aiButton == 2) 
		MintyConfig.setSheetWait(0.03)
	elseIf (aiButton == 3)
		MintyConfig.setSheetWait(0.05)
	elseIf (aiButton == 4)
		MintyConfig.setSheetWait(0.1)
	elseIf (aiButton == 5) 
		MintyConfig.setSheetWait(0.5)
	else
		abMenu = False
	endif		
	Log.Info("Sheet Anim Time = " + MintyConfig.getSheetWait())
EndFunction


Function ShowStatusMenu(Bool abMenu = True, Int aiButton = 0)
	String msg = "Minty Lightning Mod (Version: " + MintyConfig.getVersion() + ")\n"

	if (MintyConfig.isForkEnabled())
		msg += getHostileDesc() + "Fork Lightning:-\n"
		msg += getForkFreqencyDesc()
		msg += "Range[" + getForkRangeDesc(MintyConfig.getForkDistanceMin()) + "," + getForkRangeDesc(MintyConfig.getForkDistanceMax()) + "]\n"
		msg += "Bloom:" + MintyConfig.getForkBloom() + ", Wait:" + MintyConfig.getForkWait() + "\n"
	else
		msg += "No Fork Lightning.\n"
	endif
	
	if (MintyConfig.isSheetEnabled())
		msg += getHostileDesc() + "Sheet Lightning:-\n"
		msg += getSheetFreqencyDesc()
		msg += "Range[" + getSheetRangeDesc(MintyConfig.getSheetDistanceMin()) + "," + getSheetRangeDesc(MintyConfig.getSheetDistanceMax()) + "]\n"
		msg += "Bloom:" + MintyConfig.getSheetBloom() + ", Wait:" + MintyConfig.getSheetWait() + "\n"
	else
		msg += "No Sheet Lightning.\n"
	endif
	
	if (!(MintyConfig.isSheetEnabled()) && !(MintyConfig.isForkEnabled()))
		msg += "WTF!? I might as well 'Delete Myself' ;o)\n"
	else
		msg += "(Logging: " + getBoolDesc(MintyConfig.isLoggingEnabled()) + ", Feedback: " + getBoolDesc(MintyConfig.isFeedbackEnabled()) + ")"
	endif

	TraceAndBox(msg)
EndFunction


String Function getBoolDesc(Bool boolien)
	if boolien
		return "Yes"
	else
		return "No"
	endif
EndFunction


String Function getForkRangeDesc(int range)
	String msg = range
	if (range == 0)
		msg = "Local"
	elseif (range == 1)
		msg = "Medium"
	elseif (range == 2)
		msg = "Far"
	endif
	return msg
EndFunction


String Function getSheetRangeDesc(int range)
	String msg = range
	if (range == 0)
		msg = "Local"
	elseif (range == 1)
		msg = "Medium"
	elseif (range == 2)
		msg = "Far"
	elseif (range == 3)
		msg = "Distant"
	endif
	return msg
EndFunction


String Function getForkFreqencyDesc()
	Float timeToNextUpdate = MintyConfig.getUpdateFrequencyFork()
	String msg = timeToNextUpdate
	if (timeToNextUpdate == 10.0)
		msg = "Low Frequency, "
	elseif (timeToNextUpdate == 5.0)
		msg = "Med Frequency, "
	elseif (timeToNextUpdate == 1.0)
		msg = "High Frequency, "
	endif
	return msg
EndFunction


String Function getSheetFreqencyDesc()
	Float timeToNextUpdate = MintyConfig.getUpdateFrequencySheet()
	String msg = timeToNextUpdate
	if (timeToNextUpdate == 10.0)
		msg = "Low Frequency, "
	elseif (timeToNextUpdate == 5.0)
		msg = "Med Frequency, "
	elseif (timeToNextUpdate == 1.0)
		msg = "High Frequency, "
	endif
	return msg
EndFunction


String Function getHostileDesc()
	if MintyConfig.isLightningHostile()
		return "Hostile "
	else 
		return ""
	endif
EndFunction


Function ShowCredits()
	MessageBox( \
		"Credits:-" \
		+ "\n Minty" \ 
		+ "\n PlayerTwo" \ 
		+ "\n see ReadMe.txt" \
	)
EndFunction

