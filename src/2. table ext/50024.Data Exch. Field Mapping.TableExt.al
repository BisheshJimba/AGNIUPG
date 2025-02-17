tableextension 50024 tableextension50024 extends "Data Exch. Field Mapping"
{
    fields
    {
        modify("Column No.")
        {
            TableRelation = "Data Exch. Column Def"."Column No." WHERE("Data Exch. Def Code" = FIELD("Data Exch. Def Code"),
                                                                        "Data Exch. Line Def Code" = FIELD("Data Exch. Line Def Code"));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Target Field Caption"(Field 13)".

    }
}

