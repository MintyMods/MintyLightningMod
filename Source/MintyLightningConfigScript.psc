Scriptname MintyLightningConfigScript extends activemagiceffect  

import Game
import debug
import utility
import weather

MintyQuestScript Property Config Auto
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
	Wait(0.5)
	ShowMainMenu()
EndEvent 


Function ShowMainMenu(Bool abMenu = True, Int aiButton = 0)
	While abMenu
		If (aiButton != -1) ; Wait for input
			aiButton = MintyMsgMainMenu.Show() 
			If (aiButton == 0)
				ShowDamageMenu()
			ElseIf (aiButton == 1)
				ShowForkMainMenu()	
			ElseIf (aiButton == 2)
				ShowSheetMainMenu()
			ElseIf (aiButton == 3)
				ShowHelp()
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


Function ShowHelp(Bool abMenu = True, Int aiButton = 0)
	; TODO as a book or note
	Log.Warn("Not Implemented Yet")
EndFunction


Function ShowDebugMainMenu(Bool abMenu = True, Int aiButton = 0)
	While abMenu
		aiButton = MintyMsgDebugMenu.Show()
		If (aiButton == 0) 
			ShowForceWeatherMenu()
		ElseIf (aiButton == 1) 
			ShowStatusMenu()
		ElseIf (aiButton == 2) 
			ShowDebugFeedBackMenu()
		ElseIf (aiButton == 3) 
			ShowCreditsMenu()
		Else
			abMenu = False 
		EndIf			
	EndWhile
EndFunction


Function ShowDamageMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDamageMenu.Show()
	If (aiButton == 0) ; Gives Damage
		Log.Info("Lightning is now hostile!")					
		Config.isLightningHostile = true
	ElseIf (aiButton == 1) ; No Damage
		Log.Info("Lightning is now harmless.")
		Config.isLightningHostile = false
	EndIf
EndFunction


Function ShowMinDistanceForkMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDistanceMinForkMenu.Show()
	If (aiButton == 0)
		Config.distanceForkMinMultiplyer = 1
	ElseIf (aiButton == 1)
		Config.distanceForkMinMultiplyer = 2
	ElseIf (aiButton == 2)
		Config.distanceForkMinMultiplyer = 3
	EndIf
	Log.Info("Min Fork Distance = " + Config.distanceForkMinMultiplyer)	
EndFunction


Function ShowMaxDistanceForkMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDistanceMaxForkMenu.Show()
	If (aiButton == 0)
		Config.distanceForkMaxMultiplyer = 1
	ElseIf (aiButton == 1)
		Config.distanceForkMaxMultiplyer = 2
	ElseIf (aiButton == 2)
		Config.distanceForkMaxMultiplyer = 3
	EndIf
	Log.Info("Max Fork Distance = " + Config.distanceForkMaxMultiplyer)	
EndFunction


Function ShowMinDistanceSheetMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDistanceMinSheetMenu.Show()
	If (aiButton == 0) 
		Config.distanceSheetMinMultiplyer = 1
	ElseIf (aiButton == 1)
		Config.distanceSheetMinMultiplyer = 2
	ElseIf (aiButton == 2)
		Config.distanceSheetMinMultiplyer = 4
	ElseIf (aiButton == 2)
		Config.distanceSheetMinMultiplyer = 5
	EndIf
	Log.Info("Min Sheet Distance = " + Config.distanceSheetMinMultiplyer)	
EndFunction


Function ShowMaxDistanceSheetMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDistanceMaxSheetMenu.Show()
	If (aiButton == 0)
		Config.distanceSheetMaxMultiplyer = 1
	ElseIf (aiButton == 1)
		Config.distanceSheetMaxMultiplyer = 2
	ElseIf (aiButton == 2)
		Config.distanceSheetMaxMultiplyer = 4
	ElseIf (aiButton == 2)
		Config.distanceSheetMaxMultiplyer = 5
	EndIf
	Log.Info("Max Sheet Distance = " + Config.distanceSheetMaxMultiplyer)	
EndFunction


Function ShowFrequencyForkMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgFrequencyForkMenu.Show()
	If (aiButton == 0) 
		Config.isForkEnabled = False
	ElseIf (aiButton == 1)
		Config.updateFrequencyFork = 10.0 
		Config.isForkEnabled = True
	ElseIf (aiButton == 2)
		Config.updateFrequencyFork = 5.0
		Config.isForkEnabled = True
	ElseIf (aiButton == 3)
		Config.updateFrequencyFork = 0.3
		Config.isForkEnabled = True
	EndIf
	Log.Info("Fork Frequncy = " + Config.updateFrequencyFork)		
EndFunction


