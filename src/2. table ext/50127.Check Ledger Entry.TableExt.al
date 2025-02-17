tableextension 50127 tableextension50127 extends "Check Ledger Entry"
{
    fields
    {
        modify("Bank Payment Type")
        {
            OptionCaption = ' ,Computer Check,Manual Check,NCHL';

            //Unsupported feature: Property Modification (OptionString) on ""Bank Payment Type"(Field 12)".

        }
        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal.Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                            ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
        }
        modify("Statement Line No.")
        {
            TableRelation = "Bank Acc. Reconciliation Line"."Statement Line No." WHERE (Bank Account No.=FIELD(Bank Account No.),
                                                                                        Statement No.=FIELD(Statement No.));
        }
    }
}

