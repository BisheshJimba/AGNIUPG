page 25006455 "Model Version Card"
{
    // 26.10.2015 #NAV2016 Merge
    //   Action "Item Tracking Entries" removed;
    // 22.10.2015 NAV2016 Merge
    //   "Next Counting Period" field deleted (deleted in nav2016 standard)

    Caption = 'Model Version Card';
    PageType = Card;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = Table27;
    SourceTableView = SORTING(Item Type)
                      WHERE(Item Type=CONST(Model Version));

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
                    NotBlank = true;

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                    Importance = Promoted;
                }
                field("Assembly BOM"; "Assembly BOM")
                {
                }
                field("Shelf No."; "Shelf No.")
                {
                }
                field("Automatic Ext. Texts"; "Automatic Ext. Texts")
                {
                }
                field("Created From Nonstock Item"; "Created From Nonstock Item")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {

                    trigger OnValidate()
                    begin
                        EnableCostingControls;
                    end;
                }
                field("Product Group Code"; "Product Group Code")
                {
                }
                field("Product Subgroup Code"; "Product Subgroup Code")
                {
                }
                field(Ton; Ton)
                {
                }
                field(CC; CC)
                {
                }
                field("Seat Capacity"; "Seat Capacity")
                {
                }
                field("Search Description"; "Search Description")
                {
                }
                field(Inventory; Inventory)
                {
                    Importance = Promoted;
                }
                field("Qty. on Purch. Order"; "Qty. on Purch. Order")
                {
                }
                field("Qty. on Prod. Order"; "Qty. on Prod. Order")
                {
                }
                field("Qty. on Component Lines"; "Qty. on Component Lines")
                {
                }
                field("Qty. on Sales Order"; "Qty. on Sales Order")
                {
                }
                field("Qty. on Service Order"; "Qty. on Service Order")
                {
                }
                field("Service Item Group"; "Service Item Group")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field("Skip in Vehicle Order Report"; "Skip in Vehicle Order Report")
                {
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Costing Method"; "Costing Method")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        EnableCostingControls;
                    end;
                }
                field("Cost is Adjusted"; "Cost is Adjusted")
                {
                }
                field("Cost is Posted to G/L"; "Cost is Posted to G/L")
                {
                }
                field("Standard Cost"; "Standard Cost")
                {
                    Enabled = StandardCostEnable;

                    trigger OnDrillDown()
                    var
                        ShowAvgCalcItem: Codeunit "5803";
                    begin
                        ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Rec)
                    end;
                }
                field("Unit Cost"; "Unit Cost")
                {
                    Enabled = UnitCostEnable;

                    trigger OnDrillDown()
                    var
                        ShowAvgCalcItem: Codeunit "5803";
                    begin
                        ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Rec)
                    end;
                }
                field("Overhead Rate"; "Overhead Rate")
                {
                }
                field("Indirect Cost %"; "Indirect Cost %")
                {
                }
                field("Last Direct Cost"; "Last Direct Cost")
                {
                }
                field("Price/Profit Calculation"; "Price/Profit Calculation")
                {
                }
                field("Profit %"; "Profit %")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                    Importance = Promoted;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    Importance = Promoted;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                }
                field("Inventory Posting Group"; "Inventory Posting Group")
                {
                    Importance = Promoted;
                }
                field("Net Invoiced Qty."; "Net Invoiced Qty.")
                {
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                }
                field("Item Disc. Group"; "Item Disc. Group")
                {
                }
                field("Sales Unit of Measure"; "Sales Unit of Measure")
                {
                }
            }
            group(Replenishment)
            {
                Caption = 'Replenishment';
                field("Replenishment System"; "Replenishment System")
                {
                    Importance = Promoted;
                    OptionCaption = 'Purchase,Prod. Order';
                }
                group(Purchase)
                {
                    Caption = 'Purchase';
                    field("Vendor No."; "Vendor No.")
                    {
                    }
                    field("Vendor Item No."; "Vendor Item No.")
                    {
                    }
                    field("Purch. Unit of Measure"; "Purch. Unit of Measure")
                    {
                    }
                    field("Lead Time Calculation"; "Lead Time Calculation")
                    {
                    }
                }
                group(Production)
                {
                    Caption = 'Production';
                    field("Manufacturing Policy"; "Manufacturing Policy")
                    {
                    }
                    field("Routing No."; "Routing No.")
                    {
                    }
                    field("Production BOM No."; "Production BOM No.")
                    {
                    }
                    field("Rounding Precision"; "Rounding Precision")
                    {
                    }
                    field("Flushing Method"; "Flushing Method")
                    {
                    }
                    field("Scrap %"; "Scrap %")
                    {
                    }
                    field("Lot Size"; "Lot Size")
                    {
                    }
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                field("Reordering Policy"; "Reordering Policy")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        EnablePlanningControls
                    end;
                }
                field("Include Inventory"; "Include Inventory")
                {
                    Enabled = IncludeInventoryEnable;

                    trigger OnValidate()
                    begin
                        EnablePlanningControls
                    end;
                }
                field(Reserve; Reserve)
                {
                    Importance = Promoted;
                }
                field("Order Tracking Policy"; "Order Tracking Policy")
                {
                }
                field("Stockkeeping Unit Exists"; "Stockkeeping Unit Exists")
                {
                }
                field(Critical; Critical)
                {
                }
                field("Time Bucket"; "Time Bucket")
                {
                    Enabled = ReorderCycleEnable;
                }
                field("Safety Lead Time"; "Safety Lead Time")
                {
                    Enabled = SafetyLeadTimeEnable;
                }
                field("Safety Stock Quantity"; "Safety Stock Quantity")
                {
                    Enabled = SafetyStockQuantityEnable;
                }
                field("Reorder Point"; "Reorder Point")
                {
                    Enabled = ReorderPointEnable;
                }
                field("Reorder Quantity"; "Reorder Quantity")
                {
                    Enabled = ReorderQuantityEnable;
                }
                field("Maximum Inventory"; "Maximum Inventory")
                {
                    Enabled = MaximumInventoryEnable;
                }
                field("Minimum Order Quantity"; "Minimum Order Quantity")
                {
                    Enabled = MinimumOrderQuantityEnable;
                }
                field("Maximum Order Quantity"; "Maximum Order Quantity")
                {
                    Enabled = MaximumOrderQuantityEnable;
                }
                field("Order Multiple"; "Order Multiple")
                {
                    Enabled = OrderMultipleEnable;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("HS Code"; "Tariff No.")
                {
                    Caption = 'HS Code';
                }
                field("Country/Region of Origin Code"; "Country/Region of Origin Code")
                {
                }
                field("Net Weight"; "Net Weight")
                {
                }
                field("Gross Weight"; "Gross Weight")
                {
                }
            }
            group("Item Tracking")
            {
                Caption = 'Item Tracking';
                field("Item Tracking Code"; "Item Tracking Code")
                {
                    Importance = Promoted;
                }
                field("Serial Nos."; "Serial Nos.")
                {
                }
                field("Lot Nos."; "Lot Nos.")
                {
                }
                field("Expiration Calculation"; "Expiration Calculation")
                {
                }
            }
            group("E-Commerce")
            {
                Caption = 'E-Commerce';
                group(BizTalk)
                {
                    Caption = 'BizTalk';
                    field("Common Item No."; "Common Item No.")
                    {
                    }
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                field("Special Equipment Code"; "Special Equipment Code")
                {
                }
                field("Put-away Template Code"; "Put-away Template Code")
                {
                }
                field("Put-away Unit of Measure Code"; "Put-away Unit of Measure Code")
                {
                    Importance = Promoted;
                }
                field("Phys Invt Counting Period Code"; "Phys Invt Counting Period Code")
                {
                    Importance = Promoted;
                }
                field("Last Phys. Invt. Date"; "Last Phys. Invt. Date")
                {
                }
                field("Last Counting Period Update"; "Last Counting Period Update")
                {
                }
                field("Identifier Code"; "Identifier Code")
                {
                }
                field("Use Cross-Docking"; "Use Cross-Docking")
                {
                }
            }
        }
        area(factboxes)
        {
            part("Model Version Pictures"; 25006047)
            {
                Caption = 'Model Version Pictures';
                SubPageLink = Source Type=CONST(27),
                              Source Subtype=CONST(2),
                              Source ID=FIELD(No.),
                              Source Ref. No.=CONST(0);
                SubPageView = SORTING(Source Type,Source Subtype,Source ID,Source Ref. No.,No.);
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
                    Image = Warehouse;
                    RunObject = Page 5701;
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                group("E&ntries")
                {
                    Caption = 'E&ntries';
                    Image = Entries;
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
                    action("Application Worksheet")
                    {
                        Caption = 'Application Worksheet';
                        Image = Worksheet;
                        RunObject = Page 521;
                                        RunPageLink = Item No.=FIELD(No.);
                    }
                }
                group(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action(Statistics)
                    {
                        Caption = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'F7';

                        trigger OnAction()
                        begin
                            ItemStatistics.SetItem(Rec);
                            ItemStatistics.RUNMODAL;
                        end;
                    }
                    action("Entry Statistics")
                    {
                        Caption = 'Entry Statistics';
                        Image = Statistics;
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
                        Image = Turnover;
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
                        ItemsByLocation.SETRECORD(Rec);
                        ItemsByLocation.RUN;
                    end;
                }
                action("Manufacturer Options")
                {
                    Caption = 'Manufacturer Options';
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006450;
                                    RunPageLink = Make Code=FIELD(Make Code),
                                  Model Code=FIELD(Model Code),
                                  Model Version No.=FIELD(No.);
                }
                action("<Action1101901000>")
                {
                    Caption = 'Specification';
                    Image = ExternalDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006001;
                                    RunPageLink = Make Code=FIELD(Make Code),
                                  Model Code=FIELD(Model Code),
                                  Model Version No.=FIELD(No.);
                }
                group("&Item Availability by")
                {
                    Caption = '&Item Availability by';
                    Image = ItemAvailability;
                    action(Period)
                    {
                        Caption = 'Period';
                        Image = Period;
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
                        Image = ItemVariant;
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
                        Image = Warehouse;
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
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                                    RunPageLink = Table ID=CONST(27),
                                  No.=FIELD(No.);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("<Page Object Picture>")
                {
                    Caption = '&Pictures';
                    Image = Picture;
                    RunObject = Page 25006059;
                                    RunPageLink = Source Type=CONST(27),
                                  Source Subtype=CONST(2),
                                  Source ID=FIELD(No.),
                                  Source Ref. No.=CONST(0);
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        // 1st par 25006005 - Vehicle
                        //PictureMgt.ShowObjectPictures(27,"Item Type"::"Model Version","No.",0)
                    end;
                }
                action("&Units of Measure")
                {
                    Caption = '&Units of Measure';
                    Image = UnitOfMeasure;
                    RunObject = Page 5404;
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action("Va&riants")
                {
                    Caption = 'Va&riants';
                    Image = ItemVariant;
                    RunObject = Page 5401;
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action("Cross Re&ferences")
                {
                    Caption = 'Cross Re&ferences';
                    Image = Link;
                    RunObject = Page 5721;
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action("Substituti&ons")
                {
                    Caption = 'Substituti&ons';
                    Image = List;
                    RunObject = Page 5716;
                                    RunPageLink = Type=CONST(Item),
                                  No.=FIELD(No.);
                }
                action("Nonstoc&k Items")
                {
                    Caption = 'Nonstoc&k Items';
                    Image = Item;
                    RunObject = Page 5726;
                }
                action(Translations)
                {
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page 35;
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action("E&xtended Texts")
                {
                    Caption = 'E&xtended Texts';
                    Image = Text;
                    RunObject = Page 391;
                                    RunPageLink = Table Name=CONST(Item),
                                  No.=FIELD(No.);
                    RunPageView = SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                }
                group("Assembly List")
                {
                    Caption = 'Assembly List';
                    Image = AssemblyBOM;
                    action("Bill of Materials")
                    {
                        Caption = 'Bill of Materials';
                        Image = List;
                        RunObject = Page 36;
                                        RunPageLink = Parent Item No.=FIELD(No.);
                    }
                    action("Where-Used List")
                    {
                        Caption = 'Where-Used List';
                        Image = List;
                        RunObject = Page 37;
                                        RunPageLink = Type=CONST(Item),
                                      No.=FIELD(No.);
                        RunPageView = SORTING(Type,No.);
                    }
                    action("Calc. Stan&dard Cost")
                    {
                        Caption = 'Calc. Stan&dard Cost';
                        Image = Calculate;

                        trigger OnAction()
                        begin
                            CLEAR(CalculateStdCost);
                            CalculateStdCost.CalcItem("No.",TRUE);
                        end;
                    }
                }
                group("Manufa&cturing")
                {
                    Caption = 'Manufa&cturing';
                    Image = Production;
                    action("Where-Used")
                    {
                        Caption = 'Where-Used';
                        Image = List;

                        trigger OnAction()
                        begin
                            ProdBOMWhereUsed.SetItem(Rec,WORKDATE);
                            ProdBOMWhereUsed.RUNMODAL;
                        end;
                    }
                    action("Calc. Stan&dard Cost")
                    {
                        Caption = 'Calc. Stan&dard Cost';
                        Image = Calculate;

                        trigger OnAction()
                        begin
                            CLEAR(CalculateStdCost);
                            CalculateStdCost.CalcItem("No.",FALSE);
                        end;
                    }
                }
                action("Ser&vice Items")
                {
                    Caption = 'Ser&vice Items';
                    Image = ServiceItem;
                    RunObject = Page 5988;
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action(Troubleshooting)
                {
                    Caption = 'Troubleshooting';
                    Image = Troubleshoot;
                    RunObject = Page 5993;
                                    RunPageLink = Type=CONST(Item),
                                  No.=FIELD(No.);
                }
                group("R&esource")
                {
                    Caption = 'R&esource';
                    Image = Resource;
                    action("Resource Skills")
                    {
                        Caption = 'Resource Skills';
                        Image = Skills;
                        RunObject = Page 6019;
                                        RunPageLink = Type=CONST(Item),
                                      No.=FIELD(No.);
                    }
                    action("Skilled Resources")
                    {
                        Caption = 'Skilled Resources';
                        Image = Resource;

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
                action(Identifiers)
                {
                    Caption = 'Identifiers';
                    Image = Union;
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
                    RunObject = Page 25006543;
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page 7004;
                                    RunPageLink = Type=CONST(Item),
                                  Code=FIELD(No.);
                    RunPageView = SORTING(Type,Code);
                }
                action("Prepa&yment Percentages")
                {
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
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
                action("Return Orders")
                {
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
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
                    Image = Vendor;
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
                    Image = LineDiscount;
                    RunObject = Page 7014;
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action("Prepa&yment Percentages")
                {
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page 665;
                                    RunPageLink = Item No.=FIELD(No.);
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
                    Image = CreateSKU;

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
                    Image = Calculate;

                    trigger OnAction()
                    var
                        PhysInvtCountMgt: Codeunit "7380";
                    begin
                        PhysInvtCountMgt.UpdateItemPhysInvtCount(Rec);
                    end;
                }
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
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 393;
            }
            action("Item Tracing")
            {
                Caption = 'Item Tracing';
                Image = ItemTracing;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 6520;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnablePlanningControls;
        EnableCostingControls;
    end;

    trigger OnInit()
    begin
        UnitCostEnable := TRUE;
        StandardCostEnable := TRUE;
        IncludeInventoryEnable := TRUE;
        OrderMultipleEnable := TRUE;
        MaximumOrderQuantityEnable := TRUE;
        MinimumOrderQuantityEnable := TRUE;
        MaximumInventoryEnable := TRUE;
        ReorderQuantityEnable := TRUE;
        ReorderPointEnable := TRUE;
        SafetyStockQuantityEnable := TRUE;
        SafetyLeadTimeEnable := TRUE;
        ReorderCycleEnable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        EnableCostingControls;

        //EDMS >>
        "Item Type" := "Item Type"::"Model Version";
        //EDMS <<
    end;

    var
        CalculateStdCost: Codeunit "5812";
        ItemStatistics: Page "5827";
                            ItemsByLocation: Page "491";
                            ProdBOMWhereUsed: Page "99000811";
                            SkilledResourceList: Page "6023";
    [InDataSet]

    ReorderCycleEnable: Boolean;
        [InDataSet]
        SafetyLeadTimeEnable: Boolean;
        [InDataSet]
        SafetyStockQuantityEnable: Boolean;
        [InDataSet]
        ReorderPointEnable: Boolean;
        [InDataSet]
        ReorderQuantityEnable: Boolean;
        [InDataSet]
        MaximumInventoryEnable: Boolean;
        [InDataSet]
        MinimumOrderQuantityEnable: Boolean;
        [InDataSet]
        MaximumOrderQuantityEnable: Boolean;
        [InDataSet]
        OrderMultipleEnable: Boolean;
        [InDataSet]
        IncludeInventoryEnable: Boolean;
        [InDataSet]
        StandardCostEnable: Boolean;
        [InDataSet]
        UnitCostEnable: Boolean;

    [Scope('Internal')]
    procedure EnablePlanningControls()
    var
        PlanningGetParam: Codeunit "99000855";
        ReorderCycleEnabled: Boolean;
        SafetyLeadTimeEnabled: Boolean;
        SafetyStockQtyEnabled: Boolean;
        ReorderPointEnabled: Boolean;
        ReorderQuantityEnabled: Boolean;
        MaximumInventoryEnabled: Boolean;
        MinimumOrderQtyEnabled: Boolean;
        MaximumOrderQtyEnabled: Boolean;
        OrderMultipleEnabled: Boolean;
        IncludeInventoryEnabled: Boolean;
        BoolVar: Boolean;
    begin
        PlanningGetParam.SetUpPlanningControls("Reordering Policy","Include Inventory",
          ReorderCycleEnabled,SafetyLeadTimeEnabled,SafetyStockQtyEnabled,
          ReorderPointEnabled,ReorderQuantityEnabled,MaximumInventoryEnabled,
          MinimumOrderQtyEnabled,MaximumOrderQtyEnabled,OrderMultipleEnabled,IncludeInventoryEnabled,BoolVar,BoolVar,BoolVar,BoolVar,BoolVar);
        ReorderCycleEnable := ReorderCycleEnabled;
        SafetyLeadTimeEnable := SafetyLeadTimeEnabled;
        SafetyStockQuantityEnable := SafetyStockQtyEnabled;
        ReorderPointEnable := ReorderPointEnabled;

        MaximumInventoryEnable := MaximumInventoryEnabled;
        MinimumOrderQuantityEnable := MinimumOrderQtyEnabled;
        MaximumOrderQuantityEnable := MaximumOrderQtyEnabled;
        OrderMultipleEnable := OrderMultipleEnabled;
        IncludeInventoryEnable := IncludeInventoryEnabled;
    end;

    [Scope('Internal')]
    procedure EnableCostingControls()
    begin
        StandardCostEnable := "Costing Method" = "Costing Method"::Standard;
        UnitCostEnable := "Costing Method" <> "Costing Method"::Standard;
    end;
}

