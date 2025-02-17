tableextension 50450 tableextension50450 extends "Posted Invt. Pick Line"
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
        modify("Bin Code")
        {
            TableRelation = IF (Action Type=FILTER(<>Take)) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                            Zone Code=FIELD(Zone Code))
                                                                            ELSE IF (Action Type=FILTER(<>Take),
                                                                                     Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                                                                                     ELSE IF (Action Type=CONST(Take)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                       Zone Code=FIELD(Zone Code))
                                                                                                                                                       ELSE IF (Action Type=CONST(Take),
                                                                                                                                                                Zone Code=FILTER('')) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code));
        }
    }
}

