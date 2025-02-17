tableextension 50491 tableextension50491 extends "Config. Line"
{
    fields
    {
        modify("Table ID")
        {
            TableRelation = IF (Line Type=CONST(Table)) Object.ID WHERE (Type=CONST(Table),
                                                                         ID=FILTER(..99000999|2000000004|2000000005));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Records"(Field 8)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Records (Source Table)"(Field 9)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Licensed Table"(Field 10)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Page Caption"(Field 15)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Licensed Page"(Field 30)".

    }
}

