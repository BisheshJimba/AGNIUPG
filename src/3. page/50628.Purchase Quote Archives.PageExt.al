pageextension 50628 pageextension50628 extends "Purchase Quote Archives"
{
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601004".

    }

    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //begin
    /*
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

