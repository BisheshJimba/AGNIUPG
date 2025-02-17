tableextension 50299 tableextension50299 extends "Prod. Order Routing Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Work Center)) "Work Center"
                            ELSE IF (Type=CONST(Machine Center)) "Machine Center";
        }
    }
}

