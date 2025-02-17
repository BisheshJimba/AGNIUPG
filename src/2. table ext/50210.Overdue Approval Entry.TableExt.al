tableextension 50210 tableextension50210 extends "Overdue Approval Entry"
{
    fields
    {
        modify("Document No.")
        {
            TableRelation = IF (Table ID=CONST(36)) "Sales Header".No. WHERE (Document Type=FIELD(Document Type))
                            ELSE IF (Table ID=CONST(38)) "Purchase Header".No. WHERE (Document Type=FIELD(Document Type));
        }
    }
}

