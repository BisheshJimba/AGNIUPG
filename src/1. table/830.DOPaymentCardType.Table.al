table 830 "DO Payment Card Type"
{
    Caption = 'Dynamics Online Payment Card Type';
    DrillDownPageID = 830;
    LookupPageID = 830;

    fields
    {
        field(1; "Sort Order"; Integer)
        {
            AutoIncrement = false;
            Caption = 'Sort Order';
        }
        field(2; Name; Code[20])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3; "Validation Rule"; Integer)
        {
            Caption = 'Validation Rule';
            NotBlank = true;
        }
        field(4; "Numeric Only"; Boolean)
        {
            Caption = 'Numeric Only';
            InitValue = true;
        }
        field(5; "Allow Spaces"; Boolean)
        {
            Caption = 'Allow Spaces';
            InitValue = true;
        }
        field(6; "Min. Length"; Integer)
        {
            Caption = 'Min. Length';
        }
        field(7; "Max. Length"; Integer)
        {
            Caption = 'Max. Length';
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
        key(Key2; "Sort Order")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        DOPaymentCardType: Record "DO Payment Card Type";
    begin
        IF "Sort Order" = 0 THEN BEGIN
            DOPaymentCardType.SETCURRENTKEY("Sort Order");
            IF DOPaymentCardType.FINDLAST THEN
                "Sort Order" := DOPaymentCardType."Sort Order" + 1
            ELSE
                "Sort Order" := 1;
        END;
    end;

    [Scope('Internal')]
    procedure CreateDefaults()
    begin
        IF NOT FINDFIRST THEN BEGIN
            INIT;
            "Sort Order" := 1;
            Name := 'VISA';
            "Validation Rule" := 1;
            "Numeric Only" := TRUE;
            "Allow Spaces" := FALSE;
            "Min. Length" := 16;
            "Max. Length" := 16;
            INSERT;

            INIT;
            "Sort Order" := 2;
            Name := 'MASTER CARD';
            "Validation Rule" := 1;
            "Numeric Only" := TRUE;
            "Allow Spaces" := FALSE;
            "Min. Length" := 16;
            "Max. Length" := 16;
            INSERT;

            INIT;
            "Sort Order" := 3;
            Name := 'AMERICAN EXPRESS';
            "Validation Rule" := 1;
            "Numeric Only" := TRUE;
            "Allow Spaces" := FALSE;
            "Min. Length" := 15;
            "Max. Length" := 15;
            INSERT;

            INIT;
            "Sort Order" := 4;
            Name := 'DISCOVER';
            "Validation Rule" := 1;
            "Numeric Only" := TRUE;
            "Allow Spaces" := FALSE;
            "Min. Length" := 16;
            "Max. Length" := 16;
            INSERT;
        END;
    end;
}

