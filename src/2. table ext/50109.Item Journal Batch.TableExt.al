tableextension 50109 tableextension50109 extends "Item Journal Batch"
{
    fields
    {
        modify("Template Type")
        {
            OptionCaption = 'Item,Transfer,Phys. Inventory,Revaluation,Consumption,Output,Capacity,Prod.Order';

            //Unsupported feature: Property Modification (OptionString) on ""Template Type"(Field 21)".

        }
        field(50001; "User Id"; Code[30])
        {
            TableRelation = "User Setup";
        }
        field(25006100; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(25006110; "New Location Code"; Code[10])
        {
            Caption = 'New Location Code';
            TableRelation = Location;
        }
        field(25006120; "Salespers./Purch. Mandatory"; Boolean)
        {
            Caption = 'Salespers./Purch. Mandatory';
        }
    }
}

