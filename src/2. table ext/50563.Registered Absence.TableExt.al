tableextension 50563 tableextension50563 extends "Registered Absence"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Capacity Type=CONST(Work Center)) "Work Center"
                            ELSE IF (Capacity Type=CONST(Machine Center)) "Machine Center";
        }
    }
}

