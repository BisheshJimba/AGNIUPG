table 25006020 "Picture Mgt. Setup"
{

    fields
    {
        field(5; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            NotBlank = true;
            TableRelation = Make.Code;
        }
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(30; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(40; "Description 2"; Text[30])
        {
            Caption = 'Description 2';
        }
    }

    keys
    {
        key(Key1; "Make Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

