tableextension 50426 tableextension50426 extends "Warehouse Journal Line"
{
    fields
    {
        modify("From Bin Code")
        {
            TableRelation = IF (Phys.Inventory=CONST(No),
                                Item No.=FILTER(''),
                                From Zone Code=FILTER('')) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code))
                                ELSE IF (Phys. Inventory=CONST(No),
                                         Item No.=FILTER(<>''),
                                         From Zone Code=FILTER('')) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                    Item No.=FIELD(Item No.))
                                                                                                    ELSE IF (Phys. Inventory=CONST(No),
                                                                                                             Item No.=FILTER(''),
                                                                                                             From Zone Code=FILTER(<>'')) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                          Zone Code=FIELD(From Zone Code))
                                                                                                                                                                          ELSE IF (Phys. Inventory=CONST(No),
                                                                                                                                                                                   Item No.=FILTER(<>''),
                                                                                                                                                                                   From Zone Code=FILTER(<>'')) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                                                                                Item No.=FIELD(Item No.),
                                                                                                                                                                                                                                                Zone Code=FIELD(From Zone Code))
                                                                                                                                                                                                                                                ELSE IF (Phys. Inventory=CONST(Yes),
                                                                                                                                                                                                                                                         From Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                                                                                                                                                                                                                                                         ELSE IF (Phys. Inventory=CONST(Yes),
                                                                                                                                                                                                                                                                  From Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                                                                                                                                               Zone Code=FIELD(From Zone Code));
        }
        modify("Bin Code")
        {
            TableRelation = IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                             Zone Code=FIELD(Zone Code));
        }
        modify("To Bin Code")
        {
            TableRelation = IF (To Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (To Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                Zone Code=FIELD(To Zone Code));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

    }
}

