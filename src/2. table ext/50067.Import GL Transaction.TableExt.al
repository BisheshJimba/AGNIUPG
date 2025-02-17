tableextension 50067 tableextension50067 extends "Import G/L Transaction"
{
    fields
    {
        modify("G/L Account")
        {
            TableRelation = "G/L Account" WHERE(Blocked = CONST(false),
                                                 "Direct Posting" = CONST(true),
                                                 "Account Type" = CONST(Posting));
        }
    }
}

