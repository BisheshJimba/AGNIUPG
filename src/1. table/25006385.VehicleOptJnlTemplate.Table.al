table 25006385 "Vehicle Opt. Jnl. Template"
{
    // 19.06.2004 EDMS P1
    //    *Created

    Caption = 'Vehicle Option Jnl. Template';
    LookupPageID = 25006522;

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
                "Form ID" := PAGE::"Vehicle Option Journal"
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
        field(15; "Test Report Name"; Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE(Object Type=CONST(Report),
                                                                           Object ID=FIELD(Test Report ID)));
            Caption = 'Test Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16;"Form Name";Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(2),
                                                                           Object ID=FIELD(Form ID)));
            Caption = 'Form Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;"Posting Report Name";Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Report),
                                                                           Object ID=FIELD(Posting Report ID)));
            Caption = 'Posting Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(20;"Posting No. Series";Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF ("Posting No. Series" = "No. Series") AND ("Posting No. Series" <> '') THEN
                  FIELDERROR("Posting No. Series",STRSUBSTNO(Text001,"Posting No. Series"));
            end;
        }
        field(30;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
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
        recVehOptJnlLine.SETRANGE("Journal Template Name",Name);
        recVehOptJnlLine.DELETEALL(TRUE);
        recVehOptJnlBatch.SETRANGE("Journal Template Name",Name);
        recVehOptJnlBatch.DELETEALL;
    end;

    trigger OnInsert()
    begin
        VALIDATE("Form ID");
    end;

    var
        Text001: Label 'must not be %1';
        recVehOptJnlBatch: Record "25006386";
        recVehOptJnlLine: Record "25006387";
}

