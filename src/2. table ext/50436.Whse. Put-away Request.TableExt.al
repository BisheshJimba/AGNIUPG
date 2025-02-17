tableextension 50436 tableextension50436 extends "Whse. Put-away Request"
{
    fields
    {
        modify("Document No.")
        {
            TableRelation = IF (Document Type=CONST(Receipt)) "Posted Whse. Receipt Header".No.
                            ELSE IF (Document Type=CONST(Internal Put-away)) "Whse. Internal Put-away Header".No.;
        }
        modify("Bin Code")
        {
            TableRelation = IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                             Zone Code=FIELD(Zone Code));
        }
    }
}

