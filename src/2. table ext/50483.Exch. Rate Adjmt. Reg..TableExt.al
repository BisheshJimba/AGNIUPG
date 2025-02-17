tableextension 50483 tableextension50483 extends "Exch. Rate Adjmt. Reg."
{
    fields
    {
        modify("Posting Group")
        {
            TableRelation = IF (Account Type=CONST(Customer)) "Customer Posting Group"
                            ELSE IF (Account Type=CONST(Vendor)) "Vendor Posting Group"
                            ELSE IF (Account Type=CONST(Bank Account)) "Bank Account Posting Group";
        }
    }
}

