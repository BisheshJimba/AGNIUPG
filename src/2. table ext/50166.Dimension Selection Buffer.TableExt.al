tableextension 50166 tableextension50166 extends "Dimension Selection Buffer"
{
    fields
    {
        modify("New Dimension Value Code")
        {
            TableRelation = IF (Code = CONST(G/L Account)) "G/L Account".No.
                            ELSE IF (Code=CONST(Business Unit)) "Business Unit".Code
                            ELSE "Dimension Value".Code WHERE (Dimension Code=FIELD(Code));
        }
        modify("Dimension Value Filter")
        {
            TableRelation = IF (Filter Lookup Table No.=CONST(15)) "G/L Account".No.
                            ELSE IF (Filter Lookup Table No.=CONST(220)) "Business Unit".Code
                            ELSE IF (Filter Lookup Table No.=CONST(841)) "Cash Flow Account".No.
                            ELSE IF (Filter Lookup Table No.=CONST(840)) "Cash Flow Forecast".No.
                            ELSE "Dimension Value".Code WHERE (Dimension Code=FIELD(Code));
        }
    }
}

