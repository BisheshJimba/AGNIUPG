table 33019813 "NCHL-NPI Transaction Setup"
{
    Caption = 'NCHL-NPI Transaction Setup';

    fields
    {
        field(1; "Integration Type"; Option)
        {
            OptionCaption = ' ,Real Time,Non-Real Time';
            OptionMembers = " ","Real Time","Non-Real Time";
        }
        field(2; "Transaction Type"; Option)
        {
            OptionCaption = ' ,On-Us (Same Bank),Off-Us (Inter Bank)';
            OptionMembers = " ","On-Us (Same Bank)","Off-Us (Inter Bank)";
        }
        field(3; "Category Purpose"; Code[30])
        {
            TableRelation = "NCHL-NPI Category Purpose";
        }
        field(4; "Transaction per Batch"; Integer)
        {
        }
        field(5; "Per Transaction Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Integration Type", "Transaction Type", "Category Purpose")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

