pageextension 50055 pageextension50055 extends "Posted Sales Credit Memos"
{

    //Unsupported feature: Property Modification (SourceTableView) on ""Posted Sales Credit Memos"(Page 144)".


    //Unsupported feature: Property Modification (CardPageID) on ""Posted Sales Credit Memos"(Page 144)".

    layout
    {

        //Unsupported feature: Code Modification on "Control 13.OnDrillDown".

        //trigger OnDrillDown()
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SETRANGE("No.");
        PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memo",Rec)
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        SETRANGE("No.");
        PAGE.RUNMODAL(PAGE::"Posted Credit Note",Rec)
        */
        //end;


        //Unsupported feature: Code Modification on "Control 15.OnDrillDown".

        //trigger OnDrillDown()
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SETRANGE("No.");
        PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memo",Rec)
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        SETRANGE("No.");
        PAGE.RUNMODAL(PAGE::"Posted Credit Note",Rec)
        */
        //end;
        addafter("Control 27")
        {
            field("Sys. LC No."; Rec."Sys. LC No.")
            {
            }
            field("Bank LC No."; Rec."Bank LC No.")
            {
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
            }
        }
        addafter("Control 1102601005")
        {
            field("External Document No."; Rec."External Document No.")
            {
                Visible = false;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 32".



        //Unsupported feature: Code Modification on "Action 26.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        PAGE.RUN(PAGE::"Posted Sales Credit Memo",Rec)
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        PAGE.RUN(PAGE::"Posted Credit Note",Rec)
        */
        //end;


        //Unsupported feature: Code Modification on "Action 20.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SalesCrMemoHeader := Rec;
        CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
        SalesCrMemoHeader.PrintRecords(TRUE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        SalesCrMemoHeader := Rec;
        CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
        SalesCrMemoHeader.PrintRecords2(TRUE);
        */
        //end;
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

