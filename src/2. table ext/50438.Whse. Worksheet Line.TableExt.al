tableextension 50438 tableextension50438 extends "Whse. Worksheet Line"
{
    fields
    {
        modify("To Bin Code")
        {
            TableRelation = IF (To Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                         Code=FIELD(To Bin Code))
                                                                         ELSE IF (To Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                             Zone Code=FIELD(To Zone Code),
                                                                                                                             Code=FIELD(To Bin Code));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 31)".

        modify("Destination No.")
        {
            TableRelation = IF (Destination Type=CONST(Customer)) Customer.No.
                            ELSE IF (Destination Type=CONST(Vendor)) Vendor.No.
                            ELSE IF (Destination Type=CONST(Location)) Location.Code;
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
                                                                                                                                                                                                                                                                                                                                                                                                                    ELSE IF (Whse. Document Type=CONST(Production)) "Prod. Order Line"."Line No." WHERE (Status=CONST(Released),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Prod. Order No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Line No.=FIELD(Line No.))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ELSE IF (Whse. Document Type=CONST(Assembly)) "Assembly Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Document No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Line No.=FIELD(Whse. Document Line No.));
        }
    }
}

