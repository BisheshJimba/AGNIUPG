table 345 "Setup Checklist Comment"
{
    Caption = 'Setup Checklist Comment';
    // DrillDownPageID = 532;
    // LookupPageID = 532;

    fields
    {
        field(1; "Table Name"; Text[80])
        {
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Setup Checklist Line"."Table Name" where("Table ID" = field("Table ID")));
        }
        field(2; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            TableRelation = "Setup Checklist Line";
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
        key(Key1; "Table ID", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure SetUpNewLine()
    var
        CommentLine: Record "Setup Checklist Comment";
    begin
        CommentLine.SetRange("Table ID", "Table ID");
        IF NOT CommentLine.Find('-') THEN
            Date := WorkDate();
    end;
}

