tableextension 50443 tableextension50443 extends "Whse. Internal Pick Header"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 11)".

        modify("To Bin Code")
        {
            TableRelation = IF (To Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (To Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                Zone Code=FIELD(To Zone Code));
        }
    }
}