Function ShowFrequencySheetMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgFrequencySheetMenu.Show()
	If (aiButton == 0)
		Config.isSheetEnabled = False
	ElseIf (aiButton == 1)
		Config.updateFrequencySheet = 10.0
		Config.isSheetEnabled = True
	ElseIf (aiButton == 2)
		Config.updateFrequencySheet = 5.0
		Config.isSheetEnabled = True
	ElseIf (aiButton == 3)
		Config.updateFrequencySheet = 0.3
		Config.isSheetEnabled = True
	EndIf
	Log.Info("Sheet Frequncy = " + Config.updateFrequencySheet)		
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
	aiButton = MintyMsgDbgFeedBackMenu.Show() ; Show Logging
	If (aiButton == 0) ; Off
		Config.showDebugMessages = False
		Config.logDebugMessages = False
	elseIf (aiButton == 1) ; Info
		Config.showDebugMessages = True
		Config.logDebugMessages = True
	elseIf (aiButton == 2) ; Debug
		Config.showDebugMessages = False
		Config.logDebugMessages = True
	else
		abMenu = False 
	endif
	Log.Info("Showing Feedback")
EndFunction


Function ShowBloomForkMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDbgBloomMenu.Show() ; Show Bloom
	If (aiButton == 0) 
		Config.bloomFork = 0.5
	elseIf (aiButton == 1) 
		Config.bloomFork = 1.0
	elseIf (aiButton == 2)
		Config.bloomFork = 2.0
	elseIf (aiButton == 3)
		Config.bloomFork = 3.0 
	elseIf (aiButton == 4) 
		Config.bloomFork = 4.0
	else
		abMenu = False 
	endif
	Log.Info("Fork Bloom = " + Config.bloomFork)
EndFunction


Function ShowBloomSheetMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDbgBloomMenu.Show() ; Show Bloom
	If (aiButton == 0) 
		Config.bloomSheet = 0.5
	elseIf (aiButton == 1) 
		Config.bloomSheet = 1.0
	elseIf (aiButton == 2)
		Config.bloomSheet = 2.0
	elseIf (aiButton == 3)
		Config.bloomSheet = 3.0 
	elseIf (aiButton == 4) 
		Config.bloomSheet = 4.0
	else
		abMenu = False
	endif
	Log.Info("Sheet Bloom = " + Config.bloomSheet)
EndFunction


Function ShowAnimationTimeForkMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDbgAnimMenu.Show() ; Show Wait Time
	If (aiButton == 0) 
		Config.minAnimationTimeFork = 0.0
	elseIf (aiButton == 1) 
		Config.minAnimationTimeFork = 0.15
	elseIf (aiButton == 2) 
		Config.minAnimationTimeFork = 0.3
	elseIf (aiButton == 3)
		Config.minAnimationTimeFork = 0.5
	elseIf (aiButton == 4)
		Config.minAnimationTimeFork = 1.0
	elseIf (aiButton == 5) 
		Config.minAnimationTimeFork = 2.0
	else
		abMenu = False
	endif				
	Log.Info("Fork Anim Time = " + Config.minAnimationTimeFork)
EndFunction


Function ShowAnimationTimeSheetMenu(Bool abMenu = True, Int aiButton = 0)
	aiButton = MintyMsgDbgAnimMenu.Show() ; Show Wait Time
	If (aiButton == 0) 
		Config.minAnimationTimeSheet = 0.0
	elseIf (aiButton == 1) 
		Config.minAnimationTimeSheet = 0.15
	elseIf (aiButton == 2) 
		Config.minAnimationTimeSheet = 0.3
	elseIf (aiButton == 3)
		Config.minAnimationTimeSheet = 0.5
	elseIf (aiButton == 4)
		Config.minAnimationTimeSheet = 1.0
	elseIf (aiButton == 5) 
		Config.minAnimationTimeSheet = 2.0
	else
		abMenu = False
	endif		
	Log.Info("Sheet Anim Time = " + Config.minAnimationTimeSheet)
EndFunction

Function ShowCreditsMenu(Bool abMenu = True, Int aiButton = 0)
	MessageBox( \
		"Credits:-" \
		+ "\n PlayerTwo" \ 
		+ "\n RandoomNoob" \
		+ "\n & More, see ReadMe.txt" \
		+ "\n @TODO create ReadMe.txt ;o)" \
	)
EndFunction


Function ShowStatusMenu(Bool abMenu = True, Int aiButton = 0)
	TraceAndBox("Minty Lightning Mod (Version: " + Config.version + ")" \
	+ "\nFork Freq:" + Config.updateFrequencyFork \
	+ ", Range(" + Config.distanceForkMinMultiplyer \
	+ "," + Config.distanceForkMaxMultiplyer \
	+ "), Bloom:" + Config.bloomFork \
	+ ", Wait:" + Config.minAnimationTimeFork \	
	+ "\nSheet Freq: " + Config.updateFrequencySheet \
	+ ", Range(" + Config.distanceSheetMinMultiplyer \
	+ "," + Config.distanceSheetMaxMultiplyer \
	+ "), Bloom:" + Config.bloomSheet \
	+ ", Wait:" + Config.minAnimationTimeSheet \
	+ "\nHostile:" + Config.isLightningHostile \
	+ "\nLogging:" + Config.logDebugMessages \
	+ ", Notifications:" + Config.showDebugMessages \
	+ "\nStrike Distance:" + Config.strikeDistance \
	+ "\nWeather:" + GetCurrentWeather().GetClassification())
EndFunction




