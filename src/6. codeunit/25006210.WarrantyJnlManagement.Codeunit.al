codeunit 25006210 WarrantyJnlManagement
{

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'WARRANTY';
        Text001: Label 'Warranty Journals';
        Text002: Label 'RECURRING';
        Text003: Label 'Recurring Warranty Journal';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
        OldVehNo: Code[20];

    [Scope('Internal')]
    procedure TemplateSelection(FormID: Integer; RecurringJnl: Boolean; var WarrantyJnlLine: Record "25006206"; var JnlSelected: Boolean)
    var
        WarrantyJnlTemplate: Record "25006204";
    begin
        JnlSelected := TRUE;

        WarrantyJnlTemplate.RESET;
        WarrantyJnlTemplate.SETRANGE("Form ID", FormID);
        WarrantyJnlTemplate.SETRANGE(Recurring, RecurringJnl);

        CASE WarrantyJnlTemplate.COUNT OF
            0:
                BEGIN
                    WarrantyJnlTemplate.INIT;
                    WarrantyJnlTemplate.Recurring := RecurringJnl;
                    IF NOT RecurringJnl THEN BEGIN
                        WarrantyJnlTemplate.Name := Text000;
                        WarrantyJnlTemplate.Description := Text001;
                    END ELSE BEGIN
                        WarrantyJnlTemplate.Name := Text002;
                        WarrantyJnlTemplate.Description := Text003;
                    END;
                    WarrantyJnlTemplate.VALIDATE("Form ID");
                    WarrantyJnlTemplate.INSERT;
                    COMMIT;
                END;
            1:
                WarrantyJnlTemplate.FINDFIRST;
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, WarrantyJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            WarrantyJnlLine.FILTERGROUP := 2;
            WarrantyJnlLine.SETRANGE("Journal Template Name", WarrantyJnlTemplate.Name);
            WarrantyJnlLine.FILTERGROUP := 0;
        END;
    end;

    [Scope('Internal')]
    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var WarrantyJnlLine: Record "25006206")
    begin
        CheckTemplateName(WarrantyJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
        WarrantyJnlLine.FILTERGROUP := 2;
        WarrantyJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        WarrantyJnlLine.FILTERGROUP := 0;
    end;

    [Scope('Internal')]
    procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        WarrantyJnlBatch: Record "25006205";
    begin
        WarrantyJnlBatch.SETRANGE("Journal Template Name", CurrentJnlTemplateName);
        IF NOT WarrantyJnlBatch.GET(CurrentJnlTemplateName, CurrentJnlBatchName) THEN BEGIN
            IF NOT WarrantyJnlBatch.FINDFIRST THEN BEGIN
                WarrantyJnlBatch.INIT;
                WarrantyJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                WarrantyJnlBatch.SetupNewBatch;
                WarrantyJnlBatch.Name := Text004;
                WarrantyJnlBatch.Description := Text005;
                WarrantyJnlBatch.INSERT(TRUE);
                COMMIT;
            END;
            CurrentJnlBatchName := WarrantyJnlBatch.Name;
        END;
    end;

    [Scope('Internal')]
    procedure CheckName(CurrentJnlBatchName: Code[10]; var WarrantyJnlLine: Record "25006206")
    var
        WarrantyJnlBatch: Record "25006205";
    begin
        WarrantyJnlBatch.GET(WarrantyJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
    end;

    [Scope('Internal')]
    procedure SetName(CurrentJnlBatchName: Code[10]; var WarrantyJnlLine: Record "25006206")
    begin
        WarrantyJnlLine.FILTERGROUP := 2;
        WarrantyJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        WarrantyJnlLine.FILTERGROUP := 0;
        IF WarrantyJnlLine.FINDSET THEN;
    end;

    [Scope('Internal')]
    procedure LookupName(var CurrentJnlBatchName: Code[10]; var WarrantyJnlLine: Record "25006206"): Boolean
    var
        WarrantyJnlBatch: Record "25006205";
    begin
        COMMIT;
        WarrantyJnlBatch."Journal Template Name" := WarrantyJnlLine.GETRANGEMAX("Journal Template Name");
        WarrantyJnlBatch.Name := WarrantyJnlLine.GETRANGEMAX("Journal Batch Name");
        WarrantyJnlBatch.FILTERGROUP := 2;
        WarrantyJnlBatch.SETRANGE("Journal Template Name", WarrantyJnlBatch."Journal Template Name");
        WarrantyJnlBatch.FILTERGROUP := 0;
        IF PAGE.RUNMODAL(0, WarrantyJnlBatch) = ACTION::LookupOK THEN BEGIN
            CurrentJnlBatchName := WarrantyJnlBatch.Name;
            SetName(CurrentJnlBatchName, WarrantyJnlLine);
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

