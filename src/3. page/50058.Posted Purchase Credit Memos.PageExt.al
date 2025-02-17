pageextension 50058 pageextension50058 extends "Posted Purchase Credit Memos"
{

    //Unsupported feature: Property Modification (SourceTableView) on ""Posted Purchase Credit Memos"(Page 147)".


    //Unsupported feature: Property Modification (CardPageID) on ""Posted Purchase Credit Memos"(Page 147)".

    layout
    {

        //Unsupported feature: Code Modification on "Control 13.OnDrillDown".

        //trigger OnDrillDown()
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SETRANGE("No.");
        PAGE.RUNMODAL(PAGE::"Posted Purchase Credit Memo",Rec)
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        SETRANGE("No.");
        PAGE.RUNMODAL(PAGE::"Posted Debit Note",Rec)
        */
        //end;


        //Unsupported feature: Code Modification on "Control 17.OnDrillDown".

        //trigger OnDrillDown()
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SETRANGE("No.");
        PAGE.RUNMODAL(PAGE::"Posted Purchase Credit Memo",Rec)
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        SETRANGE("No.");
        PAGE.RUNMODAL(PAGE::"Posted Debit Note",Rec)
        */
        //end;
        addafter("Control 97")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
            }
        }
        addafter("Control 71")
        {
            field("Vendor Posting Group"; Rec."Vendor Posting Group")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 30".

    }


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetSecurityFilterOnRespCenter;
    IF FINDFIRST THEN;
    IsOfficeAddin := OfficeMgt.IsAvailable;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    // SetSecurityFilterOnRespCenter;
    IF FINDFIRST THEN;
    IsOfficeAddin := OfficeMgt.IsAvailable;

    FilterOnRecord;
    */
    //end;

    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetPurchasesFilter();
        IF RespCenterFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            IF UserMgt.DefaultResponsibility THEN
                Rec.SETRANGE("Responsibility Center", RespCenterFilter)
            ELSE
                Rec.SETRANGE("Accountability Center", RespCenterFilter);
            Rec.FILTERGROUP(0);
        END;
    end;
}

