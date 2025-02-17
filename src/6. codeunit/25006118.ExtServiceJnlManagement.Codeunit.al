codeunit 25006118 "Ext.ServiceJnlManagement"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'EXTSERV';
        Text001: Label 'Ext. Service Journals';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
        OldExtServiceNo: Code[20];

    [Scope('Internal')]
    procedure TemplateSelection(var ExtServiceJnlLine: Record "25006143"; var JnlSelected: Boolean)
    var
        ExtServiceJnlTemplate: Record "25006142";
    begin
        JnlSelected := TRUE;

        ExtServiceJnlTemplate.RESET;

        CASE ExtServiceJnlTemplate.COUNT OF
            0:
                BEGIN
                    ExtServiceJnlTemplate.INIT;
                    ExtServiceJnlTemplate.Name := Text000;
                    ExtServiceJnlTemplate.Description := Text001;
                    ExtServiceJnlTemplate.VALIDATE("Form ID");
                    ExtServiceJnlTemplate.INSERT;
                    COMMIT;
                END;
            1:
                ExtServiceJnlTemplate.FINDFIRST;
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, ExtServiceJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            ExtServiceJnlLine.FILTERGROUP := 2;
            ExtServiceJnlLine.SETRANGE("Journal Template Name", ExtServiceJnlTemplate.Name);
            ExtServiceJnlLine.FILTERGROUP := 0;
        END;
    end;

    [Scope('Internal')]
    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var ExtServiceJnlLine: Record "25006143")
    begin
        CheckTemplateName(ExtServiceJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
        ExtServiceJnlLine.FILTERGROUP := 2;
        ExtServiceJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        ExtServiceJnlLine.FILTERGROUP := 0;
    end;

    [Scope('Internal')]
    procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        ExtServiceJnlBatch: Record "25006144";
    begin
        ExtServiceJnlBatch.SETRANGE("Journal Template Name", CurrentJnlTemplateName);
        IF NOT ExtServiceJnlBatch.GET(CurrentJnlTemplateName, CurrentJnlBatchName) THEN BEGIN
            IF ExtServiceJnlBatch.ISEMPTY THEN BEGIN
                ExtServiceJnlBatch.INIT;
                ExtServiceJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                ExtServiceJnlBatch.SetupNewBatch;
                ExtServiceJnlBatch.Name := Text004;
                ExtServiceJnlBatch.Description := Text005;
                ExtServiceJnlBatch.INSERT(TRUE);
                COMMIT;
            END;
            CurrentJnlBatchName := ExtServiceJnlBatch.Name;
        END;
    end;

    [Scope('Internal')]
    procedure CheckName(CurrentJnlBatchName: Code[10]; var ExtServiceJnlLine: Record "25006143")
    var
        ExtServiceJnlBatch: Record "25006144";
    begin
        ExtServiceJnlBatch.GET(ExtServiceJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
    end;

    [Scope('Internal')]
    procedure SetName(CurrentJnlBatchName: Code[10]; var ExtServiceJnlLine: Record "25006143")
    begin
        ExtServiceJnlLine.FILTERGROUP := 2;
        ExtServiceJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        ExtServiceJnlLine.FILTERGROUP := 0;
        IF ExtServiceJnlLine.FINDSET THEN;
    end;

    [Scope('Internal')]
    procedure LookupName(var CurrentJnlBatchName: Code[10]; var ExtServiceJnlLine: Record "25006143"): Boolean
    var
        ExtServiceJnlBatch: Record "25006144";
    begin
        COMMIT;
        ExtServiceJnlBatch."Journal Template Name" := ExtServiceJnlLine.GETRANGEMAX("Journal Template Name");
        ExtServiceJnlBatch.Name := ExtServiceJnlLine.GETRANGEMAX("Journal Batch Name");
        ExtServiceJnlBatch.FILTERGROUP := 2;
        ExtServiceJnlBatch.SETRANGE("Journal Template Name", ExtServiceJnlBatch."Journal Template Name");
        ExtServiceJnlBatch.FILTERGROUP := 0;
        IF PAGE.RUNMODAL(0, ExtServiceJnlBatch) = ACTION::LookupOK THEN BEGIN
            CurrentJnlBatchName := ExtServiceJnlBatch.Name;
            SetName(CurrentJnlBatchName, ExtServiceJnlLine);
        END;
    end;

    [Scope('Internal')]
    procedure GetExtService(ExtServiceNo: Code[20]; var ExtServiceName: Text[50])
    var
        ExtService: Record "25006133";
    begin
        IF ExtServiceNo <> OldExtServiceNo THEN BEGIN
            ExtServiceName := '';
            IF ExtServiceNo <> '' THEN
                IF ExtService.GET(ExtServiceNo) THEN
                    ExtServiceName := ExtService.Description;
            OldExtServiceNo := ExtServiceNo;
        END;
    end;
}

