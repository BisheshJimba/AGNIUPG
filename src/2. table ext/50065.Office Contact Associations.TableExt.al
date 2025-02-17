tableextension 50065 tableextension50065 extends "Office Contact Associations"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF ("Associated Table" = CONST(Customer)) Customer
            ELSE IF ("Associated Table" = CONST(Vendor)) Vendor
            ELSE IF ("Associated Table" = CONST("Bank Account")) "Bank Account";
        }
    }
}

