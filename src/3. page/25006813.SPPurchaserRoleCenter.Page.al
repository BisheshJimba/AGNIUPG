page 25006813 "SP Purchaser Role Center"
{
    // 21.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *'Sales Price Worksheet" added to actions
    // 
    // 10.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Report Import Curr.Exch. Rates
    // 
    // 09.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Report "Internal Invoice" added to the menu
    // 
    // 24.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Visible=False set to the following menu items:
    //     - Pending Confirmation
    //     - Purchase Return Orders
    //     - Purchase Analysis Reports
    //   *Added menu items:
    //     - Transfer Orders
    //     - Service Orders

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group()
            {
                part(; 25006815)
                {
                }
                systempart(; Outlook)
                {
                }
            }
            group()
            {
                part(; 9151)
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
            action("Vendor - T&op 10 List")
            {
                Caption = 'Vendor - T&op 10 List';
                Image = "Report";
                RunObject = Report 311;
            }
            action("Vendor/&Item Purchases")
            {
                Caption = 'Vendor/&Item Purchases';
                Image = "Report";
                RunObject = Report 313;
            }
            action("Received Item Journal")
            {
                Caption = 'Received Item Journal';
                Image = "Report";
                RunObject = Report 50017;
            }
            action("Internal Invoice")
            {
                Caption = 'Internal Invoice';
                RunObject = Report 50040;
            }
            action("<Action1102159011>")
            {
                Caption = 'Fill Rate Calculation';
                RunObject = Page 33019840;
            }
            action("Purchase Order (GRN")
            {
                Caption = 'Purchase Order (GRN';
                RunObject = Report 33019835;
            }
            group(Inventory)
            {
                Caption = 'Inventory';
                action("Inventory - &Availability Plan")
                {
                    Caption = 'Inventory - &Availability Plan';
                    Image = "Report";
                    RunObject = Report 707;
                }
                action("Inventory &Purchase Orders")
                {
                    Caption = 'Inventory &Purchase Orders';
                    Image = "Report";
                    RunObject = Report 709;
                }
                action("Inventory - &Vendor Purchases")
                {
                    Caption = 'Inventory - &Vendor Purchases';
                    Image = "Report";
                    RunObject = Report 714;
                }
                action("Inventory &Cost and Price List")
                {
                    Caption = 'Inventory &Cost and Price List';
                    Image = "Report";
                    RunObject = Report 716;
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
            action("Import Requisition")
            {
                Caption = 'Import Requisition';
                RunObject = Page 33019836;
            }
            action("Import Dispatch")
            {
                Caption = 'Import Dispatch';
                RunObject = Page 33019834;
            }
            action("Item Sales Cue")
            {
                Caption = 'Item Sales Cue';
                RunObject = Page 33019838;
            }
            action("Transfer Orders")
            {
                Caption = 'Transfer Orders';
                RunObject = Page 5742;
            }
            action("Purchase Orders")
            {
                Caption = 'Purchase Orders';
                RunObject = Page 25006820;
            }
            action("Pending Confirmation")
            {
                Caption = 'Pending Confirmation';
                RunObject = Page 25006820;
                Visible = false;
            }
            action("Partially Delivered")
            {
                Caption = 'Partially Delivered';
                RunObject = Page 25006820;
                RunPageView = WHERE(Status = FILTER(Released),
                                    Receive = FILTER(Yes),
                                    Completely Received=FILTER(No));
            }
            action("Purchase Quotes")
            {
                Caption = 'Purchase Quotes';
                RunObject = Page 25006834;
            }
            action("Purchase Blanket Orders")
            {
                Caption = 'Purchase Blanket Orders';
                RunObject = Page 25006837;
            }
            action("Purchase Invoices")
            {
                Caption = 'Purchase Invoices';
                RunObject = Page 25006835;
            }
            action("Purchase Return Orders")
            {
                Caption = 'Purchase Return Orders';
                RunObject = Page 25006821;
                                Visible = false;
            }
            action("Purchase Credit Memos")
            {
                Caption = 'Purchase Credit Memos';
                RunObject = Page 25006836;
            }
            action("Sales Orders")
            {
                Caption = 'Sales Orders';
                RunObject = Page 25006816;
            }
            action(Vendors)
            {
                Caption = 'Vendors';
                RunObject = Page 27;
            }
            action(Items)
            {
                Caption = 'Items';
                RunObject = Page 31;
            }
            action("Nonstock Items")
            {
                Caption = 'Nonstock Items';
                RunObject = Page 5726;
            }
            action("Stockkeeping Units")
            {
                Caption = 'Stockkeeping Units';
                RunObject = Page 5701;
            }
            action("Purchase Analysis Reports")
            {
                Caption = 'Purchase Analysis Reports';
                RunObject = Page 9375;
                                RunPageView = WHERE(Analysis Area=FILTER(Purchase));
                Visible = false;
            }
            action("Inventory Analysis Reports")
            {
                Caption = 'Inventory Analysis Reports';
                RunObject = Page 9377;
                                RunPageView = WHERE(Analysis Area=FILTER(Inventory));
            }
            action("Item Journals")
            {
                Caption = 'Item Journals';
                RunObject = Page 262;
                                RunPageView = WHERE(Template Type=CONST(Item),
                                    Recurring=CONST(No));
            }
            action("Purchase Journals")
            {
                Caption = 'Purchase Journals';
                RunObject = Page 251;
                                RunPageView = WHERE(Template Type=CONST(Purchases),
                                    Recurring=CONST(No));
            }
            action("Requisition Worksheets")
            {
                Caption = 'Requisition Worksheets';
                RunObject = Page 295;
                                RunPageView = WHERE(Template Type=CONST(Req.),
                                    Recurring=CONST(No),
                                    Document Profile=CONST(Spare Parts Trade));
            }
            action("Transfer Orders")
            {
                Caption = 'Transfer Orders';
                RunObject = Page 5742;
            }
            action("Service Orders")
            {
                Caption = 'Service Orders';
                RunObject = Page 25006185;
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
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
                action("Posted Return Shipments")
                {
                    Caption = 'Posted Return Shipments';
                    RunObject = Page 6652;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Spare Parts Trade));
                }
                action("Posted Purchase Credit Memos")
                {
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page 147;
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
                action("Purchase &Quote")
                {
                    Caption = 'Purchase &Quote';
                    Image = Quote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 49;
                                    RunPageMode = Create;
                                    RunPageView = WHERE(Document Profile=CONST(Spare Parts Trade));
                }
                action("Purchase &Invoice")
                {
                    Caption = 'Purchase &Invoice';
                    Image = Invoice;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 51;
                                    RunPageMode = Create;
                                    RunPageView = WHERE(Document Profile=CONST(Spare Parts Trade));
                }
                action("Purchase &Order")
                {
                    Caption = 'Purchase &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 50;
                                    RunPageMode = Create;
                                    RunPageView = WHERE(Document Profile=CONST(Spare Parts Trade));
                }
                action("Purchase &Return Order")
                {
                    Caption = 'Purchase &Return Order';
                    Image = ReturnOrder;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 6640;
                                    RunPageMode = Create;
                                    RunPageView = WHERE(Document Profile=CONST(Spare Parts Trade));
                }
            }
            group(Tasks)
            {
                Caption = 'Tasks';
                action("&Purchase Journal")
                {
                    Caption = '&Purchase Journal';
                    Image = Journals;
                    RunObject = Page 254;
                }
                action("Item &Journal")
                {
                    Caption = 'Item &Journal';
                    Image = Journals;
                    RunObject = Page 40;
                }
                action("Order Plan&ning")
                {
                    Caption = 'Order Plan&ning';
                    Image = "Order";
                    RunObject = Page 5522;
                }
            }
            group(Related)
            {
                Caption = 'Related';
                action("Requisition &Worksheet")
                {
                    Caption = 'Requisition &Worksheet';
                    Image = Worksheet;
                    RunObject = Page 295;
                                    RunPageView = WHERE(Template Type=CONST(Req.),
                                        Recurring=CONST(No));
                }
                action("Pur&chase Prices")
                {
                    Caption = 'Pur&chase Prices';
                    Image = Price;
                    RunObject = Page 7012;
                }
                action("Purchase &Line Discounts")
                {
                    Caption = 'Purchase &Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page 7014;
                }
                action("Sales Price Worksheet")
                {
                    Caption = 'Sales Price Worksheet';
                    Image = Worksheet;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 7023;
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

