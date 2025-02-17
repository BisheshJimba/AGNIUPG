table 33020378 "Manpower Budget_Entry"
{
    // Design and developed by Sangam Shrestha on 11 April 2012 at 9.30 PM.


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Fiscal Year"; Code[10])
        {
            TableRelation = "Manpower Budget Header"."Fiscal Year";
        }
        field(3; "Department Code"; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));
        }
        field(4; "Department Name"; Text[100])
        {
            CalcFormula = Lookup("Location Master".Description WHERE(Code = FIELD(Department Code)));
            FieldClass = FlowField;
        }
        field(5; Location; Code[10])
        {
            TableRelation = Location.Code;
        }
        field(6; "No. of Person"; Integer)
        {
        }
        field(7; Description; Text[250])
        {
        }
        field(8; Date; Date)
        {
        }
        field(9; Position; Code[80])
        {
        }
        field(10; TestYear; Code[10])
        {
        }
        field(11; TestYear1; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Fiscal Year")
        {
        }
    }

    fieldgroups
    {
    }
}

