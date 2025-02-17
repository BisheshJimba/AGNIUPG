table 33019812 "NCHL-NPI Category Purpose"
{
    Caption = 'NCHL-NPI Category Purpose';
    DrillDownPageID = 33019812;
    LookupPageID = 33019812;

    fields
    {
        field(1; "Category Code"; Code[30])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Charge Bearer"; Option)
        {
            OptionCaption = ' ,Sender,Receiver';
            OptionMembers = " ",Sender,Receiver;
        }
    }

    keys
    {
        key(Key1; "Category Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

