tableextension 50021 tableextension50021 extends "Direct Debit Collection Entry"
{
    fields
    {
        modify("Applies-to Entry No.")
        {
            TableRelation = "Cust. Ledger Entry" WHERE("Customer No." = FIELD("Customer No."),
                                                        "Document Type" = FILTER('Invoice|Finance Charge Memo|Reminder'),
                                                        Open = CONST(true));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Applies-to Entry Amount"(Field 18)".

    }
}

