pageextension 50054 pageextension50054 extends "Posted Sales Invoices"
{

    //Unsupported feature: Property Modification (SourceTableView) on ""Posted Sales Invoices"(Page 143)".

    layout
    {
        addafter("Control 2")
        {
            field("Order No."; Rec."Order No.")
            {
            }
            field("Order Type"; Rec."Order Type")
            {
            }
        }
        addafter("Control 6")
        {
            field("Direct Sales"; Rec."Direct Sales")
            {
            }
            field(Returned; Rec.Returned)
            {
            }
        }
        addafter("Control 24")
        {
            field(Kilometrage; Rec.Kilometrage)
            {
            }
        }
        addafter("Control 147")
        {
            field("Sell-to City"; Rec."Sell-to City")
            {
            }
        }
        addafter("Control 1102601003")
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
        addafter("<Document Exchange Status>")
        {
            field("Pre-Assigned No."; Rec."Pre-Assigned No.")
            {
            }
            field("User ID"; Rec."User ID")
            {
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
            }
            field("VIN from Posted Service"; Rec."VIN from Posted Service")
            {
                Caption = 'VIN';
            }
            field("Vehicle Regd. No."; Rec."Vehicle Regd. No.")
            {
            }
            field("Model Code"; Rec."Model Code")
            {
            }
            field("Model Version No."; Rec."Model Version No.")
            {
            }
            field("Make Code - VT"; Rec."Make Code - VT")
            {
            }
            field("Model Code - VT"; Rec."Model Code - VT")
            {
            }
            field("Model Version No. - VT"; Rec."Model Version No. - VT")
            {
            }
            field("DRP No./ARE1 No."; Rec."DRP No./ARE1 No.")
            {
            }
            field("VIN - Vehicle Sales"; Rec."VIN - Vehicle Sales")
            {
            }
            field("Financed By"; Rec."Financed By")
            {
                Editable = false;
                Visible = false;
            }
            field("Re-Financed By"; Rec."Re-Financed By")
            {
                Editable = false;
                Visible = false;
            }
            field("Service Order No."; Rec."Service Order No.")
            {
            }
            field("Financed Amount"; Rec."Financed Amount")
            {
                Editable = false;
                Visible = false;
            }
            field("Dealer PO No."; Rec."Dealer PO No.")
            {
            }
            field("Dealer VIN"; Rec."Dealer VIN")
            {
            }
            field("Vehicle Registration No."; Rec."Vehicle Registration No.")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 32".

        modify(Print)
        {
            ShortCutKey = 'Ctrl+P';
        }


        //Unsupported feature: Code Modification on "Print(Action 20).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SalesInvHeader := Rec;
        CurrPage.SETSELECTIONFILTER(SalesInvHeader);
        SalesInvHeader.PrintRecords(TRUE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        SalesInvHeader := Rec;
        CurrPage.SETSELECTIONFILTER(SalesInvHeader);
        SalesInvHeader.PrintRecords2(TRUE);
        */
        //end;


        //Unsupported feature: Code Modification on "CreateCreditMemo(Action 30).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CorrectPostedSalesInvoice.CreateCreditMemoCopyDocument(Rec,SalesHeader);
        PAGE.RUN(PAGE::"Sales Credit Memo",SalesHeader);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CorrectPostedSalesInvoice.CreateCreditMemoCopyDocument(Rec,SalesHeader);
        PAGE.RUN(PAGE::"Credit Note",SalesHeader);
        */
        //end;
        addafter(Navigate)
        {
            action("<Action1000000000>")
            {
                Caption = 'GatePass';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesShptHeader: Record "110";
                    SalesShipmentLine: Record "111";
                    Make: Record "25006000";
                begin
                    CompInfo.GET;
                    IF NOT CompInfo."Balaju Auto Works" THEN BEGIN
                        SalesShptHeader.RESET;
                        SalesShptHeader.SETRANGE("Order No.", Rec."Order No.");
                        SalesShptHeader.SETRANGE("Document Profile", Rec."Document Profile");
                        IF SalesShptHeader.FINDLAST THEN BEGIN
                            SalesShipmentLine.RESET;
                            SalesShipmentLine.SETRANGE("Document No.", SalesShptHeader."No.");
                            SalesShipmentLine.SETFILTER(VIN, '<>%1', '');
                            SalesShipmentLine.SETRANGE("Line Type", SalesShipmentLine."Line Type"::Vehicle);
                            IF SalesShipmentLine.FINDFIRST THEN BEGIN
                                Make.GET(SalesShipmentLine."Make Code");
                                IF NOT Make."Skip Delivery" THEN
                                    IF NOT SalesShptHeader."Vehicle Delivered" THEN
                                        ERROR('Please deliever vehicle first.');
                            END;
                        END;
                    END;
                    CreateGatePass;

                end;
            }
        }
    }

    var
        SalesInvHeader: Record "112";
        UserMgt: Codeunit "5700";
        CustLedger: Record "21";
        UserSetup: Record "91";
        StplMgt: Codeunit "50000";
        CompInfo: Record "79";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DocExchStatusStyle := GetDocExchStatusStyle;

    SalesInvoiceHeader.COPYFILTERS(Rec);
    SalesInvoiceHeader.SETFILTER("Document Exchange Status",'<>%1',"Document Exchange Status"::"Not Sent");
    DocExchStatusVisible := NOT SalesInvoiceHeader.ISEMPTY;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5

    CustLedger.SETRANGE("Document No.","No.");
    CustLedger.SETRANGE("Document Type",CustLedger."Document Type"::Invoice);
    IF CustLedger.FINDFIRST THEN BEGIN
      CustLedger.CALCFIELDS("Remaining Amount");
      "Remaining Amount" := CustLedger."Remaining Amount";
    END ELSE
      "Remaining Amount" := 0;
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetSecurityFilterOnRespCenter;
    CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    IF FINDFIRST THEN;
    IsOfficeAddin := OfficeMgt.IsAvailable;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    // SetSecurityFilterOnRespCenter;
    #2..4

    FilterOnRecord;
    */
    //end;

    procedure CreateGatePass()
    var
        GatepassHeader: Record "50004";
        GatepassLine: Record "50005";
        GatepassPage: Page "50002";
        Text000: Label 'Document cannot be identified for gatepass. Please issue Gatepass Manually.';
    begin
        GatepassHeader.RESET;
        GatepassHeader.SETCURRENTKEY("External Document No.");
        GatepassHeader.SETRANGE("External Document No.", Rec."No.");
        IF NOT GatepassHeader.FINDFIRST THEN BEGIN
            GatepassHeader.INIT;
            IF Rec."Document Profile" = Rec."Document Profile"::Service THEN
                GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle Service"
            ELSE
                IF Rec."Document Profile" = Rec."Document Profile"::"Spare Parts Trade" THEN
                    GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Spare Parts Trade"
                ELSE
                    IF Rec."Document Profile" = Rec."Document Profile"::"Vehicles Trade" THEN
                        GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle Trade"
                    ELSE
                        IF Rec."Document Profile" = Rec."Document Profile"::" " THEN
                            GatepassHeader."Document Type" := GatepassHeader."Document Type"::Admin;
            GatepassHeader."External Document Type" := GatepassHeader."External Document Type"::Invoice;
            GatepassHeader."External Document No." := Rec."No.";
            GatepassHeader.Person := Rec."Sell-to Customer Name";
            GatepassHeader.Owner := Rec."Bill-to Name";
            GatepassHeader."Vehicle Registration No." := Rec."Vehicle Registration No.";
            GatepassHeader.VALIDATE("Issued Date", TODAY);
            GatepassHeader.Destination := 'Out';
            GatepassHeader.INSERT(TRUE);
        END;
        GatepassPage.SETRECORD(GatepassHeader);
        GatepassPage.RUN;
    end;

    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
        SkipFilter: Boolean;
    begin
        UserSetup.GET(USERID);
        // IF ("Document Profile" = "Document Profile"::"Vehicles Trade") THEN
        IF UserSetup."Allow View all Veh. Invoice" THEN
            SkipFilter := TRUE;
        IF NOT SkipFilter THEN BEGIN
            RespCenterFilter := UserMgt.GetSalesFilter();
            IF RespCenterFilter <> '' THEN BEGIN
                Rec.FILTERGROUP(2);
                IF UserMgt.DefaultResponsibility THEN
                    Rec.SETRANGE("Responsibility Center", RespCenterFilter)
                ELSE
                    Rec.SETRANGE("Accountability Center", RespCenterFilter);
                Rec.FILTERGROUP(0);
            END;
        END;
    end;
}

