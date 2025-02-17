table 33019983 "Dept/Emp. Vehicle"
{
    DrillDownPageID = 33020000;
    LookupPageID = 33020000;

    fields
    {
        field(1; "Entry Type"; Option)
        {
            OptionCaption = ' ,Employee,Department';
            OptionMembers = " ",Employee,Department;
        }
        field(2; "Code"; Code[20])
        {
        }
        field(3; "Vehicle No./Reg. No."; Code[30])
        {
        }
        field(4; Type; Option)
        {
            OptionCaption = ' ,Vehicle,Motorcycle,Generator,Others';
            OptionMembers = " ",Vehicle,Motorcycle,Generator,Others;
        }
        field(5; Location; Code[10])
        {
            TableRelation = "Location - Admin".Code;
        }
        field(6; VIN; Code[20])
        {
        }
        field(7; Mileage; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Entry Type", "Code", Type, "Vehicle No./Reg. No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

