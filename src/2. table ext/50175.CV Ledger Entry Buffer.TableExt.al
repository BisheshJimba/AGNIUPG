tableextension 50175 tableextension50175 extends "CV Ledger Entry Buffer"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Description(Field 7)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal.Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                            ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
        }

        //Unsupported feature: Property Deletion (Editable) on ""Dimension Set ID"(Field 480)".

        field(50000;"Model Code";Code[20])
        {
            Editable = false;
            TableRelation = Model;
        }
    }
}

