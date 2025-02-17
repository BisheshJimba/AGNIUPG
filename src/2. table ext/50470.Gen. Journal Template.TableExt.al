tableextension 50470 tableextension50470 extends "Gen. Journal Template"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Test Report Caption"(Field 15)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Page Caption"(Field 16)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Posting Report Caption"(Field 17)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal.Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                            ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Cust. Receipt Report Caption"(Field 26)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Vendor Receipt Report Caption"(Field 28)".

        field(50000;"User ID";Code[50])
        {
            TableRelation = "User Setup";
        }
    }
}

