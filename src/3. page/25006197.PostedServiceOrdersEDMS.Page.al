page 25006197 "Posted Service Orders EDMS"
{
    // 13.05.2014 Elva Baltic P21 #S0100 MMG7.00
    //   Modified triggers:
    //     OnAfterGetRecord
    //     <Action32> - OnAction()
    //   Modified function:
    //     GetSatisfaction
    // 
    // 14.04.2014 Elva Baltic P18 #RX029 MMG7.00
    //   Modified Procedure
    //     CommentsExist()
    // 
    // 27.03.2014 Elva Baltic P18 #RX029 MMG7.00
    //   Added field "Phone No."
    //   Added function & field
    //     GetSatisfaction()
    //     CommentsExist()

    Caption = 'Posted Service Orders';
    CardPageID = "Posted Service Order EDMS";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,History';
    SourceTable = Table25006149;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Order Date"; "Order Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("No."; "No.")
                {
                }
                field("Order No."; "Order No.")
                {
                }
                field(PurchInvHeader."Vendor Invoice No.";
                    PurchInvHeader."Vendor Invoice No.")
                {
                    Caption = 'Telco Invoice No.';
                    Visible = false;
                }
                field(PurchInvHeader."Document Date";
                    PurchInvHeader."Document Date")
                {
                    Caption = 'Telco Invoice Date';
                    Visible = false;
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field(Vehicle."Variable Field 25006803";
                    Vehicle."Variable Field 25006803")
                {
                    Caption = 'Engine No.';
                }
                field("Job Type"; "Job Type")
                {
                }
                field("Service Type"; "Service Type")
                {
                }
                field("<VIN>"; VIN)
                {
                }
                field(GetResourceNo("No."); GetResourceNo("No."))
                {
                    Caption = 'Resource Used';
                    TableRelation = Resource;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Next Service Date"; "Next Service Date")
                {
                }
                field(Amount; Amount)
                {

                    trigger OnDrillDown()
                    begin
                        SETRANGE("No.");
                        PAGE.RUNMODAL(PAGE::"Posted Sales Invoice", Rec)
                    end;
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {

                    trigger OnDrillDown()
                    begin
                        SETRANGE("No.");
                        PAGE.RUNMODAL(PAGE::"Posted Sales Invoice", Rec)
                    end;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    Visible = false;
                }
                field(Kilometrage; Kilometrage)
                {
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
                field("CSI Exists"; "CSI Exists")
                {
                }
                field("Service Advisor"; "Service Advisor")
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
                field("No. Printed"; "No. Printed")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Visible = false;
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
                field("Approx. Estimation"; "Approx. Estimation")
                {
                }
                field("Arrival Date"; "Arrival Date")
                {
                }
                field("Arrival Time"; "Arrival Time")
                {
                }
                field("Actual Delivery Time"; "Actual Delivery Time")
                {
                }
                field("Is Invoiced"; "Is Invoiced")
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                }
                field("Due Date"; "Due Date")
                {
                    Visible = false;
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Comments; Comments)
                {
                    Caption = 'Comments';
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
            group("<Action19>")
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
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.RUN(PAGE::"Posted Service Order EDMS", Rec)
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
                                    RunPageLink = No.=FIELD(Order No.);

                    trigger OnAction()
                    begin
                        // 13.05.2014 Elva Baltic P21 #S0100 MMG7.00 >>
                        /*
                        ServiceCommentLine.RESET;
                        ServiceCommentLine.SETRANGE(Type, ServiceCommentLine.Type::"Posted Service Order");
                        ServiceCommentLine.SETRANGE("No.", "No.");
                        IF ServiceCommentLine.FINDFIRST THEN;
                        IF PAGE.RUNMODAL(PAGE::"Service Comment Sheet EDMS", ServiceCommentLine) = ACTION::LookupOK THEN BEGIN
                          Comments := CommentsExist;
                        END;
                        *///Agni 2009 UPG Properties updated
                        
                        // 13.05.2014 Elva Baltic P21 #S0100 MMG7.00 <<

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
                Visible = false;

                trigger OnAction()
                var
                    DocMgt: Codeunit "25006000";
                    DocReport: Record "25006011";
                begin
                    //CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    //SalesInvHeader.PrintRecords(TRUE);
                    /*
                    DocMgt.PrintCurrentDoc(3, 3, 8, DocReport);
                    DocMgt.SelectPostServDocReport(DocReport,Rec)
                    *///Agni UPG 2009
                    
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    SalesInvHeader.PrintRecords(TRUE);

                end;
            }
            action("&Navigate")
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
                          ServiceFeedback.INSERT(TRUE);
                        UNTIL FeedbackQuestion.NEXT = 0;
                      END;
                    END;
                    PAGE.RUN(33020243,ServiceFeedback);
                end;
            }
            action("<Action1102159019>")
            {
                Caption = '&Job Order';
                Description = 'ServiceAgreement';
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    ServHeaders: Record "25006149";
                begin
                    CurrPage.SETSELECTIONFILTER(ServHeaders);
                    REPORT.RUNMODAL(33020247,TRUE,FALSE,ServHeaders);
                end;
            }
            action("<Action1102159012>")
            {
                Caption = '&Item Issue';
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = false;

                trigger OnAction()
                var
                    ServHeaders: Record "25006149";
                begin
                    CurrPage.SETSELECTIONFILTER(ServHeaders);
                    REPORT.RUNMODAL(33020248,TRUE,FALSE,ServHeaders);
                end;
            }
            action("&Work Order")
            {
                Caption = '&Work Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = false;
                RunObject = Page 33020249;
                                RunPageLink = Service Order No.=FIELD(Order No.);
                RunPageMode = View;
                RunPageView = SORTING(Service Order No.,Line No.);

                trigger OnAction()
                begin
                    //33020249
                end;
            }
            action("<Action1102159022>")
            {
                Caption = 'Vehicle History';
                Image = History;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Vehicle: Record "25006005";
                begin
                    Vehicle.RESET;
                    Vehicle.SETRANGE("Serial No.","Vehicle Serial No.");
                    IF Vehicle.FINDFIRST THEN
                      REPORT.RUNMODAL(33020241,TRUE,FALSE,Vehicle);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Comments := CommentsExist;                                // 13.05.2014 Elva Baltic P21 #S0100 MMG7.00

        TelcoInvNo := '';
        TelcoInvDate := 0D;

        PurchInvLine.RESET;
        PurchInvLine.SETCURRENTKEY(Type,"Line Type","Vehicle Serial No.");
        PurchInvLine.SETRANGE(Type,PurchInvLine.Type::Item);
        PurchInvLine.SETRANGE("Line Type",PurchInvLine."Line Type"::Vehicle);
        PurchInvLine.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");
        IF PurchInvLine.FINDFIRST THEN BEGIN
          PurchInvHeader.RESET;
          PurchInvHeader.SETRANGE("No.",PurchInvLine."Document No.");
          IF PurchInvHeader.FINDFIRST THEN BEGIN
            TelcoInvNo := PurchInvHeader."Vendor Invoice No.";
            TelcoInvDate := PurchInvHeader."Document Date";
          END;
        END;

        Vehicle.RESET;
        Vehicle.SETRANGE("Serial No.","Vehicle Serial No.");
        IF Vehicle.FINDFIRST THEN;
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
        SalesInvHeader: Record "112";
        Comments: Boolean;
        ServiceCommentLine: Record "25006148";
        UserMgt: Codeunit "5700";
        ServiceFeedback: Record "33020243";
        FeedbackQuestion: Record "33020244";
        PostedServLine: Record "25006150";
        Vehicle: Record "25006005";
        PurchInvLine: Record "123";
        PurchInvHeader: Record "122";
        TelcoInvNo: Code[50];
        TelcoInvDate: Date;
        CustCompHdr: Record "33019847";

    [Scope('Internal')]
    procedure CommentsExist(): Boolean
    var
        ServiceComment: Record "25006148";
    begin
        ServiceComment.RESET;
        ServiceComment.SETRANGE(Type,ServiceComment.Type::"Posted Service Order");
        ServiceComment.SETRANGE("No.","No.");
        IF ServiceComment.FINDFIRST THEN
          EXIT(TRUE);

        EXIT(FALSE); // 14.04.2014 Elva Baltic P18 #RX029 MMG7.00
    end;

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

