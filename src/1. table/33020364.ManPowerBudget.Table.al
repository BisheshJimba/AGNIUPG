table 33020364 "Man-Power Budget"
{

    fields
    {
        field(1; "Fiscal Year"; Code[9])
        {
            TableRelation = "Eng-Nep Date"."Fiscal Year";
        }
        field(2; Department; Text[30])
        {
            TableRelation = "Location Master".Description;
        }
        field(3; Location; Text[30])
        {
            TableRelation = Location.Name;
        }
        field(4; Level; Option)
        {
            OptionMembers = " ","Manager Level","Officer Level","Technician/Assistant","Support/Drivers";
        }
        field(5; "No. Of Position"; Integer)
        {
        }
        field(6; "Intake Number"; Integer)
        {
        }
        field(7; "Last Intake Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Fiscal Year", Department, Location, Level)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

