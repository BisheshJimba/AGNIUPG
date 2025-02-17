pageextension 50602 pageextension50602 extends "Purchase Order List"
{
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 1901138007".

        addafter("Control 1102601027")
        {
            field("Vendor Invoice No."; Rec."Vendor Invoice No.")
            {
            }
        }
        addafter("Control 22")
        {
            field("Total TDS Amount"; "Total TDS Amount")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601030".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601039".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601038".



        //Unsupported feature: Code Modification on "Post(Action 52).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SendToPosting(CODEUNIT::"Purch.-Post (Yes/No)");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //***SM 25/06/2013 to create vehicle checklist at each receiving point***
        ProcessCheckList.RESET;
        ProcessCheckList.SETRANGE("Source ID","No.");
        IF NOT ProcessCheckList.FINDFIRST THEN
          ERROR(NoChecklistCreated);
        //***SM 25/06/2013 to create vehicle checklist at each receiving point***

        SendToPosting(CODEUNIT::"Purch.-Post (Yes/No)");
        */
        //end;


        //Unsupported feature: Code Modification on "PostAndPrint(Action 53).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SendToPosting(CODEUNIT::"Purch.-Post + Print");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //***SM 25/06/2013 to create vehicle checklist at each receiving point***
        ProcessCheckList.RESET;
        ProcessCheckList.SETRANGE("Source ID","No.");
        IF NOT ProcessCheckList.FINDFIRST THEN
          ERROR(NoChecklistCreated);
        //***SM 25/06/2013 to create vehicle checklist at each receiving point***

        SendToPosting(CODEUNIT::"Purch.-Post + Print");
        */
        //end;
    }

    var
        UserMgt: Codeunit "5700";
        ProcessCheckList: Record "25006025";
        NoChecklistCreated: Label 'The delivery checklist has not been created.Please create the checklist for this vehicle.';


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetSecurityFilterOnRespCenter;

    JobQueueActive := PurchasesPayablesSetup.JobQueueActive;

    CopyBuyFromVendorFilter;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5
    //AGNI2017CU8 >>
    FILTERGROUP(3);
    SETRANGE("Document Profile",0);
    SETRANGE("Import Purch. Order",FALSE); //Agni UPG 2009
    FilterOnRecord;
    //AGNi2017CU8 <<
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

