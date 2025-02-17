table 60001 "Manpower Budget Line"
{

    fields
    {
        field(1; "Fiscal Year"; Code[10])
        {
            TableRelation = "Manpower Budget Header"."Fiscal Year";
        }
        field(2; "Department Code"; Code[10])
        {
            TableRelation = "Location Master".Code;
        }
        field(3; "Department Name"; Text[100])
        {
        }
        field(4; "Position 1"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(60001, 4); //need to solve error in codeunit
        }
        field(5; "Position 2"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(60001, 5);
        }
        field(6; "Position 3"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(60001, 6);
        }
        field(7; "Position 4"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(60001, 7);
        }
        field(8; "Position 5"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(60001, 8);
        }
        field(9; "Position 6"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(60001, 9);
        }
        field(10; "Position 7"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(60001, 10);
        }
        field(11; "Position 8"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(60001, 11);
        }
        field(12; "Position 9"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(60001, 12);
        }
        field(13; "Position 10"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(60001, 13);
        }
    }

    keys
    {
        key(Key1; "Fiscal Year", "Department Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GblStplMngt: Codeunit 50000;
}

