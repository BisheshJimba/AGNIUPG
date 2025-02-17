tableextension 50364 tableextension50364 extends "Service Comment Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Table Name=CONST(Service Contract)) "Service Contract Header"."Contract No."
                            ELSE IF (Table Name=CONST(Service Header)) "Service Header".No.
                            ELSE IF (Table Name=CONST(Service Item)) "Service Item"
                            ELSE IF (Table Name=CONST(Loaner)) Loaner;
        }
    }
}

