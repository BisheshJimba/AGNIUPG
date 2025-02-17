tableextension 50562 tableextension50562 extends "Planning Routing Line"
{
    fields
    {
        modify("Worksheet Line No.")
        {
            TableRelation = "Requisition Line"."Line No." WHERE(Worksheet Template Name=FIELD(Worksheet Template Name),
                                                                 Journal Batch Name=FIELD(Worksheet Batch Name));
        }
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Work Center)) "Work Center"
                            ELSE IF (Type=CONST(Machine Center)) "Machine Center";
        }
    }
}

