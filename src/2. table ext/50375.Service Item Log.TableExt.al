tableextension 50375 tableextension50375 extends "Service Item Log"
{
    fields
    {
        modify("Document No.")
        {
            TableRelation = IF (Document Type=CONST(Quote)) "Service Header".No. WHERE (Document Type=CONST(Quote))
                            ELSE IF (Document Type=CONST(Order)) "Service Header".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Document Type=CONST(Contract)) "Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract));
        }
        field(50000; Reason; Text[250])
        {
        }
    }
}

