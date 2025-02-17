table 25006164 "Serv. Journal Batch"
{
    Caption = 'Serv. Journal Batch';
    DataCaptionFields = Name, Description;
    LookupPageID = 25006206;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Serv. Journal Template";
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
        field(4; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";

            trigger OnValidate()
            begin
                IF "Reason Code" <> xRec."Reason Code" THEN BEGIN
                    ServJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                    ServJnlLine.SETRANGE("Journal Batch Name", Name);
                    ServJnlLine.MODIFYALL("Reason Code", "Reason Code");
                    MODIFY;
                END;
            end;
        }
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF "No. Series" <> '' THEN BEGIN
                    ServJnlTemplate.GET("Journal Template Name");
                    IF ServJnlTemplate.Recurring THEN
                        ERROR(
                          Text000,
                          FIELDCAPTION("Posting No. Series"));
                    IF "No. Series" = "Posting No. Series" THEN
                        VALIDATE("Posting No. Series", '');
                END;
            end;
        }
        field(6; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF ("Posting No. Series" = "No. Series") AND ("Posting No. Series" <> '') THEN
                    FIELDERROR("Posting No. Series", STRSUBSTNO(Text001, "Posting No. Series"));
                ServJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                ServJnlLine.SETRANGE("Journal Batch Name", Name);
                ServJnlLine.MODIFYALL("Posting No. Series", "Posting No. Series");
                MODIFY;
            end;
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

    trigger OnDelete()
    begin
        ServJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
        ServJnlLine.SETRANGE("Journal Batch Name", Name);
        ServJnlLine.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    begin
        LOCKTABLE;
        ServJnlTemplate.GET("Journal Template Name");
    end;

    trigger OnRename()
    begin
        ServJnlLine.SETRANGE("Journal Template Name", xRec."Journal Template Name");
        ServJnlLine.SETRANGE("Journal Batch Name", xRec.Name);
        WHILE ServJnlLine.FINDSET(TRUE, TRUE) DO
            ServJnlLine.RENAME("Journal Template Name", Name, ServJnlLine."Line No.");
    end;

    var
        Text000: Label 'Only the %1 field can be filled in on recurring journals.';
        Text001: Label 'must not be %1';
        ServJnlTemplate: Record "25006163";
        ServJnlLine: Record "25006165";

    [Scope('Internal')]
    procedure SetupNewBatch()
    begin
        ServJnlTemplate.GET("Journal Template Name");
        "No. Series" := ServJnlTemplate."No. Series";
        "Posting No. Series" := ServJnlTemplate."Posting No. Series";
        "Reason Code" := ServJnlTemplate."Reason Code";
    end;
}

