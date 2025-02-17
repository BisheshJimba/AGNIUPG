codeunit 33020236 "Service Steps Checking"
{

    trigger OnRun()
    begin
    end;

    var
        ServiceHeader: Record "25006145";
        AllocationEntry: Record "25006271";
        Resource: Record "156";
        BayHasToBeScheduledFirst: Label 'Bay has to be scheduled first for Service Order %1.';
        ProcessChecklist: Record "25006025";
        ProcessCheckListShouldBeDone: Label 'Process Checklist has to be done for Service Order %1.';
        Diagnosis: Record "25006148";
        DiagnosisShouldBeDone: Label 'Diagnosis has not been done Yet. Please Enter Diagnosis details for Service Order %1.';
        ServiceMgtSetup: Record "25006120";
        MandatorySteps: Record "33020241";
        Bay: Boolean;
        Inventory: Boolean;
        Diag: Boolean;

    [Scope('Internal')]
    procedure CheckBaySchedule()
    var
        BayFound: Boolean;
    begin
        IF Bay THEN BEGIN
            AllocationEntry.RESET;
            AllocationEntry.SETCURRENTKEY("Source ID");
            AllocationEntry.SETRANGE("Source ID", ServiceHeader."No.");
            IF AllocationEntry.FINDFIRST THEN BEGIN
                REPEAT
                    Resource.RESET;
                    Resource.SETRANGE("No.", AllocationEntry."Resource No.");
                    Resource.SETRANGE("Is Bay", TRUE);
                    IF Resource.FINDFIRST THEN
                        BayFound := TRUE;
                UNTIL AllocationEntry.NEXT = 0;
                IF NOT BayFound THEN
                    ERROR(BayHasToBeScheduledFirst, ServiceHeader."No.");
            END
            ELSE
                ERROR(BayHasToBeScheduledFirst, ServiceHeader."No.");
        END;
    end;

    [Scope('Internal')]
    procedure CheckProcessChecklist()
    begin
        IF Inventory THEN BEGIN
            ProcessChecklist.RESET;
            ProcessChecklist.SETCURRENTKEY("Source ID");
            ProcessChecklist.SETRANGE("Source ID", ServiceHeader."No.");
            IF NOT ProcessChecklist.FINDFIRST THEN
                ERROR(ProcessCheckListShouldBeDone, ServiceHeader."No.");
        END;
    end;

    [Scope('Internal')]
    procedure CheckDiagnosis()
    begin
        IF Diag THEN BEGIN
            Diagnosis.RESET;
            Diagnosis.SETCURRENTKEY(Type, "No.");
            Diagnosis.SETRANGE(Type, Diagnosis.Type::"Service Order");
            Diagnosis.SETRANGE("No.", ServiceHeader."No.");
            IF NOT Diagnosis.FINDFIRST THEN
                ERROR(DiagnosisShouldBeDone, ServiceHeader."No.");
        END;
    end;

    [Scope('Internal')]
    procedure CheckSteps("ServiceHeaderNo.": Code[20]; Steps: Option CheckBay,CheckChecklist,CheckDiagnosis)
    begin
        Bay := TRUE;
        Inventory := TRUE;
        Diag := TRUE;
        ServiceMgtSetup.GET;

        IF ServiceMgtSetup."Apply Rules of Checking Steps" THEN BEGIN
            ServiceHeader.RESET;
            ServiceHeader.SETRANGE("No.", "ServiceHeaderNo.");
            IF ServiceHeader.FINDFIRST THEN BEGIN
                MandatorySteps.SETRANGE("Job Type Code", ServiceHeader."Job Type");
                IF MandatorySteps.FINDFIRST THEN BEGIN
                    IF NOT MandatorySteps."Bay Mandatory" THEN Bay := FALSE;
                    IF NOT MandatorySteps."IC Mandatory" THEN Inventory := FALSE;
                    IF NOT MandatorySteps."Diagnosis Mandatory" THEN Diag := FALSE;
                END;
                IF Steps = Steps::CheckBay THEN BEGIN
                    CheckBaySchedule
                END
                ELSE
                    IF Steps = Steps::CheckChecklist THEN BEGIN
                        CheckBaySchedule;
                        CheckProcessChecklist;
                    END
                    ELSE
                        IF Steps = Steps::CheckDiagnosis THEN BEGIN
                            CheckBaySchedule;
                            CheckProcessChecklist;
                            CheckDiagnosis;
                        END;
            END;
        END;
    end;
}

