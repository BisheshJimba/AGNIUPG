page 25006812 "SP Salesperson Role Center"
{
    // 17.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added "Page Req. Wksh. Names" to the menu
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //         Added Page Action:
    //           Page Contract List EDMS
    // 
    // 27.03.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added "Service Order" to the menu
    // 
    // 17.03.2014 Elva Baltic P8 #S0002 MMG7.00
    //   * Added R250024

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group()
            {
                part(; 25006814)
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
            group(Customer)
            {
                Caption = 'Customer';
                action("Customer - &Order Summary")
                {
                    Caption = 'Customer - &Order Summary';
                    Image = "Report";
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
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                action("Salesperson - Sales &Statistics")
                {
                    Caption = 'Salesperson - Sales &Statistics';
                    Image = Statistics;
                    RunObject = Report 114;
                }
                action("Price &List")
                {
                    Caption = 'Price &List';
                    Image = "Report";
                    RunObject = Report 715;
                }
            }
            group(Other)
            {
                Caption = 'Other';
                action("Inventory - Sales &Back Orders")
                {
                    Caption = 'Inventory - Sales &Back Orders';
                    Image = "Report";
                    RunObject = Report 718;
                }
                action("<Action1101904000>")
                {
                    Caption = 'Sales by Item Categories';
                    Image = "Report";
                    RunObject = Report 25006517;
                }
                action("Item Sales Report")
                {
                    Caption = 'Item Sales Report';
                    RunObject = Report 50024;
                }
            }
        }
        area(embedding)
        {
            action("<Action19>")
            {
                Caption = 'Requisition Worksheets';
                RunObject = Page 295;
                RunPageView = WHERE(Template Type=CONST(Req.),
                                    Recurring=CONST(No));
            }
            action("<Action1102159008>")
            {
                Caption = 'Import Requisition';
                RunObject = Page 33019836;
            }
            action("Import Dispatch")
            {
                Caption = 'Import Dispatch';
                RunObject = Page 33019834;
            }
            action("<Action1102159011>")
            {
                Caption = 'Item Sales Cue';
                RunObject = Page 33019838;
            }
            action("Sales Orders")
            {
                Caption = 'Sales Orders';
                RunObject = Page 25006816;
            }
            action("Shipped Not Invoiced")
            {
                Caption = 'Shipped Not Invoiced';
                RunObject = Page 25006816;
                RunPageView = WHERE(Completely Shipped=FILTER(Yes),
                                    Invoice=FILTER(No));
            }
            action("Sales Quotes")
            {
                Caption = 'Sales Quotes';
                Image = Quote;
                RunObject = Page 25006817;
            }
            action("Sales Blanket Orders")
            {
                Caption = 'Sales Blanket Orders';
                RunObject = Page 25006833;
            }
            action("Sales Invoices")
            {
                Caption = 'Sales Invoices';
                RunObject = Page 25006832;
            }
            action("Sales Return Orders")
            {
                Caption = 'Sales Return Orders';
                RunObject = Page 25006819;
            }
            action("Sales Credit Memos")
            {
                Caption = 'Sales Credit Memos';
                RunObject = Page 25006818;
            }
            action(Items)
            {
                Caption = 'Items';
                RunObject = Page 31;
            }
            action(Customers)
            {
                Caption = 'Customers';
                RunObject = Page 22;
            }
            action("Item Journals")
            {
                Caption = 'Item Journals';
                RunObject = Page 262;
                                RunPageView = WHERE(Template Type=CONST(Item),
                                    Recurring=CONST(No));
            }
            action("Sales Journals")
            {
                Caption = 'Sales Journals';
                RunObject = Page 251;
                                RunPageView = WHERE(Template Type=CONST(Sales),
                                    Recurring=CONST(No));
            }
            action("Cash Receipt Journals")
            {
                Caption = 'Cash Receipt Journals';
                Image = Journals;
                RunObject = Page 251;
                                RunPageView = WHERE(Template Type=CONST(Cash Receipts),
                                    Recurring=CONST(No));
            }
            action("Service Orders")
            {
                Caption = 'Service Orders';
                RunObject = Page 25006185;
            }
            action("Requisition Worksheets")
            {
                Caption = 'Requisition Worksheets';
                RunObject = Page 295;
                                RunPageView = WHERE(Template Type=CONST(Req.),
                                    Recurring=CONST(No),
                                    Document Profile=CONST(Spare Parts Trade));
            }
            action(Contracts)
            {
                Caption = 'Contracts';
                RunObject = Page 25006046;
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Shipments")
                {
                    Caption = 'Posted Sales Shipments';
                    RunObject = Page 142;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Spare Parts Trade));
                }
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page 143;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Spare Parts Trade));
                }
                action("Posted Return Receipts")
                {
                    Caption = 'Posted Return Receipts';
                    RunObject = Page 6662;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Spare Parts Trade));
                }
                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    RunObject = Page 144;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Spare Parts Trade));
                }
                action("Posted Purchase Receipts")
                {
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page 145;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Spare Parts Trade));
                }
                action("Posted Purchase Invoices")
                {
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page 146;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Spare Parts Trade));
                }
            }
        }
        area(processing)
        {
            group("New Document")
            {
                Caption = 'New Document';
                action("Sales &Quote")
                {
                    Caption = 'Sales &Quote';
                    Image = Quote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 41;
                                    RunPageMode = Create;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Spare Parts Trade));
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
                                  WHERE(Document Profile=CONST(Spare Parts Trade));
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
                                  WHERE(Document Profile=CONST(Spare Parts Trade));
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
                                  WHERE(Document Profile=CONST(Spare Parts Trade));
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
                                  WHERE(Document Profile=CONST(Spare Parts Trade));
                }
            }
            group(Tasks)
            {
                Caption = 'Tasks';
                action("Sales &Journal")
                {
                    Caption = 'Sales &Journal';
                    Image = Journals;
                    RunObject = Page 253;
                }
                action("Sales Price &Worksheet")
                {
                    Caption = 'Sales Price &Worksheet';
                    Image = PriceWorksheet;
                    RunObject = Page 7023;
                }
            }
            group(Related)
            {
                Caption = 'Related';
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
            }
            group(History)
            {
                Caption = 'History';
                action("Navi&gate")
                {
                    Caption = 'Navi&gate';
                    Image = Navigate;
                    RunObject = Page 344;
                }
            }
        }
    }
}

