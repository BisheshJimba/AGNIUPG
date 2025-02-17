table 33020011 "Vehicle Module Setup"
{
    Caption = 'Vehicle Module Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "LC Details Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(3; "LC Ammended Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(4; "Markup %"; Decimal)
        {
        }
        field(5; "LC Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(6; "LC Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Journal Template Name=FIELD(LC Template Name));
        }
        field(7; "CC Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(8; "CC PCD Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Ins. Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "Ins. PCD Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50000; "Prepaid Insurance A/C"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50001; "Reponsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(50002; "Guarantee Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

