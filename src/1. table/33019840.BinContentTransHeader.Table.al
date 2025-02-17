table 33019840 "Bin Content Trans. Header"
{

    fields
    {
        field(1; "No."; Integer)
        {
        }
        field(2; Location; Code[10])
        {
        }
        field(3; "Item No."; Code[20])
        {
        }
        field(4; "Item Description"; Text[50])
        {
        }
        field(5; "Opening Balance"; Decimal)
        {
        }
        field(6; "Date From"; Date)
        {
        }
        field(7; "Date To"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; Location, "Item No.")
        {
        }
    }

    fieldgroups
    {
    }
}

