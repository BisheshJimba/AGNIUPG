pageextension 50125 pageextension50125 extends "Item Card"
{
    // 04.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added "Make Code" field
    // 04.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added "model Code" field
    // 
    // 04.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added "NO" field
    // 
    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Changed "Page Action" : "Replacement Overview"
    // 
    // 24.04.2013 EDMS P8
    //   * IMAGES
    Editable = Process;
    Editable = false;

    //Unsupported feature: Property Insertion (Name) on ""Item Card"(Page 30)".

    Editable = IsEditable;
    Editable = IsVisible;
    Editable = IsVisible;
    Editable = IsVisible;
    Editable = IsVisible;
    Editable = false;
    Editable = IsVisible;
    Editable = IsVisible;
    Editable = true;

    //Unsupported feature: Property Insertion (Name) on ""Item Card"(Page 30)".

    Caption = 'HS Code';
    Editable = IsVisible;
    Editable = false;
    Editable = false;
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "ItemPicture(Control 109)".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 132".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 134".



        //Unsupported feature: Code Modification on "Control 170.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.ItemAttributesFactbox.PAGE.LoadItemAttributesData("No.");
        EnableCostingControls;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CurrPage.ItemAttributesFactbox.PAGE.LoadItemAttributesData("No.");
        //EnableCostingControls; standard code commented
        */
        //end;

        //Unsupported feature: Property Deletion (Importance) on "Control 235".

        addafter(Control4)
        {
            field("Description 2"; Rec."Description 2")
            {
            }
        }
        addafter("Control 166")
        {
            field("Supplier Code"; "Supplier Code")
            {
            }
        }
        addafter("Control 135")
        {
            field("Make Code"; "Make Code")
            {
            }
            field("Model Code"; "Model Code")
            {
            }
            field("Model No"; "Model No")
            {
            }
            field("MOQ (Dealer)"; "MOQ (Dealer)")
            {
            }
        }
        addafter("Control 170")
        {
            field("Item Movement Category"; "Item Movement Category")
            {
            }
        }
        addafter("Control 168")
        {
            field("Alternative Item No."; Rec."Alternative Item No.")
            {
            }
            field("Product Subgroup Code"; "Product Subgroup Code")
            {
            }
            field("Item For"; "Item For")
            {
            }
            field("Local Parts"; "Local Parts")
            {
            }
            field("Is NLS"; "Is NLS")
            {
            }
        }
        addafter("Control 97")
        {
            field("Purchase Type"; "Purchase Type")
            {
            }
            field(Saved; Saved)
            {
                Editable = false;
            }
            field(ABC; ABC)
            {
            }
            field(CBM; CBM)
            {
            }
        }
        addafter("Control 189")
        {
            field("Qty. on Service Order EDMS"; "Qty. on Service Order EDMS")
            {
            }
            field("Res. Qty. on Serv. Orders EDMS"; "Res. Qty. on Serv. Orders EDMS")
            {
            }
        }
        addafter("Control 73")
        {
            field("Inventory Value Zero"; Rec."Inventory Value Zero")
            {
            }
        }
        addafter("Control 1901343701")
        {
            group("FMS/ABC")
            {
                Caption = 'FMS/ABC';
                Editable = true;
                field("ABC-FMS"; "ABC-FMS")
                {
                }
                field("Movement Code (MC)"; "Movement Code (MC)")
                {
                }
                field("Inventory Holding Period (Day)"; "Inventory Holding Period (Day)")
                {
                }
                field("Item Status"; "Item Status")
                {
                }
                field("Status Description"; "Status Description")
                {
                }
            }
        }
        addafter("Control 1907509201")
        {
            group("Battery Service")
            {
                Caption = 'Battery Service';
                field("NDP Rate"; "NDP Rate")
                {
                }
                field("Scrap No."; "Scrap No.")
                {
                    Caption = ' Scrap No.';
                }
                field(IsScrap; IsScrap)
                {
                    Caption = ' Is Scrap';
                    Visible = false;
                }
                field("Ampere Per Hour"; "Ampere Per Hour")
                {
                }
                field("Scrap Amount"; "Scrap Amount")
                {
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 80".


        //Unsupported feature: Property Modification (RunPageView) on "Action 105".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 75".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 184".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 117".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 158".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 110".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 77".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 69".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 108".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 111".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 106".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 87".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 191".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 83".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 163".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 96".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 185".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 187".

        modify("Action 241")
        {
            Visible = false;
        }
        modify(ApplyTemplate)
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (ToolTipML) on "Action 105".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Action 105".


        //Unsupported feature: Property Deletion (PromotedIsBig) on "Action 105".


        //Unsupported feature: Property Deletion (ToolTipML) on "Action 112".


        //Unsupported feature: Property Deletion (Promoted) on "Action 112".


        //Unsupported feature: Property Deletion (PromotedIsBig) on "Action 112".


        //Unsupported feature: Property Deletion (PromotedCategory) on "Action 112".

        addafter("Action 218")
        {
            action("Sync To Dealer ERP")
            {
                Image = Task;
                ToolTip = 'This action will sync item and its prices to Dealer ERP manually.';
                Visible = true;

                trigger OnAction()
                var
                    SuppliertoDealerIntegration: Report "33020511";
                    Item: Record "27";
                begin
                    //SRT Feb 4th 2020 >>
                    IF NOT CONFIRM('Do you want to manually sync item %1 to Agni Master?', FALSE, Rec."No.") THEN
                        EXIT;

                    Item.SETRANGE("No.", Rec."No.");
                    Item.FINDFIRST;
                    CLEAR(SuppliertoDealerIntegration);
                    SuppliertoDealerIntegration.SetCalledFromItemCard(Item);
                    SuppliertoDealerIntegration.RUN;

                    //SRT feb 4th 2020 <<
                end;
            }
        }
        addafter(CalculateCountingPeriod)
        {
            separator()
            {
            }
        }
        addafter(Templates)
        {
            action(ApplyTemplate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Apply Template';
                Ellipsis = true;
                Image = ApplyTemplate;
                ToolTip = 'Use a template to quickly create a new item card.';

                trigger OnAction()
                var
                    ItemTemplate: Record "1301";
                begin
                    ItemTemplate.UpdateItemFromTemplate(Rec);
                end;
            }
        }
        addafter(SaveAsTemplate)
        {
            action("<Action1101904001>")
            {
                Caption = 'Register Lost Sale';
                Image = Register;

                trigger OnAction()
                var
                    LostSalesMgt: Codeunit "25006504";
                begin
                    LostSalesMgt.RegisterLostSale_Item(Rec."No."); //EDMS
                end;
            }
        }
        addafter("Action 1902532604")
        {
            action(Save)
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to save the Item card?') THEN BEGIN //MIN 4/28/2019
                        Saved := TRUE;
                        Rec.MODIFY;
                    END;
                    Rec.TESTFIELD("No.");
                    Rec.TESTFIELD(Description);
                    Rec.TESTFIELD("Base Unit of Measure");
                    Rec.TESTFIELD("Gen. Prod. Posting Group");
                    Rec.TESTFIELD("VAT Prod. Posting Group");
                    Rec.TESTFIELD("Inventory Posting Group");

                    IF Rec."Inventory Posting Group" <> 'SUNDRYAST' THEN BEGIN
                        Rec.TESTFIELD("Make Code");
                        Rec.TESTFIELD("Purchase Type");
                    END;
                    IF Rec."Inventory Posting Group" = 'SUNDRYAST' THEN
                        Rec.TESTFIELD("Inventory Value Zero");
                end;
            }
        }
        addfirst("Action 1900000003")
        {
            group(History)
            {
                Caption = 'History';
                Image = History;
                group("E&ntries")
                {
                    Caption = 'E&ntries';
                    Image = Entries;
                    action("Ledger E&ntries")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ledger E&ntries';
                        Image = ItemLedger;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Category5;
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = true;
                        RunObject = Page 38;
                        RunPageLink = Item No.=FIELD(No.);
                        RunPageView = SORTING(Item No.)
                                      ORDER(Descending);
                        ShortCutKey = 'Ctrl+F7';
                        ToolTip = 'View the history of transactions that have been posted for the selected record.';
                    }
                    action("&Phys. Inventory Ledger Entries")
                    {
                        Caption = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        Promoted = true;
                        PromotedCategory = Category5;
                        PromotedIsBig = true;
                        RunObject = Page 390;
                                        RunPageLink = Item No.=FIELD(No.);
                        RunPageView = SORTING(Item No.);
                        ToolTip = 'View how many units of the item you had in stock at the last physical count.';
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
                            ItemTrackingDocMgt: Codeunit "6503";
                        begin
                            ItemTrackingDocMgt.ShowItemTrackingForMasterData(3,'',"No.",'','','','');
                        end;
                    }
                    action("&Warehouse Entries")
                    {
                        Caption = '&Warehouse Entries';
                        Image = BinLedger;
                        RunObject = Page 7318;
                                        RunPageLink = Item No.=FIELD(No.);
                        RunPageView = SORTING(Item No.,Bin Code,Location Code,Variant Code,Unit of Measure Code,Lot No.,Serial No.,Entry Type,Dedicated);
                    }
                    action("Application Worksheet")
                    {
                        Caption = 'Application Worksheet';
                        Image = ApplicationWorksheet;
                        RunObject = Page 521;
                                        RunPageLink = Item No.=FIELD(No.);
                    }
                }
            }
        }
        addafter("Action 184")
        {
            action("Substituti&ons")
            {
                Caption = 'Substituti&ons';
                Image = ItemSubstitution;
                RunObject = Page 5716;
                                RunPageLink = Type=CONST(Item),
                              No.=FIELD(No.),
                              Entry Type=CONST(Substitution),
                              Substitute Type=CONST(Item);
            }
            action(ReplacementOverview)
            {
                Caption = 'Replacement Overview';
                Image = ItemSubstitution;

                trigger OnAction()
                var
                    ItemSubstSync: Codeunit "25006513";
                    TypePar: Option Item,"Nonstock Item";
                begin
                    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 >>
                    ItemSubstSync.ShowReplacementOverview(TypePar::"Nonstock Item", GetSourceNonstockEntryNo(), '' );
                    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 <<
                end;
            }
        }
        addfirst("Action 126")
        {
            action("Vehicle Models")
            {
                Caption = 'Vehicle Models';
                Image = ListPage;

                trigger OnAction()
                begin
                    ShowItemVehicleModels;
                end;
            }
        }
        addafter("Action 237")
        {
            action("Lost Sale Entries")
            {
                Caption = 'Lost Sale Entries';
                Image = LedgerEntries;
                RunObject = Page 25006858;
                                RunPageLink = Item No.=FIELD(No.);
                RunPageView = SORTING(Item No.);
            }
            action("<Action1102159013>")
            {
                Caption = 'Print Barcode Label';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    itemRec.RESET;
                    itemRec.SETRANGE("No.","No.");
                    IF itemRec.FINDFIRST THEN
                    REPORT.RUNMODAL(50060,TRUE,FALSE,itemRec);
                end;
            }
        }
        moveafter("Action 1900000003";"Action 190")
        moveafter("Action 105";"Action 75")
    }

    var
        UserSetup: Record "91";
        ItemForFilter: Text[250];
        [InDataSet]
        ISVisible: Boolean;
        UoM: Record "5404";
        itemRec: Record "27";
        SaveItemPageConf: Label 'You must first save the item card page before close it.';
        InventorySetup: Record "313";
        IsEditable: Boolean;
        StplMgt: Codeunit "50000";


    //Unsupported feature: Code Modification on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        InitControls
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        InitControls;

        UserSetup.GET(USERID);
        IF UserSetup."Can See Cost" THEN
          ISVisible :=TRUE
        ELSE
          ISVisible := FALSE;

        IF UserSetup."Can Edit Item Description" THEN
          IsEditable := TRUE
        ELSE
          IsEditable := FALSE;
        */
    //end;


    //Unsupported feature: Code Modification on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //>>>> ORIGINAL CODE:
    //begin
        /*
        OnNewRec
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
                        OnNewRec;
        EnablePlanningControls;
        EnableCostingControls;

        "Price/Profit Calculation" := "Price/Profit Calculation"::"No Relationship";
        //EDMS >>
        "Item Type" := "Item Type"::Item;
        //EDMS <<

        CASE ItemForFilter OF
          FORMAT("Item For"::BTD) :
            "Item For" := "Item For"::BTD;
        END;
         "Costing Method" := "Costing Method"::Average;
        */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
        EnableControls;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*

        //Sipradi-YS * Code to Calculate only User's Location Inventory
        IF UserSetup.GET(USERID) THEN
        BEGIN
          SETFILTER("Location Filter",'%1',UserSetup."Default Location");
          CALCFIELDS(Inventory);
        END;
        //Sipradi-YS End

        IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
        EnableControls;
        */
    //end;


    //Unsupported feature: Code Insertion on "OnQueryClosePage".

    //trigger OnQueryClosePage(CloseAction: Action): Boolean
    //begin
        /*
        IF NOT Saved THEN //MIN 5/2/2019
         // ERROR(SaveItemPageConf);
        */
    //end;


    //Unsupported feature: Code Modification on "InitControls(PROCEDURE 12)".

    //procedure InitControls();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        UnitCostEnable := TRUE;
        StandardCostEnable := TRUE;
        OverflowLevelEnable := TRUE;
        #4..16
        TimeBucketEnable := TRUE;

        InventoryItemEditable := Type = Type::Inventory;
        "Costing Method" := "Costing Method"::FIFO;
        UnitCostEditable := TRUE;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..19
        //"Costing Method" := "Costing Method"::FIFO;
        UnitCostEditable := TRUE;
        {InventorySetup.GET; //Min
        "Costing Method" := InventorySetup."Default Costing Method";}
        */
    //end;
}

