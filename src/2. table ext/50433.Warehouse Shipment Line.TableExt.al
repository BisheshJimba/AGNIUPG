tableextension 50433 tableextension50433 extends "Warehouse Shipment Line"
{
    fields
    {
        modify("Bin Code")
        {
            TableRelation = IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                             Zone Code=FIELD(Zone Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Pick Qty."(Field 27)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pick Qty. (Base)"(Field 28)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 31)".

        modify("Destination No.")
        {
            TableRelation = IF (Destination Type=CONST(Customer)) Customer.No.
                            ELSE IF (Destination Type=CONST(Vendor)) Vendor.No.
                            ELSE IF (Destination Type=CONST(Location)) Location.Code;
        }
    }
}

