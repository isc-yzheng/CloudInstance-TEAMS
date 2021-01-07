ROUTINE HS.IHE.ATNA [Type=INC]
#; ATNA Events
#define ATNAEvent(%actor,%request,%response,%status) ##class(HS.IHE.ATNA.SecureApplication.Utils).Audit(%actor,%request,%response,%status,$$$CurrentClass,..%SessionId)
#define ATNAEventUnitTest(%actor,%request,%response,%status) ##class(HS.IHE.ATNA.SecureApplication.Utils).Audit(%actor,%request,%response,%status,$$$CurrentClass,"")
#; returns a boolean, and if it's the audit instance and we're not on a non-primary mirror, the database of the audit repository
#define IsRunningAuditInstance(%DB) ##class(%ZHSLIB.HealthShareMgr).IsRunningAuditInstance(.%DB)
