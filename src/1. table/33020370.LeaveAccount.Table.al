table 33020370 "Leave Account"
{

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;
        }
        field(2; "Leave Type"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = "Leave Type"."Leave Type Code";
        }
        field(3; "Earned Days"; Decimal)
        {
        }
        field(4; LastCalculatedDate; Date)
        {
        }
        field(5; "Total Leaves"; Decimal)
        {
            Description = '//';
        }
        field(6; "Used Days"; Decimal)
        {
        }
        field(7; "Balance Days"; Decimal)
        {
        }
        field(8; Remarks; Text[100])
        {
        }
        field(10; "Total Enchased Days"; Decimal)
        {
        }
        field(11; "Total WriteOff Days"; Decimal)
        {
            Description = 'For Old reference date (not to be deleted)';
        }
        field(12; "Employee Name"; Text[100])
        {
        }
        field(13; "Total Writeoff Days (New)"; Decimal)
        {
            Description = 'Added for new scheme of leave';
        }
        field(14; "Total Enchased Days F"; Decimal)
        {
            CalcFormula = Sum("Leave Encash Ledger".Days WHERE(Employee No.=FIELD(Employee Code),
                                                                Leave Code=FIELD(Leave Type)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Employee Code","Leave Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

