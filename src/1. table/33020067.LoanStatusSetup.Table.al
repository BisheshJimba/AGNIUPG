table 33020067 "Loan Status Setup"
{

    fields
    {
        field(1; "From Days"; Integer)
        {
        }
        field(2; "To Days"; Integer)
        {
        }
        field(3; "Loan Status"; Option)
        {
            OptionCaption = 'Performing,Substandard,Doubtful,Critical,Watch list 1,Watch list 2';
            OptionMembers = Performing,Substandard,Doubtful,Critical,"Watch list 1","Watch list 2";
        }
    }

    keys
    {
        key(Key1; "From Days")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

