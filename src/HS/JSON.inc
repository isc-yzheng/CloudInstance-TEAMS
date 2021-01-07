ROUTINE HS.JSON [Type=INC]
#include %occReference
#include HS.JSON.Errors

#if $$$comClassDefined("%Library.Object")
    #def1arg HSJsonMethodClassIsLatestVersion(%arg) $classIsLatestVersion(%arg)
    						//usage: obj.$$$HSJsonClassIsLatestVersion()
    #def1arg HSJsonMethodExtends(%arg) $extends(%arg)
    						//usage: {}.$$$HSJsonExtends(classname) 
	#def1arg HSJsonMethodFromJSON(%arg) $fromJSON(%arg)
    						//usage: {}.$$$HSJsonFromJSON(string) 
    #def1arg HSJsonMethodGetIterator(%arg) $getIterator(%arg)
    						//usage: obj.$$$HSJsonGetIterator()
    #def1arg HSJsonMethodGetNext(%arg) $getNext(%arg)
    						//usage: iterator.$$$HSJsonGetNext(.key, .value)
    #def1arg HSJsonMethodIsA(%arg) $isA(%arg)
    						//usage: obj.$$$HSJsonIsA(classname)
    #def1arg HSJsonMethodToJSON(%arg) $toJSON(%arg)
    						//usage: obj.$$$HSJsonToJSON()
    #def1arg HSJsonMethodGet(%arg) $get(%arg)
    						//usage: obj.$$$HSJsonGet(key)
    #def1arg HSJsonMethodGetTypeOf(%arg) $getTypeOf(%arg)
    						//usage: obj.$$$HSJsonMethodGetTypeOf(key)
    #def1arg HSJsonMethodIsDefined(%arg) $isDefined(%arg)
    						//usage: obj.$$$HSJsonIsDefined(key) 
    #def1arg HSJsonMethodRemove(%arg) $remove(%arg)
    						//usage: obj.$$$HSJsonRemove(key)
    #def1arg HSJsonMethodSet(%arg) $set(%arg)
    						//usage: obj.$$$HSJsonSet(key, val)
    #def1arg HSJsonMethodSize(%arg) $size(%arg)
    						// usage: obj.$$$HSJsonSize()
    #def1arg HSJsonMethodPop(%arg) $pop(%arg)
    						//usage: obj.$$$HSJsonPop()
    #def1arg HSJsonMethodPush(%arg) $push(%arg)
    						//usage: obj.$$$HSJsonPush(val)
	#define HSJsonClassAbstract %Library.AbstractObject
	#define HSJsonClassObject %Library.Object
	#define HSJsonClassArray %Library.Array
#else
    #def1arg HSJsonMethodClassIsLatestVersion(%arg) %ClassIsLatestVersion(%arg)
    						//usage: obj.$$$HSJsonClassIsLatestVersion()
    #def1arg HSJsonMethodExtends(%arg) %Extends(%arg)
    						//usage: {}.$$$HSJsonExtends(classname) 
    #def1arg HSJsonMethodFromJSON(%arg) %FromJSON(%arg)
    						//usage: {}.$$$HSJsonFromJSON(string) 
    #def1arg HSJsonMethodGetIterator(%arg) %GetIterator(%arg)
    						//usage: obj.$$$HSJsonGetIterator()
	#def1arg HSJsonMethodGetNext(%arg) %GetNext(%arg)
    						//usage: iterator.$$$HSJsonGetNext(.key, .value)
    #def1arg HSJsonMethodGetTypeOf(%arg) %GetTypeOf(%arg)
    						//usage: obj.$$$HSJsonMethodGetTypeOf(key)
	#def1arg HSJsonMethodIsA(%arg) %IsA(%arg)
    						//usage: obj.$$$HSJsonIsA(className)
    #def1arg HSJsonMethodToJSON(%arg) %ToJSON(%arg)
    						//usage: obj.$$$HSJsonToJSON()
    #def1arg HSJsonMethodGet(%arg) %Get(%arg)
    						//usage: obj.$$$HSJsonGet(key)
    #def1arg HSJsonMethodIsDefined(%arg) %IsDefined(%arg)
    						//usage: obj.$$$HSJsonIsDefined(key) 
    #def1arg HSJsonMethodRemove(%arg) %Remove(%arg)
    						//usage: obj.$$$HSJsonRemove(key)
    #def1arg HSJsonMethodSet(%arg) %Set(%arg)
    						//usage: obj.$$$HSJsonSet(key, val)
    #def1arg HSJsonMethodSize(%arg) %Size(%arg)
    						//usage: obj.$$$HSJsonSize()
    #def1arg HSJsonMethodPop(%arg) %Pop(%arg)
    						//usage: obj.$$$HSJsonPop()
    #def1arg HSJsonMethodPush(%arg) %Push(%arg)
    						//usage: obj.$$$HSJsonPush(val) 
	#define HSJsonClassAbstract %Library.DynamicAbstractObject
	#define HSJsonClassObject %Library.DynamicObject
	#define HSJsonClassArray %Library.DynamicArray
#endif

#define HSJsonDisableNode ^||ISC.HS.Config("JSON","DisableDynamic")
#define HSJsonDisable Set $$$HSJsonDisableNode = 1
#define HSJsonEnable Kill $$$HSJsonDisableNode
#define HSJsonIsEnabled '$Get($$$HSJsonDisableNode,0)

#define HSJsonQuotedClassAbstract ##Quote($$$HSJsonClassAbstract)
#define HSJsonQuotedClassObject ##Quote($$$HSJsonClassObject)
#define HSJsonQuotedClassArray ##Quote($$$HSJsonClassArray)

#; Workarounds for 2017.1's behavior of array.%IsDefined("string") returning 1
#define HSJsonIsValidArraySubscript(%val) ((%val = (%val\1)) && (%val >= 0))
#define HSJsonKeyDefined(%obj,%key) (%obj.$$$HSJsonMethodIsDefined(%key) && ('%obj.%IsA($$$HSJsonQuotedClassArray) || $$$HSJsonIsValidArraySubscript(%key)))

#if $$$comClassDefined($$$HSJsonQuotedClassObject)
	#define HSJsonIsSupported 1
#else
	#define HSJsonIsSupported 0
#endif