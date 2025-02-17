table 33020553 "Attendance Journal Batch"
{
    LookupPageID = 33020554;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = "Attendance Journal Template";
        }
        field(2; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(7; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(8; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        AttJnlTemplate: Record "33020552";

    [Scope('Internal')]
    procedure SetupNewBatch()
    begin
        AttJnlTemplate.GET("Journal Template Name");
        "No. Series" := AttJnlTemplate."No. Series";
        "Posting No. Series" := AttJnlTemplate."Posting No. Series";
    end;
}

