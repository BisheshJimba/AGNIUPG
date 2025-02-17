tableextension 50567 tableextension50567 extends "Untracked Planning Element"
{
    fields
    {
        modify("Worksheet Line No.")
        {
            TableRelation = "Requisition Line"."Line No." WHERE(Worksheet Template Name=FIELD(Worksheet Template Name),
                                                                 Journal Batch Name=FIELD(Worksheet Batch Name));
        }
        modify("Variant Code")
        {

            //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 12)".

            TableRelation = "Item Variant".Code WHERE(Item No.=FIELD(Item No.),
                                                       Code=FIELD(Variant Code));
        }
    }
}

