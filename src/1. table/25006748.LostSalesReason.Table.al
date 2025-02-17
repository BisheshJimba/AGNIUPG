table 25006748 "Lost Sales Reason"
{
    Caption = 'Lost Sales Reason';
    LookupPageID = 25006859;

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[150])
        {
            Caption = 'Description';
        }
        field(30; "Description 2"; Text[150])
        {
            Caption = 'Description 2';
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

