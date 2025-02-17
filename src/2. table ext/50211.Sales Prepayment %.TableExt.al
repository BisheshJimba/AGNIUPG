tableextension 50211 tableextension50211 extends "Sales Prepayment %"
{
    fields
    {
        modify("Sales Code")
        {
            TableRelation = IF (Sales Type=CONST(Customer)) Customer
                            ELSE IF (Sales Type=CONST(Customer Price Group)) "Customer Price Group";
        }
    }
}

