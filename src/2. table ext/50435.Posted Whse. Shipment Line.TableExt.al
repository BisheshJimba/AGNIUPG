tableextension 50435 tableextension50435 extends "Posted Whse. Shipment Line"
{
    fields
    {
        modify("Bin Code")
        {
            TableRelation = IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                             Zone Code=FIELD(Zone Code));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 31)".

        modify("Destination No.")
        {
            TableRelation = IF (Destination Type=CONST(Customer)) Customer.No.
                            ELSE IF (Destination Type=CONST(Vendor)) Vendor.No.
                            ELSE IF (Destination Type=CONST(Location)) Location.Code;
        }
    }
}

