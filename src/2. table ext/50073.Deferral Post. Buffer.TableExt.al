tableextension 50073 tableextension50073 extends "Deferral Post. Buffer"
{
    fields
    {
        modify("G/L Account")
        {
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
        }
    }
}

