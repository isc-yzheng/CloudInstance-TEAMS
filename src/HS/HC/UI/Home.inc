ROUTINE HS.HC.UI.Home [Type=INC]
#define HSUILink(%key,%default) ##Class(HS.UI.Util).HSUILink(%key,%default)
#define HSUILinkQuery(%key,%default,%query) ##Class(HS.UI.Util).HSUILink(%key,%default,.%query)
#define HSUILinkNS(%key,%default,%namespace) ##Class(HS.UI.Util).HSUILink(%key,%default,"",%namespace)
#define HSUILinkNSQ(%key,%default,%query,%namespace) ##Class(HS.UI.Util).HSUILink(%key,%default,.%query,%namespace)
