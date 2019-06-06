Scriptname MintyQuestScript extends Quest  
{Place holder to hook into weather system}

import debug
import game
import weather

Spell Property LightningSpell Auto


Event OnInit()
	RegisterForUpdate(5)
EndEvent


Event OnUpdate()
;	Notification("Weather:"+  GetCurrentWeather().GetClassification() )
	if (GetSkyMode() == 3) 
		if (GetCurrentWeather().GetClassification() == 2)
			LightningSpell.Cast(getPlayer(), None)
		endif
	endif
endEvent
