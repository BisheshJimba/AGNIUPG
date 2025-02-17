tableextension 50189 tableextension50189 extends "Handled IC Inbox Jnl. Line"
{
    fields
    {
        modify("Account No.")
        {
            TableRelation = IF (Account Type=CONST(G/L Account)) "IC G/L Account"
                            ELSE IF (Account Type=CONST(Customer)) Customer
                            ELSE IF (Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Account Type=CONST(IC Partner)) "IC Partner";
        }
    }
}

