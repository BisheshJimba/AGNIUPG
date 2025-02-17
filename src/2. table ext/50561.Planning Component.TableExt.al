tableextension 50561 tableextension50561 extends "Planning Component"
{
    fields
    {
        modify("Worksheet Line No.")
        {
            TableRelation = "Requisition Line"."Line No." WHERE(Worksheet Template Name=FIELD(Worksheet Template Name),
                                                                 Journal Batch Name=FIELD(Worksheet Batch Name));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 21)".

        modify("Supplied-by Line No.")
        {
            TableRelation = "Requisition Line"."Line No." WHERE(Worksheet Template Name=FIELD(Worksheet Template Name),
                                                                 Journal Batch Name=FIELD(Worksheet Batch Name),
                                                                 Line No.=FIELD(Supplied-by Line No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. (Base)"(Field 63)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity"(Field 71)".

    }
}

