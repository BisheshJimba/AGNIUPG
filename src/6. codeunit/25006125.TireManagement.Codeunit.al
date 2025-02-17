codeunit 25006125 "Tire Management"
{

    trigger OnRun()
    begin
    end;

    var
        TireManagementSetup: Record "25006182";

    [Scope('Internal')]
    procedure ShowCreateAxleFromTmpl(VehicleAxlePar: Record "25006178"): Boolean
    var
        PlatformTemplate: Record "25006183";
        PlatformTemplateAxle: Record "25006184";
        VehicleAxle: Record "25006178";
        VehicleTirePosition: Record "25006179";
        PlatformTemplTirePosition: Record "25006185";
        PlatformTemplates: Page "25006272";
    begin
        PlatformTemplates.LOOKUPMODE(TRUE);
        IF PlatformTemplates.RUNMODAL IN [ACTION::LookupOK, ACTION::OK] THEN BEGIN
            PlatformTemplates.GETRECORD(PlatformTemplate);
            IF PlatformTemplate.Code <> '' THEN BEGIN
                AsignPlatformToVehicle(VehicleAxlePar."Vehicle Serial No.", PlatformTemplate.Code);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure GetVehicleAxleToEntry(VehicleNo: Code[20]; AxleCode: Code[10]) RetValue: Code[10]
    var
        VehicleAxle: Record "25006178";
    begin
        IF (VehicleNo <> '') AND (AxleCode <> '') THEN BEGIN
            VehicleAxle.RESET;
            IF VehicleAxle.GET(VehicleNo, AxleCode) THEN
                IF NOT VehicleAxle.Available THEN BEGIN
                    RetValue := GetNextAvailableAxle(VehicleNo);
                END ELSE
                    RetValue := AxleCode;
        END ELSE
            RetValue := GetNextAvailableAxle(VehicleNo);
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure GetNextAvailableAxle(VehicleNo: Code[20]) RetValue: Code[10]
    var
        VehicleAxle: Record "25006178";
    begin
        IF (VehicleNo <> '') THEN BEGIN
            VehicleAxle.RESET;
            VehicleAxle.SETRANGE("Vehicle Serial No.", VehicleNo);
            VehicleAxle.SETRANGE(Available, TRUE);
            IF NOT VehicleAxle.FINDFIRST THEN
                IF TireManagementSetup.GET THEN
                    IF TireManagementSetup."Default Platform Template" <> '' THEN
                        AsignPlatformToVehicle(VehicleNo, TireManagementSetup."Default Platform Template");
            IF VehicleAxle.FINDFIRST THEN
                RetValue := VehicleAxle.Code;
        END;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure CloseOpenedEntries(TireEntryPar: Record "25006181")
    var
        TireEntry: Record "25006181";
    begin
        IF (TireEntryPar."Tire Code" <> '') THEN BEGIN
            TireEntry.RESET;
            TireManagementSetup.GET;
            IF TireManagementSetup."Check Tire Unique" THEN BEGIN
                TireEntry.SETRANGE("Tire Code", TireEntryPar."Tire Code");
                TireEntry.SETRANGE(Open, TRUE);
            END ELSE BEGIN
                TireEntry.SETRANGE("Vehicle Serial No.", TireEntryPar."Vehicle Serial No.");
                TireEntry.SETRANGE("Vehicle Axle Code", TireEntryPar."Vehicle Axle Code");
                TireEntry.SETRANGE("Tire Position Code", TireEntryPar."Tire Position Code");
                TireEntry.SETRANGE(Open, TRUE);
            END;
            IF TireEntry.FINDFIRST THEN
                REPEAT
                    TireEntry.Open := FALSE;
                    TireEntry.MODIFY(FALSE);
                UNTIL TireEntry.NEXT = 0;
        END;
        EXIT;
    end;

    [Scope('Internal')]
    procedure AddTireEntry(ServLENo: Integer; DocumentNo: Code[20]; PostingDate: Date; VehicleSerialNo: Code[20]; VehicleAxleCode: Code[10]; TirePositionCode: Code[10]; TireCode: Code[20]; EntryType: Integer; MileagePar: Decimal) RetEntryNo: Integer
    var
        TireEntry: Record "25006181";
        TireEntry2: Record "25006181";
        TextPlaceBusy: Label 'That Tire placement is already used.';
        TextTireBusy: Label 'That Tire is already used.';
    begin
        //"Vehicle Serial No.", "Vehicle Axle Code", "Tire Position Code", "Tire Code", "Entry Type", Mileage
        TireEntry.INIT;
        TireEntry."Service Ledger Entry No." := ServLENo;
        TireEntry."Document No." := DocumentNo;
        TireEntry."Posting Date" := PostingDate;
        TireEntry."Vehicle Serial No." := VehicleSerialNo;
        TireEntry."Vehicle Axle Code" := VehicleAxleCode;
        TireEntry."Tire Position Code" := TirePositionCode;
        TireEntry."Tire Code" := TireCode;
        TireEntry."Entry Type" := EntryType;
        TireEntry."Variable Field Run 1" := MileagePar;

        TireEntry.TESTFIELD("Vehicle Serial No.");
        TireEntry.TESTFIELD("Vehicle Axle Code");
        TireEntry.TESTFIELD("Tire Code");
        IF TireEntry."Entry Type" = TireEntry."Entry Type"::"Put on" THEN
            IF (TireEntry."Vehicle Serial No." <> '') AND (TireEntry."Vehicle Axle Code" <> '') AND (TireEntry."Tire Position Code" <> '') THEN BEGIN
                TireEntry2.RESET;
                TireEntry2.SETRANGE("Vehicle Serial No.", TireEntry."Vehicle Serial No.");
                TireEntry2.SETRANGE("Vehicle Axle Code", TireEntry."Vehicle Axle Code");
                TireEntry2.SETRANGE("Tire Position Code", TireEntry."Tire Position Code");
                TireEntry2.SETRANGE(Open, TRUE);
                //TireEntry2.SETFILTER("Entry No.", '<>%1', "Entry No.");
                IF TireEntry2.FINDFIRST THEN
                    ERROR(TextPlaceBusy);
            END;
        TireManagementSetup.GET;
        IF TireManagementSetup."Check Tire Unique" THEN
            IF (TireEntry."Tire Code" <> '') THEN BEGIN
                TireEntry2.RESET;
                TireEntry2.SETRANGE("Tire Code", TireEntry."Tire Code");
                TireEntry2.SETRANGE(Open, TRUE);
                TireEntry2.SETFILTER("Entry No.", '<>%1', TireEntry."Entry No.");
                IF TireEntry2.FINDFIRST THEN
                    ERROR(TextTireBusy);
            END;
        IF TireEntry."Posting Date" = 0D THEN
            TireEntry."Posting Date" := WORKDATE;
        IF TireEntry."Entry Type" = TireEntry."Entry Type"::"Take off" THEN
            TireEntry.Open := FALSE
        ELSE
            TireEntry.Open := TRUE;
        IF TireEntry."Entry Type" <> TireEntry."Entry Type"::"Put on" THEN BEGIN
            // THen it supposed to be Tire take off and lets find last puton of that Tire on the possition
            TireEntry2.RESET;
            TireEntry2.SETRANGE("Vehicle Serial No.", TireEntry."Vehicle Serial No.");
            TireEntry2.SETRANGE("Vehicle Axle Code", TireEntry."Vehicle Axle Code");
            TireEntry2.SETRANGE("Tire Position Code", TireEntry."Tire Position Code");
            TireEntry2.SETRANGE("Tire Code", TireEntry."Tire Code");
            TireEntry2.SETRANGE("Entry Type", TireEntry."Entry Type"::"Put on");
            IF TireEntry2.FINDLAST THEN
                TireEntry."Tire Kilometers" := TireEntry."Variable Field Run 1" - TireEntry2."Variable Field Run 1";
        END;

        CloseOpenedEntries(TireEntry);
        TireEntry.LOCKTABLE;
        GetNextTireEntryPrimaryNo;
        TireEntry.INSERT(TRUE);
        RetEntryNo := TireEntry."Entry No.";
        EXIT(RetEntryNo);
    end;

    [Scope('Internal')]
    procedure AsignPlatformToVehicle(VehicleNo: Code[20]; PlatformCode: Code[10])
    var
        PlatformTemplateAxle: Record "25006184";
        VehicleAxle: Record "25006178";
        PlatformTemplTirePosition: Record "25006185";
        VehicleTirePosition: Record "25006179";
    begin
        IF PlatformCode = '' THEN
            EXIT;

        PlatformTemplateAxle.RESET;
        PlatformTemplateAxle.SETRANGE("Template Code", PlatformCode);
        IF PlatformTemplateAxle.FINDFIRST THEN
            REPEAT
                VehicleAxle.INIT;
                VehicleAxle.VALIDATE(Code, PlatformTemplateAxle.Code);
                VehicleAxle."Vehicle Serial No." := VehicleNo;
                VehicleAxle.INSERT(TRUE);
                PlatformTemplTirePosition.RESET;
                PlatformTemplTirePosition.SETRANGE("Template Code", PlatformTemplateAxle."Template Code");
                PlatformTemplTirePosition.SETRANGE("Template Axle Code", PlatformTemplateAxle.Code);
                IF PlatformTemplTirePosition.FINDFIRST THEN
                    REPEAT
                        VehicleTirePosition.INIT;
                        VehicleTirePosition.VALIDATE(Code, PlatformTemplTirePosition.Code);
                        VehicleTirePosition.VALIDATE(Description, PlatformTemplTirePosition.Description);
                        VehicleTirePosition."Vehicle Serial No." := VehicleNo;
                        VehicleTirePosition.VALIDATE("Axle Code", VehicleAxle.Code);
                        VehicleTirePosition.INSERT(TRUE);
                    UNTIL PlatformTemplTirePosition.NEXT = 0;
            UNTIL PlatformTemplateAxle.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetNextTireEntryPrimaryNo() RetValue: Integer
    var
        TireEntry: Record "25006181";
    begin
        TireEntry.RESET;
        IF TireEntry.FINDLAST THEN
            RetValue := TireEntry."Entry No."
        ELSE
            RetValue := 0;
        EXIT(RetValue + 1);
    end;

    [Scope('Internal')]
    procedure ChangeVehicleInServiceHeader(ServiceHeader: Record "25006145"; VehicleNoFrom: Code[20]; VehicleNoTo: Code[20])
    var
        ServiceLine: Record "25006146";
        TextDoAutoAdjust: Label 'Do you allow adjust Tire data in lines by program?';
        TextErrorStop: Label 'Process is interrupted, do it manually first.';
        VehicleFrom: Record "25006005";
        VehicleTo: Record "25006005";
        VehicleTirePosition: Record "25006179";
    begin
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETFILTER("Vehicle Axle Code", '<>%1', '');
        IF ServiceLine.FINDFIRST THEN
            IF CONFIRM(TextDoAutoAdjust, TRUE) THEN BEGIN
                IF VehicleFrom.GET(VehicleNoFrom) THEN BEGIN
                    IF VehicleTo.GET(VehicleNoTo) THEN BEGIN
                        VehicleTirePosition.RESET;
                        VehicleTirePosition.SETCURRENTKEY("Vehicle Serial No.", "Axle Code", Code);
                        REPEAT
                            // IN future it could be redone like trying to do real adjustment, but simply check
                            IF NOT VehicleTirePosition.GET(VehicleNoTo, "Vehicle Axle Code", "Tire Position Code") THEN
                                ERROR(TextErrorStop);
                        UNTIL ServiceLine.NEXT = 0;
                    END ELSE
                        ERROR(TextErrorStop);
                END ELSE
                    ERROR(TextErrorStop);
            END ELSE
                ERROR(TextErrorStop);
    end;

    [Scope('Internal')]
    procedure GetTireOfPosition(VehicleSerialNo: Code[20]; AxleCode: Code[20]; PositionCode: Code[20]): Code[20]
    var
        TireEntry: Record "25006181";
    begin
        TireEntry.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
        TireEntry.SETRANGE("Vehicle Axle Code", AxleCode);
        TireEntry.SETRANGE("Tire Position Code", PositionCode);
        TireEntry.SETRANGE(Open, TRUE);
        IF TireEntry.FINDLAST THEN
            EXIT(TireEntry."Tire Code")
        ELSE
            EXIT('');
    end;
}

