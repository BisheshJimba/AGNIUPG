pageextension 50057 pageextension50057 extends "Posted Purchase Invoices"
{

    //Unsupported feature: Property Modification (SourceTableView) on ""Posted Purchase Invoices"(Page 146)".

    layout
    {
        addafter("Control 4")
        {
            field("Vendor Invoice No."; Rec."Vendor Invoice No.")
            {
            }
            field("Order No."; Rec."Order No.")
            {
            }
            field("Sys. LC No."; Rec."Sys. LC No.")
            {
            }
            field("Bank LC No."; Rec."Bank LC No.")
            {
            }
            field("Service Order No."; Rec."Service Order No.")
            {
            }
        }
        addafter("Control 13")
        {
            field("<Currency Code2"; Rec."Currency Code")
            {
            }
        }
        addafter("Control 33")
        {
            field("VIN-COGS"; VINCOGS)
            {
                Caption = 'VIN-COGS';
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 30".



        //Unsupported feature: Code Modification on "CreateCreditMemo(Action 11).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CorrectPostedPurchInvoice.CreateCreditMemoCopyDocument(Rec,PurchaseHeader);
        PAGE.RUN(PAGE::"Purchase Credit Memo",PurchaseHeader);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CorrectPostedPurchInvoice.CreateCreditMemoCopyDocument(Rec,PurchaseHeader);
        PAGE.RUN(PAGE::"Debit Memo",PurchaseHeader);
        */
        //end;
        addafter(Navigate)
        {
            action("&Create Sales Order")
            {
                Caption = '&Create Sales Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;

                trigger OnAction()
                var
                    GPDSales: Page "50023";
                begin
                    //GPDSales.CreateOrder(Rec);
                    //GPDSales.RUNMODAL;
                    PurchInvHeader.CreateSalesOrder(Rec);
                end;
            }
            action("Report Selection")
            {
                Caption = 'Report Selection';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    REPORT.RUN(50067);
                end;
            }
        }
        addafter("Action 22")
        {
            action("Procument Memo")
            {

                trigger OnAction()
                var
                    ProcMemo: Record "130415";
                begin
                    ProcMemo.RESET;
                    ProcMemo.SETRANGE("Memo No.", Rec."Procument Memo No.");
                    IF ProcMemo.FINDFIRST THEN
                        PAGE.RUN(PAGE::"Posted Procurement Memo", ProcMemo);
                end;
            }
        }
    }

    var
        PurchInvHeader: Record "122";
        VINCOGS: Code[20];
        PurchInvLine: Record "123";


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

    PurchInvLine.RESET;
    PurchInvLine.SETRANGE("Document No.","No.");
    IF PurchInvLine.FINDFIRST THEN BEGIN
      VINCOGS := PurchInvLine."VIN - COGS";
    END;
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

