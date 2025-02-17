tableextension 50029 tableextension50029 extends "Text-to-Account Mapping"
{
    fields
    {
        modify("Debit Acc. No.")
        {
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false),
                                                 "Direct Posting" = CONST(true));
        }
        modify("Credit Acc. No.")
        {
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false),
                                                 "Direct Posting" = CONST(true));
        }
        modify("Bal. Source No.")
        {
            TableRelation = IF ("Bal. Source Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false))
            ELSE IF ("Bal. Source Type" = CONST(Customer)) Customer
            ELSE IF ("Bal. Source Type" = CONST(Vendor)) Vendor
            ELSE IF ("Bal. Source Type" = CONST("Bank Account")) "Bank Account";
        }
    }
}

