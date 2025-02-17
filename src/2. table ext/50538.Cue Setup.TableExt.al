tableextension 50538 tableextension50538 extends "Cue Setup"
{
    fields
    {
        modify("Table ID")
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE(Object Type=CONST(Table),
                                                                 Object Name=FILTER(*Cue));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Field Name"(Field 4)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Table Name"(Field 10)".

    }
}

