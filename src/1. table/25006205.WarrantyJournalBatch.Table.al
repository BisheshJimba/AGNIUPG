table 25006205 "Warranty Journal Batch"
{
    Caption = 'Warranty Journal Batch';
    DataCaptionFields = Name, Description;
    LookupPageID = 25006413;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Warranty Journal Template";
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
                    WarrantyJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                    WarrantyJnlLine.SETRANGE("Journal Batch Name", Name);
                    WarrantyJnlLine.MODIFYALL("Reason Code", "Reason Code");
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
                    WarrantyJnlTemplate.GET("Journal Template Name");
                    IF WarrantyJnlTemplate.Recurring THEN
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
                WarrantyJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                WarrantyJnlLine.SETRANGE("Journal Batch Name", Name);
                WarrantyJnlLine.MODIFYALL("Posting No. Series", "Posting No. Series");
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
        WarrantyJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
        WarrantyJnlLine.SETRANGE("Journal Batch Name", Name);
        WarrantyJnlLine.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    begin
        LOCKTABLE;
        WarrantyJnlTemplate.GET("Journal Template Name");
    end;

    trigger OnRename()
    begin
        WarrantyJnlLine.SETRANGE("Journal Template Name", xRec."Journal Template Name");
        WarrantyJnlLine.SETRANGE("Journal Batch Name", xRec.Name);
        WHILE WarrantyJnlLine.FINDSET(TRUE, TRUE) DO
            WarrantyJnlLine.RENAME("Journal Template Name", Name, WarrantyJnlLine."Line No.");
    end;

    var
        Text000: Label 'Only the %1 field can be filled in on recurring journals.';
        Text001: Label 'must not be %1';
        WarrantyJnlTemplate: Record "25006204";
        WarrantyJnlLine: Record "25006206";

    [Scope('Internal')]
    procedure SetupNewBatch()
    begin
        WarrantyJnlTemplate.GET("Journal Template Name");
        "No. Series" := WarrantyJnlTemplate."No. Series";
        "Posting No. Series" := WarrantyJnlTemplate."Posting No. Series";
        "Reason Code" := WarrantyJnlTemplate."Reason Code";
    end;
}

