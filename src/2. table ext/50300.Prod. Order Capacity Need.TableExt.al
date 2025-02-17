tableextension 50300 tableextension50300 extends "Prod. Order Capacity Need"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Work Center)) "Work Center"
                            ELSE IF (Type=CONST(Machine Center)) "Machine Center";
        }
        modify("Worksheet Line No.")
        {
            TableRelation = "Requisition Line"."Line No." WHERE(Worksheet Template Name=FIELD(Worksheet Template Name),
                                                                 Journal Batch Name=FIELD(Worksheet Batch Name));
        }
    }
}

