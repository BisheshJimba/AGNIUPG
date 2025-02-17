tableextension 50339 tableextension50339 extends "Warehouse Request"
{
    fields
    {
        modify("Source No.")
        {
            TableRelation = IF (Source Document=CONST(Sales Order)) "Sales Header".No. WHERE (Document Type=CONST(Order),
                                                                                              No.=FIELD(Source No.))
                                                                                              ELSE IF (Source Document=CONST(Sales Return Order)) "Sales Header".No. WHERE (Document Type=CONST(Return Order),
                                                                                                                                                                            No.=FIELD(Source No.))
                                                                                                                                                                            ELSE IF (Source Document=CONST(Purchase Order)) "Purchase Header".No. WHERE (Document Type=CONST(Order),
                                                                                                                                                                                                                                                         No.=FIELD(Source No.))
                                                                                                                                                                                                                                                         ELSE IF (Source Document=CONST(Purchase Return Order)) "Purchase Header".No. WHERE (Document Type=CONST(Return Order),
                                                                                                                                                                                                                                                                                                                                             No.=FIELD(Source No.))
                                                                                                                                                                                                                                                                                                                                             ELSE IF (Source Type=CONST(5741)) "Transfer Header".No. WHERE (No.=FIELD(Source No.))
                                                                                                                                                                                                                                                                                                                                             ELSE IF (Source Type=FILTER(5406|5407)) "Production Order".No. WHERE (Status=CONST(Released),
                                                                                                                                                                                                                                                                                                                                                                                                                   No.=FIELD(Source No.))
                                                                                                                                                                                                                                                                                                                                                                                                                   ELSE IF (Source Type=FILTER(901)) "Assembly Header".No. WHERE (Document Type=CONST(Order),
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

        //Unsupported feature: Property Modification (CalcFormula) on ""Put-away / Pick No."(Field 20)".

    }
}

