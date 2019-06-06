Scriptname MintyLightningConfigScript extends activemagiceffect  

import Game
import debug
import utility
import weather

MintyQuestScript Property MintyLightningQuest Auto
Book Property MintyLightningConfigBook Auto

; Config Menus
Message Property MintyMsgMainMenu Auto
Message Property MintyMsgDamageMenu Auto
Message Property MintyMsgTypeMenu Auto
Message Property MintyMsgDistanceMenu Auto
Message Property MintyMsgDistanceForkMenu Auto
Message Property MintyMsgDistanceSheetMenu Auto
Message Property MintyMsgFrequencyMenu Auto

; Debug Menus
Message Property MintyMsgDebugMenu Auto
Message Property MintyMsgDebugMenuMore Auto
Message Property MintyMsgStrikeOffsetMenu Auto
Message Property MintyMsgNumTargetsMenu Auto
Message Property MintyMsgDbgForceWeatherMenu Auto
Message Property MintyMsgDbgFeedBackMenu Auto
Message Property MintyMsgDbgBloomMenu Auto
Message Property MintyMsgDbgAnimMenu Auto
String version = "9.0" ; Current Version
String LogFile = "Minty"


Function LogDebug(String msg) 
	if (MintyLightningQuest.logDebugMessages)
		 TraceUser(LogFile,msg)
	endif
EndFunction


Function LogInfo(String msg) 
	if (MintyLightningQuest.showDebugMessages)
		Notification(msg)
	endif
	LogDebug(msg)
EndFunction


Event OnEffectStart(Actor Target, Actor Caster)
	
	OpenUserLog(LogFile) 
	DisablePlayerControls(abMenu = True) ; Momentarily disable other menus
	EnablePlayerControls(abMenu = True) ; Undo DisablePlayerControls
	ShowMainMenu()
 
EndEvent 


