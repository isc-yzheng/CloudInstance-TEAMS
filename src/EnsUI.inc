ROUTINE EnsUI [Type=INC]
#;For localizing text in CSP pages
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#def1arg LocalizeText(%args)     $$FormatMessage^%occMessages(%response.Language,%args)
#define EnsMsgError              $$$LocalizeText("Ensemble","ErrorOnly","Error")
#define EnsMsgModified           $$$LocalizeText("Ensemble","Modified","Modified")
#define EnsMsgReadOnly           $$$LocalizeText("Ensemble","ReadOnly","ReadOnly")
#define EnsMsgOk                 $$$LocalizeText("Ensemble","Ok","Ok")
#define EnsMsgOn                 $$$LocalizeText("Ensemble","On","On")
#define EnsMsgOff                $$$LocalizeText("Ensemble","Off","Off")
#define EnsMsgTrue               $$$LocalizeText("Ensemble","True","True")
#define EnsMsgFalse              $$$LocalizeText("Ensemble","False","False")
#define EnsMsgDeleting           $$$LocalizeText("Ensemble","Deleting","Deleting...")
#define EnsMsgSaving             $$$LocalizeText("Ensemble","Saving","Saving...")
#define EnsMsgRules              $$$LocalizeText("Ensemble","Rules","Rules")
#define EnsMsgConditions         $$$LocalizeText("Ensemble","Conditions","Conditions")
#define EnsMsgActions            $$$LocalizeText("Ensemble","Actions","Actions")

#; For getting a boolean form variable value
#define RequestDataBooleanI(%fv,%idx) $Case($ZCVT($G(%request.Data(%fv,%idx),"off"),"L"),0:0,"off":0,"false":0,:1)
#define RequestDataBoolean(%fv)       $$$RequestDataBooleanI(%fv,1)

#;For a production item's "virtual settings":
#; $lb(Target,Name,Value,ValueType,Default,DefaultType,Description,Type,MAXLEN,MINVAL,MAXVAL,VALUELIST,DISPLAYLIST,IsRequired,LocalizedName,Category,LocalizedCategory,EditorContext)
#define EnsItemTarget            1
#define EnsItemName              2
#define EnsItemValue             3
#define EnsItemValueType         4
#define EnsItemDefault           5
#define EnsItemDefaultType       6
#define EnsItemDescription       7
#define EnsItemType              8
#define EnsItemMAXLEN            9
#define EnsItemMINVAL            10
#define EnsItemMAXVAL            11
#define EnsItemVALUELIST         12
#define EnsItemDISPLAYLIST       13
#define EnsItemIsRequired        14
#define EnsItemLocalizedName     15
#define EnsItemCategory          16
#define EnsItemLocalizedCategory 17
#define EnsItemEditorContext     18
