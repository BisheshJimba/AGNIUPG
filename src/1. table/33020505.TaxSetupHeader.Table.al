table 33020505 "Tax Setup Header"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*

    DataPerCompany = false;
    DrillDownPageID = 33020503;
    LookupPageID = 33020503;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Effective from"; Date)
        {
        }
        field(4; "Effective to"; Date)
        {
        }
        field(5; "Special Tax Exempt %"; Decimal)
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

