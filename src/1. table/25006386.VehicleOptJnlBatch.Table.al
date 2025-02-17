table 25006386 "Vehicle Opt. Jnl. Batch"
{
    // 19.06.2004 EDMS P1
    //    *Created

    Caption = 'Vehicle Option Jnl. Batch';
    DataCaptionFields = Name, Description;
    LookupPageID = 25006523;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = "Vehicle Opt. Jnl. Template";
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
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF "No. Series" <> '' THEN BEGIN
                    recVehOptJnlTemplate.GET("Journal Template Name");
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
                recVehOptJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                recVehOptJnlLine.SETRANGE("Journal Batch Name", Name);
                recVehOptJnlLine.MODIFYALL("Posting No. Series", "Posting No. Series");
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
        recVehOptJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
        recVehOptJnlLine.SETRANGE("Journal Batch Name", Name);
        recVehOptJnlLine.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    begin
        LOCKTABLE;
        recVehOptJnlTemplate.GET("Journal Template Name");
    end;

    trigger OnRename()
    begin
        recVehOptJnlLine.SETRANGE("Journal Template Name", xRec."Journal Template Name");
        recVehOptJnlLine.SETRANGE("Journal Batch Name", xRec.Name);
        IF recVehOptJnlLine.FINDSET(TRUE, TRUE) THEN
            REPEAT
                recVehOptJnlLine.RENAME("Journal Template Name", Name, recVehOptJnlLine."Line No.");
            UNTIL recVehOptJnlLine.NEXT = 0;
    end;

    var
        Text000: Label 'Only the %1 field can be filled in on recurring journals.';
        Text001: Label 'must not be %1';
        recVehOptJnlTemplate: Record "25006385";
        recVehOptJnlLine: Record "25006387";

    [Scope('Internal')]
    procedure fSetupNewBatch()
    begin
        recVehOptJnlTemplate.GET("Journal Template Name");
        "No. Series" := recVehOptJnlTemplate."No. Series";
        "Posting No. Series" := recVehOptJnlTemplate."Posting No. Series";
    end;
}

