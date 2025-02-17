tableextension 50074 tableextension50074 extends "Posted Deferral Header"
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

