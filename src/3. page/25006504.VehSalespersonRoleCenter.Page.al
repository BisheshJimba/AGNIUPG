page 25006504 "Veh. Salesperson Role Center"
{
    // 19.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * To-Do List added to Menu

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group()
            {
                part(; 25006505)
                {
                }
                systempart(; Outlook)
                {
                }
            }
            group()
            {
                part(; 9150)
                {
                }
                part(; 9152)
                {
                }
                part(; 9175)
                {
                    Visible = false;
                }
                systempart(; MyNotes)
                {
                }
                part(; 681)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Report Selector Pram")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50067;
            }
            action("Customer - &Order Summary")
            {
                Caption = 'Customer - &Order Summary';
                Image = StatisticsDocument;
                RunObject = Report 107;
            }
            action("Customer - &Top 10 List")
            {
                Caption = 'Customer - &Top 10 List';
                Image = "Report";
                RunObject = Report 111;
            }
            action("Customer/&Item Sales")
            {
                Caption = 'Customer/&Item Sales';
                Image = "Report";
                RunObject = Report 113;
            }
            action("Salesperson - Sales &Statistics")
            {
                Caption = 'Salesperson - Sales &Statistics';
                Image = Statistics;
                RunObject = Report 114;
            }
            action("Price &List")
            {
                Caption = 'Price &List';
                Image = SalesPrices;
                RunObject = Report 715;
            }
            action("Inventory - Sales &Back Orders")
            {
                Caption = 'Inventory - Sales &Back Orders';
                Image = MakeOrder;
                RunObject = Report 718;
            }
            action("<Action1101904003>")
            {
                Caption = 'Vehicle Sales';
                Image = "Report";
                RunObject = Report 25006321;
            }
            action("Salesperson Interactions")
            {
                Caption = 'Salesperson Interactions';
                Image = "Report";
                RunObject = Report 50012;
            }
            action("Vehicle Rent")
            {
                Caption = 'Vehicle Rent';
                Image = "Report";
                RunObject = Report 50013;
            }
        }
        area(embedding)
        {
            action("Sales Orders")
            {
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page 25006466;
            }
            action("Sales Quotes")
            {
                Caption = 'Sales Quotes';
                Image = Quote;
                RunObject = Page 25006471;
            }
            action("Sales Invoices")
            {
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page 25006546;
            }
            action("Sales Return Orders")
            {
                Caption = 'Sales Return Orders';
                Image = ReturnOrder;
                RunObject = Page 25006473;
            }
            action("Sales Credit Memos")
            {
                Caption = 'Sales Credit Memos';
                Image = CreditMemo;
                RunObject = Page 25006472;
            }
            action(Vehicles)
            {
                Caption = 'Vehicles';
                Image = ListPage;
                RunObject = Page 25006033;
            }
            action(Contacts)
            {
                Caption = 'Contacts';
                Image = CustomerContact;
                RunObject = Page 5052;
            }
            action(Customers)
            {
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page 22;
            }
            action("Item Journals")
            {
                Caption = 'Item Journals';
                Image = Journal;
                RunObject = Page 262;
                RunPageView = WHERE(Template Type=CONST(Item),
                                    Recurring=CONST(No));
            }
            action("To-Do List")
            {
                Caption = 'To-Do List';
                RunObject = Page 5096;
            }
        }
        area(sections)
        {
            group("<Action1101904009>")
            {
                Caption = 'Catalogues';
                Image = ReferenceData;
                action("<Action1101904014>")
                {
                    Caption = 'Makes';
                    Image = Production;
                    RunObject = Page 25006014;
                }
                action("<Action1101904015>")
                {
                    Caption = 'Models';
                    Image = ListPage;
                    RunObject = Page 25006016;
                }
                action("Model Versions")
                {
                    Caption = 'Model Versions';
                    Image = Versions;
                    RunObject = Page 25006054;
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Shipments")
                {
                    Caption = 'Posted Sales Shipments';
                    RunObject = Page 142;
                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page 143;
                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
                action("Posted Return Receipts")
                {
                    Caption = 'Posted Return Receipts';
                    RunObject = Page 6662;
                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    RunObject = Page 144;
                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
                action("Posted Purchase Receipts")
                {
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page 145;
                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
                action("Posted Purchase Invoices")
                {
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page 146;
                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
                action("<Action1101904002>")
                {
                    Caption = 'Sales Order Archives';
                    Image = Archive;
                    RunObject = Page 9349;
                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
            }
        }
        area(processing)
        {
            separator(New)
            {
                Caption = 'New';
                IsHeader = true;
            }
            action("<Action37>")
            {
                Caption = 'Sales &Quote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 41;
                RunPageMode = Create;
                RunPageView = SORTING(Document Profile)
                              WHERE(Document Profile=CONST(Vehicles Trade));
            }
            action("Sales &Invoice")
            {
                Caption = 'Sales &Invoice';
                Image = Invoice;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 43;
                RunPageMode = Create;
                RunPageView = SORTING(Document Profile)
                              WHERE(Document Profile=CONST(Vehicles Trade));
            }
            action("Sales &Order")
            {
                Caption = 'Sales &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 42;
                RunPageMode = Create;
                RunPageView = SORTING(Document Profile)
                              WHERE(Document Profile=CONST(Vehicles Trade));
            }
            action("Sales &Return Order")
            {
                Caption = 'Sales &Return Order';
                Image = ReturnOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 6630;
                RunPageMode = Create;
                RunPageView = SORTING(Document Profile)
                              WHERE(Document Profile=CONST(Vehicles Trade));
            }
            action("Sales &Credit Memo")
            {
                Caption = 'Sales &Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 44;
                RunPageMode = Create;
                RunPageView = SORTING(Document Profile)
                              WHERE(Document Profile=CONST(Vehicles Trade));
            }
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Sales &Journal")
            {
                Caption = 'Sales &Journal';
                Image = Journals;
                RunObject = Page 253;
            }
            action("Sales Price &Worksheet")
            {
                Caption = 'Sales Price &Worksheet';
                Image = Worksheet;
                RunObject = Page 7023;
            }
            separator()
            {
            }
            action("Sales &Prices")
            {
                Caption = 'Sales &Prices';
                Image = SalesPrices;
                RunObject = Page 7002;
            }
            action("Sales &Line Discounts")
            {
                Caption = 'Sales &Line Discounts';
                Image = SalesLineDisc;
                RunObject = Page 7004;
            }
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page 344;
            }
            action("Interaction Log")
            {
                Caption = 'Interaction Log';
                Image = InteractionLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 5076;
            }
        }
    }
}

