table 50001 "Location Wise File"
{

    fields
    {
        field(1; Location; Code[10])
        {
        }
        field(2; "Fiscal Year"; Code[10])
        {
        }
        field(3; "Usage Type"; Option)
        {
            OptionCaption = ' ,Finance';
            OptionMembers = " ",Finance;
        }
        field(4; "Last File No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; Location, "Fiscal Year", "Usage Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

