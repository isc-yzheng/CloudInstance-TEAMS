/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// SQL database polling client adapter. Repeatedly executes a query against a remote database via an ODBC- or JDBC- defined DSN (Data Source Name) and processes each resulting row.
Class EnsLib.SQL.InboundAdapter Extends (Ens.InboundAdapter, EnsLib.SQL.Common) [ ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter SERVICEINPUTCLASS = "EnsLib.SQL.Snapshot";

/// The Base query string that will be repeatedly executed to look for new rows
Property Query As %String(MAXLEN = "") [ Required ];

/// A comma-separated list of parameter value specifiers, if any. These correspond to any replaceable ? parameters in the query string.
/// %<varname> refers to Adapter properties such as %LastKey;
/// $<varname> refers to Service class properties;
/// &<varname> refers to persistent values saved between invocations.
Property Parameters As %String(MAXLEN = 1000);

/// If specified, used to delete rows after processing. Must have exactly one parameter for IDKey value
Property DeleteQuery As %String(MAXLEN = "");

/// The name of the IDKey field in the query's resultset. Must be unique (non-reused) over time if DeleteQuery is empty.
Property KeyFieldName As %String [ InitialExpression = "ID" ];

/// These are the production settings for this object
Parameter SETTINGS = "Query:Data,Parameters:Data,DeleteQuery:Data,KeyFieldName:Data,MaxVarCharLengthAsString:Data";

/// If DeleteQuery is empty or fails, the IDKey value of the last retrieved row is recorded here.
/// If you want to use a Query that will return only new ID values and not use a DeleteQuery, use
///  a Parameters specifier that includes "%LastKey" to access this transient value or "&%LastKey" to
///  access a persistent copy of this value.
Property %LastKey As %Numeric [ InitialExpression = 0, Private ];

/// ResultSet carried over to multiple OnTask() calls if multiple rows found
Property %CurrResultSet As EnsLib.SQL.GatewayResultSet [ Private ];

/// Key index for one Adapter instance to Array of RowIDs of rows found in the current execution of its query.
Property %InstKey As %Integer [ Private ];

/// A shell to hold the current row to pass to ProcessInput()
Property %Row As EnsLib.SQL.Snapshot [ Private ];

Method OnInit() As %Status
{
	Set ..%CurrResultSet=$$$NULLOREF
	
	#; Create an instance of the one-Row snapshot object
	Do ..%RowNewObject()  $$$ASSERT($IsObject(..%Row))
	Set ..%Row.MaxRowsToGet=1

	Set tSC=##super()  Quit:$$$ISERR(tSC) tSC
	Set tSC=..init()  Quit:$$$ISERR(tSC) tSC
	Set:..StayConnected>0&&(..StayConnected<..CallInterval) ..KeepaliveInterval=..StayConnected
	Kill $$$EnsRuntimeAppData(..BusinessHost.%ConfigName,"adapter.sqlrow") ; clean up on restart
	If ..StayConnected<0 { Set tSC=..Connect(..ConnectTimeout,1)  If $$$ISERR(tSC) $$$LOGWARNING($$$StatusDisplayString(tSC)) } // timeout is not fatal at this point, but do log it
	Else { $$$SetJobMonitor(..BusinessHost.%ConfigName,$$$SystemName_":"_$Job,$$$eMonitorConnected,"0|"_$$$timeUTC) }
	Set ..%InstKey=$I(^IRIS.Temp.Adapter.sqlrow(..BusinessHost.%ConfigName))
	Do ..deleteRuntimeAppData()
	Quit $$$OK
}

Method OnTearDown() As %Status
{
	Kill ^IRIS.Temp.Adapter.sqlrow(..BusinessHost.%ConfigName,..%InstKey)
	Quit ##Class(EnsLib.SQL.Common)$this.OnTearDown()
}

/// Parse out parameters by comma-separators, honoring single and double quotes, escaped by doubling
Method getParms(Output pArray) As %Status [ Private ]
{
	Kill pArray  Set pArray=0, tParm="", tParms=..Parameters_",", tLen=$L(tParms), qq1=0, qq2=0, lq=0, inq(lq)=0
	For i=1:1:tLen { Set c=$E(tParms,i)
		If ","=c&&('lq||(lq=1&&$Case(inq(1),1:qq1,2:qq2,:0))) {
			Quit:i=tLen&&(""=tParm) ; skip the trailing parm if blank
			Set tParm=$ZStrip(tParm,"<>W"), c1=$E(tParm), tParm=$E(tParm,2,*)
			Set tParm=$Case(c1, "%":$zobjproperty($this,"%"_tParm), "$":$zobjproperty(..BusinessHost,tParm), "&":$G($$$EnsStaticAppData(..BusinessHost.%ConfigName,"adapter.sqlparam",tParm)), :c1_tParm)
			Set pArray=pArray+1, pArray(pArray)=tParm, tParm="", lq=0, qq1=0, qq2=0
		} Else {
			If "'"=c { Set:inq(lq)=2&&qq2 lq=lq-1  Set qq2=0
				If inq(lq)=1 { If qq1 { Set qq1=0 } Else { Set qq1=1 } }
				Else { Set lq=lq+1, inq(lq)=1 }
			}
			ElseIf """"=c { Set:inq(lq)=1&&qq1 lq=lq-1  Set qq1=0
				If inq(lq)=2 { If qq2 { Set qq2=0 } Else { Set qq2=1 } }
				Else { Set lq=lq+1, inq(lq)=2 }
			} Else {
				Set:qq1||qq2 lq=lq-1, qq1=0, qq2=0
			}
			Set tParm=tParm_c
		}
	}
	If ""'=tParm {
		#; remove artificial comma, match unbalanced quotes
		Set tParm=$E(tParm,1,*-1)
		For lq=lq:-1:1 Set tParm=tParm_$Case(inq(lq),1:"'",2:"""",:"")
		Set pArray=pArray+1, pArray(pArray)=tParm
	}
	Quit $$$OK
}

Method OnTask() As %Status
{
#define ErrorRowTable(%key) $$$EnsRuntimeAppData(..BusinessHost.%ConfigName,"adapter.sqlrow",%key)
#define DoneRowTable(%key) $$$EnsStaticAppData(..BusinessHost.%ConfigName,"adapter.sqlrow",%key)

	Set $ZT="Trap", tSC=$$$OK, tOneRow="" 
	Do {
		If '..Connected||'$IsObject(..%CurrResultSet) {
			Set tSC=..Connect(..ConnectTimeout)
			Quit:""=..Query||'..Connected
			#; Query the database
			#; construct parms array
			Set tSC=..getParms(.tParms) Quit:$$$ISERR(tSC)
			Set ..%CurrResultSet=$$$NULLOREF
			Set tSC=..ExecuteQueryParmArray(.tRS,..Query,.tParms)  Quit:$$$ISERR(tSC)  $$$ASSERT($IsObject(tRS))
			Set ..%CurrResultSet=tRS
			Kill ^IRIS.Temp.Adapter.sqlrow(..BusinessHost.%ConfigName,..%InstKey)
		}
		Set tRowID="",tCount=0  While $IsObject(..%CurrResultSet) {
			Set tSC=..%CurrResultSet.GetSnapshot(..%Row)  Quit:$$$ISERR(tSC)
			Set tCount=..%Row.RowCount
			If 'tCount {
				#; Done with this ResultSet now
				Set ..%CurrResultSet=$$$NULLOREF
				Do:'..StayConnected ..Disconnect()

				#; Remove errored and/or processed rows from the globals if they no longer exist
				Set f="" For  Set f=$Order($$$ErrorRowTable(f)) Quit:f=""  if '$G(^IRIS.Temp.Adapter.sqlrow(..BusinessHost.%ConfigName,..%InstKey,f)) If ""'=$G($$$ErrorRowTable(f)) { $$$sysTRACE("Removed absent row '"_f_"' from errored list") } Kill $$$ErrorRowTable(f)
				Set f="" For  Set f=$Order($$$DoneRowTable(f)) Quit:f=""   if '$G(^IRIS.Temp.Adapter.sqlrow(..BusinessHost.%ConfigName,..%InstKey,f)) $$$sysTRACE("Removed absent row '"_f_"' from processed list")  Kill $$$DoneRowTable(f)
				Quit
			}
			Do ..%Row.Next()
			If ""=..KeyFieldName { Set tRowID="" }
			Else {
				Set tOneRow = ..%Row.Get(..KeyFieldName)  If (""=tOneRow||($C(0)=tOneRow)) $$$LOGERROR("Key value not found in field '"_..KeyFieldName_"'") Quit
				Set ^IRIS.Temp.Adapter.sqlrow(..BusinessHost.%ConfigName,..%InstKey,tOneRow)=1

				Lock +$$$ErrorRowTable(tOneRow):0 Else  $$$LOGINFO("Skipping locked row '"_tOneRow_"'") Continue
				#; Skip the rows we have already processed or that errored; only warn once
				If $G($$$DoneRowTable(tOneRow)) If $G(^(tOneRow,"done"_$E($G($$$ErrorRowTable(tOneRow)),-1))) { Kill ^("done") $$$sysTRACE("Skipping previously processed row '"_tOneRow_"'") } Lock -$$$ErrorRowTable(tOneRow) Continue
				If $G($$$ErrorRowTable(tOneRow)) If $G(^(tOneRow,"wrn")) { Kill ^("wrn") $$$LOGWARNING("Skipping previously errored row '"_tOneRow_"'") } Lock -$$$ErrorRowTable(tOneRow) Continue
				Set $$$ErrorRowTable(tOneRow)=1, ^(tOneRow,"wrn") = 1
				Set:""=..DeleteQuery ^("done")=1
				Lock -$$$ErrorRowTable(tOneRow)

				Set tRowID=tOneRow, tOneRow=""
			}
			$$$sysTRACE("About to process row '"_tRowID_"'")
			Quit ; found a good one
		}
		Quit:$$$ISERR(tSC)||$S(""=..KeyFieldName:'tCount, 1:""=tRowID)
 		$$$LOGINFO("Processing row "_..KeyFieldName_" '"_tRowID_"'")

 		Set tSC=..BusinessHost.ProcessInput(..%Row.%ConstructClone())  Quit:$$$ISERR(tSC)
 		
		If ""'=..DeleteQuery {
			#; delete the row, and remove the row from do-not-process list if it is deleted
			Set tSC=$S(""=..KeyFieldName:..ExecuteUpdate(.tOK,..DeleteQuery),1:..ExecuteUpdate(.tOK,..DeleteQuery,tRowID))  Set:$$$ISERR(tSC) tOK=0
			If tOK { Kill:""'=tRowID $$$ErrorRowTable(tRowID) }
			Else { $$$LOGWARNING("Failed to delete row '"_tRowID_"'") }
		} ElseIf ""'=tRowID {
			Set $$$ErrorRowTable(tRowID)="", ^(tRowID,"done")=1
			Set $$$DoneRowTable(tRowID)=1
		}
		Set:""'=tRowID (..%LastKey, $$$EnsStaticAppData(..BusinessHost.%ConfigName,"adapter.sqlparam","%LastKey"))=tRowID
	} While 0
Exit
	Quit tSC
Trap
 	Set $ZT="",tSC=$$$EnsSystemError
	Lock:""'=tOneRow -$$$ErrorRowTable(tOneRow)
	Goto Exit
}

ClassMethod GetPersistentValue(pConfigName As %String, pParamName As %String) As %String [ CodeMode = expression ]
{
$G($$$EnsStaticAppData(pConfigName,"adapter.sqlparam",pParamName))
}

ClassMethod SetPersistentValue(pConfigName As %String, pParamName As %String, pValue As %String) As %String
{
	Set tOld=$G($$$EnsStaticAppData(pConfigName,"adapter.sqlparam",pParamName))
	Set ^(pParamName) = pValue
	Quit tOld
}

/// Set persistent value (default name=%LastKey) to new value only if it is currently undefined. Return old value if any.
ClassMethod InitializePersistentValue(pConfigName As %String, pParamName As %String = "%LastKey", pNewValue As %String) As %String
{
	Set tDefined=$D($$$EnsStaticAppData(pConfigName,"adapter.sqlparam",pParamName),tOldVal)
	Quit:tDefined#2 tOldVal
	Set ^(pParamName) = pNewValue
	Quit ""
}

ClassMethod InitializeLastKeyValue(pConfigName As %String, pNewLastKey As %String = 0) As %String [ CodeMode = expression ]
{
..InitializePersistentValue(pConfigName,,pNewLastKey)
}

}
