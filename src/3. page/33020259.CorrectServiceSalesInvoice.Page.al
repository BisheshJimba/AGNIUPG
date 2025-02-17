page 33020259 "Correct Service Sales Invoice"
{
    Caption = 'Sales Invoice';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = Table36;
    SourceTableView = WHERE(Document Type=FILTER(Invoice));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                          CurrPage.UPDATE;
                    end;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Contact No.";"Sell-to Contact No.")
                {
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                }
                field("Sell-to Address";"Sell-to Address")
                {
                    Importance = Additional;
                }
                field("Sell-to Address 2";"Sell-to Address 2")
                {
                    Importance = Additional;
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    Importance = Additional;
                }
                field("Sell-to City";"Sell-to City")
                {
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                }
                field("Posting Date";"Posting Date")
                {
                    Importance = Promoted;
                }
                field("Document Date";"Document Date")
                {
                }
                field("External Document No.";"External Document No.")
                {
                    Importance = Promoted;
                }
                field("Salesperson Code";"Salesperson Code")
                {

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("Campaign No.";"Campaign No.")
                {
                    Importance = Additional;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Accountability Center";"Accountability Center")
                {
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    Importance = Additional;
                }
                field(Status;Status)
                {
                    Importance = Promoted;
                }
                field("Financed By No.";"Financed By No.")
                {
                }
                field("Re-Financed By";"Re-Financed By")
                {
                }
                field("Job Type";"Job Type")
                {
                    Visible = ServiceDocument;
                }
                field("Vehicle Regd. No.";"Vehicle Regd. No.")
                {
                }
            }
            part(SalesLines;33020260)
            {
                SubPageLink = Document No.=FIELD(No.);
                Visible = NOT VehicleTradeDocument;
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No.";"Bill-to Contact No.")
                {
                }
                field("Bill-to Name";"Bill-to Name")
                {
                }
                field("Bill-to Address";"Bill-to Address")
                {
                    Importance = Additional;
                }
                field("Bill-to Address 2";"Bill-to Address 2")
                {
                    Importance = Additional;
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    Importance = Additional;
                }
                field("Bill-to City";"Bill-to City")
                {
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    Importance = Additional;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    Importance = Promoted;
                }
                field("Due Date";"Due Date")
                {
                    Importance = Promoted;
                }
                field("Payment Discount %";"Payment Discount %")
                {
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    Importance = Additional;
                }
                field("Payment Method Code";"Payment Method Code")
                {
                }
                field("Prices Including VAT";"Prices Including VAT")
                {

                    trigger OnValidate()
                    begin
                        PricesIncludingVATOnAfterValid;
                    end;
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code";"Ship-to Code")
                {
                    Importance = Promoted;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    Importance = Additional;
                }
                field("Ship-to Address 2";"Ship-to Address 2")
                {
                    Importance = Additional;
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    Importance = Promoted;
                }
                field("Ship-to City";"Ship-to City")
                {
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    Importance = Additional;
                }
                field("Location Code";"Location Code")
                {
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                }
                field("Package Tracking No.";"Package Tracking No.")
                {
                    Importance = Additional;
                }
                field("Shipment Date";"Shipment Date")
                {
                    Importance = Promoted;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code";"Currency Code")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        CLEAR(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                          VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                          CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeOnAfterValidate;
                    end;
                }
                field("Transaction Type";"Transaction Type")
                {
                }
                field("Transaction Specification";"Transaction Specification")
                {
                }
                field("Transport Method";"Transport Method")
                {
                }
                field("Exit Point";"Exit Point")
                {
                }
                field(Area;Area)
                {
                }
            }
            group(Service)
            {
                Caption = 'Service';
                field("Document Profile";"Document Profile")
                {
                }
                field("Service Document No.";"Service Document No.")
                {
                    Caption = 'Service Order No.';
                }
                field("Vehicle Item Charge No.";"Vehicle Item Charge No.")
                {
                }
                field("Make Code";"Make Code")
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field("Model Version No.";"Model Version No.")
                {
                }
            }
        }
        area(factboxes)
        {
            part(;9080)
            {
                SubPageLink = No.=FIELD(Sell-to Customer No.);
                Visible = false;
            }
            part(;9081)
            {
                SubPageLink = No.=FIELD(Bill-to Customer No.);
                Visible = false;
            }
            part(;9082)
            {
                SubPageLink = No.=FIELD(Bill-to Customer No.);
                Visible = true;
            }
            part(;9084)
            {
                SubPageLink = No.=FIELD(Sell-to Customer No.);
                Visible = true;
            }
            part(;9087)
            {
                Provider = SalesLines;
                SubPageLink = Document Type=FIELD(Document Type),
                              Document No.=FIELD(Document No.),
                              Line No.=FIELD(Line No.);
                Visible = false;
            }
            part(;9089)
            {
                Provider = SalesLines;
                SubPageLink = No.=FIELD(No.);
                Visible = true;
            }
            part(;9092)
            {
                SubPageLink = Table ID=CONST(36),
                              Document Type=FIELD(Document Type),
                              Document No.=FIELD(No.),
                              Status=CONST(Open);
                Visible = false;
            }
            part(;9108)
            {
                Provider = SalesLines;
                SubPageLink = No.=FIELD(No.);
                Visible = false;
            }
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
        area(navigation)
        {
            group("&Invoice")
            {
                Caption = '&Invoice';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        CalcInvDiscForHeader;
                        COMMIT;
                        PAGE.RUNMODAL(PAGE::"Sales Statistics",Rec);
                    end;
                }
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page 21;
                                    RunPageLink = No.=FIELD(Sell-to Customer No.);
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 67;
                                    RunPageLink = Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+r';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "414";
                    begin
                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    ShortCutKey = 'Ctrl+o';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "414";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
                action(ApplyModification)
                {
                    Caption = 'Apply Modification';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CorrectServiceInvoice(Rec);
                    end;
                }
                action("Apply Sanjivani Amount")
                {
                    Caption = 'Apply Sanjivani Amount';
                    Visible = false;

                    trigger OnAction()
                    begin
                        CalcRemainingSanjivaniAmount(Rec);
                    end;
                }
                action("Make Debit Note")
                {
                    Caption = 'Make Debit Note';
                    Visible = false;

                    trigger OnAction()
                    begin
                        "Debit Note" := TRUE;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }
            }
            group("<Action1000000001>")
            {
                Caption = 'W&rranty';
                action("<Action1000000002>")
                {
                    Caption = 'Choose Applicable PCR';
                    Image = BulletList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunPageMode = View;
                    Visible = WarantyDocument;

                    trigger OnAction()
                    begin
                        WarrantySettle.RESET;
                        WarrantySettle.SETRANGE(Settled,FALSE);
                        WarrantySettlePage.SETTABLEVIEW(WarrantySettle);
                        WarrantySettlePage.SETRECORD(WarrantySettle);
                        WarrantySettlePage.SetPreAssignNo("No.");
                        WarrantySettlePage.RUN;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //EDMS >>
          VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
          SparePartDocument := "Document Profile" = "Document Profile"::"Spare Parts Trade";
          ServiceDocument := "Document Profile" = "Document Profile"::Service;
        //EDMS >>
        //Sipradi-YS

          IF ("Document Profile" IN ["Document Profile"::Service]) THEN
            ServiceDocument := TRUE
          ELSE
            ServiceDocument := FALSE;
          IF "Warranty Settlement" THEN
            WarantyDocument := TRUE;

        //Sipradi-YS
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SAVERECORD;
        EXIT(ConfirmDeletion);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //"Responsibility Center" := UserMgt.GetSalesFilter;
        "Accountability Center" := UserMgt.GetSalesFilter;
        //EDMS >>
          CASE DocumentProfileFilter OF
            FORMAT("Document Profile"::"Vehicles Trade"): BEGIN
              "Document Profile" := "Document Profile"::"Vehicles Trade";
              VehicleTradeDocument := TRUE;
            END;
            FORMAT("Document Profile"::"Spare Parts Trade"): BEGIN
              "Document Profile" := "Document Profile"::"Spare Parts Trade";
              SparePartDocument := TRUE;
            END;
            FORMAT("Document Profile"::Service): BEGIN
              "Document Profile" := "Document Profile"::Service;
              ServiceDocument := TRUE;
            END;
          END;
        //EDMS >>
        //Sipradi-YS BEGIN
        CASE WarrantyDocumentFilter OF
          'Yes': BEGIN
          "Warranty Settlement" := TRUE;
          WarantyDocument := TRUE;
          END;
        END;
        //Sipradi-YS END
    end;

    trigger OnOpenPage()
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Allow Correcting Serv-Inv" THEN
          ERROR(Text000);
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          //SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
          SETRANGE("Accountability Center",UserMgt.GetSalesFilter);
          FILTERGROUP(0);
        END;

        //EDMS >>
          FILTERGROUP(3);
          DocumentProfileFilter := GETFILTER("Document Profile");
          WarrantyDocumentFilter := GETFILTER("Warranty Settlement");
          FILTERGROUP(0);
        //EDMS <<
        //Sipradi-YS
          IF ("Document Profile" IN ["Document Profile"::Service]) THEN
            ServiceDocument := TRUE
          ELSE
            ServiceDocument := FALSE;

        IF "Debit Note" THEN
          CurrPage.CAPTION(DebitNoteCaption);
        IF "Warranty Settlement" THEN
          WarantyDocument := TRUE;
        //Sipradi-YS
    end;

    var
        SalesSetup: Record "311";
        CopySalesDoc: Report "292";
                          MoveNegSalesLines: Report "6699";
                          ReportPrint: Codeunit "228";
                          UserMgt: Codeunit "5700";
                          SalesInfoPaneMgt: Codeunit "7171";
    [InDataSet]

    SalesHistoryBtnVisible: Boolean;
        [InDataSet]
        BillToCommentPictVisible: Boolean;
        [InDataSet]
        BillToCommentBtnVisible: Boolean;
        [InDataSet]
        SalesHistoryStnVisible: Boolean;
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        [InDataSet]
        ServiceDocument: Boolean;
        DocumentProfileFilter: Text[250];
        DebitNoteCaption: Label 'Debit Memo';
        recServiceInvoice: Record "36";
        VFHeader: Record "33020062";
        WarrantyDocumentFilter: Text[30];
        [InDataSet]
        WarantyDocument: Boolean;
        WarrantySettle: Record "33020252";
        WarrantySettlePage: Page "33020256";
                                UserSetup: Record "91";
                                Text000: Label 'You do not have permission to correct Sales Invoices.';
        ChangeExchangeRate: Page "511";

    local procedure UpdateInfoPanel()
    var
        DifferSellToBillTo: Boolean;
    begin
        DifferSellToBillTo := "Sell-to Customer No." <> "Bill-to Customer No.";
        SalesHistoryBtnVisible := DifferSellToBillTo;
        BillToCommentPictVisible := DifferSellToBillTo;
        BillToCommentBtnVisible := DifferSellToBillTo;
        //SalesHistoryStnVisible := SalesInfoPaneMgt.DocExist(Rec,"Sell-to Customer No.");  Commented because function in the codeunit cannot be found
        IF DifferSellToBillTo THEN
          //SalesHistoryBtnVisible := SalesInfoPaneMgt.DocExist(Rec,"Bill-to Customer No.")  Commented because function in the codeunit cannot be found
    end;

        local procedure ApproveCalcInvDisc()
    begin
        CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        CurrPage.UPDATE;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.UPDATE;
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    end;
}

