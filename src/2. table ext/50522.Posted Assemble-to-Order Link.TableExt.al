tableextension 50522 tableextension50522 extends "Posted Assemble-to-Order Link"
{
    fields
    {
        modify("Document No.")
        {
            TableRelation = IF (Document Type=CONST(Sales Shipment)) "Sales Shipment Line" WHERE (Document No.=FIELD(Document No.),
                                                                                                  Line No.=FIELD(Document Line No.));
        }
    }
}

