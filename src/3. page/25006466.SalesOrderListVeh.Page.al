page 25006466 "Sales Order List (Veh.)"
{
    // 22.10.2015 NAV2016 Merge
    //   Approvals removed

    Caption = 'Sales Orders';
    CardPageID = "Sales Order";
    Editable = false;
    PageType = List;
    SourceTable = Table36;
    SourceTableView = WHERE(Document Type=CONST(Order));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field("Quote No."; "Quote No.")
                {
                }
                field("Sys. LC No."; "Sys. LC No.")
                {
                }
                field("Bank LC No."; "Bank LC No.")
                {
                }
                field("Dealer PO No."; "Dealer PO No.")
                {
                }
                field("Advance Payment"; "Advance Payment")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("External Document No."; "External Document No.")
                {
                    Visible = false;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; "Sell-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    Visible = false;
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    Visible = false;
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                    Visible = false;
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; "Bill-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                    Visible = false;
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                    Visible = false;
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                    Visible = false;
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    Visible = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    Visible = true;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    Visible = false;
                }
                field(SalesPerson; SalesPerson)
                {
                    Caption = 'Salesperson';
                    TableRelation = Salesperson/Purchaser.Name WHERE (Code=FIELD(Salesperson Code));
                }
                field("Assigned User ID";"Assigned User ID")
                {
                }
                field("Currency Code";"Currency Code")
                {
                    Visible = false;
                }
                field("Document Date";"Document Date")
                {
                    Visible = false;
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    Visible = false;
                }
                field("Campaign No.";"Campaign No.")
                {
                    Visible = false;
                }
                field("Model Code";"Model Code")
                {
                }
                field("Make Code";"Make Code")
                {
                }
                field("Model Version No.";"Model Version No.")
                {
                }
                field("Model Version No. (Sales Line)";"Model Version No. (Sales Line)")
                {
                }
                field(Status;Status)
                {
                    Visible = false;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    Visible = false;
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
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    Visible = false;
                }
                field("Shipment Date";"Shipment Date")
                {
                    Visible = false;
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    Visible = false;
                }
                field(ModelCode;ModelCode)
                {
                    Caption = 'Model Code';
                }
                field(ModelVersionCode;ModelVersionCode)
                {
                    Caption = 'Model Version No.';
                }
                field(DRP;DRP)
                {
                    Caption = 'DRP No./ARE1 No.';
                }
                field("Booked Date";"Booked Date")
                {
                }
            }
        }
        area(factboxes)
        {
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
            group("O&rder")
            {
                Caption = 'O&rder';
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
                        PAGE.RUNMODAL(PAGE::"Sales Order Statistics",Rec);
                    end;
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
                action("S&hipments")
                {
                    Caption = 'S&hipments';
                    Image = Shipment;
                    RunObject = Page 142;
                                    RunPageLink = Order No.=FIELD(No.);
                    RunPageView = SORTING(Order No.);
                }
                action(Invoices)
                {
                    Caption = 'Invoices';
                    Image = Invoice;
                    RunObject = Page 143;
                                    RunPageLink = Order No.=FIELD(No.);
                    RunPageView = SORTING(Order No.);
                }
                action("Prepa&yment Invoices")
                {
                    Caption = 'Prepa&yment Invoices';
                    Image = PrepaymentInvoice;
                    RunObject = Page 143;
                                    RunPageLink = Prepayment Order No.=FIELD(No.);
                    RunPageView = SORTING(Prepayment Order No.);
                }
                action("Prepayment Credi&t Memos")
                {
                    Caption = 'Prepayment Credi&t Memos';
                    Image = PrepaymentCreditMemo;
                    RunObject = Page 144;
                                    RunPageLink = Prepayment Order No.=FIELD(No.);
                    RunPageView = SORTING(Prepayment Order No.);
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
                action("A&pprovals")
                {
                    Caption = 'A&pprovals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Sales Header","Document Type","No.");
                        ApprovalEntries.RUN;
                    end;
                }
                action("Whse. Shipment Lines")
                {
                    Caption = 'Whse. Shipment Lines';
                    Image = ShipmentLines;
                    RunObject = Page 7341;
                                    RunPageLink = Source Type=CONST(37),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(No.);
                    RunPageView = SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                }
                action("In&vt. Put-away/Pick Lines")
                {
                    Caption = 'In&vt. Put-away/Pick Lines';
                    Image = InventoryJournal;
                    RunObject = Page 5774;
                                    RunPageLink = Source Document=CONST(Sales Order),
                                  Source No.=FIELD(No.);
                    RunPageView = SORTING(Source Document,Source No.,Location Code);
                }
                action("Pla&nning")
                {
                    Caption = 'Pla&nning';
                    Image = ServiceHours;

                    trigger OnAction()
                    begin
                        SalesPlanForm.SetSalesOrder("No.");
                        SalesPlanForm.RUNMODAL;
                    end;
                }
                action("Order &Promising")
                {
                    Caption = 'Order &Promising';
                    Image = "Order";

                    trigger OnAction()
                    var
                        OrderPromisingLine: Record "99000880" temporary;
                    begin
                        OrderPromisingLine.SETRANGE("Source Type","Document Type");
                        OrderPromisingLine.SETRANGE("Source ID","No.");
                        PAGE.RUNMODAL(PAGE::"Order Promising Lines",OrderPromisingLine);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Create &Whse. Shipment")
                {
                    Caption = 'Create &Whse. Shipment';
                    Image = Shipment;

                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "5752";
                    begin
                        GetSourceDocOutbound.CreateFromSalesOrder(Rec);

                        IF NOT FINDSET THEN
                          INIT;
                    end;
                }
                action("Create Inventor&y Put-away/Pick")
                {
                    Caption = 'Create Inventor&y Put-away/Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;

                    trigger OnAction()
                    begin
                        CreateInvtPutAwayPick;

                        IF NOT FINDSET THEN
                          INIT;
                    end;
                }
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN;
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

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

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "414";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
                action("Send IC Sales Order Cnfmn.")
                {
                    Caption = 'Send IC Sales Order Cnfmn.';
                    Image = SendTo;

                    trigger OnAction()
                    var
                        ICInOutboxMgt: Codeunit "427";
                        PurchaseHeader: Record "38";
                    begin
                        //IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN
                          ICInOutboxMgt.SendSalesDoc(Rec,FALSE);
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
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin

                        // IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN BEGIN
                        //   IF ApprovalMgt.TestSalesPrepayment(Rec) THEN
                        //     ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //   ELSE BEGIN
                        //     IF ApprovalMgt.TestSalesPayment(Rec) THEN
                        //       ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //     ELSE
                              CODEUNIT.RUN(CODEUNIT::"Sales-Post (Yes/No)",Rec);
                        //   END;
                        // END;
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin


                        //added by RNM 7/9/2013
                        SalesLine.RESET;
                        SalesLine.SETRANGE("Document No.","No.");
                        IF SalesLine."Document Profile" = SalesLine."Document Profile"::"Vehicles Trade" THEN BEGIN
                           IF SalesLine.FINDFIRST THEN BEGIN
                              Vehicle.RESET;
                              Vehicle.SETRANGE("Serial No.",SalesLine."Vehicle Serial No.");
                              IF Vehicle.FINDFIRST THEN BEGIN
                                 //Vehicle.CALCFIELDS("Insurance Policy No.");
                                // Vehicle.TESTFIELD("Insurance Policy No.");
                              END;
                           END;
                        END;


                        // IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN BEGIN
                        //   IF ApprovalMgt.TestSalesPrepayment(Rec) THEN
                        //     ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //   ELSE BEGIN
                        //     IF ApprovalMgt.TestSalesPayment(Rec) THEN
                        //       ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //     ELSE
                              CODEUNIT.RUN(CODEUNIT::"Sales-Post + Print",Rec);
                        //   END;
                        // END;
                    end;
                }
                action("Post &Batch")
                {
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        REPORT.RUNMODAL(REPORT::"Batch Post Sales Orders",TRUE,TRUE,Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                action("<Action1000000007>")
                {
                    Caption = 'Count Records';
                    Image = CalculatePlan;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CountRec := COUNT;
                        MESSAGE('No. of records are %1 ',CountRec);
                    end;
                }
                action("Sales Order Confirmation")
                {
                    Caption = 'Sales Order Confirmation';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(SalesHeader);
                        REPORT.RUNMODAL(33020020,TRUE,FALSE,SalesHeader);
                    end;
                }
                action("Order Confirmation")
                {
                    Caption = 'Order Confirmation';
                    Ellipsis = true;
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesOrder(Rec,Usage::"Order Confirmation");
                    end;
                }
                action("Work Order")
                {
                    Caption = 'Work Order';
                    Ellipsis = true;
                    Image = Print;
                    Visible = false;

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesOrder(Rec,Usage::"Work Order");
                    end;
                }
                action(Print)
                {
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesLine: Record "37";
                        DocMgt: Codeunit "25006000";
                        DocReport: Record "25006011";
                    begin
                        SalesLine.RESET;
                        DocMgt.PrintCurrentDoc("Document Profile", 1, 1, DocReport);
                        DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine,FALSE);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Sales Reservation Avail.")
            {
                Caption = 'Sales Reservation Avail.';
                Image = Reserve;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 209;
            }
            action(SendMail)
            {
                Image = update;
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;

                trigger OnAction()
                var
                    PostMail: Report "25006109";
                begin
                    //PostMail.SendEmail('1123','C000001');
                    SMSSet.SendSMSTest;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        //SN := SN + 1;
        ModelCode := '';
        ModelVersionCode := '';
        VINCode := '';
        DRP := '';
        SalesLine.SETRANGE("Document No.","No.");
        SalesLine.SETFILTER(VIN,'<>%1','');
        IF SalesLine.FINDFIRST THEN BEGIN
          ModelCode := SalesLine."Model Code";
          ModelVersionCode := SalesLine."Model Version No.";
          SalesLine.CALCFIELDS(VIN);
          VINCode := SalesLine.VIN;
          Vehicle.RESET;
          Vehicle.SETRANGE(VIN,VINCode);
          IF Vehicle.FINDFIRST THEN
            DRP := Vehicle."DRP No./ARE1 No.";
        END;
    end;

    trigger OnOpenPage()
    begin
        //EDMS>>
        FILTERGROUP(3);
        SETRANGE("Document Profile","Document Profile"::"Vehicles Trade");
        //EDMS<<
        FilterOnRecord;
    end;

    var
        DocPrint: Codeunit "229";
        ReportPrint: Codeunit "228";
        Usage: Option "Order Confirmation","Work Order";
        Text001: Label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: Label 'There are unpaid Prepayment Invoices related to %1 %2.';
        ApprovalEntries: Page "658";
                             SalesPlanForm: Page "99000883";
                             Contact: Record "5050";
                             PipelineHistory1: Record "33020198";
                             PipelineHistory2: Record "33020198";
                             ModelCode: Code[20];
                             ModelVersionCode: Code[20];
                             SalesLine: Record "37";
                             VINCode: Code[20];
                             SalesPerson: Text[50];
                             UserMgt: Codeunit "5700";
                             UserSetup: Record "91";
                             DRP: Code[20];
                             Vehicle: Record "25006005";
                             SalesHeader: Record "36";
                             CountRec: Integer;
                             SN: Integer;
                             SMSSet: Codeunit "50002";

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
        SkipFilter: Boolean;
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        IF ("Document Profile" = "Document Profile"::"Vehicles Trade") THEN
            IF NOT UserSetup."Allow View all Veh. Invoice" THEN BEGIN
                RespCenterFilter := UserMgt.GetSalesFilter();
                IF RespCenterFilter <> '' THEN BEGIN
                    FILTERGROUP(2);
                    IF UserMgt.DefaultResponsibility THEN
                        SETRANGE("Responsibility Center", RespCenterFilter)
                    ELSE
                        SETRANGE("Accountability Center", RespCenterFilter);
                    FILTERGROUP(0);
                END;
            END;
    end;
}

