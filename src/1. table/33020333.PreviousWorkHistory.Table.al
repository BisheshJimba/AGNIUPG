table 33020333 "Previous Work History"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Table Name=CONST(Application)) Application.No.
                            ELSE IF (Table Name=CONST(Employee)) Employee.No.;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Company Name"; Text[250])
        {
        }
        field(4; "Job Description"; Text[250])
        {
        }
        field(5; "From Date"; Date)
        {

            trigger OnValidate()
            begin
                "Additional From Date" := STPLSysMgmt.getNepaliDate("From Date");
            end;
        }
        field(6; "To Date"; Date)
        {

            trigger OnValidate()
            begin
                "Additional To Date" := STPLSysMgmt.getNepaliDate("To Date");
            end;
        }
        field(7; "Current Employer"; Boolean)
        {
        }
        field(8; "Table Name"; Option)
        {
            OptionMembers = " ",Application,Employee;
        }
        field(9; "Additional From Date"; Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020333, 9);

            trigger OnValidate()
            begin
                "From Date" := STPLSysMgmt.getEngDate("Additional From Date");
            end;
        }
        field(10; "Additional To Date"; Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020333, 10);

            trigger OnValidate()
            begin
                "To Date" := STPLSysMgmt.getEngDate("Additional To Date");
            end;
        }
        field(11; "Years Worked"; Decimal)
        {
        }
        field(12; Salary; Decimal)
        {
        }
        field(13; Department; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.", "Table Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        STPLSysMgmt: Codeunit "50000";
}

