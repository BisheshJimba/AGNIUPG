tableextension 50387 tableextension50387 extends "Service Invoice Header"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal.Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Hours"(Field 5911)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Unallocated Items"(Field 5921)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reallocation Needed"(Field 5934)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Allocations"(Field 5939)".

        modify("Contract No.")
        {
            TableRelation = "Service Contract Header"."Contract No." WHERE(Contract Type=CONST(Contract),
                                                                            Customer No.=FIELD(Customer No.),
                                                                            Ship-to Code=FIELD(Ship-to Code),
                                                                            Bill-to Customer No.=FIELD(Bill-to Customer No.));
        }
    }
}

