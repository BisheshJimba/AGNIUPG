table 25006268 "Serv. Allocation Description"
{
    Caption = 'Serv. Allocation Description';
    DrillDownPageID = 25006080;
    LookupPageID = 25006080;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; Description; Text[250])
        {
            Caption = 'Description';
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

    trigger OnInsert()
    begin
        IF "Entry No." = 0 THEN BEGIN
            ServAllocationDetail.RESET;
            IF ServAllocationDetail.FINDLAST THEN
                "Entry No." := ServAllocationDetail."Entry No.";
            "Entry No." += 1;
        END;
    end;

    var
        ServAllocationDetail: Record "25006268";
}

