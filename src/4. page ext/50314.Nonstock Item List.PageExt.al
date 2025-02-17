pageextension 50314 pageextension50314 extends "Nonstock Item List"
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified SetDefFilters(), Usert Profile Setup to Branch Profile Setup
    // 
    // 03.03.2015 EDMS P21
    //   Added fields:
    //     Inventory
    //     "Reserved Qty. on Inventory"
    //   Added procedure:
    //     SetDefFilters
    //   Modified trigger:
    //     OnOpenPage
    // 
    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Changed ReplacementOverview OnAction trigger
    // 
    // 31.03.2014 Elva Baltic P18
    //   Rewrote Function GetItemPrice
    //   Changed visibility for field "Entry No." [false] -> [true]
    // 
    // 27.03.2014 Elva Baltic P1 #RX MMG7.00 >>
    //   *Modified function GetItemPrice
    // 
    // 18.03.2014 P18 #RX001 MMG7.00
    //   Added function
    //     GetItemPrice()
    //     GetCaptionClassUnitPrice()

    //Unsupported feature: Property Modification (SourceTableView) on ""Nonstock Item List"(Page 5726)".

    layout
    {
        addafter("Control 6")
        {
            field("Substitutes Exist"; "Substitutes Exist")
            {
                Visible = false;
            }
            field("Replacements Exist"; "Replacements Exist")
            {
                Visible = false;
            }
        }
        addafter("Control 14")
        {
            field(GetItemPrice; GetItemPrice)
            {
                CaptionClass = GetCaptionClassUnitPrice;
                Caption = 'Unit Price';
            }
        }
        addafter("Control 18")
        {
            field("Product Subgroup Code"; "Product Subgroup Code")
            {
            }
        }
        addafter("Control 35")
        {
            field(Inventory; Inventory)
            {
            }
            field("Reserved Qty. on Inventory"; "Reserved Qty. on Inventory")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601004".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601005".

        addafter("Action 1102601004")
        {
            action(Replacements)
            {
                Caption = 'Replacements';
                Image = ItemSubstitution;
                RunObject = Page 5716;
                RunPageLink = Type = CONST(Nonstock Item),
                              No.=FIELD(Entry No.),
                              Entry Type=CONST(Replacement),
                              Substitute Type=CONST(Nonstock Item);
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
                    ItemSubstSync.ShowReplacementOverview(TypePar::"Nonstock Item", "Entry No.", '' );
                    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 <<
                end;
            }
        }
        addafter("Action 1102601005")
        {
            action("<Action184>")
            {
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page 540;
                                RunPageLink = Table ID=CONST(5718),
                              No.=FIELD(Entry No.);
                ShortCutKey = 'Shift+Ctrl+D';
            }
            action("<Action1101904006>")
            {
                Caption = 'Translations';
                Image = Translations;
                RunObject = Page 25006849;
                                RunPageLink = Nonstock Item Entry No.=FIELD(Entry No.);
            }
            action("<Action1101904013>")
            {
                Caption = 'Vehicle Models';
                Image = Item;

                trigger OnAction()
                begin
                    ShowVehModels
                end;
            }
            group(Sales)
            {
                Caption = 'Sales';
                action("<Action36>")
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page 25006845;
                                    RunPageLink = Nonstock Item Entry No.=FIELD(Entry No.);
                    RunPageView = SORTING(Sales Type,Sales Code,Nonstock Item Entry No.,Starting Date,Currency Code,Unit of Measure Code,Minimum Quantity,Location Code,Ordering Price Type Code,Document Profile);
                }
                action("<Action34>")
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page 25006846;
                                    RunPageLink = Nonstock Item Entry No.=FIELD(Entry No.);
                    RunPageView = SORTING(Nonstock Item Entry No.,Sales Type,Sales Code,Starting Date,Currency Code,Unit of Measure Code,Minimum Quantity,Vehicle Status Code,Document Profile);
                }
            }
            group(Purchases)
            {
                Caption = 'Purchases';
                action("<Action39>")
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page 25006847;
                                    RunPageLink = Nonstock Item Entry No.=FIELD(Entry No.);
                    RunPageView = SORTING(Nonstock Item Entry No.,Vendor No.,Starting Date,Currency Code,Unit of Measure Code,Minimum Quantity,Ordering Price Type Code);
                }
                action("<Action42>")
                {
                    Caption = 'Line Discounts';
                    Image = Discount;
                    RunObject = Page 25006848;
                                    RunPageLink = Nonstock Item Entry No.=FIELD(Entry No.);
                    RunPageView = SORTING(Nonstock Item Entry No.,Vendor No.,Starting Date,Currency Code,Unit of Measure Code,Minimum Quantity,Ordering Price Type Code);
                }
            }
        }
        addfirst(processing)
        {
            group("<Action139>")
            {
                Caption = 'F&unctions';
            }
            action("<Action41>")
            {
                Caption = '&Create Item';
                Image = NewItemNonStock;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    NonstockItemMgt: Codeunit "5703";
                begin
                    NonstockItemMgt.NonstockAutoItem(Rec);
                end;
            }
        }
    }


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //begin
        /*
        SetDefFilters;       // 03.03.2015 EDMS P21
        */
    //end;

    procedure GetSelectionFilter(): Code[80]
    var
        recNonstockItem: Record "5718";
        codFirstItem: Code[30];
        codLastItem: Code[30];
        codSelectionFilter: Code[250];
        iItemCount: Integer;
        bMore: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(recNonstockItem);
        iItemCount := recNonstockItem.COUNT;
        IF iItemCount > 0 THEN BEGIN
          recNonstockItem.FIND('-');
          WHILE iItemCount > 0 DO BEGIN
            iItemCount := iItemCount - 1;
            recNonstockItem.MARKEDONLY(FALSE);
            codFirstItem := recNonstockItem."Entry No.";
            codLastItem := codFirstItem;
            bMore := (iItemCount > 0);
            WHILE bMore DO
              IF recNonstockItem.NEXT = 0 THEN
                bMore := FALSE
              ELSE
                IF NOT recNonstockItem.MARK THEN
                  bMore := FALSE
                ELSE BEGIN
                  codLastItem := recNonstockItem."Entry No.";
                  iItemCount := iItemCount - 1;
                  IF iItemCount = 0 THEN
                    bMore := FALSE;
                END;
            IF codSelectionFilter <> '' THEN
              codSelectionFilter := codSelectionFilter + '|';
            IF codFirstItem = codLastItem THEN
              codSelectionFilter := codSelectionFilter + codFirstItem
            ELSE
              codSelectionFilter := codSelectionFilter + codFirstItem + '..' + codLastItem;
            IF iItemCount > 0 THEN BEGIN
              recNonstockItem.MARKEDONLY(TRUE);
              recNonstockItem.NEXT;
            END;
          END;
        END;
        EXIT(codSelectionFilter);
    end;

    procedure GetItemPrice(): Decimal
    var
        SalesPriceCacMgt: Codeunit "7000";
    begin
        // 31.03.2014 Elva Baltic P18 MMG7.00 >>
        EXIT(SalesPriceCacMgt.GetNonstockItemPrice("Entry No.",'',''));
        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;

    procedure GetCaptionClassUnitPrice(): Text[80]
    var
        SalesSetup: Record "311";
        SalesPricesIncVar: Integer;
        Text001: Label 'Unit Price';
    begin
        SalesSetup.GET;
        IF SalesSetup."Def. Sales Price Include VAT" THEN
          SalesPricesIncVar := 1
        ELSE
          SalesPricesIncVar := 0;
        CLEAR(SalesSetup);
        EXIT('2,'+FORMAT(SalesPricesIncVar)+',' + Text001);
    end;

    procedure SetDefFilters()
    var
        UserProfileSetup: Record "25006067";
        UserProfileMgt: Codeunit "25006002";
    begin
        IF UserProfileSetup.GET(UserProfileMgt.CurrProfileID) THEN
          SETRANGE("Location Filter", UserProfileSetup."Def. Spare Part Location Code");
    end;
}

