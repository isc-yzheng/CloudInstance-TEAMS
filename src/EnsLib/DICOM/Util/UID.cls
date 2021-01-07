/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.DICOM.Util.UID Extends %RegisteredObject [ System = 4 ]
{

/// B.2 UUID DERIVED UID 
/// ISO/IEC 9834-8 / ITU-T X.667 defines a method by which a UID may be 
/// constructed from the root '2.25.' followed by a decimal representation 
/// of a Universally Unique Identifier (UUID). That decimal representation 
/// treats the 128 bit UUID as an integer, and may thus be up to 39 digits 
/// long (leading zeros must be suppressed).
ClassMethod Generate() As %String [ CodeMode = expression ]
{
("2.25."_$SYSTEM.Util.CreateDecimalGUID())
}

}
