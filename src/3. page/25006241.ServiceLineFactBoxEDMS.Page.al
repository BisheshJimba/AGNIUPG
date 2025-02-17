page 25006241 "Service Line FactBox EDMS"
{
    // 12.05.2015 EB.P30 #T030
    //   Added field:
    //     "Res. Cost Amount Total"
    // 
    // 17.12.2014 EDMS P12
    //   * Moved code form trigger OnLookup to OnDrillDown for field "Replacements Exist"
    // 
    // 08.09.2014 Elva baltic P8 #F0015 EDMS
    //   * Added field Item."Replacements Exist"

    Caption = 'Service Line Details';
    PageType = CardPart;
    SourceTable = Table25006146;

    layout
    {
        area(content)
        {
            field("No."; "No.")
            {
                Caption = 'Item No.';
                Lookup = false;

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field(STRSUBSTNO('%1',ServiceInfoPaneMgt.CalcAvailability(Rec));STRSUBSTNO('%1',ServiceInfoPaneMgt.CalcAvailability(Rec)))
            {
                Caption = 'Availability';
                DecimalPlaces = 2:0;
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    ItemAvailability(0);
                    CurrPage.UPDATE(TRUE);
                end;
            }
            field(STRSUBSTNO('%1',ServiceInfoPaneMgt.CalcNoOfSubstitutions(Rec));STRSUBSTNO('%1',ServiceInfoPaneMgt.CalcNoOfSubstitutions(Rec)))
            {
                Caption = 'Substitutions';
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    ShowItemSub;
                    CurrPage.UPDATE;
                end;
            }
            field(STRSUBSTNO('%1',ServiceInfoPaneMgt.CalcNoOfSalesPrices(Rec));STRSUBSTNO('%1',ServiceInfoPaneMgt.CalcNoOfSalesPrices(Rec)))
            {
                Caption = 'Sales Prices';
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    ShowPrices;
                    CurrPage.UPDATE;
                end;
            }
            field(STRSUBSTNO('%1',ServiceInfoPaneMgt.CalcNoOfSalesLineDisc(Rec));STRSUBSTNO('%1',ServiceInfoPaneMgt.CalcNoOfSalesLineDisc(Rec)))
            {
                Caption = 'Sales Line Discounts';
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    ShowLineDisc;
                    CurrPage.UPDATE;
                end;
            }
            field(Item."Replacements Exist";Item."Replacements Exist")
            {
                Caption = 'Replacements Exist';

                trigger OnDrillDown()
                var
                    ItemSubstSync: Codeunit "25006513";
                    TypePar: Option Item,"Nonstock Item";
                begin
                    ItemSubstSync.ShowReplacementOverview(TypePar::"Nonstock Item", Item.GetSourceNonstockEntryNo(), '' );
                end;
            }
            field("Res. Cost Amount Total";"Res. Cost Amount Total")
            {
            }
            field(STRSUBSTNO('%1',ServiceInfoPaneMgt.GetNoofShippedItems(Rec));STRSUBSTNO('%1',ServiceInfoPaneMgt.GetNoofShippedItems(Rec)))
            {
                Caption = 'No. of Shipped Items';
            }
            field(STRSUBSTNO('%1',ServiceInfoPaneMgt.GetNoofReceivedItems(Rec));STRSUBSTNO('%1',ServiceInfoPaneMgt.GetNoofReceivedItems(Rec)))
            {
                Caption = 'No. of Received Items';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IF NOT Item.GET("No.") THEN  //08.09.2014 Elva baltic P8 #F0015 EDMS
          Item.INIT;
        Item.CALCFIELDS("Replacements Exist");
    end;

    var
        ServiceHeader: Record "25006145";
        Item: Record "27";
        SalesPriceCalcMgt: Codeunit "7000";
        ServiceInfoPaneMgt: Codeunit "25006104";

    [Scope('Internal')]
    procedure ShowDetails()
    var
        Item: Record "27";
    begin
        IF Type = Type::Item THEN BEGIN
          Item.GET("No.");
          PAGE.RUN(PAGE::"Item Card",Item);
        END;
    end;

    [Scope('Internal')]
    procedure ShowPrices()
    var
        ServiceHeader: Record "25006145";
    begin
        ServiceHeader.GET("Document Type","Document No.");
        SalesPriceCalcMgt.GetDMSServLinePrice(ServiceHeader,Rec);
    end;

    [Scope('Internal')]
    procedure ShowLineDisc()
    var
        recServiceHeader: Record "25006145";
    begin
        ServiceHeader.GET("Document Type","Document No.");
        SalesPriceCalcMgt.GetDMSServLineLineDisc(ServiceHeader,Rec);
    end;
}

