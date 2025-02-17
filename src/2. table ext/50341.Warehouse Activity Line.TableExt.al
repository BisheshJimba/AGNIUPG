tableextension 50341 tableextension50341 extends "Warehouse Activity Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 15)".

        modify("Destination No.")
        {
            TableRelation = IF (Destination Type=CONST(Vendor)) Vendor
                            ELSE IF (Destination Type=CONST(Customer)) Customer
                            ELSE IF (Destination Type=CONST(Location)) Location
                            ELSE IF (Destination Type=CONST(Item)) Item
                            ELSE IF (Destination Type=CONST(Family)) Family
                            ELSE IF (Destination Type=CONST(Sales Order)) "Sales Header".No. WHERE (Document Type=CONST(Order));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Serial No. Blocked"(Field 6504)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Lot No. Blocked"(Field 6505)".

        modify("Bin Code")
        {
            TableRelation = IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                             Zone Code=FIELD(Zone Code));
        }
        modify("Whse. Document No.")
        {
            TableRelation = IF (Whse. Document Type=CONST(Receipt)) "Posted Whse. Receipt Header".No. WHERE (No.=FIELD(Whse. Document No.))
                            ELSE IF (Whse. Document Type=CONST(Shipment)) "Warehouse Shipment Header".No. WHERE (No.=FIELD(Whse. Document No.))
                            ELSE IF (Whse. Document Type=CONST(Internal Put-away)) "Whse. Internal Put-away Header".No. WHERE (No.=FIELD(Whse. Document No.))
                            ELSE IF (Whse. Document Type=CONST(Internal Pick)) "Whse. Internal Pick Header".No. WHERE (No.=FIELD(Whse. Document No.))
                            ELSE IF (Whse. Document Type=CONST(Production)) "Production Order".No. WHERE (No.=FIELD(Whse. Document No.))
                            ELSE IF (Whse. Document Type=CONST(Assembly)) "Assembly Header".No. WHERE (Document Type=CONST(Order),
                                                                                                       No.=FIELD(Whse. Document No.));
        }
        modify("Whse. Document Line No.")
        {
            TableRelation = IF (Whse. Document Type=CONST(Receipt)) "Posted Whse. Receipt Line"."Line No." WHERE (No.=FIELD(Whse. Document No.),
                                                                                                                  Line No.=FIELD(Whse. Document Line No.))
                                                                                                                  ELSE IF (Whse. Document Type=CONST(Shipment)) "Warehouse Shipment Line"."Line No." WHERE (No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                            Line No.=FIELD(Whse. Document Line No.))
                                                                                                                                                                                                            ELSE IF (Whse. Document Type=CONST(Internal Put-away)) "Whse. Internal Put-away Line"."Line No." WHERE (No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                                                                                    Line No.=FIELD(Whse. Document Line No.))
                                                                                                                                                                                                                                                                                                                    ELSE IF (Whse. Document Type=CONST(Internal Pick)) "Whse. Internal Pick Line"."Line No." WHERE (No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                                                                                                                                                                                    Line No.=FIELD(Whse. Document Line No.))
                                                                                                                                                                                                                                                                                                                                                                                                                    ELSE IF (Whse. Document Type=CONST(Production)) "Prod. Order Line"."Line No." WHERE (Prod. Order No.=FIELD(No.),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Line No.=FIELD(Line No.))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ELSE IF (Whse. Document Type=CONST(Assembly)) "Assembly Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Document No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Line No.=FIELD(Whse. Document Line No.));
        }
    }
}

