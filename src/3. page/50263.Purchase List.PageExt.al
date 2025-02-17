pageextension 50263 pageextension50263 extends "Purchase List"
{

    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CopyBuyFromVendorFilter;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    FilterOnRecord;
    CopyBuyFromVendorFilter;
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

