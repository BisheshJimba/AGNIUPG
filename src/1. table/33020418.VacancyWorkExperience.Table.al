table 33020418 "Vacancy WorkExperience"
{

    fields
    {
        field(1; "Applicant No."; Code[20])
        {
            TableRelation = "Internal Vacancy Applicant"."Applicant No.";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Employee Code"; Code[20])
        {
        }
        field(5; Organization; Text[100])
        {
        }
        field(6; Department; Text[100])
        {
        }
        field(7; Position; Text[100])
        {
        }
        field(8; Duration; Decimal)
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
}

