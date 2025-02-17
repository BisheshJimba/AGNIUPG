tableextension 50077 tableextension50077 extends "Standard Customer Sales Code"
{
    fields
    {
        modify("Direct Debit Mandate ID")
        {
            TableRelation = "SEPA Direct Debit Mandate" WHERE("Customer No." = FIELD("Customer No."),
                                                               Blocked = CONST(false),
                                                               Closed = CONST(false));
        }
    }
}

