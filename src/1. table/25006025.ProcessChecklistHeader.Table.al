table 25006025 "Process Checklist Header"
{
    // 29.04.2015 EB.P7 #HklaBug
    //   Template Code - OnValidate() trigger modified.

    Caption = 'Process Checklist Header';
    LookupPageID = 25006010;

    fields
    {
        field(10; "No."; Code[10])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    ProcessChecklistSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                END;
            end;
        }
        field(20; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(30; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(40; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
        }
        field(50; VIN; Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Caption = 'VIN';
                Editable = false;
                FieldClass = FlowField;
        }
        field(60; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(70; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(80; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(100; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            TableRelation = "Process Checklist Template";

            trigger OnValidate()
            var
                ChecklistLine: Record "25006028";
            begin
                TESTFIELD("No.");

                ChecklistLine.RESET;
                ChecklistLine.SETRANGE("Process Checklist No.", "No.");
                IF ChecklistLine.FINDFIRST THEN
                    ERROR(Text010, FIELDCAPTION("Template Code"));

                FillTemplateLines;
            end;
        }
        field(200; "Process Date"; Date)
        {
            Caption = 'Process Date';
        }
        field(33020235; Picture; BLOB)
        {
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Vehicle Serial No.")
        {
        }
        key(Key3; "Source Type", "Source Subtype", "Source ID")
        {
        }
        key(Key4; "Source ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ProcessChecklistLine: Record "25006028";
    begin
        ProcessChecklistLine.RESET;
        ProcessChecklistLine.SETRANGE("Process Checklist No.", "No.");
        ProcessChecklistLine.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    var
        ProcessChecklistTemplate: Record "25006026";
    begin
        // Sipradi-YS BEGIN * Code to check Steps
        ServiceStepsChecking.CheckSteps("Source ID", Steps::CheckBay);

        // Sipradi-YS END
        IF "No." = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "Process Date" := TODAY;
        //SIPRADI BEGIN
        Vehicle.GET("Vehicle Serial No.");
        "Template Code" := Vehicle."Make Code";
        FillTemplateLines;
        //SIPRADI END
    end;

    var
        ProcessChecklistSetup: Record "25006009";
        ProcessChecklistHdr: Record "25006025";
        NoSeriesMgt: Codeunit "396";
        ServiceStepsChecking: Codeunit "33020236";
        Steps: Option CheckBay,CheckChecklist,CheckDiagnosis;
        UserProfileSetup: Record "25006067";
        UserSetup: Record "91";
        Vehicle: Record "25006005";
        Text051: Label 'Process checkilst %1 already exists.';
        Text010: Label 'You cannot change %1 while lines exist.';

    [Scope('Internal')]
    procedure AssistEdit(OldProcessChecklistHdr: Record "25006025"): Boolean
    var
        ProcessChecklistHdr2: Record "25006025";
    begin
        ProcessChecklistHdr.COPY(Rec);
        ProcessChecklistSetup.GET;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(ProcessChecklistSetup."Process Checklist Nos.",
           OldProcessChecklistHdr."No. Series", ProcessChecklistHdr."No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(ProcessChecklistHdr."No.");
            IF ProcessChecklistHdr2.GET(ProcessChecklistHdr."No.") THEN
                ERROR(Text051, ProcessChecklistHdr."No.");
            Rec := ProcessChecklistHdr;
            EXIT(TRUE);
        END;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        ProcessChecklistSetup.GET;
        ProcessChecklistSetup.TESTFIELD("Process Checklist Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        EXIT(ProcessChecklistSetup."Process Checklist Nos.");
    end;

    [Scope('Internal')]
    procedure FillTemplateLines()
    var
        ChecklistTemplateLine: Record "25006027";
        LineNo: Integer;
        ChecklistLine: Record "25006028";
    begin
        LineNo := 0;
        ChecklistTemplateLine.RESET;
        ChecklistTemplateLine.SETRANGE("Template Code", "Template Code");
        IF ChecklistTemplateLine.FINDFIRST THEN
            REPEAT
                LineNo += 10000;
                ChecklistLine.INIT;
                // ChecklistLine.VALIDATE("Process Checklist No.","No.");
                ChecklistLine."Process Checklist No." := "No.";
                ChecklistLine.VALIDATE("Line No.", LineNo);
                ChecklistLine.INSERT(TRUE);
                ChecklistLine.VALIDATE("Type Code", ChecklistTemplateLine."Type Code");
                ChecklistLine.MODIFY(TRUE);
            UNTIL ChecklistTemplateLine.NEXT = 0;
    end;
}

