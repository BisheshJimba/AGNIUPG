tableextension 50557 tableextension50557 extends "Sales Planning Line"
{
    fields
    {
        modify("Sales Order Line No.")
        {
            TableRelation = "Sales Line"."Line No." WHERE(Document Type=CONST(Order),
                                                           Document No.=FIELD(Sales Order No.));
        }
        modify("Variant Code")
        {

            //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 11)".

            TableRelation = "Item Variant".Code WHERE(Item No.=FIELD(Item No.),
                                                       Code=FIELD(Variant Code));
        }
    }
}

