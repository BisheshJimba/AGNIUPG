tableextension 50075 tableextension50075 extends "Posted Deferral Line"
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

