pageextension 50513 pageextension50513 extends "Item Attribute"
{
    layout
    {
        modify("Control 4")
        {
            Visible = false;
        }
        addafter("Control 5")
        {
            field("Value Type"; Rec."Value Type")
            {
            }
            field("Unit of Measure"; Rec."Unit of Measure")
            {
                ApplicationArea = Basic, Suite;
                DrillDown = false;
                ToolTip = 'Specifies the unit of measure for the item attribute.';

                trigger OnDrillDown()
                begin
                    Rec.OpenItemAttributeValues;
                end;
            }
        }
    }
}

