tableextension 50431 tableextension50431 extends "Posted Whse. Receipt Line"
{
    fields
    {
        modify("Bin Code")
        {
            TableRelation = IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                             Zone Code=FIELD(Zone Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Put-away Qty."(Field 27)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Put-away Qty. (Base)"(Field 28)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 31)".

    }
}

