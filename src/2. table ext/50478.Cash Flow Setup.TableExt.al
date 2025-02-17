tableextension 50478 tableextension50478 extends "Cash Flow Setup"
{
    fields
    {
        modify("Tax Bal. Account No.")
        {
            TableRelation = IF (Tax Bal.Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Tax Bal. Account Type=CONST(Vendor)) Vendor;
        }
    }
}

