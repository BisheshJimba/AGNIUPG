table 33019815 "NCHL-NPI Approval Workflow"
{
    Caption = 'NCHL-NPI Approval Workflow';

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[80])
        {
        }
        field(3; "Amount Filter"; Text[50])
        {
        }
        field(4; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
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

