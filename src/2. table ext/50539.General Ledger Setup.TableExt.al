tableextension 50539 tableextension50539 extends "General Ledger Setup"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Cust. Balances Due"(Field 44)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Vendor Balances Due"(Field 45)".

        field(50000; "Block Zero Value Invoice Posti"; Boolean)
        {
        }
        field(50001; "Use Accountability Center"; Boolean)
        {
        }
        field(50002; "Vehicle Tax"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50003; "Income Tax"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50004; "Road Maintenance"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50005; "Registration Fee"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50006; "Ownership Transfer Fee"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50007; "Other Fee"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50008; "Balancing A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(80002; "Exact Return Amount Mandatory"; Boolean)
        {
        }
        field(80003; "Return Tolerance"; Decimal)
        {
        }
        field(25006000; "Calc.Prepmt.VAT by Line PostGr"; Boolean)
        {
            Caption = 'Calculate prepmt. VAT using Line Posting Groups';
        }
    }
}

