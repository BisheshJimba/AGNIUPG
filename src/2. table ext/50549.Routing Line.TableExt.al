tableextension 50549 tableextension50549 extends "Routing Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Work Center)) "Work Center"
                            ELSE IF (Type=CONST(Machine Center)) "Machine Center";
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 45)".

    }
}

