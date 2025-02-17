table 5181 "Unsynchronized Category"
{
    Caption = 'Unsynchronized Category';
    //DrillDownPageID = 5181;

    fields
    {
        field(1; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            // TableRelation = Salesperson/Purchaser;
            TableRelation = "Salesperson/Purchaser";
        }
        field(2; Category; Text[50])
        {
            Caption = 'Category';
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "Salesperson Code", Category)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

