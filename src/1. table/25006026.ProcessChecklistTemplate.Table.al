table 25006026 "Process Checklist Template"
{
    Caption = 'Process Checklist Template';
    DrillDownPageID = 25006011;
    LookupPageID = 25006011;

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(20; Description; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Field100)
        {
        }
    }
}

