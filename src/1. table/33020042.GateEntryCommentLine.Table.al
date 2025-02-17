table 33020042 "Gate Entry Comment Line"
{
    Caption = 'Gate Entry Comment Line';
    DrillDownPageID = 16595;
    LookupPageID = 16595;

    fields
    {
        field(1; "Gate Entry Type"; Option)
        {
            Caption = 'Gate Entry Type';
            OptionCaption = 'Inward,Outward';
            OptionMembers = Inward,Outward;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "Gate Entry Type", "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GateEntryCommentLine: Record "33020042";

    [Scope('Internal')]
    procedure SetUpNewLine()
    begin
        GateEntryCommentLine.SETRANGE("Gate Entry Type", "Gate Entry Type");
        GateEntryCommentLine.SETRANGE("No.", "No.");
        GateEntryCommentLine.SETRANGE(Date, WORKDATE);
        IF NOT GateEntryCommentLine.FINDFIRST THEN
            Date := WORKDATE;
    end;
}

