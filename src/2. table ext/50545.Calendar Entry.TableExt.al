tableextension 50545 tableextension50545 extends "Calendar Entry"
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

