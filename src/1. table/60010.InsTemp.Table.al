table 60010 "Ins Temp"
{

    fields
    {
        field(1; "Insurance Policy No."; Code[50])
        {
            Caption = 'Insurance Policy No.';
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "Insurance Policy No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

