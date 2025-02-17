table 33020363 "Employee Rec For Appraisal"
{

    fields
    {
        field(1; "No."; Code[10])
        {
        }
        field(2; Name; Text[50])
        {
        }
        field(3; "Manager ID"; Code[10])
        {
        }
        field(4; "User ID"; Code[10])
        {
        }
        field(5; "From Date"; Date)
        {
        }
        field(6; "To Date"; Date)
        {

            trigger OnValidate()
            begin
                MonthDiff := DATE2DMY("To Date", 2) - DATE2DMY("From Date", 2);
            end;
        }
        field(7; MonthDiff; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

