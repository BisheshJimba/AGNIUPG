page 25006509 "Posted Sales Invoices (Veh.)"
{
    Caption = 'Posted Sales Invoices';
    CardPageID = "Posted Sales Invoice";
    Editable = false;
    PageType = List;
    SourceTable = Table112;
    SourceTableView = SORTING(No.)
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Posting Date"; "Posting Date")
                {
                }
                field("No."; "No.")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Order No."; "Order No.")
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
                field("Remaining Amount"; "Remaining Amount")
                {
                }
                field(CustAddress; CustAddress)
                {
                    Caption = 'Address';
                    Visible = false;
                }
                field(CustPhone; CustPhone)
                {
                    Caption = 'Phone No.';
                }
                field(CustMobile; CustMobile)
                {
                    Caption = 'Mobile No.';
                }
                field(CustCity; CustCity)
                {
                    Caption = 'City';
                }
                field("Direct Sales"; "Direct Sales")
                {
                }
                field(Returned; Returned)
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
                field(SalesInvHeader."Sell-to Address";
                    SalesInvHeader."Sell-to Address")
                {
                }
                field("Sys. LC No."; "Sys. LC No.")
                {
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
                field("Salesperson Name"; "Salesperson Name")
                {
                    TableRelation = Salesperson/Purchaser.Name WHERE (Code=FIELD(Salesperson Code));
                }
                field("Ship-to Contact";"Ship-to Contact")
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
                field("Financed By";"Financed By")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Financed By Name";"Financed By Name")
                {
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
                field(Dispatched;Dispatched)
                {
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
                        PAGE.RUN(PAGE::"Posted Sales Invoice",Rec)
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
                action("<Action1000000021>")
                {
                    Caption = 'Count Records';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //**SM 21-10-2013 to count the records in list pages
                        CountRec := COUNT;
                        MESSAGE('No. of records are %1 ',CountRec);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
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
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    //SalesInvHeader.PrintRecords(TRUE);
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
            action("<Action1000000018>")
            {
                Caption = '& Receipt';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SalesInvHeader.RESET;
                    SalesInvHeader.SETRANGE("No.","No.");
                    REPORT.RUN(33020025,TRUE,TRUE,SalesInvHeader);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        ModelCode := '';
        ModelVersionCode := '';
        VINCode := '';

        SalesInvLine.SETRANGE("Document No.","No.");
        SalesInvLine.SETFILTER(VIN,'<>%1','');
        IF SalesInvLine.FINDFIRST THEN BEGIN
          ModelCode := SalesInvLine."Model Code";
          ModelVersionCode := SalesInvLine."Model Version No.";
          SalesInvLine.CALCFIELDS(VIN);
          VINCode := SalesInvLine.VIN;
          IF VINCode <> '' THEN BEGIN
            Vehicle.SETRANGE(VIN,VINCode);
            IF Vehicle.FINDFIRST THEN
              DRP := Vehicle."DRP No./ARE1 No."
            ELSE
              DRP := '';
           END;
        END;

        CustCity := '';
        CustAddress := '';
        CustPhone := '';
        CustMobile := '';

        Customer.RESET;
        Customer.SETRANGE("No.","Sell-to Customer No.") ;
        IF Customer.FINDFIRST THEN BEGIN
          CustCity := Customer.City;
          CustAddress := Customer.Address;
          CustPhone := Customer."Phone No.";
          CustMobile := Customer."Mobile No.";
        END;

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
        //EDMS>>
        FILTERGROUP(3);
        SETRANGE("Document Profile","Document Profile"::"Vehicles Trade");
        //EDMS<<
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
        SalesInvHeader: Record "112";
        UserMgt: Codeunit "5700";
        ModelCode: Code[20];
        ModelVersionCode: Code[20];
        SalesInvLine: Record "113";
        VINCode: Code[20];
        SalesPerson: Text[50];
        DRP: Code[20];
        Vehicle: Record "25006005";
        UserSetup: Record "91";
        Customer: Record "18";
        CustCity: Text[100];
        CustAddress: Text[1024];
        CustPhone: Text[1024];
        CustMobile: Text[1024];
        CustLedger: Record "21";
        CountRec: Integer;

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
        SkipFilter: Boolean;
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        // IF ("Document Profile" = "Document Profile"::"Vehicles Trade") THEN
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
}

