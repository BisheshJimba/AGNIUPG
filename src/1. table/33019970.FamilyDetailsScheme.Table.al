table 33019970 "Family Details (Scheme)"
{

    fields
    {
        field(1; "Membership No."; Code[20])
        {
        }
        field(2; Name; Text[100])
        {
        }
        field(4; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(5; Grade; Text[30])
        {
        }
        field(6; "Qualified for Scholorship"; Boolean)
        {

            trigger OnValidate()
            begin
                IF NOT "Qualified for Scholorship" THEN
                    "Scholorship Amount" := 0;
            end;
        }
        field(7; "Scholorship Amount"; Decimal)
        {
        }
        field(8; "Line No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Membership No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

