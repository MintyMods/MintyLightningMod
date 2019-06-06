Scriptname MintyQuestScript extends MintyWeatherUtils
{Place holder to hook into weather system}

import game
import utility

Quest Property qMintyLightningQuestFork Auto
Quest Property qMintyLightningQuestSheet Auto
Book Property MintyLightningConfigBook Auto


Event OnInit()
	GotoState("WatchingTheWeather")
	Info("Minty Lightning Quest (Version:" + MintyVersion.GetValue() + ") Init...")
	InitBooks()
	RegisterForSingleUpdate(getUpdateFrequencyWeatherCheck())		
EndEvent


; STATES
State WatchingTheWeather

	Event OnInit()
		; Ignore any further Inits...
	EndEvent

	Event OnUpdate()
		if (isStormWeather())
			Debug("Storm Weather Detected - Updating, in " + getUpdateFrequencyWeatherCheck())
			if (isForkEnabled())
				StartForking()
			endif
			if (isSheetEnabled())
				StartSheeting()
			endif
		else 
			Debug("Shutting down weather system")
			qMintyLightningQuestFork.stop()
			qMintyLightningQuestSheet.stop()
		endif
		RegisterForSingleUpdate(getUpdateFrequencyWeatherCheck())		
	endEvent

EndState


Function StopForking()
	disableFork()
	qMintyLightningQuestFork.stop()
EndFunction	


Function StartForking()
	enableFork()
	qMintyLightningQuestFork.start()
EndFunction	


Function StopSheeting()
	disableSheet()
	qMintyLightningQuestSheet.stop()
EndFunction		


Function StartSheeting()
	enableSheet()
	qMintyLightningQuestSheet.start()
EndFunction		

	
Function InitBooks()
	Actor Player = GetPlayer()
	if (Player.GetItemCount(MintyLightningConfigBook) < 1)
		Player.addItem(MintyLightningConfigBook)
	endif
EndFunction

