page 25006185 "Service Orders EDMS"
{
    // 22.10.2015 NAV2016 Merge
    //   Approvals removed
    // 
    // 2014.09.15 EDMS P7
    //   * tcp error fix. Schedule page run moved from code to properties
    // 
    // 2012.05.08 EDMS P8
    //   * Added column Resources

    Caption = 'Service Orders';
    CardPageID = "Service Order EDMS";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Print';
    SourceTable = Table25006145;
    SourceTableView = WHERE(Document Type=CONST(Order),
                            Job Closed=CONST(No));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Order Date"; "Order Date")
                {
                }
                field("Booked By"; "Booked By")
                {
                }
                field("Arrival Date"; "Arrival Date")
                {
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                }
                field("Service Person"; "Service Person")
                {
                }
                field("No."; "No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Job Type"; "Job Type")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
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
                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Job Finished Date"; "Job Finished Date")
                {
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                    Visible = false;
                }
                field("Campaign No."; "Campaign No.")
                {
                    Visible = false;
                }
                field(Status; Status)
                {
                    Visible = false;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Visible = false;
                }
                field("Due Date"; "Due Date")
                {
                    Visible = false;
                }
                field("Payment Discount %"; "Payment Discount %")
                {
                    Visible = false;
                }
                field("Job Description"; "Job Description")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
                field(Resources; Resources)
                {
                    Caption = 'Resources';
                    Editable = false;
                }
                field(DateTimeMgt.Datetime2Date("Schedule Start Date Time");
                    DateTimeMgt.Datetime2Date("Schedule Start Date Time"))
                {
                    Caption = 'Schedule Start Date';
                    Editable = false;
                    Visible = false;
                }
                field(DateTimeMgt.Datetime2Time("Schedule Start Date Time");
                    DateTimeMgt.Datetime2Time("Schedule Start Date Time"))
                {
                    Caption = 'Schedule Start Time';
                    Editable = false;
                    Visible = false;
                }
                field(DateTimeMgt.Datetime2Date("Schedule End Date Time");
                    DateTimeMgt.Datetime2Date("Schedule End Date Time"))
                {
                    Caption = 'Schedule End Date';
                    Editable = false;
                    Visible = false;
                }
                field(DateTimeMgt.Datetime2Time("Schedule End Date Time");
                    DateTimeMgt.Datetime2Time("Schedule End Date Time"))
                {
                    Caption = 'Schedule End Time';
                    Editable = false;
                    Visible = false;
                }
                field(Remarks; Remarks)
                {
                }
                field("Mobile No. for SMS"; "Mobile No. for SMS")
                {
                }
            }
        }
        area(factboxes)
        {
            part(; 25006253)
            {
                SubPageLink = Document Type=FIELD(Document Type),
                              No.=FIELD(No.);
                Visible = true;
            }
            part(;25006074)
            {
                SubPageLink = No.=FIELD(Bill-to Customer No.);
                Visible = true;
            }
            part("Vehicle Pictures";25006047)
            {
                Caption = 'Vehicle Pictures';
                SubPageLink = Source Type=CONST(25006005),
                              Source Subtype=CONST(0),
                              Source ID=FIELD(Vehicle Serial No.),
                              Source Ref. No.=CONST(0);
                SubPageView = SORTING(Source Type,Source Subtype,Source ID,Source Ref. No.,No.);
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
                action("<Action1102601006>")
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ShortCutKey = 'F7';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //CalcInvDiscForHeader;
                        COMMIT;
                        PAGE.RUNMODAL(PAGE::"Service Order Statistics EDMS",Rec);
                    end;
                }
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
                action("<Action62>")
                {
                    Caption = 'Customer Card';
                    Image = EditLines;
                    RunObject = Page 21;
                                    RunPageLink = No.=FIELD(Sell-to Customer No.);
                    ShortCutKey = 'Shift+F7';
                }
                action("<Action1101904005>")
                {
                    Caption = 'V&ehicle Card';
                    Image = EditLines;
                    RunObject = Page 25006033;
                                    RunPageLink = Serial No.=FIELD(Vehicle Serial No.);
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=FIELD(Document Type),
                                  No.=FIELD(No.);
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SAVERECORD;
                    end;
                }
                action("A&pprovals")
                {
                    Caption = 'A&pprovals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Service Header EDMS","Document Type","No.");
                        ApprovalEntries.RUN;
                    end;
                }
            }
            group(Transfers)
            {
                Caption = 'Transfers';
                action("<Action1101904028>")
                {
                    Caption = 'Transfer Orders';
                    Image = Documents;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupOrdTransf(Rec)
                    end;
                }
                action("<Action1101904029>")
                {
                    Caption = 'Transfer Shipments';
                    Image = PostedReceipts;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupTransferShipment(Rec)
                    end;
                }
                action("<Action1101904030>")
                {
                    Caption = 'Transfer Receipts';
                    Image = PostedReceipts;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupTransferReceipt(Rec)
                    end;
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                action("<Action1102601011>")
                {
                    Caption = 'Prepa&yment Invoices';
                    Image = PrepaymentInvoice;
                    RunObject = Page 143;
                                    RunPageLink = Prepayment Order No.=FIELD(No.);
                    RunPageView = SORTING(Prepayment Order No.);
                    Visible = false;
                }
                action("<Action1102601012>")
                {
                    Caption = 'Prepayment Credi&t Memos';
                    Image = PrepaymentCreditMemo;
                    RunObject = Page 144;
                                    RunPageLink = Prepayment Order No.=FIELD(No.);
                    RunPageView = SORTING(Prepayment Order No.);
                    Visible = false;
                }
            }
            group(Schedule)
            {
                Caption = 'Schedule';
                action("Schedule Allocation Entries")
                {
                    Caption = 'Schedule Allocation Entries';
                    Image = EntriesList;

                    trigger OnAction()
                    var
                        ServLaborAllocation: Record "25006271";
                        ScheduleMgt: Codeunit "25006201";
                    begin
                        ServLaborAllocation.RESET;
                        ScheduleMgt.FindServAllocationEntries(ServLaborAllocation, "Document Type", "No.");
                        PAGE.RUNMODAL(PAGE::"Serv. Labor Allocation Entries", ServLaborAllocation);
                    end;
                }
                action("Schedule Application Entries")
                {
                    Caption = 'Schedule Application Entries';
                    Image = EntriesList;

                    trigger OnAction()
                    var
                        ServLaborAllocAplication: Record "25006277";
                        ScheduleMgt: Codeunit "25006201";
                    begin
                        ServLaborAllocAplication.RESET;
                        ScheduleMgt.FindServAllocAplicationEntries(ServLaborAllocAplication, "Document Type", "No.");
                        PAGE.RUNMODAL(PAGE::"Serv. Labor Alloc. Application", ServLaborAllocAplication);
                    end;
                }
            }
            group(Vehicle)
            {
                Caption = 'Vehicle';
                action(Pictures)
                {
                    Caption = 'Pictures';
                    Image = Picture;
                    RunObject = Page 25006059;
                                    RunPageLink = Source Type=CONST(25006005),
                                  Source Subtype=CONST(0),
                                  Source ID=FIELD(Vehicle Serial No.),
                                  Source Ref. No.=CONST(0);
                    RunPageMode = View;
                }
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseServiceDoc: Codeunit "25006119";
                    begin
                        ReleaseServiceDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseServiceDoc: Codeunit "25006119";
                    begin
                        ReleaseServiceDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("<Action1101904007>")
                {
                    Caption = 'Item Order Overview';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    var
                        ItemOrderOverview: Page "25006805";
                    begin
                        ItemOrderOverview.SetSourceType2(2); //Service
                        ItemOrderOverview.SetDocumentFilter("No.");
                        ItemOrderOverview.SetFilters;
                        ItemOrderOverview.FindRec;
                        ItemOrderOverview.RUN;
                    end;
                }
                action("Send SMS")
                {
                    Caption = 'Send SMS';
                    Image = SendTo;

                    trigger OnAction()
                    var
                        SendSMS: Page "25006404";
                                     UserSetup: Record "91";
                                     SalespersonCode: Code[10];
                    begin
                        UserSetup.GET(USERID);
                        IF UserSetup."Salespers./Purch. Code" <> '' THEN
                          SalespersonCode := UserSetup."Salespers./Purch. Code"
                        ELSE
                          SalespersonCode := Rec."Service Person";

                        SendSMS.SetDocumentNo(Rec."No.");
                        SendSMS.SetDocumentType(2);
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.RUN;
                    end;
                }
            }
            group(Plan)
            {
                Caption = 'Plan';
                action("<Action1101904031>")
                {
                    Caption = 'Schedule';
                    Image = Planning;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006358;

    trigger OnAction()
    var
        ServiceSchedule: Page "25006358";
    begin
        //ServiceSchedule.SetServiceHeader(Rec);
        //ServiceSchedule.RUN;
    end;
                }
                action("Order &Promising")
                {
                    Caption = 'Order &Promising';
                    Image = OrderPromising;
                    Visible = false;

                    trigger OnAction()
                    var
                        OrderPromisingLine: Record "99000880" temporary;
                    begin
                        OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::Job);
                        OrderPromisingLine.SETRANGE("Source ID","No.");
                        PAGE.RUNMODAL(PAGE::"Order Promising Lines",OrderPromisingLine);
                    end;
                }
            }
            group(Request)
            {
                Caption = 'Request';
                action("<Action1102601046>")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN;
                    end;
                }
                action("<Action1102601047>")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin
                        //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN BEGIN
                        //  IF ApprovalMgt.TestServPrepayment(Rec) THEN
                        //    ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //  ELSE BEGIN
                        //    IF ApprovalMgt.TestServPayment(Rec) THEN
                        //      ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //    ELSE
                              CODEUNIT.RUN(CODEUNIT::"Service-Post (Yes/No) EDMS",Rec);
                        //  END;
                        //END;
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

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin
                        //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN BEGIN
                        //  IF ApprovalMgt.TestServPrepayment(Rec) THEN
                        //    ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //  ELSE BEGIN
                        //    IF ApprovalMgt.TestServPayment(Rec) THEN
                        //      ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //    ELSE
                              CODEUNIT.RUN(CODEUNIT::"Service-Post+Print EDMS",Rec);
                        //  END;
                        //END;
                    end;
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                action(Print)
                {
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServLine: Record "25006146";
                        DocMgt: Codeunit "25006000";
                        DocReport: Record "25006011";
                    begin
                        ServLine.RESET;
                        DocMgt.PrintCurrentDoc(3, 3, 1, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine,FALSE);
                    end;
                }
                action(GatePass)
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        StplMgt.CreateGatePass(4,5,"No.","Bill-to Name","Bill-to Name");
                    end;
                }
            }
        }
        area(reporting)
        {
        }
    }

    trigger OnAfterGetRecord()
    begin
        Resources := ServiceScheduleMgt.GetRelatedResources("Document Type", "No.", ServiceLine.Type::Labor, 0, 0);
        IsVFRun1Visible := IsVFActive(FIELDNO(Kilometrage));
        // IsVFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2"));
        // IsVFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));
        IsVisibleFactBox1 := ((NOT IsVFRun1Visible) AND (NOT IsVFRun2Visible) AND (NOT IsVFRun3Visible));
        IsVisibleFactBox2 := ((IsVFRun1Visible) AND (NOT IsVFRun2Visible) AND (NOT IsVFRun3Visible));
        CALCFIELDS("Schedule Start Date Time", "Schedule End Date Time");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CLEAR(Resources);
    end;

    trigger OnOpenPage()
    begin
        /*
        IF UserMgt.GetServiceFilterEDMS <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetServiceFilterEDMS);
          FILTERGROUP(0);
        END;
        *///Agni UPG 2009
        
        FilterOnRecord;

    end;

    var
        Text001: Label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: Label 'There are unpaid Prepayment Invoices related to %1 %2.';
        ServInfoPaneMgt: Codeunit "25006104";
        ServiceScheduleMgt: Codeunit "25006201";
        ServiceLine: Record "25006146";
        ApprovalEntries: Page "658";
    [InDataSet]

    Resources: Text[250];
        UserMgt: Codeunit "5700";
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        [InDataSet]
        IsVisibleFactBox1: Boolean;
        [InDataSet]
        IsVisibleFactBox2: Boolean;
        DateTimeMgt: Codeunit "25006012";
        CountRec: Integer;
        StplMgt: Codeunit "50000";

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetServiceFilterEDMS();
        IF RespCenterFilter <> '' THEN BEGIN
          FILTERGROUP(2);
           IF UserMgt.DefaultResponsibility THEN
              SETRANGE("Responsibility Center",RespCenterFilter)
          ELSE
              SETRANGE("Accountability Center",RespCenterFilter);
          FILTERGROUP(0);
        END;
    end;
}

