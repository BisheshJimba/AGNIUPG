page 33019915 "Battery Customer Card"
{
    Caption = 'Customer Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Table18;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Customer Type"; "Customer Type")
                {
                }
                field(Name; Name)
                {
                    Importance = Promoted;
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                    Importance = Promoted;
                }
                field(City; City)
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Primary Contact No."; "Primary Contact No.")
                {
                }
                field(Contact; Contact)
                {
                    Editable = ContactEditable;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        ContactOnAfterValidate;
                    end;
                }
                field("Search Name"; "Search Name")
                {
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {

                    trigger OnDrillDown()
                    var
                        DtldCustLedgEntry: Record "379";
                        CustLedgEntry: Record "21";
                    begin
                        DtldCustLedgEntry.SETRANGE("Customer No.", "No.");
                        COPYFILTER("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        COPYFILTER("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        COPYFILTER("Currency Filter", DtldCustLedgEntry."Currency Code");
                        CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                    end;
                }
                field("Credit Limit (LCY)"; "Credit Limit (LCY)")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                }
                field("Service Zone Code"; "Service Zone Code")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Mobile No."; "Mobile No.")
                {
                }
                field("Phone No. "; "Phone No.")
                {
                    Caption = 'Phone No.';
                    Importance = Promoted;
                }
                field("Fax No."; "Fax No.")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                    Importance = Promoted;
                }
                field("Home Page"; "Home Page")
                {
                }
                field("IC Partner Code"; "IC Partner Code")
                {

                    trigger OnValidate()
                    begin
                        ICPartnerCodeOnAfterValidate;
                    end;
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Invoice Copies"; "Invoice Copies")
                {
                }
                field("Invoice Disc. Code"; "Invoice Disc. Code")
                {
                }
                field("Copy Sell-to Addr. to Qte From"; "Copy Sell-to Addr. to Qte From")
                {
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    Importance = Promoted;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                    Importance = Promoted;
                }
                field("Customer Price Group"; "Customer Price Group")
                {
                    Importance = Promoted;
                }
                field("Customer Disc. Group"; "Customer Disc. Group")
                {
                    Importance = Promoted;
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                }
                field("Prices Including VAT"; "Prices Including VAT")
                {
                }
                field("Prepayment %"; "Prepayment %")
                {
                }
                field(Internal; Internal)
                {
                }
                field("Corresponding Vendor No."; "Corresponding Vendor No.")
                {
                }
                field("Default Service Item Charge"; "Default Service Item Charge")
                {
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                Visible = false;
                field("Application Method"; "Application Method")
                {
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Importance = Promoted;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    Importance = Promoted;
                }
                field("Reminder Terms Code"; "Reminder Terms Code")
                {
                    Importance = Promoted;
                }
                field("Fin. Charge Terms Code"; "Fin. Charge Terms Code")
                {
                    Importance = Promoted;
                }
                field("Print Statements"; "Print Statements")
                {
                }
                field("Last Statement No."; "Last Statement No.")
                {
                }
                field("Block Payment Tolerance"; "Block Payment Tolerance")
                {

                    trigger OnValidate()
                    begin
                        IF "Block Payment Tolerance" THEN BEGIN
                            IF CONFIRM(Text002, FALSE) THEN
                                PaymentToleranceMgt.DelTolCustLedgEntry(Rec);
                        END ELSE BEGIN
                            IF CONFIRM(Text001, FALSE) THEN
                                PaymentToleranceMgt.CalcTolCustLedgEntry(Rec);
                        END;
                    end;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                Visible = false;
                field("Location Code"; "Location Code")
                {
                    Importance = Promoted;
                }
                field("Combine Shipments"; "Combine Shipments")
                {
                }
                field(Reserve; Reserve)
                {
                }
                field("Shipping Advice"; "Shipping Advice")
                {
                    Importance = Promoted;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    Importance = Promoted;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    Importance = Promoted;
                }
                field("Shipping Agent Service Code"; "Shipping Agent Service Code")
                {
                }
                field("Shipping Time"; "Shipping Time")
                {
                }
                field("Base Calendar Code"; "Base Calendar Code")
                {
                    DrillDown = false;
                }
                field("Customized Calendar"; CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."Source Type"::Customer, "No.", '', "Base Calendar Code"))
                {
                    Caption = 'Customized Calendar';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        CurrPage.SAVERECORD;
                        TESTFIELD("Base Calendar Code");
                        CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."Source Type"::Customer, "No.", '', "Base Calendar Code");
                    end;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                Visible = false;
                field("Currency Code"; "Currency Code")
                {
                    Importance = Promoted;
                }
                field("Language Code"; "Language Code")
                {
                }
                field("VAT Registration No. "; "VAT Registration No.")
                {
                    Caption = 'VAT Registration No.';
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
            part(; 9083)
            {
                SubPageLink = Table ID=CONST(18),
                              No.=FIELD(No.);
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
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
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
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                                    RunPageLink = Table ID=CONST(18),
                                  No.=FIELD(No.);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
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
                    Caption = '';
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
                    Caption = '';
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
                action("&Jobs")
                {
                    Caption = '&Jobs';
                    RunObject = Page 89;
                                    RunPageLink = Bill-to Customer No.=FIELD(No.);
                    RunPageView = SORTING(Bill-to Customer No.);
                }
                separator()
                {
                }
                action("Online Map")
                {
                    Caption = 'Online Map';

                    trigger OnAction()
                    begin
                        DisplayMap;
                    end;
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
                    RunPageView = SORTING(Document Type,Sell-to Customer No.,No.);
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
                    RunPageView = SORTING(Document Type,Sell-to Customer No.,No.);
                }
                action("Return Orders")
                {
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page 9304;
                                    RunPageLink = Sell-to Customer No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Sell-to Customer No.,No.);
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
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
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
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Apply Template")
                {
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        TemplateMgt: Codeunit "8612";
                        RecRef: RecordRef;
                    begin
                        RecRef.GETTABLE(Rec);
                        TemplateMgt.UpdateFromTemplateSelection(RecRef);
                    end;
                }
            }
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
            action("Customer Detailed Aging")
            {
                Caption = 'Customer Detailed Aging';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 106;
            }
            action("Customer - Labels")
            {
                Caption = 'Customer - Labels';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 110;
            }
            action("Customer - Balance to Date")
            {
                Caption = 'Customer - Balance to Date';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 121;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ActivateFields;

        OnAfterGetCurrRecord;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        RecordFound: Boolean;
    begin
        RecordFound := FIND(Which);
        IF NOT RecordFound AND (GETFILTER("No.") <> '') THEN BEGIN
        MESSAGE(Text003,GETFILTER("No."));
        SETRANGE("No.");
        RecordFound := FIND(Which);
        END;
        EXIT(RecordFound);
    end;

    trigger OnInit()
    begin
        ContactEditable := TRUE;
        MapPointVisible := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Customer Type" := "Customer Type"::BTD;
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "802";
    begin
        ActivateFields;
        IF NOT MapMgt.TestSetup THEN
          MapPointVisible := FALSE;
    end;

    var
        CustomizedCalEntry: Record "7603";
        Text001: Label 'Do you want to allow payment tolerance for entries that are currently open?';
        CustomizedCalendar: Record "7602";
        Text002: Label 'Do you want to remove payment tolerance from entries that are currently open?';
        CalendarMgmt: Codeunit "7600";
        PaymentToleranceMgt: Codeunit "426";
        SalesInfoPaneMgt: Codeunit "7171";
        Text003: Label 'The customer %1 does not exist.';
        [InDataSet]
        MapPointVisible: Boolean;
        [InDataSet]
        ContactEditable: Boolean;

    [Scope('Internal')]
    procedure ActivateFields()
    begin
        ContactEditable := "Primary Contact No." = '';
    end;

    local procedure ContactOnAfterValidate()
    begin
        ActivateFields;
    end;

    local procedure ICPartnerCodeOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        ActivateFields;
    end;
}

