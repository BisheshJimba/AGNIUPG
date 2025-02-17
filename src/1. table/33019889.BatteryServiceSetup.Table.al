table 33019889 "Battery Service Setup"
{

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            TableRelation = "Req. Wksh. Template".Name;
        }
        field(2; "Journal Batch Name"; Code[10])
        {
        }
        field(3; "Primary Key"; Code[10])
        {
        }
        field(4; "Entry Type"; Option)
        {
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output;
        }
        field(5; "Inventory Posting Group"; Code[10])
        {
            TableRelation = "Inventory Posting Group";
        }
        field(6; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(7; "Gen. Prod. Posting Group"; Code[10])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(8; "Flushing Method"; Option)
        {
            OptionMembers = Manual,Forward,Backward,"Pick + Forward","Pick + Backward";
        }
        field(9; "Warranty Customer"; Code[20])
        {
            TableRelation = Customer.No. WHERE(No.=CONST(WARR-BATT));
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

