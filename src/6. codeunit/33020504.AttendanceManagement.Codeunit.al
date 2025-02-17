codeunit 33020504 "Attendance Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: Label '%1 journal';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
        OpenFromBatch: Boolean;

    [Scope('Internal')]
    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var AttJnlLine: Record "33020555")
    begin
        CheckTemplateName(AttJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
        AttJnlLine.FILTERGROUP := 2;
        AttJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        AttJnlLine.FILTERGROUP := 0;
    end;

    [Scope('Internal')]
    procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        AttJnlBatch: Record "33020553";
    begin
        AttJnlBatch.SETRANGE("Journal Template Name", CurrentJnlTemplateName);
        IF NOT AttJnlBatch.GET(CurrentJnlTemplateName, CurrentJnlBatchName) THEN BEGIN
            IF NOT AttJnlBatch.FIND('-') THEN BEGIN
                AttJnlBatch.INIT;
                AttJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                AttJnlBatch.SetupNewBatch;
                AttJnlBatch.Name := Text004;
                AttJnlBatch.Description := Text005;
                AttJnlBatch.INSERT(TRUE);
                COMMIT;
            END;
            CurrentJnlBatchName := AttJnlBatch.Name
        END;
    end;

    [Scope('Internal')]
    procedure TemplateSelection(PageID: Integer; FormTemplate: Option Attendance; var AttJnlLine: Record "33020555"; var JnlSelected: Boolean)
    var
        AttJnlTemplate: Record "33020552";
    begin
        JnlSelected := TRUE;
        AttJnlTemplate.RESET;
        AttJnlTemplate.SETRANGE("Page ID", PageID);
        AttJnlTemplate.SETRANGE(Type, FormTemplate);
        CASE AttJnlTemplate.COUNT OF
            0:
                BEGIN
                    AttJnlTemplate.INIT;
                    AttJnlTemplate.Type := FormTemplate;
                    AttJnlTemplate.Name := FORMAT(AttJnlTemplate.Type, MAXSTRLEN(AttJnlTemplate.Name));
                    AttJnlTemplate.Description := STRSUBSTNO(Text001, AttJnlTemplate.Type);
                    AttJnlTemplate.VALIDATE(Type);
                    AttJnlTemplate.INSERT;
                    COMMIT;
                END;
            1:
                BEGIN
                    AttJnlTemplate.FIND('-');
                END;
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, AttJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            AttJnlLine.FILTERGROUP := 2;
            AttJnlLine.SETRANGE("Journal Template Name", AttJnlTemplate.Name);
            AttJnlLine.FILTERGROUP := 0;
            IF OpenFromBatch THEN BEGIN
                AttJnlLine."Journal Template Name" := '';
                PAGE.RUN(AttJnlTemplate."Page ID", AttJnlLine);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure CheckName(CurrentJnlBatchName: Code[10]; var AttJnlLine: Record "33020555")
    var
        AttJnlBatch: Record "33020553";
    begin
        AttJnlBatch.GET(AttJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
    end;

    [Scope('Internal')]
    procedure LookupName(var CurrentJnlBatchName: Code[10]; var AttJnlLine: Record "33020555")
    var
        AttJnlBatch: Record "33020553";
    begin
        COMMIT;
        AttJnlBatch."Journal Template Name" := AttJnlLine.GETRANGEMAX("Journal Template Name");
        AttJnlBatch.Name := AttJnlLine.GETRANGEMAX("Journal Batch Name");
        AttJnlBatch.FILTERGROUP(2);
        AttJnlBatch.SETRANGE("Journal Template Name", AttJnlBatch."Journal Template Name");
        AttJnlBatch.FILTERGROUP(0);
        IF PAGE.RUNMODAL(0, AttJnlBatch) = ACTION::LookupOK THEN BEGIN
            CurrentJnlBatchName := AttJnlBatch.Name;
            SetName(CurrentJnlBatchName, AttJnlLine);
        END;
    end;

    [Scope('Internal')]
    procedure SetName(CurrentJnlBatchName: Code[10]; var AttJnlLine: Record "33020555")
    begin
        AttJnlLine.FILTERGROUP := 2;
        AttJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        AttJnlLine.FILTERGROUP := 0;
        IF AttJnlLine.FIND('-') THEN;
    end;

    [Scope('Internal')]
    procedure ProcessActivities(var RecAttJnlLine: Record "33020555")
    var
        ImportEmpActivities: Report "33020503";
    begin
        ImportEmpActivities.SetJnlRecord(RecAttJnlLine);
        ImportEmpActivities.RUN;
    end;

    [Scope('Internal')]
    procedure CheckDateStatus(CalendarCode: Code[10]; TargetDate: Date; var Description: Text[50]): Boolean
    var
        BaseCalChange: Record "33020561";
    begin
        BaseCalChange.RESET;
        BaseCalChange.SETRANGE("Base Calendar Code", CalendarCode);
        IF BaseCalChange.FINDSET THEN
            REPEAT
                CASE BaseCalChange."Recurring System" OF
                    BaseCalChange."Recurring System"::" ":
                        IF TargetDate = BaseCalChange.Date THEN BEGIN
                            Description := BaseCalChange.Description;
                            EXIT(BaseCalChange.Nonworking);
                        END;
                    BaseCalChange."Recurring System"::"Weekly Recurring":
                        IF DATE2DWY(TargetDate, 1) = BaseCalChange.Day THEN BEGIN
                            Description := BaseCalChange.Description;
                            EXIT(BaseCalChange.Nonworking);
                        END;
                    BaseCalChange."Recurring System"::"Annual Recurring":
                        IF (DATE2DMY(TargetDate, 2) = DATE2DMY(BaseCalChange.Date, 2)) AND
                           (DATE2DMY(TargetDate, 1) = DATE2DMY(BaseCalChange.Date, 1))
                        THEN BEGIN
                            Description := BaseCalChange.Description;
                            EXIT(BaseCalChange.Nonworking);
                        END;
                END;
            UNTIL BaseCalChange.NEXT = 0;
        Description := '';
    end;
}