Function ShowMainMenu(Bool abMenu = True, Int aiButton = 0)
	Wait(0.5)
	While abMenu
		If (aiButton != -1) ; Wait for input
		
			aiButton = MintyMsgMainMenu.Show() ; Main Menu
			If (aiButton == 0) ; DAMAGE MENU
		
				aiButton = MintyMsgDamageMenu.Show()
				If (aiButton == 0) ; Gives Damage
					LogInfo("Lightning is now hostile!")					
					MintyLightningQuest.isLightningHostile = true
				ElseIf (aiButton == 1) ; No Damage
					LogInfo("Lightning is now harmless.")
					MintyLightningQuest.isLightningHostile = false
				EndIf
				
			ElseIf (aiButton == 1) ; FORK/SHEET
				aiButton = MintyMsgTypeMenu.Show()
				If (aiButton == 0) ; 0%
					MintyLightningQuest.chanceToFork = 0
				ElseIf (aiButton == 1) ; 10%
					MintyLightningQuest.chanceToFork = 10
				ElseIf (aiButton == 2) ; 25% 
					MintyLightningQuest.chanceToFork = 25 ; DEFAULT
				ElseIf (aiButton == 3) ; 50%
					MintyLightningQuest.chanceToFork = 50
				ElseIf (aiButton == 4) ; 75%
					MintyLightningQuest.chanceToFork = 75
				ElseIf (aiButton == 5) ; 100%
					MintyLightningQuest.chanceToFork = 100
				EndIf
				LogInfo("Fork Lightning Chance = " + MintyLightningQuest.chanceToFork + "%")
			ElseIf (aiButton == 2) ; DISTANCE
			; START
				aiButton = MintyMsgDistanceMenu.Show()
				If (aiButton == 0) ; Fork
				
					aiButton = MintyMsgDistanceForkMenu.Show()
					If (aiButton == 0) ; Fork
						MintyLightningQuest.distanceForkMultiplyer = 1
					ElseIf (aiButton == 1) ; Medium
						MintyLightningQuest.distanceForkMultiplyer = 2
					ElseIf (aiButton == 2) ; Long range 
						MintyLightningQuest.distanceForkMultiplyer = 3
					EndIf
					LogInfo("Distance Multiplyer = " + MintyLightningQuest.distanceForkMultiplyer)	
					
				ElseIf (aiButton == 1) ; Sheet
					
					aiButton = MintyMsgDistanceSheetMenu.Show()
					If (aiButton == 0) ; Local
						MintyLightningQuest.distanceSheetMultiplyer = 1
					ElseIf (aiButton == 1) ; Medium
						MintyLightningQuest.distanceSheetMultiplyer = 2
					ElseIf (aiButton == 2) ; Long range 
						MintyLightningQuest.distanceSheetMultiplyer = 4
					ElseIf (aiButton == 2) ; Distant range 
						MintyLightningQuest.distanceSheetMultiplyer = 5
					EndIf
					LogInfo("Distance Multiplyer = " + MintyLightningQuest.distanceSheetMultiplyer)	
					
				Else
					abMenu = False 
				EndIf
			; END	
			ElseIf (aiButton == 3) 	; FREQUENCY
				aiButton = MintyMsgFrequencyMenu.Show()
				If (aiButton == 0) ; Low
					MintyLightningQuest.updateFrequency = 10.0
				ElseIf (aiButton == 1) ; Medium (Default)
					MintyLightningQuest.updateFrequency = 5.0
				ElseIf (aiButton == 2) ; High
					MintyLightningQuest.updateFrequency = 1.0
				EndIf
				LogInfo("Frequncy = " + MintyLightningQuest.updateFrequency)				
			ElseIf (aiButton == 4) 	; DEBUG MENU 
			
				While abMenu
					aiButton = MintyMsgDebugMenu.Show()
					If (aiButton == 0) 
						
						aiButton = MintyMsgDbgForceWeatherMenu.Show() ; Force Weather
						If (aiButton == 0) 
							
							; RANDOM selection
							int random = RandomInt(1,5)
							if (random == 1)
								MintyLightningQuest.SkyrimStormRainTU.ForceActive()
							elseif (random == 2)
								MintyLightningQuest.SkyrimStormRainFF.ForceActive()							
							elseif (random == 3)
								MintyLightningQuest.SkyrimStormRain.ForceActive()
							elseif (random == 4)
								MintyLightningQuest.SkyrimOvercastRainVT.ForceActive()							
							elseif (random == 5)
								MintyLightningQuest.FXMagicStormRain.ForceActive()
							endif
							
						ElseIf (aiButton == 1) ; SkyrimStormRainTU 10a241
							MintyLightningQuest.SkyrimStormRainTU.ForceActive()
						ElseIf (aiButton == 2) ; SkyrimStormRainFF 10a23c
							MintyLightningQuest.SkyrimStormRainFF.ForceActive()
						ElseIf (aiButton == 3) ; SkyrimStormRain C8220 
							MintyLightningQuest.SkyrimStormRain.ForceActive()
						ElseIf (aiButton == 4) ; SkyrimOvercastRainVT 10A746
							MintyLightningQuest.SkyrimOvercastRainVT.ForceActive()
						ElseIf (aiButton == 5) ; FXMagicStormRain D4886							
							MintyLightningQuest.FXMagicStormRain.ForceActive()
						EndIf		
						LogInfo("Waeather forced to " + GetCurrentWeather())
						
					ElseIf (aiButton == 1) ; SHOW STATUS
					
						TraceAndBox("Minty Lightning Mod (Version: " + version + ")" \
						+ "\n\t Bloom: " + MintyLightningQuest.bloom \ 
						+ "\n\t Strike Offset: " + MintyLightningQuest.strikeOffset \
						+ "\n\t Frequncy: " + MintyLightningQuest.updateFrequency \
						+ "\n\t Distance Fork: " + MintyLightningQuest.distanceForkMultiplyer \
						+ "\n\t Distance Sheet: " + MintyLightningQuest.distanceSheetMultiplyer \
						+ "\n\t Bloom: " + MintyLightningQuest.bloom \
						+ "\n\t Anim Time: " + MintyLightningQuest.minAnimationTime \
						+ "\n\t Fork Chance: " + MintyLightningQuest.chanceToFork \
						+ "\n\t Hostile: " + MintyLightningQuest.isLightningHostile \
						+ "\n\t Logging: " + MintyLightningQuest.logDebugMessages \
						+ "\n\t Notifications: " + MintyLightningQuest.showDebugMessages \
						+ "\n\t Weather: " + GetCurrentWeather())
					
					ElseIf (aiButton == 2) ; SHOW CREDITS
						MessageBox( \
							"Credits:-" \
							+ "\n PlayerTwo" \ 
							+ "\n RandoomNoob" \
							+ "\n RedRavyn" \
							+ "\n & More, see ReadMe.txt" \
						)
					
					ElseIf (aiButton == 3) ; MORE...
						
						aiButton = MintyMsgDebugMenuMore.Show()
						
						If (aiButton == 0) 
							aiButton = MintyMsgStrikeOffsetMenu.Show() ; STRIKE OFFSET
							If (aiButton == 0) 
								MintyLightningQuest.strikeOffset = 10.0
							ElseIf (aiButton == 1)
								MintyLightningQuest.strikeOffset = 50.0
							ElseIf (aiButton == 2) 
								MintyLightningQuest.strikeOffset = 100.0 ; DEFAULT
							ElseIf (aiButton == 3) 
								MintyLightningQuest.strikeOffset = 200.0
							ElseIf (aiButton == 4) 
								MintyLightningQuest.strikeOffset = 500.0
							EndIf					
					
						ElseIf (aiButton == 1) 
					
							aiButton = MintyMsgDbgFeedBackMenu.Show() ; Show Logging
							If (aiButton == 0) ; Off
								MintyLightningQuest.showDebugMessages = False
								MintyLightningQuest.logDebugMessages = False
							elseIf (aiButton == 1) ; Info
								MintyLightningQuest.showDebugMessages = True
								MintyLightningQuest.logDebugMessages = True
							elseIf (aiButton == 2) ; Debug
								MintyLightningQuest.showDebugMessages = False
								MintyLightningQuest.logDebugMessages = True
							else
								abMenu = False ; End the log level function
							endif
						
						ElseIf (aiButton == 2) ; SHOW BLOOM

							aiButton = MintyMsgDbgBloomMenu.Show() ; Show Bloom
							If (aiButton == 0) 
								MintyLightningQuest.bloom = 0.5
							elseIf (aiButton == 1) 
								MintyLightningQuest.bloom = 1.0
							elseIf (aiButton == 2)
								MintyLightningQuest.bloom = 2.0
							elseIf (aiButton == 3)
								MintyLightningQuest.bloom = 3.0 
							elseIf (aiButton == 2) 
								MintyLightningQuest.bloom = 4.0
							else
								abMenu = False ; End the log level function
							endif

						ElseIf (aiButton == 3) ; Animation Time			
						
							aiButton = MintyMsgDbgAnimMenu.Show() ; Show Wait Time
							If (aiButton == 0) 
								MintyLightningQuest.minAnimationTime = 0.0
							elseIf (aiButton == 1) 
								MintyLightningQuest.minAnimationTime = 0.15
							elseIf (aiButton == 2) 
								MintyLightningQuest.minAnimationTime = 0.3
							elseIf (aiButton == 3)
								MintyLightningQuest.minAnimationTime = 0.5
							elseIf (aiButton == 4)
								MintyLightningQuest.minAnimationTime = 1.0
							elseIf (aiButton == 5) 
								MintyLightningQuest.minAnimationTime = 2.0
							else
								abMenu = False ; End the log level function
							endif						
						Else
							abMenu = False ; End the debug menu function
						EndIf
						
					Else
						abMenu = False ; End the debug menu function
					EndIf			
				EndWhile
				
			Else 
				abMenu = False ; End the main message function
			EndIf
		EndIf
	EndWhile
 
EndFunction
