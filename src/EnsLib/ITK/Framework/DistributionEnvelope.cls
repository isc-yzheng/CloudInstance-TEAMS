/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Internal representation of a DistributionEnvelope.
Class EnsLib.ITK.Framework.DistributionEnvelope Extends (%SerialObject, %XML.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Internal representation of a DistributionEnvelope. 
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property AddressList As list Of %String(MAXLEN = "");

Property AuditIdentity As list Of %String(MAXLEN = "");

Property TrackingId As %String(MAXLEN = "");

Property Service As %String(MAXLEN = "");

/// The address of the sender (if there is one)
/// This is used to send business or technical ascknolgements back to
/// Added with ITK 2.0
Property SenderAddress As %String;

Storage Default
{
<Data name="DistributionEnvelopeState">
<Value name="1">
<Value>AddressList</Value>
</Value>
<Value name="2">
<Value>AuditIdentity</Value>
</Value>
<Value name="3">
<Value>TrackingId</Value>
</Value>
<Value name="4">
<Value>Service</Value>
</Value>
<Value name="5">
<Value>Sender</Value>
</Value>
<Value name="6">
<Value>SenderAddress</Value>
</Value>
</Data>
<State>DistributionEnvelopeState</State>
<StreamLocation>^EnsITK.DistributionEnvelopeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
