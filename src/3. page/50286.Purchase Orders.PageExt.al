pageextension 50286 pageextension50286 extends "Purchase Orders"
{
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 32".


        //Unsupported feature: Code Modification on "Action 33.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ShowReservationEntries(TRUE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        ShowVehReservationEntries(TRUE);
        */
        //end;
    }


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //begin
    /*

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

