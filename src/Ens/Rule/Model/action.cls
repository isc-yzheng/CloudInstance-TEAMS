/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class Ens.Rule.Model.action Extends Ens.Rule.Model.base [ Abstract, System = 3 ]
{

/// Overriden since actions is a choice
/// Arguments:<br>
///     dynamicObject is the dynamic object with thee values to be assigned to the new object.<br>
///     containerOref is the containing object instance when called from JSONImport.
ClassMethod %JSONNew(dynamicObject As %DynamicObject, containerOref As %RegisteredObject = "") As %RegisteredObject
{
	/*	Dynamic Object item number is one less than list
		and Count() is current number of inserted actions
	*/
	#dim actionNumberToGet = containerOref.actions.Count()
	#dim action = dynamicObject.actions.%Get(actionNumberToGet)
	#dim class = "Ens.Rule.Model."_action.type
	Return $classmethod(class,"%New")
}

}
