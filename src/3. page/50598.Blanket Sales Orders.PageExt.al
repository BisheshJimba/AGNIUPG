pageextension 50598 pageextension50598 extends "Blanket Sales Orders"
{
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 1902018507".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1900316107".

    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601019".

    }

    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetSecurityFilterOnRespCenter;

    CopySellToCustomerFilter;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    FilterOnRecord; //AGNI2017CU8
    */
    //end;

    local procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetSalesFilter();
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

