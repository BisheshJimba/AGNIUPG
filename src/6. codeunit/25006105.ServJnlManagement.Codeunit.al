codeunit 25006105 ServJnlManagement
{
    Permissions = TableData 25006163 = rimd,
                  TableData 25006164 = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'SERVICE';
        Text001: Label 'Service Journals';
        Text002: Label 'RECURRING';
        Text003: Label 'Recurring Service Journal';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
        OldVehNo: Code[20];

    [Scope('Internal')]
    procedure TemplateSelection(FormID: Integer; RecurringJnl: Boolean; var ServJnlLine: Record "25006165"; var JnlSelected: Boolean)
    var
        ServJnlTemplate: Record "25006163";
    begin
        JnlSelected := TRUE;

        ServJnlTemplate.RESET;
        ServJnlTemplate.SETRANGE("Form ID", FormID);
        ServJnlTemplate.SETRANGE(Recurring, RecurringJnl);

        CASE ServJnlTemplate.COUNT OF
            0:
                BEGIN
                    ServJnlTemplate.INIT;
                    ServJnlTemplate.Recurring := RecurringJnl;
                    IF NOT RecurringJnl THEN BEGIN
                        ServJnlTemplate.Name := Text000;
                        ServJnlTemplate.Description := Text001;
                    END ELSE BEGIN
                        ServJnlTemplate.Name := Text002;
                        ServJnlTemplate.Description := Text003;
                    END;
                    ServJnlTemplate.VALIDATE("Form ID");
                    ServJnlTemplate.INSERT;
                    COMMIT;
                END;
            1:
                ServJnlTemplate.FINDFIRST;
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, ServJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            ServJnlLine.FILTERGROUP := 2;
            ServJnlLine.SETRANGE("Journal Template Name", ServJnlTemplate.Name);
            ServJnlLine.FILTERGROUP := 0;
        END;
    end;

    [Scope('Internal')]
    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var ServJnlLine: Record "25006165")
    begin
        CheckTemplateName(ServJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
        ServJnlLine.FILTERGROUP := 2;
        ServJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        ServJnlLine.FILTERGROUP := 0;
    end;

    [Scope('Internal')]
    procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        ServJnlBatch: Record "25006164";
    begin
        ServJnlBatch.SETRANGE("Journal Template Name", CurrentJnlTemplateName);
        IF NOT ServJnlBatch.GET(CurrentJnlTemplateName, CurrentJnlBatchName) THEN BEGIN
            IF NOT ServJnlBatch.FINDFIRST THEN BEGIN
                ServJnlBatch.INIT;
                ServJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                ServJnlBatch.SetupNewBatch;
                ServJnlBatch.Name := Text004;
                ServJnlBatch.Description := Text005;
                ServJnlBatch.INSERT(TRUE);
                COMMIT;
            END;
            CurrentJnlBatchName := ServJnlBatch.Name;
        END;
    end;

    [Scope('Internal')]
    procedure CheckName(CurrentJnlBatchName: Code[10]; var ServJnlLine: Record "25006165")
    var
        ServJnlBatch: Record "25006164";
    begin
        ServJnlBatch.GET(ServJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
    end;

    [Scope('Internal')]
    procedure SetName(CurrentJnlBatchName: Code[10]; var ServJnlLine: Record "25006165")
    begin
        ServJnlLine.FILTERGROUP := 2;
        ServJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        ServJnlLine.FILTERGROUP := 0;
        IF ServJnlLine.FINDSET THEN;
    end;

    [Scope('Internal')]
    procedure LookupName(var CurrentJnlBatchName: Code[10]; var ServJnlLine: Record "25006165"): Boolean
    var
        ServJnlBatch: Record "25006164";
    begin
        COMMIT;
        ServJnlBatch."Journal Template Name" := ServJnlLine.GETRANGEMAX("Journal Template Name");
        ServJnlBatch.Name := ServJnlLine.GETRANGEMAX("Journal Batch Name");
        ServJnlBatch.FILTERGROUP := 2;
        ServJnlBatch.SETRANGE("Journal Template Name", ServJnlBatch."Journal Template Name");
        ServJnlBatch.FILTERGROUP := 0;
        IF PAGE.RUNMODAL(0, ServJnlBatch) = ACTION::LookupOK THEN BEGIN
            CurrentJnlBatchName := ServJnlBatch.Name;
            SetName(CurrentJnlBatchName, ServJnlLine);
        END;
    end;

    [Scope('Internal')]
    procedure GetVeh(VehNo: Code[20]; var VehName: Text[30])
    var
        Veh: Record "25006005";
    begin
        IF VehNo <> OldVehNo THEN BEGIN
            VehName := '';
            IF VehNo <> '' THEN
                IF Veh.GET(VehNo) THEN BEGIN
                    Veh.CALCFIELDS("Model Commercial Name");
                    VehName := Veh."Model Commercial Name";
                END;
            OldVehNo := VehNo;
        END;
    end;
}

