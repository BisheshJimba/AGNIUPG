tableextension 50490 tableextension50490 extends "Config. Template Line"
{
    fields
    {
        modify("Field ID")
        {
            TableRelation = IF (Type = CONST(Field)) Field.No. WHERE(TableNo = FIELD(Table ID),
                                                                    Class=CONST(Normal));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Table Name"(Field 7)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Table Caption"(Field 13)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Field Caption"(Field 14)".

    }
}

