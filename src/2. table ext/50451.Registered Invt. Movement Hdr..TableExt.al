tableextension 50451 tableextension50451 extends "Registered Invt. Movement Hdr."
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 10)".

        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(120)) "Purch. Rcpt. Header" WHERE (No.=FIELD(Source No.))
                            ELSE IF (Source Type=CONST(110)) "Sales Shipment Header" WHERE (No.=FIELD(Source No.))
                            ELSE IF (Source Type=CONST(6650)) "Return Shipment Header" WHERE (No.=FIELD(Source No.))
                            ELSE IF (Source Type=CONST(6660)) "Return Receipt Header" WHERE (No.=FIELD(Source No.))
                            ELSE IF (Source Type=CONST(5744)) "Transfer Shipment Header" WHERE (No.=FIELD(Source No.))
                            ELSE IF (Source Type=CONST(5746)) "Transfer Receipt Header" WHERE (No.=FIELD(Source No.))
                            ELSE IF (Source Type=CONST(5405)) "Production Order".No. WHERE (Status=FILTER(Released|Finished),
                                                                                            No.=FIELD(Source No.))
                                                                                            ELSE IF (Source Type=CONST(900)) "Assembly Header".No. WHERE (Document Type=CONST(Order),
                                                                                                                                                          No.=FIELD(Source No.));
        }
        modify("Destination No.")
        {
            TableRelation = IF (Destination Type=CONST(Vendor)) Vendor
                            ELSE IF (Destination Type=CONST(Customer)) Customer
                            ELSE IF (Destination Type=CONST(Location)) Location
                            ELSE IF (Destination Type=CONST(Item)) Item
                            ELSE IF (Destination Type=CONST(Family)) Family
                            ELSE IF (Destination Type=CONST(Sales Order)) "Sales Header".No. WHERE (Document Type=CONST(Order));
        }
    }
}

