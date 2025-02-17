tableextension 50368 tableextension50368 extends "Service Hour"
{
    fields
    {
        modify("Service Contract No.")
        {
            TableRelation = IF (Service Contract Type=CONST(Contract)) "Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract))
                            ELSE IF (Service Contract Type=CONST(Quote)) "Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Quote));
        }
    }
}

