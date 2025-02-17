tableextension 50114 tableextension50114 extends "VAT Registration Log"
{
    fields
    {
        modify("Account No.")
        {
            TableRelation = IF (Account Type=CONST(Customer)) Customer
                            ELSE IF (Account Type=CONST(Vendor)) Vendor;
        }
    }
}

