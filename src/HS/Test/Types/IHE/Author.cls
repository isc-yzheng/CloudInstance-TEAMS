Class HS.Test.Types.IHE.Author Extends HS.Test.Types.Base
{

/// If present, the authorPerson is requried
Property Person As HS.Test.Types.Value;

/// Zero or more authorInstitutions. Usually only one, so projected as element for brevity
Property Institutions As list Of HS.Test.Types.Value(XMLNAME = "Institution", XMLPROJECTION = "ELEMENT");

/// Zero or more authorRoles. Usually only one, so projected as element for brevity
Property Roles As list Of HS.Test.Types.Value(XMLNAME = "Role", XMLPROJECTION = "ELEMENT");

/// Zero or more authorSpeciality. Usually only one, so projected as element for brevity
Property Specialties As list Of HS.Test.Types.Value(XMLNAME = "Specialty", XMLPROJECTION = "ELEMENT");

}
