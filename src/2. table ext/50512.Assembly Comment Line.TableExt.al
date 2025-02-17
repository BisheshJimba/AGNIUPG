tableextension 50512 tableextension50512 extends "Assembly Comment Line"
{
    fields
    {
        modify("Document No.")
        {
            TableRelation = IF (Document Type=FILTER(Posted Assembly)) "Posted Assembly Header".No.
                            ELSE "Assembly Header".No. WHERE (Document Type=FIELD(Document Type));
        }
    }
}

