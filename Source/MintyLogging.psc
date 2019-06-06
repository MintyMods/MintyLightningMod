Scriptname MintyLogging extends Quest
{Provides logging functionality}

import debug

Bool Property showDebugMessages = False Auto  
Bool Property logDebugMessages = False Auto 
Float Property version = 11.0 Auto   
String Property LogFile = "Minty" Auto hidden
bool Property debugging = True Auto

int LOG_LEVEL_INFO = 0
int LOG_LEVEL_WARN = 1
int LOG_LEVEL_ERROR = 2


Event OnInit() 
	OpenUserLog(LogFile) 
	TraceUser(LogFile,"Minty Lightning Quest (Version:" + GetVersionAsString() + ") Init...")
EndEvent

String Function GetVersionAsString()
	return version as String
EndFunction


Function Debug(String msg) 
	if (logDebugMessages)
		 TraceUser(LogFile,msg)
	endif
EndFunction


Function Info(String msg)  
	Debug(msg)
	if (showDebugMessages)
		Notification(msg)
	endif
EndFunction


Function Warn(String msg)  
	Debug(msg)
	Notification(msg)
	TraceStack("!WARN:" + msg, LOG_LEVEL_WARN)
EndFunction


Function Error(String msg)  
	Debug(msg)
	if (showDebugMessages)
		TraceAndBox("!ERROR:" + msg, LOG_LEVEL_ERROR)
	elseif (logDebugMessages)
		TraceStack("!ERROR:" + msg, LOG_LEVEL_ERROR) 
	elseif (debugging)
		Notification(msg)
	endif
EndFunction
