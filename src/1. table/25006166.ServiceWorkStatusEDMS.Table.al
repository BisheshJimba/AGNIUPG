table 25006166 "Service Work Status EDMS"
{
    Caption = 'Service Work Status';
    DrillDownPageID = 25006202;
    LookupPageID = 25006202;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "Service Order Status"; Option)
        {
            Caption = 'Service Order Status';
            OptionCaption = 'Pending,In Process,Finished,On Hold,Booking';
            OptionMembers = Pending,"In Process",Finished,"On Hold",Booking;
        }
        field(4; Priority; Option)
        {
            Caption = 'Priority';
            OptionCaption = 'High,Medium High,Medium Low,Low';
            OptionMembers = High,"Medium High","Medium Low",Low;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Priority)
        {
        }
    }

    fieldgroups
    {
    }
}

