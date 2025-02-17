pageextension 50056 pageextension50056 extends "Posted Purchase Receipts"
{

    //Unsupported feature: Property Modification (SourceTableView) on ""Posted Purchase Receipts"(Page 145)".

    layout
    {
        addafter("Control 4")
        {
            field("Order No."; Rec."Order No.")
            {
            }
            field("Service Order No."; Rec."Service Order No.")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 24".

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

