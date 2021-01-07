/// This class enables writing and localization of user-friendly error messages related to foreign and unique key violations. <br />
/// To use it, include this class as a secondary super class (also extending %Persistent directly or indirectly), override the <code>StatusMetadata</code>
/// XData block, and add descriptive messages related to violations of any unique or foreign keys defined in the subclass.
/// @API.Extensible
/// @Modifier Availability InterSystems
Class HS.Util.Status.PersistentHelper [ Abstract ]
{

/// Provides user-friendly error messages for foreign/unique key violations, via <class>HS.Util.Status.Interpreter<class>
/// @API.Overrideable
/// @Modifier Availability InterSystems
XData StatusMetadata [ XMLNamespace = "http://www.intersystems.com/healthshare/util/status" ]
{
<Metadata>
<!-- Examples: -->
<!--
<UniqueKey Name="UniqueFoo">
<ViolationMessage Type="OnInsert">A ClassOne with that Foo value already exists</ViolationMessage>
<ViolationMessage Type="OnUpdate">Another ClassOne already has that Foo value</ViolationMessage>
</UniqueKey>
<ForeignKey Name="FirstClassOneFK">
<ViolationMessage Type="OnInsert">Invalid ClassOne</ViolationMessage>
<ViolationMessage Type="OnUpdate">Invalid FirstClassOne referenced by ClassTwo</ViolationMessage>
<ViolationMessage Type="OnDelete">A ClassTwo references the ClassOne you tried to delete as its FirstClassOne</ViolationMessage>
</ForeignKey>
<ForeignKey Name="ThirdClassOneFK">
<ViolationMessage Type="OnInsert">Invalid Foo value, does not correspond to any ClassOne</ViolationMessage>
<ViolationMessage Type="OnUpdateReferencingClass">Invalid Foo value, does not correspond to any ClassOne</ViolationMessage>
<ViolationMessage Type="OnUpdateReferencedClass">Cannot change Foo value, referenced by a ClassOne</ViolationMessage>
<ViolationMessage Type="OnDelete">Cannot delete ClassOne, a ClassTwo references it by Foo</ViolationMessage>
</ForeignKey>
-->
</Metadata>
}

/// Returns messages from the <code>StatusMetadata</code> XData block in the current class (and possibly parent classes).
ClassMethod GetViolationMessageFromMetadata(pConstraintType As %String, pConstraintName As %String, pActionType As %String) As %String [ CodeMode = objectgenerator, Internal ]
{
}

}
