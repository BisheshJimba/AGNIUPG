pageextension 50597 pageextension50597 extends "Sales Credit Memos"
{

    //Unsupported feature: Property Modification (CardPageID) on ""Sales Credit Memos"(Page 9302)".

    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 1902018507".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1900316107".

    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601023".

    }

    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetSecurityFilterOnRespCenter;
    JobQueueActive := SalesSetup.JobQueueActive;

    CopySellToCustomerFilter;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
    FilterOnRecord;  //AGNI2017CU8
    */
    //end;


    //Unsupported feature: Code Modification on "ShowPostedConfirmationMessage(PROCEDURE 7)".

    //procedure ShowPostedConfirmationMessage();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SalesCrMemoHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
    IF SalesCrMemoHeader.FINDFIRST THEN
      IF DIALOG.CONFIRM(OpenPostedSalesCrMemoQst,FALSE) THEN
        PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
        PAGE.RUN(PAGE::"Posted Credit Note",SalesCrMemoHeader);
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

