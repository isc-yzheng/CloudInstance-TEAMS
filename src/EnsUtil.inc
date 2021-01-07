ROUTINE EnsUtil [Type=INC]
 
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#ifndef NODEBUG
#define DEBUG
#endif
 
#ifdef DEBUG
#define ASSERTNOLOG(%condition)  If '(%condition) { Write !,"Assert Condition Failed: "_##quote(%condition),!  BREAK }
#else
#define ASSERTNOLOG(%condition)
#endif
 
#; Macros to get current class and method at compile time. 
#define CurrentClass         $classname()
#define CurrentMethod        ##safeexpression(""""_$get(%methodname)_"""")
#define ClassSQLTable(%c)    ($$$comClassKeyGet(%c,$$$cCLASSsqlschemaname)_"."_$$$comClassKeyGet(%c,$$$cCLASSsqltablename))
 
#; Current Timestamp in ODBC format
#define timeUTCtoUTCH(%utc)  $zdatetimeh(%utc,3,,,,,,,,0)
#define timeUTCHtoUTC(%utch) $zdatetime(%utch,3,,3)
#define timeUTC              $zdatetime($ztimestamp,3,,3)
#define timeUTCH             $ztimestamp
#define timeLocal            ##class(Ens.DataType.UTC).LogicalToOdbc($$$timeUTC)
#define timeUTCtoLocal(%utc) ##class(Ens.DataType.UTC).LogicalToOdbc(%utc)
#define timeLocaltoUTC(%utc) ##class(Ens.DataType.UTC).OdbcToLogical(%utc)
#define timeCmp(%t2,%t1)     $$HorologCmp^EnsUtil($$$timeUTCtoUTCH(%t2),$$$timeUTCtoUTCH(%t1))
#define timeDiff(%t2,%t1)    $$HorologDiff^EnsUtil($$$timeUTCtoUTCH(%t2),$$$timeUTCtoUTCH(%t1))
#define timeHDiff(%t2,%t1)   $$HorologDiff^EnsUtil(%t2,%t1)
#define timeAddSecs(%t,%s)   $$$timeUTCHtoUTC($$HorologAddSecs^EnsUtil($$$timeUTCtoUTCH(%t),%s))
 
#; Get a Class Parameter from a class
#define GetClassParameter(%cls,%parm) $$$comMemberKeyGet(%cls,$$$cCLASSparameter,%parm,$$$cPARAMdefault)
#define GetPropertyParameter(%cls,%prop,%parm) $$$comMemberArrayGet(%cls,$$$cCLASSproperty,%prop,$$$cPROPparameter,%parm)

#; Test if object variable is defined and not Null
#define IsdefObject(%obj)           ($Data(%obj)#2&&$IsObject(%obj))
 
#; Test if an I/O device name indicates it is a terminal device
#define IsTerminalDevice(%io)       $S($e(%io,1,5)="/dev/":$lf($lb("pts","tty"),$e($p(%io,"/",3),1,3)),1:$lf($lb("TRM","TNT","TNA"),$tr(%io,"0123456789|:.")))
 
#; DisplayString macros
#def1arg StatusText(%args)          $$GetOneStatusText^%apiOBJ(%args)
#def1arg StatusDisplayString(%args) $$getAllErrorTexts^EnsUtil(%args)
#def1arg StatusEquals(%args)        ##safeexpression($$macroStatusEquals^%occMsgXML(%literalargs))
 
#define PAD(%s,%l) $Extract($Reverse($Justify($Reverse(%s),%l)),1,%l)
#define NUM(%i,%l) $Translate($Justify(%i,%l)," ","0")
 
#define AND(%l,%r) $ZBoolean(%l\1,%r\1,1)
#define OR(%l,%r)  $ZBoolean(%l\1,%r\1,7)
#define XOR(%l,%r) $ZBoolean(%l\1,%r\1,6)
 
#define OBJCOUNT(%var)   Set %var=0 do {Set o="" for { Set o=$zobjnext(o) Quit:o=""  Set %var=%var+1}} while 0
 
#ifndef envEnsembleRoot
#define envEnsembleRoot  $get(^SourceRoot($namespace),$get(^%qSourceRoot($namespace),$get(^%SYS("SourceRoot",$namespace))))
#endif
 
#ifndef envEnsembleDir
#define envEnsembleDir   $select($$$envEnsembleRoot'="":$$$envEnsembleRoot,1:"m:/")
#endif
 
#; Localization macro to retrieve localized strings in domain EnsColumns
#define GetLocalizedName(%name)  $Case($$FormatMessage^%occMessages("","EnsColumns"_$Namespace,%name,%name),%name:$$FormatMessage^%occMessages("","EnsColumns",%name,%name),:$$FormatMessage^%occMessages("","EnsColumns"_$Namespace,%name,%name))
