table 33020070 "Vehicle Finance Cue"
{
    Caption = 'Finance Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; Applications; Integer)
        {
            CalcFormula = Count("Vehicle Finance App. Header" WHERE(Approved = CONST(No),
                                                                     Rejected = CONST(No)));
            Caption = 'Pending Loan File';
            FieldClass = FlowField;
        }
        field(3; "Approved Loan File"; Integer)
        {
            CalcFormula = Count("Vehicle Finance Header" WHERE(Approved = CONST(Yes),
                                                                Closed = CONST(No),
                                                                Defaulter = CONST(No),
                                                                Loan Disbursed=CONST(No),
                                                                Rejected=CONST(No)));
            Caption = 'Approved Loan File';
            FieldClass = FlowField;
        }
        field(4; "Closed Loan File"; Integer)
        {
            CalcFormula = Count("Vehicle Finance Header" WHERE(Approved = CONST(Yes),
                                                                Closed = CONST(Yes),
                                                                Defaulter = CONST(No)));
            Caption = 'Closed Loan File';
            FieldClass = FlowField;
        }
        field(5; "Due Date Filter"; Date)
        {
            Caption = 'Due Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(6; "Overdue Date Filter"; Date)
        {
            Caption = 'Overdue Date Filter';
            FieldClass = FlowFilter;
        }
        field(7; Defaulter; Integer)
        {
            CalcFormula = Count("Vehicle Finance Header" WHERE(Approved = CONST(Yes),
                                                                Defaulter = CONST(Yes),
                                                                Loan Disbursed=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(8; Performing; Integer)
        {
            CalcFormula = Count("Vehicle Finance Header" WHERE(Approved = CONST(Yes),
                                                                Closed = CONST(No),
                                                                Loan Status=CONST(Performing),
                                                                Loan Disbursed=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(9; Substandard; Integer)
        {
            CalcFormula = Count("Vehicle Finance Header" WHERE(Approved = CONST(Yes),
                                                                Closed = CONST(No),
                                                                Loan Status=CONST(Substandard),
                                                                Loan Disbursed=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(10; Doubtful; Integer)
        {
            CalcFormula = Count("Vehicle Finance Header" WHERE(Approved = CONST(Yes),
                                                                Closed = CONST(No),
                                                                Loan Status=CONST(Doubtful),
                                                                Loan Disbursed=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(11; Critical; Integer)
        {
            CalcFormula = Count("Vehicle Finance Header" WHERE(Approved = CONST(Yes),
                                                                Closed = CONST(No),
                                                                Loan Status=CONST(Critical),
                                                                Loan Disbursed=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(12; Captured; Integer)
        {
            CalcFormula = Count("Vehicle Finance Header" WHERE(Captured = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(13; "Today's Follow Up"; Integer)
        {
            CalcFormula = Count("Vehicle Finance Follow Up" WHERE(Follow-Up Date=FIELD(Datefilter),
                                                                   Responsible Person Code=FIELD(Salesperson Code)));
            FieldClass = FlowField;
        }
        field(14;Datefilter;Date)
        {
            FieldClass = FlowFilter;
        }
        field(15;"Salesperson Code";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(16;"Missed Follow Up";Integer)
        {
            CalcFormula = Count("Vehicle Finance Follow Up" WHERE (Follow-Up Date=FIELD(Missed Datefilter),
                                                                   Responsible Person Code=FIELD(Salesperson Code),
                                                                   Remarks=FILTER(''),
                                                                   Next Follow Up Date=FILTER('')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;"Missed Datefilter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(18;"Substandard %";Decimal)
        {
        }
        field(19;"Doubtful %";Decimal)
        {
        }
        field(20;"Critical %";Decimal)
        {
        }
        field(21;"Substandard Outstanding";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Header"."Principal Due" WHERE (Closed=CONST(No),
                                                                              Loan Status=CONST(Substandard),
                                                                              Loan Disbursed=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(22;"Doubtful Outstanding";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Header"."Principal Due" WHERE (Closed=CONST(No),
                                                                              Loan Status=CONST(Doubtful),
                                                                              Loan Disbursed=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(23;"Critical Outstanding";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Header"."Principal Due" WHERE (Closed=CONST(No),
                                                                              Loan Status=CONST(Critical),
                                                                              Loan Disbursed=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(24;"Total Loan";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Header"."Loan Amount" WHERE (Closed=CONST(No),
                                                                            Loan Disbursed=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(25;"Disbursed Loan";Integer)
        {
            CalcFormula = Count("Vehicle Finance Header" WHERE (Closed=CONST(No),
                                                                Loan Disbursed=CONST(Yes),
                                                                Rejected=CONST(No)));
            FieldClass = FlowField;
        }
        field(26;"Rejected Applications";Integer)
        {
            CalcFormula = Count("Vehicle Finance App. Header" WHERE (Approved=CONST(No),
                                                                     Rejected=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(27;"Rejected Loan";Integer)
        {
            CalcFormula = Count("Vehicle Finance Header" WHERE (Approved=CONST(Yes),
                                                                Closed=CONST(No),
                                                                Rejected=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(28;"Insurance Expiring On 7 Days";Integer)
        {
        }
        field(29;"Insurance Expiring On 10 Days";Integer)
        {
        }
        field(30;"Pending Approval Ins. List";Integer)
        {
            CalcFormula = Count("Vehicle Insurance HP" WHERE (Status=CONST(Pending Approval)));
            FieldClass = FlowField;
        }
        field(31;"Approved Insurance List";Integer)
        {
            CalcFormula = Count("Vehicle Insurance HP" WHERE (Status=CONST(Pending Approval)));
            FieldClass = FlowField;
        }
        field(32;"Insurance Expired";Integer)
        {
        }
        field(33;"Total Due";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Header"."Total Due" WHERE (Closed=CONST(No),
                                                                          Loan Disbursed=CONST(Yes),
                                                                          Rejected=CONST(No),
                                                                          Total Due=FILTER(<>0)));
            FieldClass = FlowField;
        }
        field(34;"Principal Due";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Header"."Principal Due" WHERE (Closed=CONST(No),
                                                                              Loan Disbursed=CONST(Yes),
                                                                              Rejected=CONST(No),
                                                                              Principal Due=FILTER(<>0)));
            FieldClass = FlowField;
        }
        field(35;"Interest Due";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Header"."Interest Due" WHERE (Closed=CONST(No),
                                                                             Loan Disbursed=CONST(Yes),
                                                                             Rejected=CONST(No),
                                                                             Interest Due=FILTER(<>0)));
            FieldClass = FlowField;
        }
        field(36;"Penalty Due";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Header"."Penalty Due" WHERE (Closed=CONST(No),
                                                                            Loan Disbursed=CONST(Yes),
                                                                            Rejected=CONST(No),
                                                                            Penalty Due=FILTER(<>0)));
            FieldClass = FlowField;
        }
        field(37;"Insurance Due";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

