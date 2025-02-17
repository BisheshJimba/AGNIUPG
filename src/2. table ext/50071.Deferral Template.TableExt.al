tableextension 50071 tableextension50071 extends "Deferral Template"
{
    fields
    {
        modify("Deferral Account")
        {
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
        }
    }
}

