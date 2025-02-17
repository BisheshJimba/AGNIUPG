page 33020277 "Service Location Item list"
{
    Caption = 'Item List';
    CardPageID = "Item Card";
    Editable = false;
    PageType = List;
    SourceTable = Table27;
    SourceTableView = SORTING(Item Type)
                      WHERE(Item Type=CONST(Item),
                            Location Filter=FILTER(BID-SC-AU),
                            Inventory=FILTER(>0));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No.";"No.")
                {
                }
                field(Description;Description)
                {
                }
                field("Description 2";"Description 2")
                {
                }
                field(Inventory;Inventory)
                {
                }
                field("Product Group Code";"Product Group Code")
                {
                }
                field("Created From Nonstock Item";"Created From Nonstock Item")
                {
                    Visible = false;
                }
                field("Substitutes Exist";"Substitutes Exist")
                {
                }
                field("Is NLS";"Is NLS")
                {
                }
                field("Stockkeeping Unit Exists";"Stockkeeping Unit Exists")
                {
                    Visible = false;
                }
                field("Unit Sales Price with VAT";"Unit Sales Price with VAT")
                {
                    Visible = false;
                }
                field("Model Filter 1";"Model Filter 1")
                {
                }
                label()
                {
                    Visible = false;
                }
                field("Production BOM No.";"Production BOM No.")
                {
                    Visible = false;
                }
                field("Routing No.";"Routing No.")
                {
                    Visible = false;
                }
                field("Base Unit of Measure";"Base Unit of Measure")
                {
                    Visible = false;
                }
                field("Shelf No.";"Shelf No.")
                {
                    Visible = false;
                }
                field("Costing Method";"Costing Method")
                {
                    Visible = false;
                }
                field("Cost is Adjusted";"Cost is Adjusted")
                {
                    Visible = false;
                }
                field("Standard Cost";"Standard Cost")
                {
                    Visible = false;
                }
                field("Price/Profit Calculation";"Price/Profit Calculation")
                {
                    Visible = false;
                }
                field("Profit %";"Profit %")
                {
                    Visible = false;
                }
                field("Inventory Posting Group";"Inventory Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Item Disc. Group";"Item Disc. Group")
                {
                    Visible = false;
                }
                field("Vendor No.";"Vendor No.")
                {
                    Visible = false;
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    Visible = false;
                }
                field("Item For";"Item For")
                {
                }
                field("Tariff No.";"Tariff No.")
                {
                    Visible = false;
                }
                field("Overhead Rate";"Overhead Rate")
                {
                    Visible = false;
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    Visible = false;
                }
                field("Item Category Code";"Item Category Code")
                {
                }
                field("Product Subgroup Code";"Product Subgroup Code")
                {
                    Visible = false;
                }
                field(Blocked;Blocked)
                {
                    Visible = false;
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    Visible = false;
                }
                field("Sales Unit of Measure";"Sales Unit of Measure")
                {
                    Visible = false;
                }
                field("Replenishment System";"Replenishment System")
                {
                    Visible = false;
                }
                field("Purch. Unit of Measure";"Purch. Unit of Measure")
                {
                    Visible = false;
                }
                field("Lead Time Calculation";"Lead Time Calculation")
                {
                    Visible = false;
                }
                field("Manufacturing Policy";"Manufacturing Policy")
                {
                    Visible = false;
                }
                field("Flushing Method";"Flushing Method")
                {
                    Visible = false;
                }
                field("Item Tracking Code";"Item Tracking Code")
                {
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                }
                field("Average Issue";"Average Issue")
                {
                }
            }
        }
        area(factboxes)
        {
            part(;9089)
            {
                SubPageLink = No.=FIELD(No.);
                Visible = true;
            }
            part(;9090)
            {
                SubPageLink = No.=FIELD(No.);
                Visible = false;
            }
            part(;9091)
            {
                SubPageLink = No.=FIELD(No.);
                Visible = true;
            }
            part(;9109)
            {
                SubPageLink = No.=FIELD(No.);
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
            group("&Item")
            {
                Caption = '&Item';
                action("Stockkeepin&g Units")
                {
                    Caption = 'Stockkeepin&g Units';
                    RunObject = Page 5701;
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action("Vehicle Models")
                {
                    Caption = 'Vehicle Models';

                    trigger OnAction()
                    begin
                        ShowItemVehicleModels;
                    end;
                }
                group("E&ntries")
                {
                    Caption = 'E&ntries';
                    action("Ledger E&ntries")
                    {
                        Caption = 'Ledger E&ntries';
                        Image = ItemLedger;
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page 38;
                                        RunPageLink = Item No.=FIELD(No.);
                        RunPageView = SORTING(Item No.);
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("&Reservation Entries")
                    {
                        Caption = '&Reservation Entries';
                        Image = ReservationLedger;
                        RunObject = Page 497;
                                        RunPageLink = Reservation Status=CONST(Reservation),
                                      Item No.=FIELD(No.);
                        RunPageView = SORTING(Item No.,Variant Code,Location Code,Reservation Status);
                    }
                    action("&Phys. Inventory Ledger Entries")
                    {
                        Caption = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        RunObject = Page 390;
                                        RunPageLink = Item No.=FIELD(No.);
                        RunPageView = SORTING(Item No.);
                    }
                    action("&Value Entries")
                    {
                        Caption = '&Value Entries';
                        Image = ValueLedger;
                        RunObject = Page 5802;
                                        RunPageLink = Item No.=FIELD(No.);
                        RunPageView = SORTING(Item No.);
                    }
                    action("Item &Tracking Entries")
                    {
                        Caption = 'Item &Tracking Entries';
                        Image = ItemTrackingLedger;

                        trigger OnAction()
                        var
                            ItemTrackingMgt: Codeunit "6500";
                            ItemTrackingDocMgt: Codeunit "6503";
                        begin
                            //ItemTrackingMgt.CallItemTrackingEntryForm(3,'',"No.",'','','','');
                            ItemTrackingDocMgt.ShowItemTrackingForMasterData(3,'',"No.",'','','','');
                        end;
                    }
                    action("<Action1101904001>")
                    {
                        Caption = 'Lost Sale Entries';
                        RunObject = Page 25006858;
                                        RunPageLink = Item No.=FIELD(No.);
                        RunPageView = SORTING(Item No.);
                    }
                }
                group(Statistics)
                {
                    Caption = 'Statistics';
                    action(Statistics)
                    {
                        Caption = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'F7';

                        trigger OnAction()
                        var
                            ItemStatistics: Page "5827";
                        begin
                            ItemStatistics.SetItem(Rec);
                            ItemStatistics.RUNMODAL;
                        end;
                    }
                    action("Entry Statistics")
                    {
                        Caption = 'Entry Statistics';
                        RunObject = Page 304;
                                        RunPageLink = No.=FIELD(No.),
                                      Date Filter=FIELD(Date Filter),
                                      Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                      Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                      Location Filter=FIELD(Location Filter),
                                      Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                      Variant Filter=FIELD(Variant Filter);
                    }
                    action("T&urnover")
                    {
                        Caption = 'T&urnover';
                        RunObject = Page 158;
                                        RunPageLink = No.=FIELD(No.),
                                      Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                      Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                      Location Filter=FIELD(Location Filter),
                                      Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                      Variant Filter=FIELD(Variant Filter);
                    }
                }
                action("Items b&y Location")
                {
                    Caption = 'Items b&y Location';
                    Image = ItemAvailbyLoc;

                    trigger OnAction()
                    begin
                        //ItemsByLocation.SETRECORD(Rec);
                        //ItemsByLocation.RUN;
                        PAGE.RUN(PAGE::"Items by Location",Rec);
                    end;
                }
                group("&Item Availability by")
                {
                    Caption = '&Item Availability by';
                    action(Period)
                    {
                        Caption = 'Period';
                        RunObject = Page 157;
                                        RunPageLink = No.=FIELD(No.),
                                      Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                      Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                      Location Filter=FIELD(Location Filter),
                                      Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                      Variant Filter=FIELD(Variant Filter);
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';
                        RunObject = Page 5414;
                                        RunPageLink = No.=FIELD(No.),
                                      Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                      Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                      Location Filter=FIELD(Location Filter),
                                      Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                      Variant Filter=FIELD(Variant Filter);
                    }
                    action(Location)
                    {
                        Caption = 'Location';
                        RunObject = Page 492;
                                        RunPageLink = No.=FIELD(No.),
                                      Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                      Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                      Location Filter=FIELD(Location Filter),
                                      Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                      Variant Filter=FIELD(Variant Filter);
                    }
                }
                action("&Bin Contents")
                {
                    Caption = '&Bin Contents';
                    Image = BinContent;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 7379;
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 124;
                                    RunPageLink = Table Name=CONST(Item),
                                  No.=FIELD(No.);
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        RunObject = Page 540;
                                        RunPageLink = Table ID=CONST(27),
                                      No.=FIELD(No.);
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        Caption = 'Dimensions-&Multiple';

                        trigger OnAction()
                        var
                            Item: Record "27";
                            DefaultDimMultiple: Page "542";
                        begin
                            /*CurrPage.SETSELECTIONFILTER(Item);
                            DefaultDimMultiple.SetMultiItem(Item);
                            DefaultDimMultiple.RUNMODAL;
                            */
                            CurrPage.SETSELECTIONFILTER(Item);
                            DefaultDimMultiple.SetMultiItem(Item);
                            DefaultDimMultiple.RUNMODAL;

                        end;
                    }
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    RunObject = Page 346;
                                    RunPageLink = No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                }
                separator()
                {
                }
                action("&Units of Measure")
                {
                    Caption = '&Units of Measure';
                    RunObject = Page 5404;
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action("Va&riants")
                {
                    Caption = 'Va&riants';
                    RunObject = Page 5401;
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action("Cross Re&ferences")
                {
                    Caption = 'Cross Re&ferences';
                    RunObject = Page 5721;
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action("Substituti&ons")
                {
                    Caption = 'Substituti&ons';
                    RunObject = Page 5716;
                                    RunPageLink = Type=CONST(Item),
                                  No.=FIELD(No.);
                }
                action("Nonstoc&k Items")
                {
                    Caption = 'Nonstoc&k Items';
                    RunObject = Page 5726;
                }
                separator()
                {
                }
                action(Translations)
                {
                    Caption = 'Translations';
                    RunObject = Page 35;
                                    RunPageLink = Item No.=FIELD(No.),
                                  Variant Code=CONST();
                }
                action("E&xtended Texts")
                {
                    Caption = 'E&xtended Texts';
                    RunObject = Page 391;
                                    RunPageLink = Table Name=CONST(Item),
                                  No.=FIELD(No.);
                    RunPageView = SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                }
                separator()
                {
                }
                group("Assembly &List")
                {
                    Caption = 'Assembly &List';
                    action("Bill of Materials")
                    {
                        Caption = 'Bill of Materials';
                        RunObject = Page 36;
                                        RunPageLink = Parent Item No.=FIELD(No.);
                    }
                    action("Where-Used List")
                    {
                        Caption = 'Where-Used List';
                        RunObject = Page 37;
                                        RunPageLink = Type=CONST(Item),
                                      No.=FIELD(No.);
                        RunPageView = SORTING(Type,No.);
                    }
                    action("Calc. Stan&dard Cost")
                    {
                        Caption = 'Calc. Stan&dard Cost';

                        trigger OnAction()
                        begin
                            CalculateStdCost.CalcItem("No.",TRUE);
                        end;
                    }
                }
                group("Manuf&acturing")
                {
                    Caption = 'Manuf&acturing';
                    action("Where-Used")
                    {
                        Caption = 'Where-Used';
                        Image = Track;
                        RunObject = Page 37;
                                        RunPageLink = Type=CONST(Item),
                                      No.=FIELD(No.);
                        RunPageView = SORTING(Type,No.);
                    }
                    action("Calc. Stan&dard Cost")
                    {
                        Caption = 'Calc. Stan&dard Cost';

                        trigger OnAction()
                        begin
                            CalculateStdCost.CalcItem("No.",FALSE);
                        end;
                    }
                }
                separator()
                {
                    Caption = '';
                }
                action("Ser&vice Items")
                {
                    Caption = 'Ser&vice Items';
                    RunObject = Page 5988;
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action(Troubleshooting)
                {
                    Caption = 'Troubleshooting';
                    RunObject = Page 5993;
                                    RunPageLink = Type=CONST(Item),
                                  No.=FIELD(No.);
                }
                group("R&esource")
                {
                    Caption = 'R&esource';
                    action("Resource &Skills")
                    {
                        Caption = 'Resource &Skills';
                        RunObject = Page 6019;
                                        RunPageLink = Type=CONST(Item),
                                      No.=FIELD(No.);
                    }
                    action("Skilled R&esources")
                    {
                        Caption = 'Skilled R&esources';

                        trigger OnAction()
                        var
                            ResourceSkill: Record "5956";
                        begin
                            CLEAR(SkilledResourceList);
                            SkilledResourceList.Initialize(ResourceSkill.Type::Item,"No.",Description);
                            SkilledResourceList.RUNMODAL;
                        end;
                    }
                }
                separator()
                {
                }
                action(Identifiers)
                {
                    Caption = 'Identifiers';
                    RunObject = Page 7706;
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.,Variant Code,Unit of Measure Code);
                }
            }
            group("S&ales")
            {
                Caption = 'S&ales';
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page 7002;
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    RunObject = Page 7004;
                                    RunPageLink = Type=CONST(Item),
                                  Code=FIELD(No.);
                    RunPageView = SORTING(Type,Code);
                }
                action("Prepa&yment Percentages")
                {
                    Caption = 'Prepa&yment Percentages';
                    RunObject = Page 664;
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action(Orders)
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page 48;
                                    RunPageLink = Type=CONST(Item),
                                  No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Type,No.);
                }
                action("Returns Orders")
                {
                    Caption = 'Returns Orders';
                    RunObject = Page 6633;
                                    RunPageLink = Type=CONST(Item),
                                  No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Type,No.);
                }
            }
            group("&Purchases")
            {
                Caption = '&Purchases';
                action("Ven&dors")
                {
                    Caption = 'Ven&dors';
                    RunObject = Page 114;
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page 7012;
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    RunObject = Page 7014;
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action("Prepa&yment Percentages")
                {
                    Caption = 'Prepa&yment Percentages';
                    RunObject = Page 665;
                                    RunPageLink = Item No.=FIELD(No.);
                }
                separator()
                {
                }
                action(Orders)
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page 56;
                                    RunPageLink = Type=CONST(Item),
                                  No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Type,No.);
                }
                action("Return Orders")
                {
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page 6643;
                                    RunPageLink = Type=CONST(Item),
                                  No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Type,No.);
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Create Stockkeeping Unit")
                {
                    Caption = '&Create Stockkeeping Unit';

                    trigger OnAction()
                    var
                        Item: Record "27";
                    begin
                        Item.SETRANGE("No.","No.");
                        REPORT.RUNMODAL(REPORT::"Create Stockkeeping Unit",TRUE,FALSE,Item);
                    end;
                }
                action("C&alculate Counting Period")
                {
                    Caption = 'C&alculate Counting Period';

                    trigger OnAction()
                    var
                        PhysInvtCountMgt: Codeunit "7380";
                    begin
                        PhysInvtCountMgt.UpdateItemPhysInvtCount(Rec);
                    end;
                }
                action("Register Lost Sale")
                {
                    Caption = 'Register Lost Sale';

                    trigger OnAction()
                    var
                        LostSalesMgt: Codeunit "25006504";
                    begin
                        LostSalesMgt.RegisterLostSale_Item("No."); //EDMS
                    end;
                }
            }
            action("Sales Prices")
            {
                Caption = 'Sales Prices';
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 7002;
                                RunPageLink = Item No.=FIELD(No.);
                RunPageView = SORTING(Item No.);
            }
            action("Sales Line Discounts")
            {
                Caption = 'Sales Line Discounts';
                Image = SalesLineDisc;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 7004;
                                RunPageLink = Type=CONST(Item),
                              Code=FIELD(No.);
                RunPageView = SORTING(Type,Code);
            }
            action("Requisition Worksheet")
            {
                Caption = 'Requisition Worksheet';
                Image = Worksheet;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 291;
            }
            action("Item Journal")
            {
                Caption = 'Item Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 40;
            }
            action("Item Reclassification Journal")
            {
                Caption = 'Item Reclassification Journal';
                Image = Journals;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 393;
            }
            action("Item Tracing")
            {
                Caption = 'Item Tracing';
                Image = ItemTracing;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 6520;
            }
            action("Adjust Item Cost/Price")
            {
                Caption = 'Adjust Item Cost/Price';
                Image = AdjustItemCost;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Report 794;
            }
            action("Adjust Cost - Item Entries")
            {
                Caption = 'Adjust Cost - Item Entries';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report 795;
            }
            action("Show All Records")
            {
                Caption = 'Show All Records';

                trigger OnAction()
                begin
                    /*RESET;
                    CurrPage.UPDATE;
                    */

                end;
            }
        }
        area(reporting)
        {
            action("Inventory - List")
            {
                Caption = 'Inventory - List';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 701;
            }
            action("Item Register - Quantity")
            {
                Caption = 'Item Register - Quantity';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 703;
            }
            action("Inventory - Transaction Detail")
            {
                Caption = 'Inventory - Transaction Detail';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 704;
            }
            action("Inventory Availability")
            {
                Caption = 'Inventory Availability';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 705;
            }
            action(Status)
            {
                Caption = 'Status';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 706;
            }
            action("Inventory - Availability Plan")
            {
                Caption = 'Inventory - Availability Plan';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 707;
            }
            action("Inventory Order Details")
            {
                Caption = 'Inventory Order Details';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 708;
            }
            action("Inventory Purchase Orders")
            {
                Caption = 'Inventory Purchase Orders';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 709;
            }
            action("Inventory - Top 10 List")
            {
                Caption = 'Inventory - Top 10 List';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 711;
            }
            action("Inventory - Sales Statistics")
            {
                Caption = 'Inventory - Sales Statistics';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 712;
            }
            action("Inventory - Customer Sales")
            {
                Caption = 'Inventory - Customer Sales';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 713;
            }
            action("Inventory - Vendor Purchases")
            {
                Caption = 'Inventory - Vendor Purchases';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 714;
            }
            action("Price List")
            {
                Caption = 'Price List';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 715;
            }
            action("Inventory Cost and Price List")
            {
                Caption = 'Inventory Cost and Price List';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 716;
            }
            action("Inventory - Reorders")
            {
                Caption = 'Inventory - Reorders';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 717;
            }
            action("Inventory - Sales Back Orders")
            {
                Caption = 'Inventory - Sales Back Orders';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 718;
            }
            action("Item/Vendor Catalog")
            {
                Caption = 'Item/Vendor Catalog';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 720;
            }
            action("Inventory - Cost Variance")
            {
                Caption = 'Inventory - Cost Variance';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 721;
            }
            action("Phys. Inventory List")
            {
                Caption = 'Phys. Inventory List';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 722;
            }
            action("Inventory Valuation")
            {
                Caption = 'Inventory Valuation';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 1001;
            }
            action("Nonstock Item Sales")
            {
                Caption = 'Nonstock Item Sales';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5700;
            }
            action("Item Substitutions")
            {
                Caption = 'Item Substitutions';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5701;
            }
            action("Invt. Valuation - Cost Spec.")
            {
                Caption = 'Invt. Valuation - Cost Spec.';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5801;
            }
            action("Inventory Valuation - WIP")
            {
                Caption = 'Inventory Valuation - WIP';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5802;
            }
            action("Item Register - Value")
            {
                Caption = 'Item Register - Value';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5805;
            }
            action("Item Charges - Specification")
            {
                Caption = 'Item Charges - Specification';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5806;
            }
            action("Item Age Composition - Qty.")
            {
                Caption = 'Item Age Composition - Qty.';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5807;
            }
            action("Item Age Composition - Value")
            {
                Caption = 'Item Age Composition - Value';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5808;
            }
            action("Item Expiration - Quantity")
            {
                Caption = 'Item Expiration - Quantity';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5809;
            }
            action("Cost Shares Breakdown")
            {
                Caption = 'Cost Shares Breakdown';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5848;
            }
            action("Detailed Calculation")
            {
                Caption = 'Detailed Calculation';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 99000756;
            }
            action("Rolled-up Cost Shares")
            {
                Caption = 'Rolled-up Cost Shares';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 99000754;
            }
            action("Single-Level Cost Shares")
            {
                Caption = 'Single-Level Cost Shares';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 99000755;
            }
            action("Where Used (Top Level)")
            {
                Caption = 'Where Used (Top Level)';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 99000757;
            }
            action("Quantity Explosion of BOM")
            {
                Caption = 'Quantity Explosion of BOM';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 99000753;
            }
            action("Compare List")
            {
                Caption = 'Compare List';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 99000758;
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*
        //Sipradi-YS * Code to Calculate only User's Location Inventory
        IF NOT DoNotFilterByUserLocation THEN BEGIN
          IF UserSetup.GET(USERID) THEN
            BEGIN
              IF Location.GET(UserSetup."Default Location") THEN BEGIN
                IF Location."Use As Service Location" THEN BEGIN
                  IF UserProfileSetup.GET(UserSetup."Default User Profile Code") THEN BEGIN
                    SETFILTER("Location Filter",'%1',UserProfileSetup."Def. Spare Part Location Code");
                    CALCFIELDS(Inventory);
                  END;
                END
                ELSE BEGIN
                  SETFILTER("Location Filter",'%1',UserSetup."Default Location");
                  CALCFIELDS(Inventory);
                END;
              END;
            END;
        END;
        //Unit Price
        SETFILTER("Customer Price Group",'%1',Location."Default Price Group");
        IF FINDLAST THEN
          CALCFIELDS("Unit Sales Price with VAT");
        //Sipradi-YS End
        */

    end;

    var
        TblshtgHeader: Record "5943";
        CalculateStdCost: Codeunit "5812";
        UserSetup: Record "91";
        DoNotFilterByUserLocation: Boolean;
        Location: Record "14";
        UserProfileSetup: Record "25006067";
        SkilledResourceList: Page "6023";

    [Scope('Internal')]
    procedure GetSelectionFilter(): Code[80]
    var
        Item: Record "27";
        FirstItem: Code[30];
        LastItem: Code[30];
        SelectionFilter: Code[250];
        ItemCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(Item);
        ItemCount := Item.COUNT;
        IF ItemCount > 0 THEN BEGIN
            Item.FIND('-');
            WHILE ItemCount > 0 DO BEGIN
                ItemCount := ItemCount - 1;
                Item.MARKEDONLY(FALSE);
                FirstItem := Item."No.";
                LastItem := FirstItem;
                More := (ItemCount > 0);
                WHILE More DO
                    IF Item.NEXT = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT Item.MARK THEN
                            More := FALSE
                        ELSE BEGIN
                            LastItem := Item."No.";
                            ItemCount := ItemCount - 1;
                            IF ItemCount = 0 THEN
                                More := FALSE;
                        END;
                IF SelectionFilter <> '' THEN
                    SelectionFilter := SelectionFilter + '|';
                IF FirstItem = LastItem THEN
                    SelectionFilter := SelectionFilter + FirstItem
                ELSE
                    SelectionFilter := SelectionFilter + FirstItem + '..' + LastItem;
                IF ItemCount > 0 THEN BEGIN
                    Item.MARKEDONLY(TRUE);
                    Item.NEXT;
                END;
            END;
        END;
        EXIT(SelectionFilter);
    end;

    [Scope('Internal')]
    procedure SetSelection(var Item: Record "27")
    begin
        CurrPage.SETSELECTIONFILTER(Item);
    end;

    [Scope('Internal')]
    procedure GetItem(): Code[20]
    begin
        EXIT("No.");
    end;

    [Scope('Internal')]
    procedure SetLocationFilter()
    begin
        DoNotFilterByUserLocation := TRUE;
    end;
}

