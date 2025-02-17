table 33020336 "Employee Group"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Weekly Working Days"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(4; "Monthly Working Days"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(5; "Yearly Working Days"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(6; "Yearly Leave Days"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(7; "Annual Pay Leave Days"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(8; "Base Calender"; Code[20])
        {
            Description = 'Lookup to Base calender table.';
            TableRelation = "Base Calendar".Code;
        }
        field(9; "Pay Type"; Option)
        {
            OptionMembers = Salaried,Hourly;
        }
        field(10; "Pay Frequency"; Option)
        {
            OptionMembers = Day,Week,Month,Quarter,Yearly;
        }
        field(11; "Regular Working Hours"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(12; "Overtime Tolerence Hours"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(13; "Regular Hours Overtime Rate"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(14; "Overtime Hours Rate"; Decimal)
        {
        }
        field(15; "Hours Per Month"; Decimal)
        {
        }
        field(16; "Donot Process Salary"; Boolean)
        {
        }
        field(17; "Donot Process Leave Pay"; Boolean)
        {
        }
        field(18; "Donot Process Gratuity"; Boolean)
        {
            Description = 'Gift, Bonus and others';
        }
        field(19; "Donot Process Air Ticket"; Boolean)
        {
        }
        field(20; "Donot Process Bus Ticket"; Boolean)
        {
        }
        field(21; "No. of Sick Leaves"; Decimal)
        {
        }
        field(22; "No. of Maternity Leaves"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(23; "No. of Emergency Leaves"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(24; "Leave Including Weekend"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

