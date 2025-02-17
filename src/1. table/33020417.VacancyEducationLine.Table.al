table 33020417 "Vacancy Education Line"
{

    fields
    {
        field(1; "Applicant No."; Code[20])
        {
            TableRelation = "Internal Vacancy Applicant"."Applicant No.";
        }
        field(2; "Vacancy Code"; Code[20])
        {
        }
        field(3; "Employee Code"; Code[20])
        {
        }
        field(4; Degree; Option)
        {
            Description = ' ,Master,Bachelors,10+2/ Intermediate,SLC,Others,Professional';
            OptionCaption = ' ,Master,Bachelors,10+2/ Intermediate,SLC,Others,Professional';
            OptionMembers = " ",Master,Bachelors,"10+2/ Intermediate",SLC,Others,Professional;
        }
        field(5; Faculty; Text[100])
        {
        }
        field(6; "College/ Institution"; Text[100])
        {
        }
        field(7; University; Text[100])
        {
        }
        field(8; "Percentage/ GPA"; Text[30])
        {
        }
        field(9; "Passed Year"; Text[30])
        {
        }
        field(10; "Line No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Applicant No.", "Employee Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        educationLine: Record "33020420";
        LineNo: Integer;
}

