tableextension 50129 tableextension50129 extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        modify("Account No.")
        {
            TableRelation = IF (Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                      Blocked=CONST(No))
                                                                                      ELSE IF (Account Type=CONST(Customer)) Customer
                                                                                      ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                                      ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
                                                                                      ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                      ELSE IF (Account Type=CONST(IC Partner)) "IC Partner";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Match Confidence"(Field 50)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Match Quality"(Field 51)".

        field(50000;"Cheque No.";Code[30])
        {
        }
        field(50001;"Document Class";Option)
        {
            Caption = 'Document Class';
            OptionCaption = ' ,Customer,Vendor,Bank Account';
            OptionMembers = " ",Customer,Vendor,"Bank Account";
        }
        field(50002;"Document Subclass";Code[20])
        {
            Caption = 'Document Subclass';
            TableRelation = IF (Document Class=CONST(Customer)) Customer
                            ELSE IF (Document Class=CONST(Vendor)) Vendor
                            ELSE IF (Document Class=CONST(Bank Account)) "Bank Account";
        }
        field(50003;Narration;Text[250])
        {
        }
        field(50004;"Doc. Subclass Description";Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE (No.=FIELD(Document Subclass)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005;"Bal. Account No.";Code[20])
        {
            Caption = 'Bal. Account No.';
            Editable = false;
        }
        field(50006;"Bal. Account Name";Text[50])
        {
            Editable = false;
        }
    }
}

