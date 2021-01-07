ROUTINE EnsSQLTypes [Type=INC]
#; EnsSQLTypes.INC
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
 
#; *** SQL.H ***
#; SQL data type codes 
#define SqlUnknownType     0 /* SqlTypeNull */
#define SqlChar            1
#define SqlNumeric         2
#define SqlDecimal         3
#define SqlInteger         4
#define SqlSmallint        5
#define SqlFloat           6
#define SqlReal            7
#define SqlDouble          8
#define SqlDateTime        9
#define SqlVarchar         12
 
#; One-parameter shortcuts for date/time data types 
#define SqlTypeDate        91
#define SqlTypeTime        92
#define SqlTypeTimestamp   93
 
#; *** SQLUCODE.H ***
#define SqlWChar           (-8)
#define SqlWVarchar        (-9)
#define SqlWLongVarchar    (-10)
#define SqlCWChar          $$$SqlWChar

#; *** SQLEXT.H ***
#; SQL extended datatypes
#define SqlDate            9
#define SqlInterval        10
#define SqlTime            10
#define SqlTimestamp       11
#define SqlLongVarchar     (-1)
#define SqlBinary          (-2)
#define SqlVarBinary       (-3)
#define SqlLongVarBinary   (-4)
#define SqlBigint          (-5)
#define SqlTinyint         (-6)
#define SqlBit             (-7)
#define SqlGuid            (-11)
 
#; interval codes
#define SqlCodeYear                1
#define SqlCodeMonth               2
#define SqlCodeDay                 3
#define SqlCodeHour                4
#define SqlCodeMinute              5
#define SqlCodeSecond              6
#define SqlCodeYearToMonth         7
#define SqlCodeDayToHour           8
#define SqlCodeDayToMinute         9
#define SqlCodeDayToSecond         10
#define SqlCodeHourToMinute        11
#define SqlCodeHourToSecond        12
#define SqlCodeMinuteToSecond      13
 
#define SqlIntervalYear            (100 + $$$SqlCodeYear)
#define SqlIntervalMonth           (100 + $$$SqlCodeMonth)
#define SqlIntervalDay             (100 + $$$SqlCodeDay) 
#define SqlIntervalHour            (100 + $$$SqlCodeHour) 
#define SqlIntervalMinute          (100 + $$$SqlCodeMinute) 
#define SqlIntervalSecond          (100 + $$$SqlCodeSecond) 
#define SqlIntervalYearToMonth     (100 + $$$SqlCodeYearToMonth)
#define SqlIntervalDayToHour       (100 + $$$SqlCodeDayToHour) 
#define SqlIntervalDayToMinute     (100 + $$$SqlCodeDayToMinute) 
#define SqlIntervalDayToSecond     (100 + $$$SqlCodeDayToSecond) 
#define SqlIntervalHourToMinute    (100 + $$$SqlCodeHourToMinute)
#define SqlIntervalHourToSecond    (100 + $$$SqlCodeHourToSecond) 
#define SqlIntervalMinuteToSecond  (100 + $$$SqlCodeMinuteToSecond) 
 
 
#define SqlUnicode                 $$$SqlWChar
#define SqlUnicodeVarchar          $$$SqlWVarchar
#define SqlUnicodeLongVarchar      $$$SqlWLongVarchar
#define SqlUnicodeChar             $$$SqlWChar
 
#define SqlDB2BLOB                 (-98)
#define SqlDB2CLOB                 (-99)
#define SqlDB2DBCLOB               (-350) /* Double Byte CLOB */
#define SqlDB2XML                  (-370)
  
#; C datatype to SQL datatype mapping Sql types
#define SqlCChar                   $$$SqlChar          /* CHAR, VARCHAR, DECIMAL, NUMERIC */
#define SqlCLong                   $$$SqlInteger       /* INTEGER */
#define SqlCShort                  $$$SqlSmallint      /* SMALLINT */
#define SqlCFloat                  $$$SqlReal          /* REAL */
#define SqlCDouble                 $$$SqlDouble        /* FLOAT, DOUBLE */
#define SqlCNumeric                $$$SqlNumeric
#define SqlCDefault                99
 
#define SqlSignedOffset            (-20)
#define SqlUnsignedOffset          (-22)
 
