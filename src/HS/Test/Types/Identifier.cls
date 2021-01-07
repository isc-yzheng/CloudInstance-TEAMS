/// A number
Class HS.Test.Types.Identifier Extends HS.Test.Types.Base
{

/// Usually an OID
Property Root As %String(MAXLEN = "", XMLNAME = "root", XMLPROJECTION = "ATTRIBUTE");

/// aka "extension", unique within the scope of the root
Property ID As %String(MAXLEN = "", XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

/// aka "assigningAuthorityName"
Property Name As %String(MAXLEN = "", XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

Method %OnNew(id, root, name) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	If $D(id) Set i%ID = id
	If $D(root) Set i%Root = root
	If $D(name) Set i%Name = name
	Quit $$$OK
}

}
