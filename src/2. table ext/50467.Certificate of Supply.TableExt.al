tableextension 50467 tableextension50467 extends "Certificate of Supply"
{
    fields
    {
        modify("Document No.")
        {
            TableRelation = IF (Document Type=FILTER(Sales Shipment)) "Sales Shipment Header".No.
                            ELSE IF (Document Type=FILTER(Service Shipment)) "Service Shipment Header".No.
                            ELSE IF (Document Type=FILTER(Return Shipment)) "Return Shipment Header".No.;
        }
    }
}

