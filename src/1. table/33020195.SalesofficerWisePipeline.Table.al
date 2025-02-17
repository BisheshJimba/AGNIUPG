table 33020195 "Salesofficer Wise Pipeline"
{

    fields
    {
        field(1; "Area"; Code[10])
        {
        }
        field(2; "Officer/Dealer"; Text[50])
        {
        }
        field(3; "DPSE C0"; Integer)
        {
        }
        field(4; "DPSE C1"; Integer)
        {
        }
        field(5; "DPSE C2"; Integer)
        {
        }
        field(6; TDP; Integer)
        {
        }
        field(7; "DP C3"; Integer)
        {
        }
        field(8; "OPSE C0"; Integer)
        {
        }
        field(9; "OPSE C1"; Integer)
        {
        }
        field(10; "OPSE C2"; Integer)
        {
        }
        field(11; TOP; Integer)
        {
        }
        field(12; "OP C3"; Integer)
        {
        }
        field(13; "APDPO C0"; Integer)
        {
        }
        field(14; "APDPO C1"; Integer)
        {
        }
        field(15; "APDPO C2"; Integer)
        {
        }
        field(16; "APDPO TAP"; Integer)
        {
        }
        field(17; Territory; Code[10])
        {
        }
        field(18; "TMSE C0"; Integer)
        {
            Description = 'This month';
        }
        field(19; "TMSE C1"; Integer)
        {
        }
        field(20; "TMSE C2"; Integer)
        {
        }
        field(21; "TMSE C3"; Integer)
        {
        }
        field(22; "TMSE STD"; Integer)
        {
        }
        field(23; "TMSE STCD"; Integer)
        {
        }
        field(24; "TMSE DTC"; Integer)
        {
        }
        field(25; "KAP Planned"; Integer)
        {
        }
        field(26; "KAP Completed"; Integer)
        {
        }
        field(27; "CR C0 to C1"; Decimal)
        {
        }
        field(28; "CR C1 to C3"; Decimal)
        {
        }
        field(29; "CR C2 to C3"; Decimal)
        {
        }
        field(30; Open; Integer)
        {
        }
        field(31; "As on Date"; Integer)
        {
        }
        field(32; "Addn. This Month"; Integer)
        {
        }
        field(33; "Today Visit"; Integer)
        {
        }
        field(34; "Total Visit This Month"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; Territory, "Area", "Officer/Dealer")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

