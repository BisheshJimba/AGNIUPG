page 25006254 "Service Quotes EDMS"
{
    // 22.10.2015 NAV2016 Merge
    //   Approvals removed
    // 
    // 24.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Action "Schedule" set VISIBLE=FALSE
    // 
    // 22.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * "Deal Type" field added
    // 
    // 20.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Added LVI captions

    Caption = 'Service Quotes';
    CardPageID = "Service Quote EDMS";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Print';
    SourceTable = Table25006145;
    SourceTableView = WHERE(Document Type=CONST(Quote));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field("Deal Type"; "Deal Type")
                {
                    Visible = false;
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
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
                field("External Document No."; "External Document No.")
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
                field("Service Person"; "Service Person")
                {
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                }
                field("Document Date"; "Document Date")
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
            part(;9084)
            {
                SubPageLink = No.=FIELD(Sell-to Customer No.);
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
            group("&Quote")
            {
                Caption = '&Quote';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        //CalcInvDiscForHeader;
                        COMMIT;
                        PAGE.RUNMODAL(PAGE::"Service Order Statistics EDMS",Rec);
                    end;
                }
                action("Customer Card")
                {
                    Caption = 'Customer Card';
                    Image = EditLines;
                    RunObject = Page 21;
                                    RunPageLink = No.=FIELD(Sell-to Customer No.);
                    ShortCutKey = 'Shift+F7';
                }
                action("C&ontact Card")
                {
                    Caption = 'C&ontact Card';
                    Image = EditLines;
                    RunObject = Page 5052;
                                    RunPageLink = No.=FIELD(Sell-to Contact No.);
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
                                    RunPageLink = Type=FILTER(Service Quote),
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
                action("<Action1102601033>")
                {
                    Caption = 'Approvals';
                    Image = Approvals;
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
                        SendSMS.SetDocumentType(1);
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.RUN;
                    end;
                }
                action("<Action1000000000>")
                {
                    Caption = 'Count Records';
                    Image = CalculatePlan;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        MESSAGE('No. of records are %1 ',COUNT);
                    end;
                }
            }
            group(Schedule)
            {
                Caption = 'Schedule';
                action("<Action1101904014>")
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
                action("<Action1101904015>")
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
            group(Print)
            {
                Caption = 'Print';
                action("&Print")
                {
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        //DocPrint.PrintSalesHeader(Rec);
                        CurrPage.SETSELECTIONFILTER(ServHeaders);
                        REPORT.RUNMODAL(33020245,TRUE,FALSE,ServHeaders);
                    end;
                }
            }
            group(Create)
            {
                Caption = 'Create';
                action("Make &Order")
                {
                    Caption = 'Make &Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin
                        //IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN
                          CODEUNIT.RUN(CODEUNIT::"Serv-Quote to Order (Y/N) EDMS",Rec);
                    end;
                }
            }
            group(Plan)
            {
                Caption = 'Plan';
                action("<Action1101904031>")
                {
                    Caption = 'Schedule';
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "25006358";
                    begin
                        ServiceSchedule.SetServiceHeader(Rec);
                        ServiceSchedule.RUN;
                    end;
                }
            }
            group(Request)
            {
                Caption = 'Request';
                action("<Action1102601017>")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN;
                    end;
                }
                action("<Action1102601018>")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CALCFIELDS("Schedule Start Date Time", "Schedule End Date Time");
    end;

    trigger OnOpenPage()
    begin
        /*
        IF UserMgt.GetServiceFilterEDMS <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetServiceFilterEDMS);
          FILTERGROUP(0);
        END;
        */
        FilterOnRecord;

    end;

    var
        DocPrint: Codeunit "229";
        UserMgt: Codeunit "5700";
        DateTimeMgt: Codeunit "25006012";
        ServHeaders: Record "25006145";
        UserSetup: Record "91";

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

