/// Property class for <class>HSMOD.REST.SerializationProxy</class>. This creates new property parameters 
/// that can be used in properties of serialization proxy classes. 
Class HSMOD.REST.SerializationPropertyParams [ Abstract ]
{

/// Properties flagged as SkipWhileDeserializing = 1 will be avoided when we are de-serializing a proxy 
/// object and copying its values into the corresponding "real" object. Such properties will still be populated when 
/// serializing (that is, creating a new proxy object and populating it from the contents of the "real" 
/// object). The classic example is a calculated/computed property in a persistent class. 
Parameter SkipWhileDeserializing As %Boolean = 0;

}
