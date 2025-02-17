pageextension 50313 pageextension50313 extends "Nonstock Item Card"
{
    // 07.02.2017 EB.P7 EDMS Upgrade 2017
    //   Added fields "Product Group Code"
    // 
    // 12.05.2015 EB.P30 #T019
    //   * Added Page Action:
    //     LinkToItem
    // 
    // 11.02.2014 EDMS P21
    //   Added field:
    //     "Item Disc. Group"
    // 
    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added Page Actions:
    //     - Replacement
    //     - Replacement Overview
    //   * Changed Page Action:
    //     - Substitution
    layout
    {
        addafter("Control 35")
        {
            field("Exchange Unit"; "Exchange Unit")
            {
            }
            field(Inventory; Inventory)
            {
            }
            field("Reserved Qty. on Inventory"; "Reserved Qty. on Inventory")
            {
            }
        }
        addafter("Control 22")
        {
            field("Item Category Code"; "Item Category Code")
            {
            }
            field("Product Group Code"; "Product Group Code")
            {
            }
            field("Product Subgroup Code"; "Product Subgroup Code")
            {
            }
            field("Item Price Group Code"; "Item Price Group Code")
            {
            }
            field("Item Disc. Group"; "Item Disc. Group")
            {
            }
            field("Tariff No."; "Tariff No.")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 44".


        //Unsupported feature: Property Insertion (Name) on "Action 41".

        modify("Action 33")
        {
            Visible = false;
        }
        addfirst("Action 24")
        {
            action("Substituti&ons")
            {
                ApplicationArea = Suite;
                Caption = 'Substituti&ons';
                Image = ItemSubstitution;
                RunObject = Page 5716;
                RunPageLink = Type = CONST(Nonstock Item),
                              No.=FIELD(Entry No.),
                              Entry Type=CONST(Substitution),
                              Substitute Type=CONST(Nonstock Item);
            }
            action(Replacements)
            {
                Caption = 'Replacements';
                Image = ItemSubstitution;
                RunObject = Page 5716;
                                RunPageLink = Type=CONST(Nonstock Item),
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
                    ReplInfoPar: Option " ",Replace,Replacement;
                    TypePar: Option Item,"Nonstock Item";
                    NoPar: Code[20];
                    VariantCodePar: Code[10];
                    PrevTypePar: Option Item,"Nonstock Item";
                    PrevNoPar: Code[20];
                    PrevVariantCodePar: Code[10];
                    CurrKey: Integer;
                    DataBuffer: Record "25006004" temporary;
                    ItemReplOverview: Page "25006094";
                begin
                    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 >>
                    ItemSubstSync.ShowReplacementOverview(TypePar::"Nonstock Item", "Entry No.", '' );
                    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 <<
                end;
            }
        }
        addafter("Action 44")
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
            action("Vehicle Models")
            {
                Caption = 'Vehicle Models';
                Image = Item;

                trigger OnAction()
                begin
                    ShowVehModels
                end;
            }
            group("<Action124>")
            {
                Caption = 'Sales';
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = SalesPrices;
                    RunObject = Page 25006845;
                                    RunPageLink = Nonstock Item Entry No.=FIELD(Entry No.);
                }
                action("<Action1101904008>")
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page 25006846;
                                    RunPageLink = Nonstock Item Entry No.=FIELD(Entry No.);
                }
            }
            group("<Action224>")
            {
                Caption = 'Purchases';
                action("Page Nonstock Purchase Prices")
                {
                    Caption = 'Prices';
                    Image = Price;
                    RunObject = Page 25006847;
                                    RunPageLink = Nonstock Item Entry No.=FIELD(Entry No.);
                }
                action("<Action1101924008>")
                {
                    Caption = 'Line Discounts';
                    Image = Discount;
                    RunObject = Page 25006848;
                                    RunPageLink = Nonstock Item Entry No.=FIELD(Entry No.);
                }
            }
        }
        addafter("Action 41")
        {
            action(LinkToItem)
            {
                Caption = 'Link To Item';
                Image = LinkWithExisting;

                trigger OnAction()
                var
                    NonstockItemManagement: Codeunit "5703";
                begin
                    NonstockItemManagement.LinkToItem("Entry No.");         // 12.05.2015 EB.P30
                end;
            }
        }
    }
}

