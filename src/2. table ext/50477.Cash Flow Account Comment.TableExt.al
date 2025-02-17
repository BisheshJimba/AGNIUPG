tableextension 50477 tableextension50477 extends "Cash Flow Account Comment"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Table Name=CONST(Cash Flow Forecast)) "Cash Flow Forecast"
                            ELSE IF (Table Name=CONST(Cash Flow Account)) "Cash Flow Account";
        }
    }
}

