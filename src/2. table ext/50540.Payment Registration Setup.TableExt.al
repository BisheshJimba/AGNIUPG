tableextension 50540 tableextension50540 extends "Payment Registration Setup"
{
    fields
    {
        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal.Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
        }
    }
}

