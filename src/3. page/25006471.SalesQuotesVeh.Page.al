page 25006471 "Sales Quotes (Veh.)"
{
    // 22.10.2015 NAV2016 Merge
    //   Approvals removed

    Caption = 'Sales Quotes';
    CardPageID = "Sales Quote";
    Editable = false;
    PageType = List;
    SourceTable = Table36;
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
                field(SalesPersonName; SalesPersonName)
                {
                    Caption = 'Sales Person';
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    Visible = false;
                }
                field("Assigned User ID"; "Assigned User ID")
                {
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
                field(ModelCode; ModelCode)
                {
                    Caption = 'Model Code';
                }
                field(ModelVersionCode; ModelVersionCode)
                {
                    Caption = 'Model Version No.';
                }
                field(VINCode; VINCode)
                {
                    Caption = 'VIN';
                }
                field("Opportunity No."; "Opportunity No.")
                {
                    Visible = false;
                }
                field(Status; Status)
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(; 9082)
            {
                SubPageLink = No.=FIELD(Bill-to Customer No.);
                    Visible = true;
            }
            part(; 9084)
            {
                SubPageLink = No.=FIELD(Sell-to Customer No.);
                    Visible = true;
            }
            systempart(; Links)
            {
                Visible = false;
            }
            systempart("`"; Notes)
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
                        CalcInvDiscForHeader;
                        COMMIT;
                        PAGE.RUNMODAL(PAGE::"Sales Statistics", Rec);
                    end;
                }
                action("Customer Card")
                {
                    Caption = 'Customer Card';
                    Image = Customer;
                    RunObject = Page 21;
                    RunPageLink = No.=FIELD(Sell-to Customer No.);
                    ShortCutKey = 'Shift+F7';
                }
                action("C&ontact Card")
                {
                    Caption = 'C&ontact Card';
                    Image = CustomerContact;
                    RunObject = Page 5052;
                                    RunPageLink = No.=FIELD(Sell-to Contact No.);
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
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Sales Header","Document Type","No.");
                        ApprovalEntries.RUN;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("C&reate Customer")
                {
                    Caption = 'C&reate Customer';
                    Image = Customer;

                    trigger OnAction()
                    begin
                        IF CheckCustomerCreated(FALSE) THEN
                          CurrPage.UPDATE(TRUE);
                    end;
                }
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    begin
                        // IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN;
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        // IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN;
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

                        // CNY.CRM >>
                        IF ("Sell-to Contact No." <> '') AND ("Document Profile" = "Document Profile" :: "Vehicles Trade") THEN
                          TESTFIELD("Prospect Line No.");
                        // CNY.CRM <<
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
                action("Create &To-do")
                {
                    Caption = 'Create &To-do';
                    Image = Task;

                    trigger OnAction()
                    begin
                        CreateTodo;
                    end;
                }
            }
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

                    // CNY.CRM >>
                    IF ("Sell-to Contact No." <> '') AND ("Document Profile" = "Document Profile" :: "Vehicles Trade") THEN
                      TESTFIELD("Prospect Line No.");
                    // CNY.CRM <<

                    // IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN
                      CODEUNIT.RUN(CODEUNIT::"Sales-Quote to Order (Yes/No)",Rec);
                end;
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    DocPrint.PrintSalesHeader(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ModelCode := '';
        ModelVersionCode := '';
        VINCode := '';
        SalesPersonName := '';
        SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Quote);
        SalesLine.SETRANGE("Document No.","No.");
        IF SalesLine.FINDFIRST THEN BEGIN
          ModelCode := SalesLine."Model Code";
          ModelVersionCode := SalesLine."Model Version No.";
          SalesLine.CALCFIELDS(VIN);
          VINCode := SalesLine.VIN;
        END;
        RecSalesPerson.RESET;
        RecSalesPerson.SETRANGE(Code,"Salesperson Code");
        IF RecSalesPerson.FINDFIRST THEN
          SalesPersonName := RecSalesPerson.Name;
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
        ApprovalEntries: Page "658";
                             Contact: Record "5050";
                             PipelineHistory1: Record "33020198";
                             PipelineHistory2: Record "33020198";
                             ModelCode: Code[20];
                             ModelVersionCode: Code[20];
                             SalesLine: Record "37";
                             VINCode: Code[20];
                             UserMgt: Codeunit "5700";
                             SalesPersonName: Text[50];
                             RecSalesPerson: Record "13";
                             CountRec: Integer;

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
        SkipFilter: Boolean;
        UserSetup: Record "91";
    begin
        RespCenterFilter := UserMgt.GetSalesFilter();
        IF RespCenterFilter <> '' THEN BEGIN
            FILTERGROUP(2);
            IF UserMgt.DefaultResponsibility THEN
                SETRANGE("Responsibility Center", RespCenterFilter)
            ELSE
                SETRANGE("Accountability Center", RespCenterFilter);
            FILTERGROUP(0);
        END;
    end;
}

