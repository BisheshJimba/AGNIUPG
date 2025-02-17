page 25006195 "Posted Service Order EDMS"
{
    // 18.01.2017 EB.P7 Upgrade 2017
    //   Removed functionality from "Credit Cards Transaction Lo&g Entries" action
    //   because of standard page removed.
    // 
    // 23.02.2015 EDMS P21
    //   Added field:
    //     "Model Version No."
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3

    Caption = 'Posted Service Order';
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports';
    RefreshOnActivate = true;
    SourceTable = Table25006149;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Sell-to Contact No."; "Sell-to Contact No.")
                {
                    Editable = false;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    Editable = false;
                }
                field("Sell-to Address"; "Sell-to Address")
                {
                    Editable = false;
                }
                field("Sell-to Address 2"; "Sell-to Address 2")
                {
                    Editable = false;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    Editable = false;
                }
                field("Sell-to City"; "Sell-to City")
                {
                    Editable = false;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    Editable = false;
                }
                field("Phone No."; "Phone No.")
                {
                    Editable = false;
                    Importance = Additional;
                }
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Document Date"; "Document Date")
                {
                    Editable = false;
                }
                field("Order No."; "Order No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("External Document No."; "External Document No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Importance = Additional;
                }
                field(VIN; VIN)
                {
                }
                field(Vehicle."Variable Field 25006803";
                    Vehicle."Variable Field 25006803")
                {
                    Caption = 'Engine No.';
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Scheme Code"; "Scheme Code")
                {
                }
                field("Membership No."; "Membership No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field(Kilometrage; Kilometrage)
                {
                    Visible = true;
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Service Advisor"; "Service Advisor")
                {
                }
                field("Driver Name"; "Driver Name")
                {
                }
                field("Driver Contact No."; "Driver Contact No.")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    Editable = false;
                }
                field("CSI Exists"; "CSI Exists")
                {
                }
                field("Activity Detail"; "Activity Detail")
                {
                }
                field("Job Type"; "Job Type")
                {
                }
                field("Service Type"; "Service Type")
                {
                }
                field("Job Category"; "Job Category")
                {
                }
                field("Approx. Estimation"; "Approx. Estimation")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
                field("Actual Delivery Time"; "Actual Delivery Time")
                {
                }
                field("Arrival Date"; "Arrival Date")
                {
                }
                field("Arrival Time"; "Arrival Time")
                {
                }
                field("Next Service Date"; "Next Service Date")
                {
                }
                field("Job Description"; "Job Description")
                {
                }
                field("Job Finished Date"; "Job Finished Date")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("No. Printed"; "No. Printed")
                {
                    Editable = false;
                }
                field("Insurance Type"; "Insurance Type")
                {
                    Editable = false;
                }
                field("Insurance Company Name"; "Insurance Company Name")
                {
                    Editable = false;
                }
                field("Insurance Policy Number"; "Insurance Policy Number")
                {
                    Editable = false;
                }
            }
            part(ServiceLines; 25006196)
            {
                SubPageLink = Document No.=FIELD(No.);
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Bill-to Contact No."; "Bill-to Contact No.")
                {
                    Editable = false;
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                    Editable = false;
                }
                field("Bill-to Address"; "Bill-to Address")
                {
                    Editable = false;
                }
                field("Bill-to Address 2"; "Bill-to Address 2")
                {
                    Editable = false;
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    Editable = false;
                }
                field("Bill-to City"; "Bill-to City")
                {
                    Editable = false;
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Editable = false;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Due Date"; "Due Date")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    Editable = false;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; "Currency Code")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date");
                        ChangeExchangeRate.EDITABLE(FALSE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            "Currency Factor" := ChangeExchangeRate.GetParameter;
                            MODIFY;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("EU 3-Party Trade"; "EU 3-Party Trade")
                {
                    Editable = false;
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field(Resources; Resources)
                {
                }
            }
            group(Advanced)
            {
                Caption = 'Advanced';
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                    Visible = IsVFRun2Visible;
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                    Visible = IsVFRun3Visible;
                }
            }
            group("Service Address")
            {
                Caption = 'Service Address';
                field("Service Address Code"; "Service Address Code")
                {
                }
                field("Service Address"; "Service Address")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action55>")
            {
                Caption = '&Order';
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
                            SalespersonCode := Rec."Service Advisor";

                        SendSMS.SetDocumentNo(Rec."No.");
                        SendSMS.SetDocumentType(2);
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.RUN;
                    end;
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006239;
                    RunPageLink = No.=FIELD(No.);
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=CONST(Posted Service Order),
                                  No.=FIELD(No.);
                }
                action("<Action112>")
                {
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        PostedApprovalEntries.Setfilters(DATABASE::"Sales Invoice Header","No.");
                        PostedApprovalEntries.RUN;
                    end;
                }
                action("Credit Cards Transaction Lo&g Entries")
                {
                    Caption = 'Credit Cards Transaction Lo&g Entries';
                    Image = Translations;
                }
                action("<Action1101904014>")
                {
                    Caption = 'Schedule Allocation Entries';
                    Image = CalendarMachine;

                    trigger OnAction()
                    var
                        ServLaborAllocation: Record "25006271";
                        ScheduleMgt: Codeunit "25006201";
                    begin
                        ServLaborAllocation.RESET;
                        ScheduleMgt.FindServAllocationEntries(ServLaborAllocation, ServLaborAllocation."Source Subtype"::Order, "No.");
                        PAGE.RUNMODAL(PAGE::"Serv. Labor Allocation Entries", ServLaborAllocation);
                    end;
                }
                action("<Action1101904015>")
                {
                    Caption = 'Schedule Application Entries';
                    Image = Resource;

                    trigger OnAction()
                    var
                        ServLaborAllocAplication: Record "25006277";
                        ScheduleMgt: Codeunit "25006201";
                    begin
                        ServLaborAllocAplication.RESET;
                        ScheduleMgt.FindServAllocAplicationEntries(ServLaborAllocAplication, ServLaborAllocAplication."Document Type"::Order, "No.");
                        PAGE.RUNMODAL(PAGE::"Serv. Labor Alloc. Application", ServLaborAllocAplication);
                    end;
                }
                action("Warranty Documents")
                {
                    Caption = 'Warranty Documents';
                    Image = Documents;
                    RunObject = Page 25006406;
                                    RunPageLink = Service Order No.=FIELD(No.);
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ServHeaders: Record "25006149";
                    DocMgt: Codeunit "25006000";
                    DocReport: Record "25006011";
                begin
                    //CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    //SalesInvHeader.PrintRecords(TRUE);
                    /*
                    DocMgt.PrintCurrentDoc(3, 3, 8, DocReport);
                    DocMgt.SelectPostServDocReport(DocReport,Rec)
                    *///Agni UPG 2009
                    CurrPage.SETSELECTIONFILTER(ServHeaders);
                    REPORT.RUNMODAL(33020247,TRUE,FALSE,ServHeaders);

                end;
            }
            action("Satisfaction Feedback Form")
            {
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ServiceFeedback.SETRANGE("Service Order No.","No.");
                    IF NOT ServiceFeedback.FINDFIRST THEN BEGIN
                      FeedbackQuestion.RESET;
                      IF FeedbackQuestion.FINDFIRST THEN BEGIN
                        REPEAT
                          ServiceFeedback.INIT;
                          ServiceFeedback."Service Order No." := "No.";
                          ServiceFeedback."Question No." := FeedbackQuestion.Code;
                          ServiceFeedback.Question := FeedbackQuestion.Question;
                          ServiceFeedback."Order No." := "Order No.";
                          ServiceFeedback.INSERT;
                        UNTIL FeedbackQuestion.NEXT = 0;
                      END;
                    END;
                    PAGE.RUN(33020243,ServiceFeedback);
                end;
            }
            action("<Action59>")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
            action("Create Warranty Document")
            {
                Caption = 'Create Warranty Document';
                Image = CreateDocument;

                trigger OnAction()
                var
                    WarrantyManagement: Codeunit "25006404";
                begin
                    WarrantyManagement.CreateWarrantyDocument(Rec);
                end;
            }
            action("Consumption Checklist")
            {
                Caption = 'Consumption Checklist';
                Image = Description;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020580;
                                RunPageLink = Job Card No.=FIELD(Order No.);
            }
            action("Print Consumption")
            {
                Caption = 'Print Consumption';
                Image = PrintAcknowledgement;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Consumption: Record "33020528";
                begin
                    Consumption.RESET;
                    Consumption.SETRANGE("Job Card No.","Order No.");
                    REPORT.RUNMODAL(33020206,TRUE,FALSE,Consumption);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Vehicle.RESET;
        Vehicle.SETRANGE("Serial No.","Vehicle Serial No.");
        IF Vehicle.FINDFIRST THEN;
    end;

    trigger OnInit()
    begin
        IsVFRun1Visible := IsVFActive(FIELDNO(Kilometrage));
        IsVFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2"));
        IsVFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));
    end;

    trigger OnOpenPage()
    begin
        FilterOnRecord;
    end;

    var
        SalesInvHeader: Record "112";
        PostedApprovalEntries: Page "659";
                                   ChangeExchangeRate: Page "511";
    [InDataSet]

    IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        ServiceFeedback: Record "33020243";
        FeedbackQuestion: Record "33020244";
        CustCompHdr: Record "33019847";
        Vehicle: Record "25006005";

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

