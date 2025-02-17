page 25006548 "Vehicle Whse. Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group()
            {
                part(; 25006549)
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
            action("Warehouse &Bin List")
            {
                Caption = 'Warehouse &Bin List';
                Image = "Report";
                RunObject = Report 7319;
            }
            action("Physical &Inventory List")
            {
                Caption = 'Physical &Inventory List';
                Image = "Report";
                RunObject = Report 722;
            }
            action("Customer &Labels")
            {
                Caption = 'Customer &Labels';
                Image = "Report";
                RunObject = Report 110;
            }
            action("<Action1101904001>")
            {
                Caption = 'Vehicle Inventory Overview';
                Image = "Report";
                RunObject = Report 25006309;
            }
        }
        area(embedding)
        {
            action("Sales Orders")
            {
                Caption = 'Sales Orders';
                RunObject = Page 25006466;
            }
            action(Released)
            {
                Caption = 'Released';
                RunObject = Page 25006466;
                RunPageView = WHERE(Status = FILTER(Released));
            }
            action("Partially Shipped")
            {
                Caption = 'Partially Shipped';
                RunObject = Page 25006466;
                RunPageView = WHERE(Status = FILTER(Released),
                                    Completely Shipped=FILTER(No));
            }
            action("Purchase Return Orders")
            {
                Caption = 'Purchase Return Orders';
                RunObject = Page 25006465;
                                RunPageView = WHERE(Document Type=FILTER(Return Order));
            }
            action("Transfer Orders")
            {
                Caption = 'Transfer Orders';
                Image = Document;
                RunObject = Page 25006467;
            }
            action("Purchase Orders")
            {
                Caption = 'Purchase Orders';
                RunObject = Page 25006464;
            }
            action(Released)
            {
                Caption = 'Released';
                RunObject = Page 25006464;
                                RunPageView = WHERE(Status=FILTER(Released));
            }
            action("Partially Received")
            {
                Caption = 'Partially Received';
                RunObject = Page 25006464;
                                RunPageView = WHERE(Status=FILTER(Released),
                                    Completely Received=FILTER(No));
            }
            action("Sales Return Orders")
            {
                Caption = 'Sales Return Orders';
                RunObject = Page 25006473;
            }
            action(Vehicles)
            {
                Caption = 'Vehicles';
                RunObject = Page 25006033;
            }
            action(Customers)
            {
                Caption = 'Customers';
                RunObject = Page 22;
            }
            action(Vendors)
            {
                Caption = 'Vendors';
                RunObject = Page 27;
            }
            action("Shipping Agents")
            {
                Caption = 'Shipping Agents';
                RunObject = Page 428;
            }
            action("Item Reclassification Journals")
            {
                Caption = 'Item Reclassification Journals';
                RunObject = Page 262;
                                RunPageView = WHERE(Template Type=CONST(Transfer),
                                    Recurring=CONST(No));
            }
            action("Phys. Inventory Journals")
            {
                Caption = 'Phys. Inventory Journals';
                RunObject = Page 262;
                                RunPageView = WHERE(Template Type=CONST(Phys. Inventory),
                                    Recurring=CONST(No));
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Invt. Picks")
                {
                    Caption = 'Posted Invt. Picks';
                    Image = PostedInventoryPick;
                    RunObject = Page 7395;
                }
                action("Posted Sales Shipment")
                {
                    Caption = 'Posted Sales Shipment';
                    Image = PostedShipment;
                    RunObject = Page 142;
                }
                action("Posted Transfer Shipments")
                {
                    Caption = 'Posted Transfer Shipments';
                    Image = PostedShipment;
                    RunObject = Page 5752;
                }
                action("Posted Return Shipments")
                {
                    Caption = 'Posted Return Shipments';
                    Image = PostedShipment;
                    RunObject = Page 6652;
                }
                action("Posted Invt. Put-aways")
                {
                    Caption = 'Posted Invt. Put-aways';
                    Image = PostedPutAway;
                    RunObject = Page 7394;
                }
                action("Posted Transfer Receipts")
                {
                    Caption = 'Posted Transfer Receipts';
                    Image = PostedReceipt;
                    RunObject = Page 5753;
                }
                action("Posted Purchase Receipts")
                {
                    Caption = 'Posted Purchase Receipts';
                    Image = PostedReceipt;
                    RunObject = Page 145;
                }
                action("Posted Return Receipts")
                {
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page 6662;
                }
            }
        }
        area(processing)
        {
            group(Document)
            {
                Caption = 'Document';
                action("T&ransfer Order")
                {
                    Caption = 'T&ransfer Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 5740;
                                    RunPageMode = Create;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
                action("&Purchase Order")
                {
                    Caption = '&Purchase Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 50;
                                    RunPageMode = Create;
                                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Vehicles Trade));
                }
            }
            group(Related)
            {
                Caption = 'Related';
                action("Inventory Pi&ck")
                {
                    Caption = 'Inventory Pi&ck';
                    Image = InventoryPick;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 7377;
                                    RunPageMode = Create;
                }
                action("Inventory P&ut-away")
                {
                    Caption = 'Inventory P&ut-away';
                    Image = Warehouse;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 7375;
                                    RunPageMode = Create;
                }
            }
            group(Tasks)
            {
                Caption = 'Tasks';
                action("Edit Item Reclassification &Journal")
                {
                    Caption = 'Edit Item Reclassification &Journal';
                    Image = Journal;
                    RunObject = Page 393;
                }
            }
            group(History)
            {
                Caption = 'History';
                action("Item &Tracing")
                {
                    Caption = 'Item &Tracing';
                    Image = ItemTracing;
                    RunObject = Page 6520;
                }
            }
        }
    }
}

