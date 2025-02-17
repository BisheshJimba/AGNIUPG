pageextension 50127 pageextension50127 extends "Item List"
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified SetDefFilters(), Usert Profile Setup to Branch Profile Setup
    // 
    // 16.10.2015 EB.P7 #bug
    //   * SetDefFilters modified
    // 
    // 03.04.2014 EB.P7 #Merge MMG7.00
    //   * SocialListeningSetupVisible and Comment ID value changes
    // 
    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Changed "Page Action" : "Replacement Overview"
    //   * Removed field "Replacements Exist"
    //   * It is replaced with the func: NonstockReplacementExist()
    // 
    // 26.03.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Changed Page Actions
    // 
    // 20.03.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added field - "Replacements Exist"
    //   * Added Actions:
    //     - Replacement
    //     - Replacement Overview
    // 
    // 19.03.2014 Elva Baltic P18 #RX004 MMG7.00
    //   Modified function SetDefFilters()
    // 
    // 13.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Added functions GetItemPrice, GetCaptionClassUnitPrice
    //   * Added "Location Filter" from User Profile
    //   * Added function SetDefFilters
    // 
    // 2012.09.10 EDMS, P8
    //   * Added fields "Reserved Qty. On Inventory", "Inventory"

    //Unsupported feature: Property Insertion (Name) on ""Item List"(Page 31)".

    Editable = true;
    Editable = true;
    Editable = Process;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = "Qty. on Service Order EDMS";
    Editable = ABC;
    Editable = "Tariff No.";

    //Unsupported feature: Property Insertion (Name) on ""Item List"(Page 31)".

    Caption = 'Hs Code';
    Editable = false;

    //Unsupported feature: Property Insertion (SourceTableView) on ""Item List"(Page 31)".

    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 26".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1901314507".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1903326807".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1906840407".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1901796907".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 53".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 53".


        //Unsupported feature: Property Deletion (Visible) on "Control 55".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 61".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 61".

        modify("Control 71")
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Visible) on "Control 1102601000".

        modify("Control 3")
        {
            Visible = false;
        }
        addafter("Control 4")
        {
            field("Description 2"; Rec."Description 2")
            {
            }
            field("Item Status"; "Item Status")
            {
            }
            field("Invoiced Inventory Value"; "Invoiced Inventory Value")
            {
            }
            field("Received Inventory Value"; "Received Inventory Value")
            {
            }
            field("Seasonal Factor Code"; "Seasonal Factor Code")
            {
            }
            field("Inventory Holding Period (Day)"; "Inventory Holding Period (Day)")
            {
            }
        }
        addafter("Control 113")
        {
            field("Net Invoiced Qty."; Rec."Net Invoiced Qty.")
            {
                Visible = false;
            }
        }
        addafter("Control 95")
        {
            field(GetSourceNonstockEntryNo; GetSourceNonstockEntryNo)
            {
                Caption = 'Nonstock Item Entry No.';
                Visible = false;
            }
        }
        addafter("Control 97")
        {
            field("Is NLS"; "Is NLS")
            {
            }
            field("Alternative Item No."; Rec."Alternative Item No.")
            {
            }
            field("Model Filter 1"; "Model Filter 1")
            {
            }
        }
        addafter("Control 6")
        {
            field(NonstockReplExists; FORMAT(NonstockRepleacementExists(Rec."No.")))
            {
                Caption = 'Nonstock Replacements Exist';
                Visible = false;
            }
            field("Replacements Exist"; "Replacements Exist")
            {
                Visible = false;
            }
        }
        addafter("Control 59")
        {
            field("Reserved Qty. on Inventory"; Rec."Reserved Qty. on Inventory")
            {
            }
        }
        addafter("Control 67")
        {
            field("Item For"; "Item For")
            {
            }
        }
        addafter("Control 1102601002")
        {
            field("Product Subgroup Code"; "Product Subgroup Code")
            {
                Visible = false;
            }
        }
        addafter("Control 31")
        {
            field(Comment; Rec.Comment)
            {
            }
            field("Unit Cost"; Rec."Unit Cost")
            {
            }
            field("Bin Code"; "Bin Code")
            {
            }
            field("Average Issue"; "Average Issue")
            {
            }
            field(UnitPriceWithVAT; UnitPriceWithVAT)
            {
                Caption = 'Unit Price Includint VAT (View)';
            }
            field("Make Code"; "Make Code")
            {
            }
            field("Model No"; "Model No")
            {
            }
            field("Model Code"; "Model Code")
            {
            }
            field("Local Parts"; "Local Parts")
            {
            }
            field("Item Type"; "Item Type")
            {
            }
            field(CBM; CBM)
            {
            }
        }
        addafter("Control 61")
        {
            field("Cost is Posted to G/L"; Rec."Cost is Posted to G/L")
            {
            }
            field("Modification Date"; "Modification Date")
            {
            }
        }
        addfirst("Control 1900000007")
        {
            part(; 875)
            {
                ApplicationArea = All;
                SubPageLink = Source Type=CONST(Item),
                              Source No.=FIELD(No.);
                                             Visible = SocialListeningVisible;
            }
            part(; 875)
            {
                SubPageLink = Source Type=CONST(Item),
                              Source No.=FIELD(No.);
                                             Visible = SocialListeningVisible;
            }
        }
        moveafter("Control 97"; "Control 99")
        moveafter("Control 8"; "Control 53")
        moveafter("Control 43"; "Control 55")
        moveafter("Control 59"; "Control 63")
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 500".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 28".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 27".


        //Unsupported feature: Property Modification (RunPageLink) on "DimensionsSingle(Action 184)".


        //Unsupported feature: Property Modification (RunPageView) on "Action 14".


        //Unsupported feature: Property Modification (RunPageLink) on ""Prices_LineDiscounts"(Action 1900869004)".

        modify(ManageApprovalWorkflow)
        {
            Caption = '&Picture';

            //Unsupported feature: Property Modification (Image) on "ManageApprovalWorkflow(Action 20)".


            //Unsupported feature: Property Insertion (RunObject) on "ManageApprovalWorkflow(Action 20)".


            //Unsupported feature: Property Insertion (RunPageLink) on "ManageApprovalWorkflow(Action 20)".

        }

        //Unsupported feature: Property Modification (RunPageLink) on "Action 21".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 80".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 78".

        modify(Coupling)
        {

            //Unsupported feature: Property Modification (ActionType) on "Coupling(Action 70)".


            //Unsupported feature: Property Modification (Name) on "Coupling(Action 70)".

            Caption = 'Replacement Overview';

            //Unsupported feature: Property Modification (Image) on "Coupling(Action 70)".

        }

        //Unsupported feature: Property Modification (RunPageLink) on "Action 47".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 77".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 17".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 22".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 15".


        //Unsupported feature: Property Modification (RunPageLink) on ""Sales_LineDiscounts"(Action 34)".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 37".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 114".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 40".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 115".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 105".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 108".



        //Unsupported feature: Code Insertion on "Substitutions(Action 500)".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //var
        //ItemSubst: Record "5715";
        //ItemSubstEntry: Page "5716";
        //begin
        /*
        */
        //end;

        //Unsupported feature: Property Deletion (ToolTipML) on "Action 82".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Action 82".


        //Unsupported feature: Property Deletion (Promoted) on "Action 82".


        //Unsupported feature: Property Deletion (PromotedCategory) on "Action 82".


        //Unsupported feature: Property Deletion (PromotedOnly) on "Action 82".


        //Unsupported feature: Property Deletion (Scope) on "Action 82".


        //Unsupported feature: Property Deletion (ToolTipML) on "Action 28".


        //Unsupported feature: Property Deletion (PromotedCategory) on "Action 27".


        //Unsupported feature: Property Deletion (Scope) on "Action 27".

        modify(ManageApprovalWorkflow)
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on "ManageApprovalWorkflow(Action 20)".


        //Unsupported feature: Property Deletion (ToolTipML) on "ManageApprovalWorkflow(Action 20)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "ManageApprovalWorkflow(Action 20)".


        //Unsupported feature: Property Deletion (Enabled) on "ManageApprovalWorkflow(Action 20)".



        //Unsupported feature: Code Insertion on "ReplacementOverview(Action 70)".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //var
        //ItemSubstSync: Codeunit "25006513";
        //TypePar: Option Item,"Nonstock Item";
        //begin
        /*
        // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 >>
        ItemSubstSync.ShowReplacementOverview(TypePar::"Nonstock Item", GetSourceNonstockEntryNo(), '' );
        // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 <<
        */
        //end;

        //Unsupported feature: Property Deletion (ToolTipML) on "Coupling(Action 70)".

        addafter("Action 121")
        {
            action("Cross Re&ferences")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cross Re&ferences';
                Image = Change;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                RunObject = Page 5721;
                RunPageLink = Item No.=FIELD(No.);
                Scope = Repeater;
                ToolTip = 'Set up a customer''s or vendor''s own identification of the selected item. Cross-references to the customer''s item number means that the item number is automatically shown on sales documents instead of the number that you use.';
            }
            action("E&xtended Texts")
            {
                Caption = 'E&xtended Texts';
                Image = Text;
                RunObject = Page 391;
                                RunPageLink = Table Name=CONST(Item),
                              No.=FIELD(No.);
                RunPageView = SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                Scope = Repeater;
                ToolTip = 'Set up additional text for the description of the selected item. Extended text can be inserted under the Description field on document lines for the item.';
            }
            action(Translations)
            {
                Caption = 'Translations';
                Image = Translations;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                RunObject = Page 35;
                                RunPageLink = Item No.=FIELD(No.),
                              Variant Code=CONST();
                Scope = Repeater;
                ToolTip = 'Set up translated item descriptions for the selected item. Translated item descriptions are automatically inserted on documents according to the language code.';
            }
        }
        addafter(CreateApprovalWorkflow)
        {
            action(ManageApprovalWorkflow)
            {
                ApplicationArea = Suite;
                Caption = 'Manage Approval Workflow';
                Enabled = EnabledApprovalWorkflowsExist;
                Image = WorkflowSetup;
                ToolTip = 'View or edit existing approval workflows for creating or changing items.';

                trigger OnAction()
                var
                    WorkflowManagement: Codeunit "1501";
                begin
                    WorkflowManagement.NavigateToWorkflows(DATABASE::Item,EventFilter);
                end;
            }
        }
        addafter("Action 7380")
        {
            action("<Action1000000006>")
            {
                Caption = 'Update Price Including VAT';

                trigger OnAction()
                begin
                    SalesPrice.UpdatePriceIncludingVAT;
                end;
            }
        }
        addafter("Action 1900805004")
        {
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
        addafter(ApprovalEntries)
        {
            action("Count Records")
            {
                Caption = 'Count Records';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IntCOunt := COUNT;
                    MESSAGE(FORMAT(IntCOunt));
                end;
            }
        }
        addafter("Action 73")
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
        addafter(CRMSynchronizeNow)
        {
            group(Coupling)
            {
                Caption = 'Coupling', Comment='Coupling is a noun';
                Image = LinkAccount;
                ToolTip = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Microsoft Dynamics CRM record.';
            }
        }
        addafter("Action 7")
        {
            action("<Action1101904001>")
            {
                Caption = 'Lost Sale Entries';
                Image = LedgerEntries;
                RunObject = Page 25006858;
                                RunPageLink = Item No.=FIELD(No.);
                RunPageView = SORTING(Item No.);
            }
        }
        addafter("Action 107")
        {
            action("Register Lost Sale")
            {
                Caption = 'Register Lost Sale';
                Image = Register;

                trigger OnAction()
                var
                    LostSalesMgt: Codeunit "25006504";
                begin
                    LostSalesMgt.RegisterLostSale_Item("No."); //EDMS
                end;
            }
            action(Update)
            {
                Image = Update;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    Item: Record "27";
                    FilterPageBuilder: FilterPageBuilder;
                    ItemNo: Code[20];
                begin
                    FilterPageBuilder.ADDRECORD('Item Table',Item);
                    FilterPageBuilder.ADDFIELD('Item Table',Item."No.");
                    FilterPageBuilder.PAGECAPTION := 'Item Page Filter';
                    FilterPageBuilder.RUNMODAL;
                    Item.SETVIEW(FilterPageBuilder.GETVIEW('Item Table'));
                    ItemNo := Item.GETFILTER("No.");


                    Item.RESET;
                    Item.SETRANGE("No.",ItemNo);
                    Item.SETRANGE(Inventory,0);
                    IF Item.FINDFIRST THEN BEGIN
                        Item."Costing Method" := Item."Costing Method"::Average;
                        Item.MODIFY;
                        MESSAGE('The Item of No. %1 costing method has modified to %2',Item."No.",Item."Costing Method");
                     END
                     ELSE
                     ERROR('Inventory is not zero');
                end;
            }
            action(GatePass)
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    StplMgt.CreateGatePass(4,2,"No.",'','');
                end;
            }
        }
        moveafter("Action 121";"Action 145")
        moveafter(CreateApprovalWorkflow;"Action 110")
        moveafter(CRMSynchronizeNow;ManageCRMCoupling)
        moveafter(DeleteCRMCoupling;Coupling)
    }

    var
        LocationFilter: Code[100];
        UserSetup: Record "91";
        DoNotFilterByUserLocation: Boolean;
        Location: Record "14";
        UserProfileSetup: Record "25006067";
        SalesPrice: Record "7002";
        UnitPriceWithVAT: Decimal;
        IntCOunt: Integer;
        StplMgt: Codeunit "50000";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SetSocialListeningFactboxVisibility;
        EnableControls;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        SetSocialListeningFactboxVisibility;
        EnableControls;


        CLEAR(UnitPriceWithVAT);

        SalesPrice.RESET;
        SalesPrice.SETRANGE("Item No.","No.");
        //salesprice.setrnage("sales code","customer price group");
        IF SalesPrice.FINDLAST THEN
          UnitPriceWithVAT := SalesPrice."Unit Price including VAT";
        */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
        SetWorkflowManagementEnabledState;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3
        //13.03.2014 Elva Baltic P1 #X01 MMG7.00 >>
        SetDefFilters;
        //13.03.2014 Elva Baltic P1 #X01 MMG7.00 <<

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
    //end;

    procedure SetDefFilters()
    var
        UserProfileSetup: Record "25006067";
        UserProfileMgt: Codeunit "25006002";
    begin
        IF UserProfileSetup.GET(UserProfileMgt.CurrProfileID) THEN
          IF UserProfileSetup."Def. Spare Part Location Code" <> '' THEN
            SETRANGE("Location Filter",UserProfileSetup."Def. Spare Part Location Code");
    end;

    procedure GetItem(): Code[20]
    begin
        EXIT("No.");
    end;

    procedure SetLocationFilter()
    begin
        DoNotFilterByUserLocation := TRUE;
    end;

    //Unsupported feature: Property Deletion (Scope) on "Action28".


    //Unsupported feature: Property Deletion (ToolTipML) on "Action27".

}

