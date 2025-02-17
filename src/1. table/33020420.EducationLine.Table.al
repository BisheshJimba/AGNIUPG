table 33020420 "Education Line"
{

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Degree; Option)
        {
            Description = ' ,Master,Bachelors,10+2/ Intermediate,SLC,Others,Professional';
            OptionCaption = ' ,Master,Bachelors,10+2/ Intermediate,SLC,Others,Professional';
            OptionMembers = " ",Master,Bachelors,"10+2/ Intermediate",SLC,Others,Professional;
        }
        field(4; Faculty; Text[100])
        {
        }
        field(5; "College/ Institution"; Text[100])
        {
        }
        field(6; "University/ Board"; Text[100])
        {
        }
        field(7; "Percentage/ GPA"; Text[30])
        {
        }
        field(8; "Passed Year"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

