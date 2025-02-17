page 25006506 "Vehicle Purchaser Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group()
            {
                part(; 25006507)
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
                action("Vehicle Purchase Overview")
                {
                    Caption = 'Vehicle Purchase Overview';
                    Image = "Report";
                    RunObject = Report 25006307;
                }
            }
        }
        area(embedding)
        {
            action("Purchase Orders")
            {
                Caption = 'Purchase Orders';
                RunObject = Page 25006464;
            }
            action("Purchase Quotes")
            {
                Caption = 'Purchase Quotes';
                RunObject = Page 25006535;
            }
            action("Purchase Invoices")
            {
                Caption = 'Purchase Invoices';
                RunObject = Page 25006536;
            }
            action("Purchase Return Orders")
            {
                Caption = 'Purchase Return Orders';
                RunObject = Page 25006465;
            }
            action("Purchase Credit Memos")
            {
                Caption = 'Purchase Credit Memos';
                RunObject = Page 25006537;
            }
            action("Sales Orders")
            {
                Caption = 'Sales Orders';
                RunObject = Page 25006466;
            }
            action(Vehicles)
            {
                Caption = 'Vehicles';
                RunObject = Page 25006033;
            }
            action(Vendors)
            {
                Caption = 'Vendors';
                RunObject = Page 27;
            }
            action("Purchase Analysis Reports")
            {
                Caption = 'Purchase Analysis Reports';
                RunObject = Page 9375;
                RunPageView = WHERE(Analysis Area=FILTER(Purchase));
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
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
                action("Posted Purchase Invoices")
                {
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page 146;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
                action("Posted Return Shipments")
                {
                    Caption = 'Posted Return Shipments';
                    RunObject = Page 6652;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
                action("Posted Purchase Credit Memos")
                {
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page 147;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
                action("<Action1101904001>")
                {
                    Caption = 'Purchase Order Archives';
                    RunObject = Page 9347;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
            }
        }
        area(processing)
        {
            group(Document)
            {
                Caption = 'Document';
                action("Purchase &Quote")
                {
                    Caption = 'Purchase &Quote';
                    Image = Quote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 49;
                                    RunPageMode = Create;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
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
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
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
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
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
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
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
}

