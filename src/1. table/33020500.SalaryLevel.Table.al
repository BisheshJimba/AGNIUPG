table 33020500 "Salary Level"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*

    DrillDownPageID = 33020504;
    LookupPageID = 33020504;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
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
    }
}

