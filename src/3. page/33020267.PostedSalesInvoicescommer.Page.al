page 33020267 "Posted Sales Invoices-commer"
{
    // SalesInvHeader.RESET;
    // SalesInvHeader.SETRANGE("Sys. LC No.","Sys. LC No.");
    // SalesInvHeader.SETRANGE(Check,TRUE);
    // IF SalesInvHeader.FINDFIRST THEN BEGIN
    //    REPEAT
    //     SalesInvLine.RESET;
    //     SalesInvLine.SETRANGE("Document No.",SalesInvHeader."No.");
    //     IF SalesInvLine.FINDFIRST THEN
    //       REPEAT
    //         CommercialLine.INIT;
    //         //CommercialLine."Document No.":= "No.";
    //         CommercialLine."Sales Invoice No.":=SalesInvLine."Document No.";
    //         CommercialLine."Line No." :=SalesInvLine."Line No.";
    //         CommercialLine.MODIFY;
    //       UNTIL SalesInvLine.NEXT =0;
    //    UNTIL SalesInvHeader.NEXT = 0;
    // END;
    // 
    // SalesInvHeader.RESET;
    // SalesInvHeader.SETRANGE("Sys. LC No.","Sys. LC No.");
    // SalesInvHeader.SETRANGE(Check,TRUE);
    // IF SalesInvHeader.FINDSET THEN
    // REPEAT
    //   SalesInvHeader.Check := FALSE;
    //   SalesInvHeader.MODIFY;
    // UNTIL SalesInvHeader.NEXT =0;

    Caption = 'Posted Sales Invoices';
    DeleteAllowed = true;
    Editable = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = Table112;
    SourceTableView = SORTING(No.)
                      ORDER(Ascending)
                      WHERE(Returned = CONST(No),
                            Commercial Invoiced=FILTER(No));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No.";"No.")
                {
                }
                field("Order No.";"Order No.")
                {
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                }
                field("Direct Sales";"Direct Sales")
                {
                }
                field(Returned;Returned)
                {
                }
                field("Currency Code";"Currency Code")
                {
                }
                field(Amount;Amount)
                {

                    trigger OnDrillDown()
                    begin
                        SETRANGE("No.");
                        PAGE.RUNMODAL(PAGE::"Posted Sales Invoice",Rec)
                    end;
                }
                field("Amount Including VAT";"Amount Including VAT")
                {

                    trigger OnDrillDown()
                    begin
                        SETRANGE("No.");
                        PAGE.RUNMODAL(PAGE::"Posted Sales Invoice",Rec)
                    end;
                }
                field("Remaining Amount";"Remaining Amount")
                {
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    Visible = false;
                }
                field("Sell-to Country/Region Code";"Sell-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    Visible = false;
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    Visible = false;
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    Visible = false;
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    Visible = false;
                }
                field("Bill-to Country/Region Code";"Bill-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    Visible = false;
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    Visible = false;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    Visible = false;
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    Visible = false;
                }
                field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    Visible = false;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    Visible = true;
                }
                field("No. Printed";"No. Printed")
                {
                }
                field("Document Date";"Document Date")
                {
                    Visible = false;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    Visible = false;
                }
                field("Payment Method Code";"Payment Method Code")
                {
                }
                field("Due Date";"Due Date")
                {
                    Visible = false;
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    Visible = false;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    Visible = false;
                }
                field("Shipment Date";"Shipment Date")
                {
                    Visible = false;
                }
                field("Pre-Assigned No.";"Pre-Assigned No.")
                {
                }
                field("User ID";"User ID")
                {
                }
                field("VAT Registration No.";"VAT Registration No.")
                {
                }
                field("VIN from Posted Service";"VIN from Posted Service")
                {
                    Caption = 'VIN';
                }
                field("Vehicle Regd. No.";"Vehicle Regd. No.")
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field("Model Version No.";"Model Version No.")
                {
                }
                field("Make Code - VT";"Make Code - VT")
                {
                }
                field("Model Code - VT";"Model Code - VT")
                {
                }
                field("Model Version No. - VT";"Model Version No. - VT")
                {
                }
                field("DRP No./ARE1 No.";"DRP No./ARE1 No.")
                {
                }
                field("VIN - Vehicle Sales";"VIN - Vehicle Sales")
                {
                }
                field("Financed By";"Financed By")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Re-Financed By";"Re-Financed By")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Financed Amount";"Financed Amount")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(;Links)
            {
                Visible = false;
            }
            systempart(;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Copy to Commercial")
            {
                Caption = 'Copy to Commercial';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "112";
                begin
                    CurrPage.SETSELECTIONFILTER(SalesInvoiceHeader);
                    CommercialLine.RESET;
                    CommercialLine.SETRANGE("Document No.",CommercialNo);
                    IF CommercialLine.FINDLAST THEN
                       CommercialLineNo := CommercialLine."Line No." + 10000
                    ELSE
                      CommercialLineNo := 10000;
                    IF SalesInvoiceHeader.FINDFIRST THEN
                    REPEAT
                      SalesCrMemoLine.RESET;//Aakrista 5/23/2022
                      SalesCrMemoLine.SETFILTER(Quantity,'<>%1',0);
                      SalesCrMemoLine.SETRANGE("Returned Invoice No.",SalesInvoiceHeader."No.");
                      IF SalesCrMemoLine.FINDFIRST THEN
                        EXIT;
                      CommercialLine.RESET;
                      CommercialLine.SETRANGE("Sales Invoice No.",SalesInvoiceHeader."No.");
                      IF NOT CommercialLine.FINDFIRST THEN BEGIN
                        MESSAGE('**');
                        CLEAR(CommercialLine);
                        CommercialLine.INIT;
                        CommercialLine."Document No." := CommercialNo;
                        CommercialLineNo := CommercialLineNo;
                        CommercialLine."Line No." := CommercialLineNo;
                        CommercialLine."Sales Invoice No." := SalesInvoiceHeader."No.";
                        SalesInvoiceHeader.CALCFIELDS("Amount Including VAT");
                        CommercialLine.Amount := SalesInvoiceHeader."Amount Including VAT"; //ratan 4.27.2021
                        CommercialLine.INSERT(TRUE);
                      END
                      ELSE
                       ERROR(Text001,CommercialLine."Sales Invoice No.",CommercialLine."Document No."); //Amisha 5/5/21
                      CommercialLineNo += 10000;
                    UNTIL SalesInvoiceHeader.NEXT = 0;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CustLedger.SETRANGE("Document No.","No.");
        CustLedger.SETRANGE("Document Type",CustLedger."Document Type"::Invoice);
        IF CustLedger.FINDFIRST THEN BEGIN
          CustLedger.CALCFIELDS("Remaining Amount");
          "Remaining Amount" := CustLedger."Remaining Amount";
        END ELSE
          "Remaining Amount" := 0;
    end;

    trigger OnOpenPage()
    begin
        FilterOnRecord;
        FILTERGROUP(10);
        SETRANGE(Returned,FALSE);
        FILTERGROUP(0);
        //SalesCrMemoLine.RESET;
        //SalesCrMemoLine.SETRANGE("S)
        //SalesCrMemoLine.SETRANGE("Returned Invoice No.","No.");
    end;

    var
        SalesInvHeader: Record "112";
        UserMgt: Codeunit "5700";
        CustLedger: Record "21";
        UserSetup: Record "91";
        SalesInvLine: Record "113";
        CommercialLine: Record "33020186";
        CommercialHdr: Record "33020185";
        CommercialNo: Code[20];
        SalesinvoiceNo: Code[20];
        CommercialLineNo: Integer;
        CommercialInvoiceLine: Record "33020186";
        Text001: Label 'Commercial sales Inv. line already exists with sales invoice no %1 in document no %2.';
        SalesCrMemoLine: Record "115";

    [Scope('Internal')]
    procedure CreateGatePass()
    var
        GatepassHeader: Record "50004";
        GatepassLine: Record "50005";
        GatepassPage: Page "50002";
                          Text000: Label 'Document cannot be identified for gatepass. Please issue Gatepass Manually.';
    begin
        GatepassHeader.RESET;
        GatepassHeader.SETCURRENTKEY("External Document No.");
        GatepassHeader.SETRANGE("External Document No.","No.");
        IF NOT GatepassHeader.FINDFIRST THEN
        BEGIN
          GatepassHeader.INIT;
          IF "Shortcut Dimension 2 Code" = '4010' THEN
            GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle GatePass"
          ELSE IF  "Shortcut Dimension 2 Code" IN ['2040','2070'] THEN
            GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle Trade"
          ELSE IF  "Shortcut Dimension 2 Code" = '3000' THEN
            GatepassHeader."Document Type" := GatepassHeader."Document Type"::"6"
          ELSE
            ERROR('Text000');
          GatepassHeader."External Document Type" := GatepassHeader."External Document Type"::Repair;
          GatepassHeader."External Document No." := "No.";
          GatepassHeader.INSERT(TRUE);
        END;
        GatepassPage.SETRECORD(GatepassHeader);
        GatepassPage.RUN;
    end;

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
        SkipFilter: Boolean;
    begin
        UserSetup.GET(USERID);
        IF UserSetup."Allow View all Veh. Invoice" THEN
            SkipFilter := TRUE;
        IF NOT SkipFilter THEN BEGIN
          RespCenterFilter := UserMgt.GetSalesFilter();
            IF RespCenterFilter <> '' THEN BEGIN
              FILTERGROUP(2);
               IF UserMgt.DefaultResponsibility THEN
                  SETRANGE("Responsibility Center",RespCenterFilter)
              ELSE
                  SETRANGE("Accountability Center",RespCenterFilter);
              FILTERGROUP(0);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure SetCommercialNo(var TempCommercialNo: Code[20])
    begin
        CommercialNo := TempCommercialNo;
    end;
}

