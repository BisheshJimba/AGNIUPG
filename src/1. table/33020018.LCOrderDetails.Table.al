table 33020018 "LC Order Details"
{

    fields
    {
        field(1; "LC No."; Code[20])
        {
        }
        field(2; "Bank LC No."; Code[20])
        {
        }
        field(3; "Trasaction Type"; Option)
        {
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(4; "Issued To/Received From"; Code[20])
        {
        }
        field(5; "Order No."; Code[20])
        {
        }
        field(6; "Shipment Date"; Date)
        {
        }
        field(7; "Order Value"; Decimal)
        {
        }
        field(8; Renewed; Boolean)
        {
        }
        field(9; "Received Bank Receipt No."; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "LC No.", "Order No.")
        {
            Clustered = true;
            SumIndexFields = "Order Value";
        }
    }

    fieldgroups
    {
    }
}

