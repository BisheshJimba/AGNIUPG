table 33020079 "VF Lines Correction"
{
    Caption = 'VF Lines Correction';

    fields
    {
        field(1; "Loan No."; Code[20])
        {
            TableRelation = "Vehicle Finance Header";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "EMI Mature Date"; Date)
        {
        }
        field(4; "EMI Amount"; Decimal)
        {
        }
        field(5; "Calculated Principal"; Decimal)
        {
        }
        field(6; "Calculated Interest"; Decimal)
        {
        }
        field(7; Balance; Decimal)
        {
        }
        field(8; "Installment No."; Integer)
        {
        }
        field(9; "Calculated Penalty"; Decimal)
        {
        }
        field(10; "Calculated Rebate"; Decimal)
        {
        }
        field(11; "Delay by No. of Days"; Decimal)
        {
        }
        field(12; "Principal Paid Correction"; Decimal)
        {
        }
        field(13; "Interest Paid Correction"; Decimal)
        {
        }
        field(14; "Penalty Paid Correction"; Decimal)
        {
        }
        field(15; "Rebate Adjusted"; Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Rebate Adjusted" WHERE(Loan No.=FIELD(Loan No.),
                                                                                       Installment No.=FIELD(Installment No.)));
            FieldClass = FlowField;
        }
        field(16;"Actual Balance";Decimal)
        {
        }
        field(17;"Insurance Paid";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Insurance Paid" WHERE (Loan No.=FIELD(Loan No.),
                                                                                      Installment No.=FIELD(Installment No.)));
            FieldClass = FlowField;
        }
        field(18;"Last Payment Date";Date)
        {
        }
        field(19;"Line Cleared";Boolean)
        {
        }
        field(20;"Duration of days fr Prev. Mnth";Integer)
        {
        }
        field(21;"Remaining Principal Amount";Decimal)
        {
        }
        field(22;"Last Payment Received Date";Date)
        {
            CalcFormula = Max("Vehicle Finance Payment Lines"."Payment Date" WHERE (Loan No.=FIELD(Loan No.),
                                                                                    Installment No.=FIELD(Installment No.)));
            FieldClass = FlowField;
        }
        field(50;"Pending Interest";Decimal)
        {
        }
        field(51;"Last Receipt No.";Code[20])
        {
            CalcFormula = Max("Vehicle Finance Payment Lines"."G/L Receipt No." WHERE (Loan No.=FIELD(Loan No.),
                                                                                       Installment No.=FIELD(Installment No.)));
            FieldClass = FlowField;
        }
        field(52;"Interest Rate";Decimal)
        {
        }
        field(53;"Temp Calculated Penalty";Decimal)
        {
        }
        field(54;"Total Principal Paid";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Principal Paid" WHERE (Loan No.=FIELD(Loan No.)));
            FieldClass = FlowField;
        }
        field(55;"Total Interest Paid";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Interest Paid" WHERE (Loan No.=FIELD(Loan No.)));
            FieldClass = FlowField;
        }
        field(56;"Total Penalty Paid";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Penalty Paid" WHERE (Loan No.=FIELD(Loan No.)));
            FieldClass = FlowField;
        }
        field(57;Rescheduled;Boolean)
        {
            CalcFormula = Exist("Reschedule Log" WHERE (Vehicle Finance No.=FIELD(Loan No.),
                                                        Installment No.=FIELD(Installment No.)));
            Editable = true;
            FieldClass = FlowField;
        }
        field(58;"Old Interest Rate";Decimal)
        {
            Editable = false;
        }
        field(59;"New Interest Rate";Decimal)
        {
            Editable = false;
        }
        field(60;"Prepayment Amount";Decimal)
        {
        }
        field(50000;"Temp Penalty Delay Days";Integer)
        {
        }
        field(50001;"SMS Logs Created";Boolean)
        {
        }
        field(50002;"SMS Entry No.";Integer)
        {
        }
        field(50003;"Wave Penalty";Boolean)
        {
        }
        field(50020;"Principal Paid";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Principal Paid" WHERE (Loan No.=FIELD(Loan No.),
                                                                                      Installment No.=FIELD(Installment No.)));
            FieldClass = FlowField;
        }
        field(50021;"Interest Paid";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Interest Paid" WHERE (Loan No.=FIELD(Loan No.),
                                                                                     Installment No.=FIELD(Installment No.)));
            FieldClass = FlowField;
        }
        field(50022;"Penalty Paid";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Penalty Paid" WHERE (Loan No.=FIELD(Loan No.),
                                                                                    Installment No.=FIELD(Installment No.)));
            FieldClass = FlowField;
        }
        field(51000;"Temp. Calculated Penalty";Decimal)
        {
        }
        field(51001;"Temp. Delay by No. of Days";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Loan No.","Installment No.")
        {
            Clustered = true;
            SumIndexFields = "EMI Amount","Calculated Interest";
        }
        key(Key2;"Installment No.")
        {
            SumIndexFields = "EMI Amount";
        }
        key(Key3;"Line No.")
        {
            SumIndexFields = "EMI Amount";
        }
        key(Key4;"Loan No.","EMI Mature Date")
        {
            SumIndexFields = "EMI Amount","Calculated Interest","Calculated Principal";
        }
    }

    fieldgroups
    {
    }
}

