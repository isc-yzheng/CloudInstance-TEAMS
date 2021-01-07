/// Additional coverage classifications.
Class HS.FHIR.DTL.vSTU3.Model.Element.Coverage.grouping Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// An identifier for the group.
Property group As %String(MAXLEN = 1000000, XMLNAME = "group", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Display text for an identifier for the group.
Property groupDisplay As %String(MAXLEN = 1000000, XMLNAME = "groupDisplay", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// An identifier for the subsection of the group.
Property subGroup As %String(MAXLEN = 1000000, XMLNAME = "subGroup", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Display text for the subsection of the group.
Property subGroupDisplay As %String(MAXLEN = 1000000, XMLNAME = "subGroupDisplay", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// An identifier for the plan.
Property plan As %String(MAXLEN = 1000000, XMLNAME = "plan", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Display text for the plan.
Property planDisplay As %String(MAXLEN = 1000000, XMLNAME = "planDisplay", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// An identifier for the subsection of the plan.
Property subPlan As %String(MAXLEN = 1000000, XMLNAME = "subPlan", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Display text for the subsection of the plan.
Property subPlanDisplay As %String(MAXLEN = 1000000, XMLNAME = "subPlanDisplay", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// An identifier for the class.
Property class As %String(MAXLEN = 1000000, XMLNAME = "class", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Display text for the class.
Property classDisplay As %String(MAXLEN = 1000000, XMLNAME = "classDisplay", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// An identifier for the subsection of the class.
Property subClass As %String(MAXLEN = 1000000, XMLNAME = "subClass", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Display text for the subsection of the subclass.
Property subClassDisplay As %String(MAXLEN = 1000000, XMLNAME = "subClassDisplay", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Coverage.grouping";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Coverage.grouping";

}
