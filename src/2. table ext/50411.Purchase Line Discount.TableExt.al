tableextension 50411 tableextension50411 extends "Purchase Line Discount"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5700)".

        field(25006670; "Item Discount Group Code"; Code[10])
        {
            Caption = 'Item Discount Group Code';
            TableRelation = "Item Discount Group";
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
    }
}

