ROUTINE EnsLib.InteropTools.HL7.MessageAnalyzer.Output [Type=INC]

	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#; Macros for writing to the console or session


#define BYPASSLOGGER 0

#if $$$BYPASSLOGGER

/// Log the given output lines
#define LOGOUTPUT(%LOGGER,%LIST) Write $ListToString(%LIST,$Char(13,10)),!


/// Log the given output lines but only if BYPASSLOGGER is clear
#define LOGOUTPUTDB(%LOGGER,%LIST)


/// Log the given output lines if the given config flag is set but only if BYPASSLOGGER is clear
#define LOGOUTPUTIFCONFIG(%LOGGER,%LIST,%FLAG)


/// Log the given single output line
#define LOGOUTPUT1(%LOGGER,%LINE) Write %LINE,!


/// Log the given single output line but only if BYPASSLOGGER is clear
#define LOGOUTPUTDB1(%LOGGER,%LINE)


/// Log the given single output line if the given config flag is set but only if BYPASSLOGGER is clear
#define LOGOUTPUTIFCONFIG1(%LOGGER,%LINE,%FLAG)


/// Log the given single output line if the given condition is true 
#define LOGOUTPUTWRITEIF1(%LOGGER,%LINE,%COND) If %COND {Write %LINE,!}

#else

/// Log the given output lines
#define LOGOUTPUT(%LOGGER,%LIST) Do %LOGGER.OutputListToLog(%LIST)


/// Log the given output lines but only if BYPASSLOGGER is clear
#define LOGOUTPUTDB(%LOGGER,%LIST) Do %LOGGER.OutputListToLog(%LIST)


/// Log the given output lines if the given config flag is set but only if BYPASSLOGGER is clear
#define LOGOUTPUTIFCONFIG(%LOGGER,%LIST,%FLAG) Do %LOGGER.OutputListToLogIfFlag(%LIST,%FLAG)


/// Log the given output lines if the given config flag is set 
#define LOGOUTPUTIFCONFIGX(%LOGGER,%LIST,%FLAG,%CONFIG) If %CONFIG.IsFlagSet(%FLAG) {Do %LOGGER.OutputListToLog(%LIST)}


/// Log the given single output line
#define LOGOUTPUT1(%LOGGER,%LINE) Do %LOGGER.OutputToLog(%LINE)


/// Log the given single output line but only if if BYPASSLOGGER is clear
#define LOGOUTPUTDB1(%LOGGER,%LINE) Do %LOGGER.OutputToLog(%LINE)


/// Log the given single output line if the given config flag is set but only if BYPASSLOGGER is clear
#define LOGOUTPUTIFCONFIG1(%LOGGER,%LINE,%FLAG) Do %LOGGER.OutputListToLogIfFlag($LB(%LINE),%FLAG)


/// Log the given single output line if the given config flag is set 
#define LOGOUTPUTIFCONFIG1X(%LOGGER,%LINE,%FLAG,%CONFIG) $$$LOGOUTPUTIFCONFIGX(%LOGGER,$LB(%LINE),%FLAG,%CONFIG)


/// Log the given single output line if the given condition is true 
#define LOGOUTPUTWRITEIF1(%LOGGER,%LINE,%COND) If %COND {$$$LOGOUTPUT1(%LOGGER,%LINE)}

#endif
