table 33020424 "Objective and Task"
{

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;
        }
        field(2; "Employee Name"; Text[90])
        {
        }
        field(4; "Fiscal Year"; Text[30])
        {
        }
        field(5; Objectives; Text[100])
        {
        }
        field(6; "Remarks by Appraisal 1"; Text[100])
        {
        }
        field(7; Complete; Boolean)
        {
        }
        field(8; "End Fiscal Date"; Date)
        {
        }
        field(9; "Remarks by Appraisal 2"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Fiscal Year", "End Fiscal Date", Objectives, Complete)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        EmpRec: Record "5200";
}

