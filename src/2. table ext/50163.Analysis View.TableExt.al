tableextension 50163 tableextension50163 extends "Analysis View"
{
    fields
    {
        modify("Account Filter")
        {
            TableRelation = IF (Account Source=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Account Source=CONST(Cash Flow Account)) "Cash Flow Account";
        }
    }
}

