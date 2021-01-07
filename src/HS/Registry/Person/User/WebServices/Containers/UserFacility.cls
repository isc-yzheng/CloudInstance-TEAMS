Class HS.Registry.Person.User.WebServices.Containers.UserFacility Extends (%Persistent, HS.Util.WebServices.ServiceStatus, HS.Util.WebServices.SuperContainerListItem) [ ClassType = persistent, Inheritance = right ]
{

/*
 * NOTE: ALL MAXLEN taken from <class>HS.Registry.Person.UserFacility</class>.
 */
/// If this parameter is true then JSON-enabling methods will be generated. 
/// Otherwise, the method generators do not produce a runnable method.
Parameter %JSONENABLED = 1;

/// The key for the user object linked to this facility. <br />
Property UserClinician As %String(MAXLEN = "");

/// Corresponds to FacilityCode in <class>HS.Registry.Person.UserFacility</class>. <br />
Property Facility As %String(MAXLEN = 256);

Property PrimaryFlag As %Boolean;

/// Base JSON translations.
XData BasicReference [ Internal, XMLNamespace = "http://www.intersystems.com/jsonmapping" ]
{
<Mapping Mapping="BasicReference" IgnoreNull="true" Null="true" xmlns="http://www.intersystems.com/jsonmapping">
<Property Name="ID" FieldName="user_facility_key"/>
<Property Name="UserClinician" FieldName="user_key"/>
<Property Name="Facility" FieldName="facility_code"/>
<Property Name="PrimaryFlag" FieldName="primary_flag"/>
</Mapping>
}

/// Overridden from <class>%Library.Persistent</class>
Method %OnValidateObject() As %Status [ Private, ServerOnly = 1 ]
{
	#dim ex As %Exception.AbstractException
	Set sc = $$$OK
	Try {
		If (..Facility '= "") {
			Do ..ValidateFacility(..Facility)
		}
	} Catch ex {
		Set sc = ex.AsStatus()
	}
	Quit sc
}

/// Do validation on property <property>Facility</property>. <br />
ClassMethod ValidateFacility(pFacility As %String) [ Internal, Private ]
{
	/*
	 * Facility comes from HS_Facility.Config as per HS.UI.Registry.User.Util:%InitializePage 
	 */
	 
	If '##class(HS.Facility.Config).%ExistsId(pFacility) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Non-existent facility code provided: "_pFacility))
	}
}

Storage Default
{
<Data name="UserFacilityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Action</Value>
</Value>
<Value name="3">
<Value>%User</Value>
</Value>
<Value name="4">
<Value>%Roles</Value>
</Value>
<Value name="5">
<Value>%Gateway</Value>
</Value>
<Value name="6">
<Value>Facility</Value>
</Value>
<Value name="7">
<Value>ID</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>PrimaryFlag</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>UserClinician</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.P1585.UserFacilityD</DataLocation>
<DefaultData>UserFacilityDefaultData</DefaultData>
<IdLocation>^HS.Registry.P1585.UserFacilityD</IdLocation>
<IndexLocation>^HS.Registry.P1585.UserFacilityI</IndexLocation>
<StreamLocation>^HS.Registry.P1585.UserFacilityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
