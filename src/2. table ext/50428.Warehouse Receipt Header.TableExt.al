tableextension 50428 tableextension50428 extends "Warehouse Receipt Header"
{
    fields
    {
        modify("Bin Code")
        {
            TableRelation = IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                            ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                             Zone Code=FIELD(Zone Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 11)".

        modify("Cross-Dock Zone Code")
        {
            TableRelation = Zone.Code WHERE (Location Code=FIELD(Location Code),
                                             Cross-Dock Bin Zone=CONST(Yes));
        }
        modify("Cross-Dock Bin Code")
        {
            TableRelation = IF (Cross-Dock Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                 Cross-Dock Bin=CONST(Yes))
                                                                                 ELSE IF (Cross-Dock Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                                             Zone Code=FIELD(Cross-Dock Zone Code),
                                                                                                                                             Cross-Dock Bin=CONST(Yes));
        }
    }
}

