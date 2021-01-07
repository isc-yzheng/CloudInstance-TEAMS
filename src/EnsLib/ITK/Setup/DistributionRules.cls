/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsITK

/// Stores the list of distribution modes and targets for an incoming Web Request
Class EnsLib.ITK.Setup.DistributionRules Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Stores the list of distribution modes and targets for an incoming Web Request
Update history:

2011-01-18  Added DistributionTargets
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property ServiceName As %String [ Required ];

Property DistributionMode As %String(VALUELIST = ",Authoritative,Non-Authoritative") [ Required ];

Property LogicalAddress As %String(MAXLEN = "") [ Required ];

Property TargetComponent As %String [ Required ];

Index DistributionRulesU1 On (ServiceName, DistributionMode, LogicalAddress) [ IdKey, Unique ];

ClassMethod GetBestMatch(pAddress As %String, pDistributionMode As %String, pServiceName As %String) As EnsLib.ITK.Setup.DistributionRules
{
	set rs = ##class(%ResultSet).%New("EnsLib.ITK.Setup.DistributionRules:DistributionRulesForService")
	do rs.Execute(pServiceName)
	
	set bestMatch=""
	set bestMatchMode=""
	
	set pAddress=$zconvert(pAddress,"L")
	
	while rs.Next()
	{
		set tAddress = rs.GetDataByName("LogicalAddress")
		set tldAddress=$zconvert(tAddress,"L")
		set tDM=rs.GetDataByName("DistributionMode")
		if (pDistributionMode=$$$ITKDMRoute) || (pDistributionMode=tDM)
		{ 
			if $E(tldAddress,*,*)="*"
			{
				set tLen = $L(tldAddress)-1
				if (tLen<$L(pAddress)) && ($E(tldAddress,1,*-1) = $E(pAddress,1,tLen))
			{
					if ($L(bestMatch)<(tLen+1)) || (($L(bestMatch)=(tLen+1)) && (tDM=$$$ITKDMAuthoritative))
					{
						set bestMatch = tAddress
						set bestMatchMode = tDM	
					}
				}			
			}
			elseif (tldAddress=pAddress)
			{
				if (bestMatch'=tAddress) || (tDM=$$$ITKDMAuthoritative)
				{
					set bestMatch = tAddress
					set bestMatchMode = tDM	
				}
				
			}
		}
	}
	
	Quit ##class(EnsLib.ITK.Setup.DistributionRules).%OpenId(pServiceName_"||"_bestMatchMode_"||"_bestMatch)
}

Query DistributionRulesForService(pServiceName As %String) As %SQLQuery
{
SELECT DistributionMode,LogicalAddress,TargetComponent FROM DistributionRules
WHERE (ServiceName = :pServiceName)
}

Query DistributionTargets() As %SQLQuery
{
SELECT distinct %EXACT TargetComponent FROM DistributionRules
}

Storage Default
{
<Data name="DistributionRulesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TargetComponent</Value>
</Value>
</Data>
<DataLocation>^EnsITK.DistributionRulesD</DataLocation>
<DefaultData>DistributionRulesDefaultData</DefaultData>
<IdLocation>^EnsITK.DistributionRulesD</IdLocation>
<IndexLocation>^EnsITK.DistributionRulesI</IndexLocation>
<StreamLocation>^EnsITK.DistributionRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
