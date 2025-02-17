tableextension 50440 tableextension50440 extends "Bin Content Buffer"
{
    fields
    {
        modify("Bin Code")
        {
            TableRelation = IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                             Zone Code=FIELD(Zone Code));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5)".

    }
}

