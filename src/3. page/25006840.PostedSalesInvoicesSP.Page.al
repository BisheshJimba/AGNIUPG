page 25006840 "Posted Sales Invoices SP"
{
    // 28.05.2014 Elva Baltic P21 #S0120 MMG7.00
    //   Added fields:
    //     Prepayment
    //     "Deal Type Code"
    //     "Document Profile"
    //     "Posting Description"
    //     "Customer Disc. Group"
    //     Correction
    //     "User ID"
    //     "Payment Method Code"
    //     "Linked Sales Shipment No."
    //     "Vehicle Serial No."
    //     "Vehicle Accounting Cycle No."
    // 
    // 30.04.2014 Elva Baltic P8 #S0077 MMG7.00
    //   * Added fields: "Order No.", "LV Invoice No."

    Caption = 'Posted Sales Invoices';
    CardPageID = "Posted Sales Invoice";
    Editable = false;
    PageType = List;
    SourceTable = Table112;

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
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("Currency Code"; "Currency Code")
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
                field("Order Type"; "Order Type")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
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
                field("Due Date"; "Due Date")
                {
                    Visible = false;
                }
                field("Payment Discount %"; "Payment Discount %")
                {
                    Visible = false;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    Visible = false;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    Visible = false;
                }
                field("Order No."; "Order No.")
                {
                    Visible = false;
                }
                field("Deal Type Code"; "Deal Type Code")
                {
                    Visible = false;
                }
                field("Document Profile"; "Document Profile")
                {
                    Visible = false;
                }
                field("Posting Description"; "Posting Description")
                {
                    Visible = false;
                }
                field("Customer Disc. Group"; "Customer Disc. Group")
                {
                    Visible = false;
                }
                field(Correction; Correction)
                {
                    Visible = false;
                }
                field("User ID"; "User ID")
                {
                    Visible = false;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    Visible = false;
                }
                field("Sys. LC No."; "Sys. LC No.")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = false;
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                    Visible = false;
                }
                field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
                {
                    Visible = false;
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
            group("&Invoice")
            {
                Caption = '&Invoice';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.RUN(PAGE::"Posted Sales Invoice", Rec)
                    end;
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 397;
                    RunPageLink = No.=FIELD(No.);
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 67;
                                    RunPageLink = Document Type=CONST(Posted Invoice),
                                  No.=FIELD(No.);
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

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    SalesInvHeader.PrintRecords2(TRUE);
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
            action(GatePass)
            {
                Caption = 'GatePass';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CreateGatePass;
                end;
            }
            action(Receipt)
            {
                Caption = 'Receipt';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //REPORT.RUN(33020025);
                    SalesInvHeader.RESET;
                    SalesInvHeader.SETRANGE("No.","No.");
                    REPORT.RUN(33020025,TRUE,TRUE,SalesInvHeader);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        FilterOnRecord;
        //EDMS>>
        FILTERGROUP(3);
        SETRANGE("Document Profile","Document Profile"::"Spare Parts Trade");
        //EDMS<<
    end;

    var
        SalesInvHeader: Record "112";

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetSalesFilter();
        IF RespCenterFilter <> '' THEN BEGIN
          FILTERGROUP(2);
           IF UserMgt.DefaultResponsibility THEN
              SETRANGE("Responsibility Center",RespCenterFilter)
          ELSE
              SETRANGE("Accountability Center",RespCenterFilter);
          FILTERGROUP(0);
        END;
    end;

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
}

