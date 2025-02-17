table 14125601 "Entry Lines Temp"
{
    DataCaptionFields = "Table Name", "Document No.";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Dimension 1"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                IF CalledFromTemporaryUpdate THEN
                    ValidateShortcutDimCode(1, "Dimension 1");
            end;
        }
        field(3; "Dimension 2"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                IF CalledFromTemporaryUpdate THEN
                    ValidateShortcutDimCode(2, "Dimension 2");
            end;
        }
        field(4; "Dimension 3"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                IF CalledFromTemporaryUpdate THEN
                    ValidateShortcutDimCode(3, "Dimension 3");
            end;
        }
        field(5; "Dimension 4"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                IF CalledFromTemporaryUpdate THEN
                    ValidateShortcutDimCode(4, "Dimension 4");
            end;
        }
        field(6; "Dimension 5"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                IF CalledFromTemporaryUpdate THEN
                    ValidateShortcutDimCode(5, "Dimension 5");
            end;
        }
        field(7; "Dimension 6"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                IF CalledFromTemporaryUpdate THEN
                    ValidateShortcutDimCode(6, "Dimension 6");
            end;
        }
        field(8; "Dimension 7"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                IF CalledFromTemporaryUpdate THEN
                    ValidateShortcutDimCode(7, "Dimension 7");
            end;
        }
        field(9; "Dimension 8"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                IF CalledFromTemporaryUpdate THEN
                    ValidateShortcutDimCode(8, "Dimension 8");
            end;
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
        field(50; "Line No."; Integer)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit DimensionManagement;
        CalledFromTemporaryUpdate: Boolean;

    [Scope('Internal')]
    procedure UpdateDimension(var TempTable: Record "Entry Lines Temp")
    var
        LogTable: Record "SMS Setup 1";
    begin
    end;

    local procedure "--SRT--"()
    begin
    end;

    [Scope('Internal')]
    procedure SetCalledFromTemporaryUpdate(_CalledFromTemporaryUpdate: Boolean)
    begin
        CalledFromTemporaryUpdate := _CalledFromTemporaryUpdate;  //SRT Nov 8th 2019
    end;

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "New Dimension Set ID");
    end;
}

