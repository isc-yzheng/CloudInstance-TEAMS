/// Base class that allows any application data that needs to have a life cycle managed as part of a session
/// to be associated with a general purpose <class>Session</class> object and cleaned up whenever the related 
/// <class>Session</class> object is deleted.
/// To take advantage of this functionality, this class simply needs to be specified as a superclass, and the 
/// related <class>Session</class> needs to be specified in the <property>Session</property> property.
/// Dedicated code can then manage the life cycle of the <class>Session</class> instance and trust that when that
/// instance is deleted, all of the related data will also be deleted.
/// It is important to note that the subclass has complete control over its storage, 
/// and may even declare the <index>Session</index> to be unique.
/// In all cases, applications will need to control access to the data they store using this mechanism.
Class HS.Util.SessionData.AbstractSessionData Extends (%Persistent, %XML.Adaptor) [ Abstract, NoExtent ]
{

Index Session On Session;

ForeignKey SessionFKey(Session) References HS.Util.SessionData.Session() [ OnDelete = cascade, OnUpdate = cascade ];

Property Session As HS.Util.SessionData.Session [ Required ];

}
