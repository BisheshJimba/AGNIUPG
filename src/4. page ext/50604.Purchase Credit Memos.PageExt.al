pageextension 50604 pageextension50604 extends "Purchase Credit Memos"
{

    //Unsupported feature: Property Modification (CardPageID) on ""Purchase Credit Memos"(Page 9309)".

    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 1901138007".

    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601024".

    }

    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetSecurityFilterOnRespCenter;

    JobQueueActive := PurchasesPayablesSetup.JobQueueActive;
    IsOfficeAddin := OfficeMgt.IsAvailable;

    CopyBuyFromVendorFilter;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
    FilterOnRecord;  //AGNI2017CU8
    */
    //end;

    local procedure FilterOnRecord()
    var
        RespCenterFilter: Code[10];
        UserMgt: Codeunit "5700";
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

