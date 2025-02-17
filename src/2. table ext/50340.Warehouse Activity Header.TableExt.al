tableextension 50340 tableextension50340 extends "Warehouse Activity Header"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 10)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Lines"(Field 13)".

        modify("Last Registering No.")
        {
            TableRelation = IF (Type = CONST(Put-away)) "Registered Whse. Activity Hdr.".No. WHERE (Type=CONST(Put-away))
                            ELSE IF (Type=CONST(Pick)) "Registered Whse. Activity Hdr.".No. WHERE (Type=CONST(Pick))
                            ELSE IF (Type=CONST(Movement)) "Registered Whse. Activity Hdr.".No. WHERE (Type=CONST(Movement));
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