#; C datatype to SQL datatype mapping 
#define SqlCDate                   $$$SqlDate
#define SqlCTime                   $$$SqlTime
#define SqlCTimeStamp              $$$SqlTimestamp
#define SqlCTypeDate               $$$SqlTypeDate
#define SqlCTypeTime               $$$SqlTypeTime
#define SqlCTypeTimeStamp          $$$SqlTypeTimestamp
#define SqlCIntervalYear           $$$SqlIntervalYear
#define SqlCIntervalMonth          $$$SqlIntervalMonth
#define SqlCIntervalDay            $$$SqlIntervalDay
#define SqlCIntervalHour           $$$SqlIntervalHour
#define SqlCIntervalMinute         $$$SqlIntervalMinute
#define SqlCIntervalSecond         $$$SqlIntervalSecond
#define SqlCIntervalYearToMonth    $$$SqlIntervalYearToMonth
#define SqlCIntervalDayToHour      $$$SqlIntervalDayToHour
#define SqlCIntervalDayToMinute    $$$SqlIntervalDayToMinute
#define SqlCIntervalDayToSecond    $$$SqlIntervalDayToSecond
#define SqlCIntervalHourToMinute   $$$SqlIntervalHourToMinute
#define SqlCIntervalHourToSecond   $$$SqlIntervalHourToSecond
#define SqlCIntervalMinuteToSecond $$$SqlIntervalMinuteToSecond
 
#define SqlCBinary         $$$SqlBinary
#define SqlCBit            $$$SqlBit
#define SqlCSBigint        ($$$SqlBigint + $$$SqlSignedOffset)      /* SIGNED BIGINT */
#define SqlCUBigint        ($$$SqlBigint + $$$SqlUnsignedOffset)    /* UNSIGNED BIGINT */
#define SqlCTinyint        $$$SqlTinyint
#define SqlCSLong          ($$$SqlCLong  + $$$SqlSignedOffset)      /* SIGNED INTEGER */
#define SqlCSShort         ($$$SqlCShort + $$$SqlSignedOffset)      /* SIGNED SMALLINT */
#define SqlCSTinyint       ($$$SqlTinyint+ $$$SqlSignedOffset)      /* SIGNED TINYINT */
#define SqlCULong          ($$$SqlCLong  + $$$SqlUnsignedOffset)    /* UNSIGNED INTEGER */
#define SqlCUShort         ($$$SqlCShort + $$$SqlUnsignedOffset)    /* UNSIGNED SMALLINT */
#define SqlCUTinyint       ($$$SqlTinyint+ $$$SqlUnsignedOffset)    /* UNSIGNED TINYINT */
#define SqlCBookmark       $$$SqlCULong                             /* BOOKMARK */
#define SqlCGuid           $$$SqlGuid
 
#define SqlTypeNull        0
#define SqlCVarBookmark    $$$SqlCBinary
 
#; *** java.sql.Types http://java.sun.com/javase/6/docs/api/index.html ***
#define SqlJArray          2003
#define SqlJBigint         $$$SqlBigint
#define SqlJBinary         $$$SqlBinary
#define SqlJBit            $$$SqlBit
#define SqlJBLOB           2004
#define SqlJBoolean        16
#define SqlJChar           $$$SqlChar
#define SqlJCLOB           2005
#define SqlJDataLink       70
#define SqlJDate           $$$SqlTypeDate
#define SqlJDecimal        $$$SqlDecimal
#define SqlJDistinct       2001
#define SqlJDouble         $$$SqlDouble
#define SqlJFloat          $$$SqlFloat
#define SqlJInteger        $$$SqlInteger
#define SqlJObject         2000
#define SqlJLongNVarchar   (-16) /* SqlCSLong */
#define SqlJLongVarBinary  $$$SqlLongVarBinary
#define SqlJLongVarchar    $$$SqlLongVarchar
#define SqlJNChar          (-15) /* SqlCSShort */
#define SqlJNCLOB          2011
#define SqlJNull           $$$SqlTypeNull
#define SqlJNumeric        $$$SqlNumeric
#define SqlJNVarchar       $$$SqlWVarchar
#define SqlJOther          1111
#define SqlJReal           $$$SqlReal
#define SqlJRef            2006
#define SqlJRowID          $$$SqlWChar
#define SqlJSmallint       $$$SqlSmallint
#define SqlJSQLXML         2009
#define SqlJStruct         2002
#define SqlJTime           $$$SqlTypeTime
#define SqlJTimeStamp      $$$SqlTypeTimestamp
#define SqlJTinyInt        $$$SqlTinyInt
#define SqlJVarBinary      $$$SqlVarBinary
#define SqlJVarchar        $$$SqlVarchar

#; *** ODBC SQLParamData stream length values - from SQL.h and SQLEXT.h ***
#define SqlNullData            (-1)
#define SqlDataAtExec          (-2)
#define SqlLenDataAtExecOffset (-100)
#define SqlLenDataAtExec(%len) (-(%len)+$$$SqlLenDataAtExecOffset)

#; *** SQLCODE return values - from SQL.h and SQLEXT.h ***
#define SQLCODEError               (-1)
#define SQLCODEInvalidHandle       (-2)
#define SQLCODESuccess               0
#define SQLCODESuccessWithInfo       1
#define SQLCODEStillExecuting        2
#define SQLCODENeedData              99
#define SQLCODENoData                100
