tableextension 50020 tableextension50020 extends "Credit Transfer Entry"
{
    fields
    {
        modify("Account No.")
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) Customer
            ELSE IF ("Account Type" = CONST(Vendor)) Vendor;
        }
        modify("Applies-to Entry No.")
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) "Cust. Ledger Entry"
            ELSE IF ("Account Type" = CONST(Vendor)) "Vendor Ledger Entry";
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Canceled(Field 10)".

    }
}

