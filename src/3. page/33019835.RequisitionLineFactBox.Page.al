page 33019835 "Requisition Line FactBox"
{
    Caption = 'Availability';
    PageType = CardPart;
    SourceTable = Table246;

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
            field(STRSUBSTNO('%1',ServiceInfoPaneMgt.CalcAvailabilityForRequisition(Rec));STRSUBSTNO('%1',ServiceInfoPaneMgt.CalcAvailabilityForRequisition(Rec)))
            {
                Caption = 'Availability';
                DecimalPlaces = 2:0;
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    //ItemAvailability(0); Commented because function could not be found by Sulav
                    CurrPage.UPDATE(TRUE);
                end;
            }
        }
    }

    actions
    {
    }

    var
        ServiceHeader: Record "25006145";
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
}

