tableextension 50362 tableextension50362 extends "Service Item Line"
{
    fields
    {
        modify("Fault Code")
        {
            TableRelation = "Fault Code".Code WHERE(Fault Area Code=FIELD(Fault Area Code),
                                                     Symptom Code=FIELD(Symptom Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Fault Comment"(Field 37)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Resolution Comment"(Field 38)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 40)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Service Item Loaner Comment"(Field 41)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Active/Finished Allocs"(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Allocations"(Field 61)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Previous Services"(Field 62)".

        modify("Contract Line No.")
        {
            TableRelation = "Service Contract Line"."Line No." WHERE (Contract Type=CONST(Contract),
                                                                      Contract No.=FIELD(Contract No.));
        }
    }
}

