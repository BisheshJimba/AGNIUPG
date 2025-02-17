page 33019916 "Battery Customer List"
{
    Caption = 'Customer List';
    CardPageID = "Battery Customer Card";
    Editable = false;
    PageType = List;
    SourceTable = Table18;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    Visible = false;
                }
                field("Post Code"; "Post Code")
                {
                    Visible = false;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    Visible = false;
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Fax No."; "Fax No.")
                {
                    Visible = false;
                }
                field("IC Partner Code"; "IC Partner Code")
                {
                    Visible = false;
                }
                field(Contact; Contact)
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    Visible = false;
                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Customer Price Group"; "Customer Price Group")
                {
                    Visible = false;
                }
                field("Customer Disc. Group"; "Customer Disc. Group")
                {
                    Visible = false;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Visible = false;
                }
                field("Reminder Terms Code"; "Reminder Terms Code")
                {
                    Visible = false;
                }
                field("Fin. Charge Terms Code"; "Fin. Charge Terms Code")
                {
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                }
                field("Language Code"; "Language Code")
                {
                    Visible = false;
                }
                field("Search Name"; "Search Name")
                {
                }
                field("Credit Limit (LCY)"; "Credit Limit (LCY)")
                {
                    Visible = false;
                }
                field(Blocked; Blocked)
                {
                    Visible = false;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    Visible = false;
                }
                field("Application Method"; "Application Method")
                {
                    Visible = false;
                }
                field("Combine Shipments"; "Combine Shipments")
                {
                    Visible = false;
                }
                field(Reserve; Reserve)
                {
                    Visible = false;
                }
                field("Shipping Advice"; "Shipping Advice")
                {
                    Visible = false;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    Visible = false;
                }
                field("Base Calendar Code"; "Base Calendar Code")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(; 9080)
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = true;
            }
            part(; 9081)
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = false;
            }
            part(; 9082)
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = true;
            }
            part(; 9084)
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = false;
            }
            part(; 9085)
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = false;
            }
            part(; 9086)
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = false;
            }
            systempart(; Links)
            {
                Visible = true;
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
            group("&Customer")
            {
                Caption = '&Customer';
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25;
                    RunPageLink = Customer No.=FIELD(No.);
                    RunPageView = SORTING(Customer No.);
                    ShortCutKey = 'Ctrl+F7';
                }
                group("Issued Documents")
                {
                    Caption = 'Issued Documents';
                    action("Issued &Reminders")
                    {
                        Caption = 'Issued &Reminders';
                        RunObject = Page 440;
                                        RunPageLink = Customer No.=FIELD(No.);
                        RunPageView = SORTING(Customer No.,Posting Date);
                    }
                    action("Issued &Finance Charge Memos")
                    {
                        Caption = 'Issued &Finance Charge Memos';
                        RunObject = Page 452;
                                        RunPageLink = Customer No.=FIELD(No.);
                        RunPageView = SORTING(Customer No.,Posting Date);
                    }
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 124;
                                    RunPageLink = Table Name=CONST(Customer),
                                  No.=FIELD(No.);
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action(DimensionsSingle)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page 540;
                                        RunPageLink = Table ID=CONST(18),
                                      No.=FIELD(No.);
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action(DimensionsMultiple)
                    {
                        AccessByPermission = TableData 348=R;
                        ApplicationArea = Suite;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            Cust: Record "18";
                            DefaultDimMultiple: Page "542";
                        begin
                            CurrPage.SETSELECTIONFILTER(Cust);
                            DefaultDimMultiple.SetMultiCust(Cust);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action("Bank Accounts")
                {
                    Caption = 'Bank Accounts';
                    RunObject = Page 424;
                                    RunPageLink = Customer No.=FIELD(No.);
                }
                action("Ship-&to Addresses")
                {
                    Caption = 'Ship-&to Addresses';
                    RunObject = Page 301;
                                    RunPageLink = Customer No.=FIELD(No.);
                }
                action("C&ontact")
                {
                    Caption = 'C&ontact';

                    trigger OnAction()
                    begin
                        ShowContact;
                    end;
                }
                separator()
                {
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 151;
                                    RunPageLink = No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                    ShortCutKey = 'F7';
                }
                action("Statistics by C&urrencies")
                {
                    Caption = 'Statistics by C&urrencies';
                    Image = Currencies;
                    RunObject = Page 486;
                                    RunPageLink = Customer Filter=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Date Filter=FIELD(Date Filter);
                }
                action("Entry Statistics")
                {
                    Caption = 'Entry Statistics';
                    RunObject = Page 302;
                                    RunPageLink = No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                }
                action("S&ales")
                {
                    Caption = 'S&ales';
                    RunObject = Page 155;
                                    RunPageLink = No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                }
                separator()
                {
                }
                action("Cross Re&ferences")
                {
                    Caption = 'Cross Re&ferences';
                    RunObject = Page 5723;
                                    RunPageLink = Cross-Reference Type=CONST(Customer),
                                  Cross-Reference Type No.=FIELD(No.);
                    RunPageView = SORTING(Cross-Reference Type,Cross-Reference Type No.);
                }
                separator()
                {
                }
                action("Ser&vice Contracts")
                {
                    Caption = 'Ser&vice Contracts';
                    Image = ServiceAgreement;
                    RunObject = Page 6065;
                                    RunPageLink = Customer No.=FIELD(No.);
                    RunPageView = SORTING(Customer No.,Ship-to Code);
                }
                action("Service &Items")
                {
                    Caption = 'Service &Items';
                    RunObject = Page 5988;
                                    RunPageLink = Customer No.=FIELD(No.);
                    RunPageView = SORTING(Customer No.,Ship-to Code,Item No.,Serial No.);
                }
                separator()
                {
                }
            }
            group("S&ales")
            {
                Caption = 'S&ales';
                action("Invoice &Discounts")
                {
                    Caption = 'Invoice &Discounts';
                    RunObject = Page 23;
                                    RunPageLink = Code=FIELD(Invoice Disc. Code);
                }
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page 7002;
                                    RunPageLink = Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                    RunPageView = SORTING(Sales Type,Sales Code);
                }
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    RunObject = Page 7004;
                                    RunPageLink = Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                    RunPageView = SORTING(Sales Type,Sales Code);
                }
                action("Prepa&yment Percentages")
                {
                    Caption = 'Prepa&yment Percentages';
                    RunObject = Page 664;
                                    RunPageLink = Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                    RunPageView = SORTING(Sales Type,Sales Code);
                }
                action("S&td. Cust. Sales Codes")
                {
                    Caption = 'S&td. Cust. Sales Codes';
                    RunObject = Page 173;
                                    RunPageLink = Customer No.=FIELD(No.);
                }
                separator()
                {
                }
                action(Quotes)
                {
                    Caption = 'Quotes';
                    Image = Quote;
                    RunObject = Page 9300;
                                    RunPageLink = Sell-to Customer No.=FIELD(No.);
                    RunPageView = SORTING(Sell-to Customer No.);
                }
                action("Blanket Orders")
                {
                    Caption = 'Blanket Orders';
                    Image = BlanketOrder;
                    RunObject = Page 9303;
                                    RunPageLink = Sell-to Customer No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Sell-to Customer No.);
                }
                action(Orders)
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page 9305;
                                    RunPageLink = Sell-to Customer No.=FIELD(No.);
                    RunPageView = SORTING(Sell-to Customer No.);
                }
                action("Return Orders")
                {
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page 9304;
                }
                action("Service Orders")
                {
                    Caption = 'Service Orders';
                    Image = Document;
                    RunObject = Page 9318;
                                    RunPageLink = Customer No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Customer No.);
                }
                action("Item &Tracking Entries")
                {
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    var
                        ItemTrackingDocMgt: Codeunit "6503";
                    begin
                        ItemTrackingDocMgt.ShowItemTrackingForMasterData(1,"No.",'','','','','');
                    end;
                }
            }
        }
        area(creation)
        {
            action("Blanket Sales Order")
            {
                Caption = 'Blanket Sales Order';
                Image = BlanketOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 507;
                                RunPageLink = Sell-to Customer No.=FIELD(No.);
                RunPageMode = Create;
            }
            action("Sales Quote")
            {
                Caption = 'Sales Quote';
                Image = Quote;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page 41;
                                RunPageLink = Sell-to Customer No.=FIELD(No.);
                RunPageMode = Create;
            }
            action("Sales Invoice")
            {
                Caption = 'Sales Invoice';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page 43;
                                RunPageLink = Sell-to Customer No.=FIELD(No.);
                RunPageMode = Create;
            }
            action("Sales Order")
            {
                Caption = 'Sales Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page 42;
                                RunPageLink = Sell-to Customer No.=FIELD(No.);
                RunPageMode = Create;
            }
            action("Sales Credit Memo")
            {
                Caption = 'Sales Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 44;
                                RunPageLink = Sell-to Customer No.=FIELD(No.);
                RunPageMode = Create;
            }
            action("Sales Return Order")
            {
                Caption = 'Sales Return Order';
                Image = ReturnOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 6630;
                                RunPageLink = Sell-to Customer No.=FIELD(No.);
                RunPageMode = Create;
            }
            action("Service Quote")
            {
                Caption = 'Service Quote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 5964;
                                RunPageLink = Customer No.=FIELD(No.);
                RunPageMode = Create;
            }
            action("Service Invoice")
            {
                Caption = 'Service Invoice';
                Image = Invoice;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 5933;
                                RunPageLink = Customer No.=FIELD(No.);
                RunPageMode = Create;
            }
            action("Service Order")
            {
                Caption = 'Service Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 5900;
                                RunPageLink = Customer No.=FIELD(No.);
                RunPageMode = Create;
            }
            action("Service Credit Memo")
            {
                Caption = 'Service Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 5935;
                                RunPageLink = Customer No.=FIELD(No.);
                RunPageMode = Create;
            }
            action(Reminder)
            {
                Caption = 'Reminder';
                Image = Reminder;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page 434;
                                RunPageLink = Customer No.=FIELD(No.);
                RunPageMode = Create;
            }
            action("Financial Charge Memo")
            {
                Caption = 'Financial Charge Memo';
                Image = FinChargeMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 446;
                                RunPageLink = Customer No.=FIELD(No.);
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            action("Cash Receipt Journal")
            {
                Caption = 'Cash Receipt Journal';
                Image = CashReceiptJournal;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 255;
            }
            action("Sales Journal")
            {
                Caption = 'Sales Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 253;
            }
        }
        area(reporting)
        {
            action("Customer List")
            {
                Caption = 'Customer List';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 101;
            }
            action("Customer Register")
            {
                Caption = 'Customer Register';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 103;
            }
            action("Customer - Detail Trial Bal.")
            {
                Caption = 'Customer - Detail Trial Bal.';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 104;
            }
            action("Customer - Summary Aging")
            {
                Caption = 'Customer - Summary Aging';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 105;
            }
            action("Customer Detailed Aging")
            {
                Caption = 'Customer Detailed Aging';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 106;
            }
            action("Customer - Order Summary")
            {
                Caption = 'Customer - Order Summary';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 107;
            }
            action("Customer - Order Detail")
            {
                Caption = 'Customer - Order Detail';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 108;
            }
            action("Customer - Top 10 List")
            {
                Caption = 'Customer - Top 10 List';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 111;
            }
            action("Sales Statistics")
            {
                Caption = 'Sales Statistics';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 112;
            }
            action("Customer/Item Sales")
            {
                Caption = 'Customer/Item Sales';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 113;
            }
            action(Statement)
            {
                Caption = 'Statement';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 116;
            }
            action(Reminder)
            {
                Caption = 'Reminder';
                Image = Reminder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 117;
            }
            action("Customer - Sales List")
            {
                Caption = 'Customer - Sales List';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 119;
            }
            action("Aged Accounts Receivable")
            {
                Caption = 'Aged Accounts Receivable';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 120;
            }
            action("Customer - Balance to Date")
            {
                Caption = 'Customer - Balance to Date';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 121;
            }
            action("Customer - Trial Balance")
            {
                Caption = 'Customer - Trial Balance';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 129;
            }
            action("Customer - Payment Receipt")
            {
                Caption = 'Customer - Payment Receipt';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 211;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SETRANGE("Customer Type","Customer Type"::BTD);
    end;

    [Scope('Internal')]
    procedure GetSelectionFilter(): Code[80]
    var
        Cust: Record "18";
        FirstCust: Code[30];
        LastCust: Code[30];
        SelectionFilter: Code[250];
        CustCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
        CustCount := Cust.COUNT;
        IF CustCount > 0 THEN BEGIN
          Cust.FIND('-');
          WHILE CustCount > 0 DO BEGIN
            CustCount := CustCount - 1;
            Cust.MARKEDONLY(FALSE);
            FirstCust := Cust."No.";
            LastCust := FirstCust;
            More := (CustCount > 0);
            WHILE More DO
              IF Cust.NEXT = 0 THEN
                More := FALSE
              ELSE
                IF NOT Cust.MARK THEN
                  More := FALSE
                ELSE BEGIN
                  LastCust := Cust."No.";
                  CustCount := CustCount - 1;
                  IF CustCount = 0 THEN
                    More := FALSE;
                END;
            IF SelectionFilter <> '' THEN
              SelectionFilter := SelectionFilter + '|';
            IF FirstCust = LastCust THEN
              SelectionFilter := SelectionFilter + FirstCust
            ELSE
              SelectionFilter := SelectionFilter + FirstCust + '..' + LastCust;
            IF CustCount > 0 THEN BEGIN
              Cust.MARKEDONLY(TRUE);
              Cust.NEXT;
            END;
          END;
        END;
        EXIT(SelectionFilter);
    end;

    [Scope('Internal')]
    procedure SetSelection(var Cust: Record "18")
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
    end;
}

