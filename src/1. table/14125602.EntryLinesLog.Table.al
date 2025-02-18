table 14125602 "Entry Lines Log"
{
    DataCaptionFields = "Table Name", "Document No.";

    fields
    {
        field(1; "Document No."; Code[250])
        {
            Editable = false;
        }
        field(2; "Dimension 1"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(3; "Dimension 2"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(4; "Dimension 3"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(5; "Dimension 4"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(6; "Dimension 5"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(7; "Dimension 6"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(8; "Dimension 7"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(9; "Dimension 8"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(10; "Table Name"; Text[50])
        {
            Editable = false;
        }
        field(11; "Dimension Set ID"; Integer)
        {
            Editable = false;
        }
        field(12; "New Dimension Set ID"; Integer)
        {
            Editable = false;
        }
        field(13; "Table ID"; Integer)
        {
            Editable = false;
        }
        field(22; "Primary Key 1"; Text[30])
        {
            Editable = false;
        }
        field(23; "Primary Key 2"; Text[30])
        {
            Editable = false;
        }
        field(24; "Primary Key 3"; Text[30])
        {
            Editable = false;
        }
        field(25; "Primary Key 4"; Text[30])
        {
            Editable = false;
        }
        field(30; "Reason Text"; Text[250])
        {
        }
        field(50; "Entry No."; Integer)
        {
            Editable = false;
        }
        field(51; "User ID"; Code[50])
        {
        }
        field(52; Date; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit DimensionManagement;

    procedure UpdateDimension(var TempTable: Record "Entry Lines Temp")
    var
        LogTable: Record "SMS Setup 1";
    begin
    end;
}

