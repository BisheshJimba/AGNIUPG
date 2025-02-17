table 33020377 "Manpower Budget_Line"
{

    fields
    {
        field(1; "Fiscal Year"; Code[10])
        {
            TableRelation = "Manpower Budget_Header"."Fiscal Year";
        }
        field(2; "Department Code"; Code[10])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                //sm to get department name

                Department.SETRANGE(Code, "Department Code");
                IF Department.FIND('-') THEN BEGIN
                    "Department Name" := Department.Description;
                END;
            end;
        }
        field(3; "Department Name"; Text[100])
        {
        }
        field(4; "Position 1"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(33020377, 4);
        }
        field(5; "Position 2"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(33020377, 5);
        }
        field(6; "Position 3"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(33020377, 6);
        }
        field(7; "Position 4"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(33020377, 7);
        }
        field(8; "Position 5"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(33020377, 8);
        }
        field(9; "Position 6"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(33020377, 9);
        }
        field(10; "Position 7"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(33020377, 10);
        }
        field(11; "Position 8"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(33020377, 11);
        }
        field(12; "Position 9"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(33020377, 12);
        }
        field(13; "Position 10"; Integer)
        {
            CaptionClass = GblStplMngt.getVariableField(33020377, 13);
        }
        field(14; TestYear; Code[10])
        {
        }
        field(15; TestYear1; Code[10])
        {
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
        GblStplMngt: Codeunit "50000";
        Department: Record "33020337";
}

