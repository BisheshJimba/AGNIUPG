tableextension 50547 tableextension50547 extends "Calendar Absence Entry"
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

