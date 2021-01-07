/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

Class Ens.Rule.Assist [ Abstract, System = 4 ]
{

/// This method returns the meta data for the cconstraint fields
/// The structure of the meta data is the following:
/// meta-data = comma separted list of fields
/// field = colon separated values:
///       = constraint-field-name : caption : [collection] # [type] [ # parameter ]
///       the valid value for collection-type is commalist or null
///       the valid values for type is configname, class or query
///       the parameter for class is passed to the class finder dialog box.
/// 
ClassMethod GetMetaData() As %String
{
	quit ""
}

/// Returns the description of the rule type 
ClassMethod GetDescription() As %String
{
	quit ""
}

/// If return true, then the class is excluded from the new rule wizard
ClassMethod IsHidden() As %String
{
	quit 0
}

/// Returns the context class. If the return value is not null, then users can not change it
ClassMethod GetContextClass() As %String
{
	quit ""
}

/// Returns if the rule is a routing rule
ClassMethod GetIsRoutingRule() As %String
{
	quit 0
}

/// Returns if the rule input is a segmented document
ClassMethod GetIsSegmentedDoc() As %String
{
	quit 0
}

/// Returns the short display string for the constraint
/// The input data is in pArray, subscripted by the constraint-field-name
ClassMethod GetShortDisplay(pArray) As %String
{
	set tMetaData=..GetMetaData() if tMetaData="" quit ""
	set tData="",tMaxLen=100\$l(tMetaData,",")
	for i=1:1:$l(tMetaData,",") {
		set name=$p($p(tMetaData,",",i),":",1)
		if $d(pArray(name)) set tData=tData_$s(tData="":"",1:", ")_name_"="_$s($l(pArray(name))>tMaxLen:$e(pArray(name),1,tMaxLen-3)_"...",1:pArray(name))
	}
	quit tData
}

/// This method is called when the constraint type is query.
/// This method returns a comma separated list of all the possible values for a particular field
/// The list will be used to populated the combo box.
ClassMethod GetQueryData(pArray, pParam) As %String
{
	quit ""
}

/// This method is called to return a list of properties
ClassMethod GetPropertyList(pArray, pText) As %String
{
	set context = $g(pArray("%contextClass"))
	set path = pText
	if (path [ "..") quit ""
	if $e(path,*)="." set path=$e(path,1,*-1)
	set piece = $s(path="":0,1:$l(path,"."))
	for i=1:1:piece {
		if context="" quit
		set property = $p(path,".",i)
		if property = "" {
			set context = ""
		} else {
			set context = $g(pArray("%classPropertyTypeOverride",context,property),..getClassPropertyType(context,property))
		}
	}
	if context="" quit ""
	quit ..getClassPropertyList(context)
}

ClassMethod getClassPropertyType(className, propertyName) As %String
{
	&sql(SELECT Type INTO :propType
		FROM %Dictionary.CompiledProperty
		WHERE parent = :className
		AND Name = :propertyName)
	If (SQLCODE = 0) {
		Quit propType
	}
	Quit ""
}

ClassMethod getClassPropertyList(className) As %String
{
	Set propertyList = ""
	&sql(DECLARE classProperties CURSOR FOR
		SELECT p.Name, c.ClassType INTO :propName, :propClassType
		FROM %Dictionary.CompiledProperty p,
		%Dictionary.CompiledClass c
		WHERE p.parent = :className
		AND $EXTRACT(p.Name,1) <> '%'
		AND p.Private = 0
		AND p.Type = c.Name)
	&sql(OPEN classProperties)
	&sql(FETCH classProperties)
	While SQLCODE = 0 {
		Set referenceSuffix = $select(propClassType '= "datatype": ".", 1: "")
		Set propertyList = propertyList _ $LB(propName _ referenceSuffix)
		&sql(FETCH classProperties)
	}
	&sql(CLOSE classProperties)
	quit $LTS(propertyList,",")
}

/// This method is called at runtime for constraint check
/// The method is to return 1 or 0 on the output parameter pPassed
ClassMethod RuntimeConstraintCheck(ByRef pArray, pContext, Output pPassed) As %Status
{
	set pPassed=1
	quit $$$OK
}

}
