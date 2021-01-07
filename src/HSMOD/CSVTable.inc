ROUTINE HSMOD.CSVTable [Type=INC]
#define ThrowErrorForSqlCode(%sqlcode)  if (%sqlcode < 0) { Throw ##class(%Exception.StatusException).ThrowIfInterrupt($$$ERROR($$$SQLError,%sqlcode,$System.SQL.SQLCODE(%sqlcode))) } 
