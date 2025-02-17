tableextension 50568 tableextension50568 extends "Capacity Constrained Resource"
{
    fields
    {
        modify("Capacity No.")
        {
            TableRelation = IF (Capacity Type=CONST(Work Center)) "Work Center"
                            ELSE IF (Capacity Type=CONST(Machine Center)) "Machine Center";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Capacity (Effective)"(Field 42)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Prod. Order Need Qty."(Field 44)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Work Center Load Qty."(Field 46)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Prod. Order Need Qty. for Plan"(Field 48)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Work Center Load Qty. for Plan"(Field 49)".

    }
}

