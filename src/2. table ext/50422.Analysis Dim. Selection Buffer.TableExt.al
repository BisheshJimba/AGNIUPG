tableextension 50422 tableextension50422 extends "Analysis Dim. Selection Buffer"
{
    fields
    {
        modify("New Dimension Value Code")
        {
            TableRelation = IF (Code = CONST(Item)) Item.No.
                            ELSE IF (Code = CONST(Location)) Location.Code
            ELSE
            "Dimension Value".Code WHERE(Dimension Code=FIELD(Code));
        }
        modify("Dimension Value Filter")
        {
            TableRelation = IF (Code=CONST(Item)) Item.No.
                            ELSE IF (Code=CONST(Location)) Location.Code
                            ELSE "Dimension Value".Code WHERE (Dimension Code=FIELD(Code));
        }
    }
}

