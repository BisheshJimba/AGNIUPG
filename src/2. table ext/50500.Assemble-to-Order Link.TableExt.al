tableextension 50500 tableextension50500 extends "Assemble-to-Order Link"
{
    fields
    {
        modify("Assembly Document No.")
        {
            TableRelation = "Assembly Header" WHERE(Document Type=FIELD(Assembly Document Type),
                                                     No.=FIELD(Assembly Document No.));
        }
        modify("Document No.")
        {
            TableRelation = IF (Type=CONST(Sale)) "Sales Line"."Document No." WHERE (Document Type=FIELD(Document Type),
                                                                                     Document No.=FIELD(Document No.),
                                                                                     Line No.=FIELD(Document Line No.));
        }
    }
}

