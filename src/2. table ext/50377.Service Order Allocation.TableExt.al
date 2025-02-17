tableextension 50377 tableextension50377 extends "Service Order Allocation"
{
    fields
    {
        modify("Service Item Line No.")
        {
            TableRelation = "Service Item Line"."Line No." WHERE(Document Type=FIELD(Document Type),
                                                                  Document No.=FIELD(Document No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Service Item Description"(Field 15)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Repair Status"(Field 17)".

    }
}

