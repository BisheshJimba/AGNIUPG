tableextension 50370 tableextension50370 extends "Service Document Log"
{
    fields
    {
        modify("Document No.")
        {
            TableRelation = IF (Document Type=CONST(Quote)) "Service Header".No. WHERE (Document Type=CONST(Quote))
                            ELSE IF (Document Type=CONST(Order)) "Service Header".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Document Type=CONST(Invoice)) "Service Header".No. WHERE (Document Type=CONST(Invoice))
                            ELSE IF (Document Type=CONST(Credit Memo)) "Service Header".No. WHERE (Document Type=CONST(Credit Memo))
                            ELSE IF (Document Type=CONST(Shipment)) "Service Shipment Header"
                            ELSE IF (Document Type=CONST(Posted Invoice)) "Service Invoice Header"
                            ELSE IF (Document Type=CONST(Posted Credit Memo)) "Service Cr.Memo Header";
        }
    }
}

