tableextension 50444 tableextension50444 extends "Whse. Internal Pick Line"
{
    fields
    {
        modify("To Bin Code")
        {
            TableRelation = IF (To Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (To Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                Zone Code=FIELD(To Zone Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Pick Qty."(Field 27)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pick Qty. (Base)"(Field 28)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 31)".

    }
}

