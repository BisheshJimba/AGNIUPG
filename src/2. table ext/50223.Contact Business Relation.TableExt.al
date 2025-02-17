tableextension 50223 tableextension50223 extends "Contact Business Relation"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Link to Table=CONST(Customer)) Customer
                            ELSE IF (Link to Table=CONST(Vendor)) Vendor
                            ELSE IF (Link to Table=CONST(Bank Account)) "Bank Account";
        }

        //Unsupported feature: Property Modification (Data type) on ""Contact Name"(Field 6)".

    }
}

