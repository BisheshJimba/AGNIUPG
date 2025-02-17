table 33020034 "Gen. Journal Narration"
{
    Caption = 'Gen. Journal Narration';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE(Journal Template Name=FIELD(Journal Template Name));
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(4; "Gen. Journal Line No."; Integer)
        {
            Caption = 'Gen. Journal Line No.';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; Narration; Text[50])
        {
            Caption = 'Narration';

            trigger OnLookup()
            begin
                IF PAGE.RUNMODAL(0, StdTxt) = ACTION::LookupOK THEN
                    Narration := StdTxt.Description;
            end;
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Document No.", "Gen. Journal Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        StdTxt: Record "7";
}

