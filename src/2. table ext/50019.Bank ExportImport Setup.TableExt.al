tableextension 50019 tableextension50019 extends "Bank Export/Import Setup"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Processing Codeunit Name"(Field 5)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Processing XMLport Name"(Field 7)".

        modify("Data Exch. Def. Code")
        {
            TableRelation = IF (Direction = CONST(Import)) "Data Exch. Def".Code WHERE(Type = CONST("Bank Statement Import"))
            ELSE IF (Direction = CONST(Export)) "Data Exch. Def".Code WHERE(Type = CONST("Payment Export"))
            ELSE IF (Direction = CONST("Export-Positive Pay")) "Data Exch. Def".Code WHERE(Type = CONST("Positive Pay Export"));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Check Export Codeunit Name"(Field 12)".

    }
}

