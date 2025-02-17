tableextension 50164 tableextension50164 extends "Analysis View Entry"
{
    fields
    {
        modify("Account No.")
        {
            TableRelation = IF (Account Source=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Account Source=CONST(Cash Flow Account)) "Cash Flow Account";
        }
    }
}

