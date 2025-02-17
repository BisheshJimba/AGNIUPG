table 25006163 "Serv. Journal Template"
{
    // * Check Recurring - On Validate
    // Functionality is commented cause isn't needed

    Caption = 'Serv. Journal Template';
    DrillDownPageID = 25006207;
    LookupPageID = 25006207;

    fields
    {
        field(1; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(5; "Test Report ID"; Integer)
        {
            Caption = 'Test Report ID';
            TableRelation = Object.ID WHERE(Type = CONST(Report));
        }
        field(6; "Form ID"; Integer)
        {
            Caption = 'Form ID';
            TableRelation = Object.ID WHERE(Type = CONST(2));

            trigger OnValidate()
            begin
                IF "Form ID" = 0 THEN
                    VALIDATE(Recurring);
            end;
        }
        field(7; "Posting Report ID"; Integer)
        {
            Caption = 'Posting Report ID';
            TableRelation = Object.ID WHERE(Type = CONST(Report));
        }
        field(8; "Force Posting Report"; Boolean)
        {
            Caption = 'Force Posting Report';
        }
        field(10; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";

            trigger OnValidate()
            begin
                ServJnlLine.SETRANGE("Journal Template Name", Name);
                ServJnlLine.MODIFYALL("Source Code", "Source Code");
                MODIFY;
            end;
        }
        field(11; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(12; Recurring; Boolean)
        {
            Caption = 'Recurring';

            trigger OnValidate()
            begin
                IF Recurring THEN
                    "Form ID" := PAGE::"Easy Clocking Set Time"
                ELSE
                    "Form ID" := PAGE::"Service Journal EDMS";
                //"Test Report ID" := REPORT::"Resource Journal - Test";
                //"Posting Report ID" := REPORT::"Resource Register";
                SourceCodeSetup.GET;
                "Source Code" := SourceCodeSetup."Service Management EDMS";
                IF Recurring THEN
                    TESTFIELD("No. Series", '');
            end;
        }
        field(13; "Test Report Name"; Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE(Object Type=CONST(Report),
                                                                           Object ID=FIELD(Test Report ID)));
            Caption = 'Test Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14;"Form Name";Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(2),
                                                                           Object ID=FIELD(Form ID)));
            Caption = 'Form Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15;"Posting Report Name";Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Report),
                                                                           Object ID=FIELD(Posting Report ID)));
            Caption = 'Posting Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF "No. Series" <> '' THEN BEGIN
                  IF Recurring THEN
                    ERROR(
                      Text000,
                      FIELDCAPTION("Posting No. Series"));
                  IF "No. Series" = "Posting No. Series" THEN
                    "Posting No. Series" := '';
                END;
            end;
        }
        field(17;"Posting No. Series";Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF ("Posting No. Series" = "No. Series") AND ("Posting No. Series" <> '') THEN
                  FIELDERROR("Posting No. Series",STRSUBSTNO(Text001,"Posting No. Series"));
            end;
        }
    }

    keys
    {
        key(Key1;Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ServJnlLine.SETRANGE("Journal Template Name",Name);
        ServJnlLine.DELETEALL(TRUE);
        ServJnlBatch.SETRANGE("Journal Template Name",Name);
        ServJnlBatch.DELETEALL;
    end;

    trigger OnInsert()
    begin
        VALIDATE("Form ID");
    end;

    var
        Text000: Label 'Only the %1 field can be filled in on recurring journals.';
        Text001: Label 'must not be %1';
        ServJnlBatch: Record "25006164";
        ServJnlLine: Record "25006165";
        SourceCodeSetup: Record "242";
}

