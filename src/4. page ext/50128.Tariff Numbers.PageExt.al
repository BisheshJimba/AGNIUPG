pageextension 50128 pageextension50128 extends "Tariff Numbers"
{
    Caption = 'HS Codes';
    layout
    {
        addafter("Control 6")
        {
            field("Show HS Code"; Rec."Show HS Code")
            {
                Editable = false;
            }
        }
    }
    actions
    {

        addfirst(processing)
        {
            action(Reset)
            {
                Image = RefreshText;
            }
        }
    }

    var
        InventorySetup: Record "313";
        PrefixLength: Integer;
        HSCodeRec: Record "260";
}

