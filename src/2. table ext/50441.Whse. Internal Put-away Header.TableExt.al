tableextension 50441 tableextension50441 extends "Whse. Internal Put-away Header"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 7)".

        modify("From Bin Code")
        {
            TableRelation = IF (From Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (From Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                  Zone Code=FIELD(From Zone Code));
        }
    }
}

