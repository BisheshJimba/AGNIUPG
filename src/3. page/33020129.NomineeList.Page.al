page 33020129 "Nominee List"
{
    // 28.06.2013 EDMS P8
    //   * Added action 'Vehicles'

    Caption = 'Customer List';
    CardPageID = "Customer Card";
    DeleteAllowed = false;
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
                field("Name 2"; "Name 2")
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
                field("Mobile No."; "Mobile No.")
                {
                }
                field("Telex No."; "Telex No.")
                {
                    Caption = 'Work Phone No.';
                }
                field("Corrected Phone No."; "Corrected Phone No.")
                {
                    Caption = 'Additional Phone No.';
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
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
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
                    Visible = false;
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
                field("Citizenship No."; "Citizenship No.")
                {
                }
                field("Citizenship Issued District"; "Citizenship Issued District")
                {
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                }
                field("Sipradi Customer No."; "Sipradi Customer No.")
                {
                    Visible = false;
                }
                field(Balance; Balance)
                {
                }
                field("Balance at Date"; "Balance at Date")
                {
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
                SubPageLink = No.=FIELD(No.),
                              Currency Filter=FIELD(Currency Filter),
                              Date Filter=FIELD(Date Filter),
                              Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                              Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                Visible = true;
            }
            part(;9081)
            {
                SubPageLink = No.=FIELD(No.),
                              Currency Filter=FIELD(Currency Filter),
                              Date Filter=FIELD(Date Filter),
                              Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                              Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                Visible = false;
            }
            part(;9082)
            {
                SubPageLink = No.=FIELD(No.),
                              Currency Filter=FIELD(Currency Filter),
                              Date Filter=FIELD(Date Filter),
                              Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                              Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                Visible = true;
            }
            part(;9084)
            {
                SubPageLink = No.=FIELD(No.),
                              Currency Filter=FIELD(Currency Filter),
                              Date Filter=FIELD(Date Filter),
                              Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                              Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                Visible = false;
            }
            part(;9085)
            {
                SubPageLink = No.=FIELD(No.),
                              Currency Filter=FIELD(Currency Filter),
                              Date Filter=FIELD(Date Filter),
                              Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                              Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                Visible = false;
            }
            part(;9086)
            {
                SubPageLink = No.=FIELD(No.),
                              Currency Filter=FIELD(Currency Filter),
                              Date Filter=FIELD(Date Filter),
                              Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                              Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                Visible = false;
            }
            systempart(;Links)
            {
                Visible = true;
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
            group("&Customer")
            {
                Caption = '&Customer';
                Image = Customer;
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
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page 540;
                                        RunPageLink = Table ID=CONST(18),
                                      No.=FIELD(No.);
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;

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
                    Image = BankAccount;
                    RunObject = Page 424;
                                    RunPageLink = Customer No.=FIELD(No.);
                }
                action("Direct Debit Mandates")
                {
                    Caption = 'Direct Debit Mandates';
                    Image = MakeAgreement;
                    RunObject = Page 1230;
                                    RunPageLink = Customer No.=FIELD(No.);
                }
                action("Ship-&to Addresses")
                {
                    Caption = 'Ship-&to Addresses';
                    Image = ShipAddress;
                    RunObject = Page 301;
                                    RunPageLink = Customer No.=FIELD(No.);
                }
                action("C&ontact")
                {
                    Caption = 'C&ontact';
                    Image = ContactPerson;

                    trigger OnAction()
                    begin
                        ShowContact;
                    end;
                }
                action("&Vehicles")
                {
                    Caption = '&Vehicles';
                    Image = Delivery;

                    trigger OnAction()
                    begin
                        ShowVehicles;
                    end;
                }
                action("Cross Re&ferences")
                {
                    Caption = 'Cross Re&ferences';
                    Image = Change;
                    RunObject = Page 5723;
                                    RunPageLink = Cross-Reference Type=CONST(Customer),
                                  Cross-Reference Type No.=FIELD(No.);
                    RunPageView = SORTING(Cross-Reference Type,Cross-Reference Type No.);
                }
                separator()
                {
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
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
                action("S&ales")
                {
                    Caption = 'S&ales';
                    Image = Sales;
                    RunObject = Page 155;
                                    RunPageLink = No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                }
                action("Entry Statistics")
                {
                    Caption = 'Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page 302;
                                    RunPageLink = No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
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
                action("Item &Tracking Entries")
                {
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    var
                        ItemTrackingMgt: Codeunit "6500";
                    begin
                        ItemTrackingMgt.CallItemTrackingEntryForm(1,"No.",'','','','','');
                    end;
                }
            }
            group("S&ales")
            {
                Caption = 'S&ales';
                Image = Sales;
                action("Invoice &Discounts")
                {
                    Caption = 'Invoice &Discounts';
                    Image = CalculateInvoiceDiscount;
                    RunObject = Page 23;
                                    RunPageLink = Code=FIELD(Invoice Disc. Code);
                }
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = Price;
                    RunObject = Page 7002;
                                    RunPageLink = Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                    RunPageView = SORTING(Sales Type,Sales Code);
                }
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page 7004;
                                    RunPageLink = Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                    RunPageView = SORTING(Sales Type,Sales Code);
                }
                action("Prepa&yment Percentages")
                {
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page 664;
                                    RunPageLink = Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                    RunPageView = SORTING(Sales Type,Sales Code);
                }
                action("S&td. Cust. Sales Codes")
                {
                    Caption = 'S&td. Cust. Sales Codes';
                    Image = CodesList;
                    RunObject = Page 173;
                                    RunPageLink = Customer No.=FIELD(No.);
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action(Quotes)
                {
                    Caption = 'Quotes';
                    Image = Quote;
                    RunObject = Page 9300;
                                    RunPageLink = Sell-to Customer No.=FIELD(No.);
                    RunPageView = SORTING(Sell-to Customer No.);
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
                                    RunPageLink = Sell-to Customer No.=FIELD(No.);
                    RunPageView = SORTING(Sell-to Customer No.);
                }
                group("Issued Documents")
                {
                    Caption = 'Issued Documents';
                    Image = Documents;
                    action("Issued &Reminders")
                    {
                        Caption = 'Issued &Reminders';
                        Image = OrderReminder;
                        RunObject = Page 440;
                                        RunPageLink = Customer No.=FIELD(No.);
                        RunPageView = SORTING(Customer No.,Posting Date);
                    }
                    action("Issued &Finance Charge Memos")
                    {
                        Caption = 'Issued &Finance Charge Memos';
                        Image = FinChargeMemo;
                        RunObject = Page 452;
                                        RunPageLink = Customer No.=FIELD(No.);
                        RunPageView = SORTING(Customer No.,Posting Date);
                    }
                }
                action("Blanket Orders")
                {
                    Caption = 'Blanket Orders';
                    Image = BlanketOrder;
                    RunObject = Page 9303;
                                    RunPageLink = Sell-to Customer No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Sell-to Customer No.);
                }
            }
            group("Credit Card")
            {
                Caption = 'Credit Card';
                Image = CreditCard;
                group("Credit Cards")
                {
                    Caption = 'Credit Cards';
                    Image = CreditCard;
                    action("C&redit Cards")
                    {
                        Caption = 'C&redit Cards';
                        Image = CreditCard;
                        RunObject = Page 828;
                                        RunPageLink = Field6=FIELD(No.);
                    }
                    action("Credit Cards Transaction Lo&g Entries")
                    {
                        Caption = 'Credit Cards Transaction Lo&g Entries';
                        Image = CreditCardLog;
                        RunObject = Page 829;
                                        RunPageLink = Field4=FIELD(No.);
                    }
                }
            }
            group(Service)
            {
                Caption = 'Service';
                Image = ServiceItem;
                action("Service Orders")
                {
                    Caption = 'Service Orders';
                    Image = Document;
                    RunObject = Page 9318;
                                    RunPageLink = Customer No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Customer No.);
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
                    Image = ServiceItem;
                    RunObject = Page 5988;
                                    RunPageLink = Customer No.=FIELD(No.);
                    RunPageView = SORTING(Customer No.,Ship-to Code,Item No.,Serial No.);
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
            action("Finance Charge Memo")
            {
                Caption = 'Finance Charge Memo';
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
            group(General)
            {
                Caption = 'General';
                action("Customer List")
                {
                    Caption = 'Customer List';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 101;
                }
                action("Customer Register")
                {
                    Caption = 'Customer Register';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 103;
                }
                action("Customer - Top 10 List")
                {
                    Caption = 'Customer - Top 10 List';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 111;
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                Image = Sales;
                action("Customer - Order Summary")
                {
                    Caption = 'Customer - Order Summary';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 107;
                }
                action("Customer - Order Detail")
                {
                    Caption = 'Customer - Order Detail';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 108;
                }
                action("Customer - Sales List")
                {
                    Caption = 'Customer - Sales List';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 119;
                }
                action("Sales Statistics")
                {
                    Caption = 'Sales Statistics';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 112;
                }
                action("Customer/Item Sales")
                {
                    Caption = 'Customer/Item Sales';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 113;
                }
            }
            group("Financial Management")
            {
                Caption = 'Financial Management';
                Image = "Report";
                action("Customer - Detail Trial Bal.")
                {
                    Caption = 'Customer - Detail Trial Bal.';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 104;
                }
                action("Customer - Summary Aging")
                {
                    Caption = 'Customer - Summary Aging';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 105;
                }
                action("Customer Detailed Aging")
                {
                    Caption = 'Customer Detailed Aging';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 106;
                }
                action(Statement)
                {
                    Caption = 'Statement';
                    Image = "Report";
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
                action("Aged Accounts Receivable")
                {
                    Caption = 'Aged Accounts Receivable';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 120;
                }
                action("Customer - Balance to Date")
                {
                    Caption = 'Customer - Balance to Date';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 121;
                }
                action("Customer - Trial Balance")
                {
                    Caption = 'Customer - Trial Balance';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 129;
                }
                action("Customer - Payment Receipt")
                {
                    Caption = 'Customer - Payment Receipt';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 211;
                }
                action("Nominee Statement")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Customer.RESET;
                        Customer.SETRANGE("No.","No.");
                        IF Customer.FINDFIRST THEN BEGIN
                          NomineeStatement.SETTABLEVIEW(Customer);
                          NomineeStatement.RUN;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(3);
        SETRANGE(Type,Type::Nominee);
    end;

    var
        Customer: Record "18";
        NomineeStatement: Report "33020060";

    [Scope('Internal')]
    procedure GetSelectionFilter(): Text
    var
        Cust: Record "18";
        SelectionFilterManagement: Codeunit "46";
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
        EXIT(SelectionFilterManagement.GetSelectionFilterForCustomer(Cust));
    end;

    [Scope('Internal')]
    procedure SetSelection(var Cust: Record "18")
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
    end;
}

