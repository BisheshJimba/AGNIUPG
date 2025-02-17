table 33019877 "TDS Posting Buffer"
{

    fields
    {
        field(1; "TDS Group"; Code[20])
        {
            TableRelation = "TDS Posting Group";
        }
        field(2; "TDS%"; Decimal)
        {
        }
        field(3; "GL Account No."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(4; "TDS Type"; Option)
        {
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(5; "TDS Base Amount"; Decimal)
        {
        }
        field(6; "TDS Amount"; Decimal)
        {
        }
        field(7; "Global Dimension 1 Code"; Code[20])
        {
        }
        field(8; "Global Dimension 2 Code"; Code[20])
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "TDS Group")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure ReverseTDSAmounts()
    begin
        //TDS2.00
        "TDS Amount" := -"TDS Amount";
        "TDS Base Amount" := -"TDS Base Amount";
    end;
}

