table 25006127 "Service Labor Translation"
{
    Caption = 'Service Labor Translation';
    DrillDownPageID = 25006203;
    LookupPageID = 25006203;

    fields
    {
        field(30; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(35; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            NotBlank = true;
            TableRelation = Language;
        }
        field(40; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(50; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
    }

    keys
    {
        key(Key1; "No.", "Language Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

