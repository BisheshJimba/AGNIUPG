table 25006035 "Vehicle Warranty Type"
{
    // 12.06.2007. EDMS P2
    //   * Created table

    Caption = 'Vehicle Warranty Type';
    DataPerCompany = false;
    LookupPageID = 25006025;

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(30; "Description 2"; Text[100])
        {
        }
        field(60; "Term Date Formula"; DateFormula)
        {
            Caption = 'Term Date Formula';
        }
        field(70; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006036,70';
            Description = 'Kilometrage Limit';
        }
        field(71; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006036,71';
        }
        field(72; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006036,72';
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

