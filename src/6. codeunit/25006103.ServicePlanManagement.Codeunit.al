codeunit 25006103 "Service Plan Management"
{
    // 08.05.2013 EDMS P8
    //   * FIX for recurring - look for adjust
    // 
    // 25.03.2013 EDMS P8
    //   * FIX FOR THE FILTERS


    trigger OnRun()
    begin
    end;

    var
        ServiceSetup: Record "25006120";
        VehicleServicePlan: Record "25006126";
        xVehicleServicePlanTmp: Record "25006126" temporary;
        VehicleServicePlanStage: Record "25006132";
        xVehicleServicePlanStageTmp: Record "25006132" temporary;
        Vehicle: Record "25006005";
        Customer: Record "18";
        SPVersion: Record "25006135";
        ServicePackage: Record "25006134";
        ServiceInfoPaneMgt: Codeunit "25006104";
        "//--Calc Exp Date vars--------": Integer;
        StageLastTmp: Record "25006132" temporary;
        Text001: Label 'Automatically created by %1.';
        "//--CreateOrdersByFiltered var": Integer;
        VehicleGlob: Record "25006005";
        VehicleContactGlob: Record "25006013";
        ContactBusinessRelationGlob: Record "5054";
        CustomerGlob: Record "18";
        VehicleServicePlanGlob: Record "25006126";
        VehicleServicePlanStageGlob: Record "25006132";
        ServicePackageGlob: Record "25006134";
        ServicePackageVersionGlob: Record "25006135";
        TextLog001: Label 'CalcExpectedServiceDate begin for: %1, %2, %3';
        TextLog002: Label 'Important values: %1=%2, %3=%4, %5=%6, %7=%8';
        TextLogUpdateField: Label 'Value of field %2 in %1 is updated to %3.';
        TextLogEnd: Label 'CalcExpectedServiceDate finished for: %1, %2, %3';
        TextLogCalcByInterval: Label 'GetExpectedDateByInterval processed, date is: %1';
        TextLogInterrupt: Label 'CalcExpectedServiceDate interrupted for: %1, %2. Due to empty %3.';
        TextLogAvgValues: Label 'Result of CalcStageAvgPerDay are values: %1, %2, %3, %4.';
        TextLogAvgValuesPlan: Label 'Result of CalcStageAvgByPlan are values: %1, %2, %3, %4.';
        TextLogLastSLEValues: Label 'Are found last SLE values: %1, %2, %3, %4.';
        TextLogCalcValue: Label 'Is calculated %1 = %2';
        TextTableFilter: Label 'Table %1 is filtered: %2.';
        TextSkip: Label 'Value of field %2 in %1 is not updated to %3 due to %4.';
        TextLogAvgCalcPars: Label 'CalcStageAvgPerDay for field %5 pars: (%1 - %2)/(%3 - %4)';
        TextLogAvgCalcPlanPars: Label 'CalcStageAvgByPlan for field %5 pars: (%1 - %2)/(%3 - %4)';
        TextLogAvgValueOfPlan: Label 'CalcStageAvgPerDay for field %1 taken from plan calc: %2';

    [Scope('Internal')]
    procedure ApplyTemplate(var VehServicePlan: Record "25006126")
    var
        ServicePlanTemplate: Record "25006140";
        ServicePlanTemplateStage: Record "25006141";
        VehServicePlan1: Record "25006126";
        VehServicePlanStage: Record "25006132";
        VehServicePlanStage1: Record "25006132";
        ServDate: Date;
        Run1: Decimal;
        Run2: Decimal;
        Run3: Decimal;
        InitRun1: Decimal;
        InitRun2: Decimal;
        InitRun3: Decimal;
    begin
        ServicePlanTemplate.RESET;
        IF NOT (PAGE.RUNMODAL(PAGE::"Service Plan Templates", ServicePlanTemplate) = ACTION::LookupOK) THEN
            EXIT;
        ApplyTemplateToPlan(ServicePlanTemplate, VehServicePlan);
    end;

    [Scope('Internal')]
    procedure ApplyTemplateToPlan(ServicePlanTemplate: Record "25006140"; var VehServicePlan: Record "25006126")
    var
        ServicePlanTemplateStage: Record "25006141";
        VehServicePlan1: Record "25006126";
        VehServicePlanStage: Record "25006132";
        VehServicePlanStage1: Record "25006132";
        ServDate: Date;
        Run1: Decimal;
        Run2: Decimal;
        Run3: Decimal;
        InitRun1: Decimal;
        InitRun2: Decimal;
        InitRun3: Decimal;
    begin
        IF VehServicePlan."No." = '' THEN BEGIN
            IF VehServicePlan1.GET(VehServicePlan."Vehicle Serial No.", ServicePlanTemplate.Code) THEN
                IF VehServicePlan.GET(VehServicePlan."Vehicle Serial No.", ServicePlanTemplate.Code) THEN
                    EXIT;
            VehServicePlan."No." := ServicePlanTemplate.Code;
            VehServicePlan.INSERT(TRUE);
            VehServicePlan.VALIDATE(Description, ServicePlanTemplate.Description);
            VehServicePlan.VALIDATE("Template Code", ServicePlanTemplate.Code);
            VehServicePlan.VALIDATE("Service Plan Type", ServicePlanTemplate."Service Plan Type");
            VehServicePlan.VALIDATE(Adjust, ServicePlanTemplate.Adjust);
            VehServicePlan.VALIDATE(Recurring, ServicePlanTemplate.Recurring);
            VehServicePlan.MODIFY(TRUE);
        END;
        VehServicePlanStage1.RESET;
        VehServicePlanStage1.SETRANGE("Vehicle Serial No.", VehServicePlan."Vehicle Serial No.");
        VehServicePlanStage1.SETRANGE("Plan No.", VehServicePlan."No.");
        ServicePlanTemplateStage.RESET;
        ServicePlanTemplateStage.SETRANGE("Template Code", ServicePlanTemplate.Code);
        IF ServicePlanTemplateStage.FINDFIRST THEN
            REPEAT
                VehServicePlanStage.INIT;
                VehServicePlanStage."Vehicle Serial No." := VehServicePlan."Vehicle Serial No.";
                VehServicePlanStage."Plan No." := VehServicePlan."No.";
                Run1 := 0;
                Run2 := 0;
                Run3 := 0;
                InitRun1 := 0;
                InitRun2 := 0;
                InitRun3 := 0;

                VehServicePlanStage1.SETRANGE(Code, ServicePlanTemplateStage.Code);
                IF VehServicePlanStage1.FINDLAST THEN BEGIN
                    VehServicePlanStage.Recurrence := VehServicePlanStage1.Recurrence + 1;
                    IF VehServicePlan.Recurring THEN BEGIN
                        Run1 := VehServicePlanStage1.Kilometrage;
                        Run2 := VehServicePlanStage1."Variable Field Run 2";
                        Run3 := VehServicePlanStage1."Variable Field Run 3";
                        InitRun1 := VehServicePlanStage1."VF Initial Run 1";
                        InitRun2 := VehServicePlanStage1."VF Initial Run 2";
                        InitRun3 := VehServicePlanStage1."VF Initial Run 3";
                    END;
                END;

                VehServicePlanStage.Code := ServicePlanTemplateStage.Code;
                VehServicePlanStage.Description := ServicePlanTemplateStage.Description;
                VehServicePlanStage."Service Interval" := ServicePlanTemplateStage."Service Interval";
                VehServicePlanStage."Package No." := ServicePlanTemplateStage."Package No.";
                IF ServicePlanTemplateStage.Kilometrage > 0 THEN BEGIN
                    VehServicePlanStage.Kilometrage := ServicePlanTemplateStage.Kilometrage + Run1;
                    VehServicePlanStage."VF Initial Run 1" := ServicePlanTemplateStage.Kilometrage + InitRun1;
                END;
                IF ServicePlanTemplateStage."Variable Field Run 2" > 0 THEN BEGIN
                    VehServicePlanStage."Variable Field Run 2" := ServicePlanTemplateStage."Variable Field Run 2" + Run2;
                    VehServicePlanStage."VF Initial Run 2" := ServicePlanTemplateStage."Variable Field Run 2" + InitRun2;
                END;
                IF ServicePlanTemplateStage."Variable Field Run 3" > 0 THEN BEGIN
                    VehServicePlanStage."Variable Field Run 3" := ServicePlanTemplateStage."Variable Field Run 3" + Run3;
                    VehServicePlanStage."VF Initial Run 3" := ServicePlanTemplateStage."Variable Field Run 3" + InitRun3;
                END;
                VehServicePlanStage."Expected Service Date" := 0D;
                VehServicePlanStage.INSERT;
            UNTIL ServicePlanTemplateStage.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdateDocLinkDocNo(OldDocType: Option "Order","Return Order","Posted Order","Posted Return Order"; OldDocNo: Code[20]; NewDocType: Option "Order","Return Order","Posted Order","Posted Return Order"; NewDocNo: Code[20])
    var
        DocLink: Record "25006157";
        DocLink2: Record "25006157";
    begin
        DocLink.RESET;
        DocLink.SETCURRENTKEY("Document Type", "Document No.");
        DocLink.SETRANGE("Document Type", OldDocType);
        DocLink.SETRANGE("Document No.", OldDocNo);
        IF DocLink.FINDFIRST THEN
            REPEAT
                DocLink2.GET(DocLink."Vehicle Serial No.", DocLink."Serv. Plan No.", DocLink."Plan Stage Recurrence",
                   DocLink."Serv. Plan Stage Code", DocLink."Line No.");
                DocLink2."Document Type" := NewDocType;
                DocLink2."Document No." := NewDocNo;
                DocLink2.MODIFY;
            UNTIL DocLink.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure DocLinkApply(ServicePlanDocumentLink: Record "25006157")
    var
        ServDate: Date;
        ServiceHeader: Record "25006145";
        PstServHeader: Record "25006149";
        PstRetServHeader: Record "25006154";
        ServicePlanTemplate: Record "25006140";
        VehicleServicePlan: Record "25006126";
    begin
        VehicleServicePlanStage.RESET;
        VehicleServicePlanStage.SETRANGE("Vehicle Serial No.", ServicePlanDocumentLink."Vehicle Serial No.");
        VehicleServicePlanStage.SETRANGE("Plan No.", ServicePlanDocumentLink."Serv. Plan No.");
        VehicleServicePlanStage.SETRANGE(Recurrence, ServicePlanDocumentLink."Plan Stage Recurrence");
        VehicleServicePlanStage.SETRANGE(Code, ServicePlanDocumentLink."Serv. Plan Stage Code");
        IF VehicleServicePlanStage.FINDFIRST THEN BEGIN
            ServDate := 0D;
            CASE "Document Type" OF
                "Document Type"::Quote:
                    BEGIN
                        IF ServiceHeader.GET(ServiceHeader."Document Type"::Quote, "Document No.") THEN
                            ServDate := GetServDateFromServHeader(ServiceHeader);
                    END;
                "Document Type"::Order:
                    BEGIN
                        IF ServiceHeader.GET(ServiceHeader."Document Type"::Order, "Document No.") THEN
                            ServDate := GetServDateFromServHeader(ServiceHeader);
                    END;
                "Document Type"::"Return Order":
                    BEGIN
                        IF ServiceHeader.GET(ServiceHeader."Document Type"::"Return Order", "Document No.") THEN
                            ServDate := GetServDateFromServHeader(ServiceHeader);
                    END;
                "Document Type"::"Posted Order":
                    BEGIN
                        IF PstServHeader.GET("Document No.") THEN
                            ServDate := GetServDateFromPostedOrder(PstServHeader);
                    END;
                "Document Type"::"Posted Return Order":
                    BEGIN
                        IF PstRetServHeader.GET("Document No.") THEN
                            ServDate := GetServDateFromPstRetOrder(PstRetServHeader);
                    END;
            END;
            IF ServDate <> 0D THEN BEGIN
                VehicleServicePlanStage.VALIDATE("Service Date", ServDate);
                VehicleServicePlanStage.VALIDATE(Status, VehicleServicePlanStage.Status::"In Process");
                VehicleServicePlanStage.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure PlanRecurringByTemplate(var VehServicePlan: Record "25006126"; MinCountOfPending: Integer): Integer
    var
        ServicePlanTemplate: Record "25006140";
        ServicePlanTemplateStage: Record "25006141";
        VehServicePlan1: Record "25006126";
        VehServicePlanStage: Record "25006132";
        ServDate: Date;
        Run1: Decimal;
        Run2: Decimal;
        Run3: Decimal;
        InitRun1: Decimal;
        InitRun2: Decimal;
        InitRun3: Decimal;
        CurrRecurrence: Integer;
    begin
        IF NOT VehServicePlan.Recurring THEN //22.04.2016 EB.P7 #T051
            EXIT;                              //22.04.2016 EB.P7 #T051

        //NEED to be sure that plan has finished
        VehServicePlanStage.RESET;
        VehServicePlanStage.SETRANGE("Vehicle Serial No.", VehServicePlan."Vehicle Serial No.");
        VehServicePlanStage.SETRANGE("Plan No.", VehServicePlan."No.");
        VehServicePlanStage.SETRANGE(Status, VehServicePlanStage.Status::Pending);
        IF VehServicePlanStage.COUNT > MinCountOfPending THEN
            EXIT(1);

        //plan should had template assigned
        ServicePlanTemplate.RESET;
        IF NOT ServicePlanTemplate.GET(VehServicePlan."Template Code") THEN
            EXIT(2);

        //find last finished stage
        VehServicePlanStage.SETRANGE(Status);
        IF NOT VehServicePlanStage.FINDLAST THEN
            EXIT(3);

        Run1 := VehServicePlanStage.Kilometrage;
        Run2 := VehServicePlanStage."Variable Field Run 2";
        Run3 := VehServicePlanStage."Variable Field Run 3";
        InitRun1 := VehServicePlanStage."VF Initial Run 1";
        InitRun2 := VehServicePlanStage."VF Initial Run 2";
        InitRun3 := VehServicePlanStage."VF Initial Run 3";
        CurrRecurrence := VehServicePlanStage.Recurrence + 1;

        //
        ServicePlanTemplateStage.RESET;
        VehServicePlanStage.RESET;
        ServicePlanTemplateStage.SETRANGE("Template Code", ServicePlanTemplate.Code);
        IF ServicePlanTemplateStage.FINDFIRST THEN
            REPEAT
                VehServicePlanStage.INIT;
                VehServicePlanStage."Vehicle Serial No." := VehServicePlan."Vehicle Serial No.";
                VehServicePlanStage."Plan No." := VehServicePlan."No.";
                VehServicePlanStage.Recurrence := CurrRecurrence;
                VehServicePlanStage.Code := ServicePlanTemplateStage.Code;
                VehServicePlanStage.Description := ServicePlanTemplateStage.Description;
                VehServicePlanStage."Service Interval" := ServicePlanTemplateStage."Service Interval";
                VehServicePlanStage."Package No." := ServicePlanTemplateStage."Package No.";
                //08.05.2013 EDMS P8 >>
                IF ServicePlanTemplateStage.Kilometrage > 0 THEN BEGIN
                    VehServicePlanStage."VF Initial Run 1" := ServicePlanTemplateStage.Kilometrage + InitRun1;
                    IF VehServicePlan.Adjust THEN
                        VehServicePlanStage.Kilometrage := ServicePlanTemplateStage.Kilometrage + Run1
                    ELSE
                        VehServicePlanStage.Kilometrage := VehServicePlanStage."VF Initial Run 1";
                END;
                IF ServicePlanTemplateStage."Variable Field Run 2" > 0 THEN BEGIN
                    VehServicePlanStage."VF Initial Run 2" := ServicePlanTemplateStage."Variable Field Run 2" + InitRun2;
                    IF VehServicePlan.Adjust THEN
                        VehServicePlanStage."Variable Field Run 2" := ServicePlanTemplateStage."Variable Field Run 2" + Run2
                    ELSE
                        VehServicePlanStage."Variable Field Run 2" := VehServicePlanStage."VF Initial Run 2";
                END;
                IF ServicePlanTemplateStage."Variable Field Run 3" > 0 THEN BEGIN
                    VehServicePlanStage."Variable Field Run 3" := ServicePlanTemplateStage."Variable Field Run 3" + Run3;
                    VehServicePlanStage."VF Initial Run 3" := ServicePlanTemplateStage."Variable Field Run 3" + InitRun3;
                    IF VehServicePlan.Adjust THEN
                        VehServicePlanStage."Variable Field Run 3" := ServicePlanTemplateStage."Variable Field Run 3" + Run3
                    ELSE
                        VehServicePlanStage."Variable Field Run 3" := VehServicePlanStage."VF Initial Run 3";
                END;
                //08.05.2013 EDMS P8 <<
                VehServicePlanStage."Expected Service Date" := 0D;
                VehServicePlanStage.INSERT;
            UNTIL ServicePlanTemplateStage.NEXT = 0;

        //need to adjust VehServicePlanStage."Expected Service Date"
        EXIT(0);
    end;

    [Scope('Internal')]
    procedure SetVehicle(var VehiclePar: Record "25006005")
    begin
        Vehicle := VehiclePar;
        //Vehicle.COPYFILTERS(VehiclePar);
    end;

    [Scope('Internal')]
    procedure SetVehicleServicePlanStage(var VehicleServicePlanStagePar: Record "25006132")
    begin
        VehicleServicePlanStage := VehicleServicePlanStagePar;
    end;

    [Scope('Internal')]
    procedure SetSPVersion(var SPVersionPar: Record "25006135")
    begin
        SPVersion := SPVersionPar;
        SPVersion.COPYFILTERS(SPVersionPar)
    end;

    [Scope('Internal')]
    procedure SetCustomer(var CustomerPar: Record "18")
    begin
        Customer := CustomerPar;
    end;

    [Scope('Internal')]
    procedure GetVehicleCustomer(VehSerNo: Code[20]) RetValue: Code[20]
    var
        Vehicle: Record "25006005";
        CustomerCount: Integer;
        Contact: Record "5050";
        VehicleContact: Record "25006013";
        ContBusRelation: Record "5054";
        Customer: Record "18";
        ServiceHeader: Record "25006145";
    begin
        IF VehSerNo = '' THEN
            EXIT('');
        ServiceSetup.GET;

        Contact.RESET;
        Customer.RESET;

        MarkVehicleContacts(Contact, VehSerNo, ServiceSetup."Serv. Plan Cont. Relationship");
        Contact.MARKEDONLY(TRUE);
        IF Contact.FINDFIRST THEN BEGIN
            REPEAT
                ContBusRelation.SETRANGE("Contact No.", Contact."No.");
                IF ContBusRelation.FINDFIRST THEN
                    REPEAT
                        IF Customer.GET(ContBusRelation."No.") THEN
                            Customer.MARK(TRUE);
                    UNTIL ContBusRelation.NEXT = 0;
            UNTIL Contact.NEXT = 0;
        END;
        Customer.MARKEDONLY(TRUE);

        IF Customer.FINDFIRST THEN
            RetValue := Customer."No.";

        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure MarkVehicleContacts(var Contact: Record "5050"; VehSerialNo: Code[20]; RelationshipCode: Code[20])
    var
        VehicleContact: Record "25006013";
    begin
        VehicleContact.RESET;
        VehicleContact.SETCURRENTKEY("Vehicle Serial No.");
        VehicleContact.SETRANGE("Vehicle Serial No.", VehSerialNo);
        IF RelationshipCode <> '' THEN
            VehicleContact.SETRANGE("Relationship Code", RelationshipCode);
        IF VehicleContact.FINDFIRST THEN
            REPEAT
                IF Contact.GET(VehicleContact."Contact No.") THEN
                    Contact.MARK := TRUE;
            UNTIL VehicleContact.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure PostServPlanStage(VehSerNo: Code[20]; PlanNo: Code[20]; Recurrence: Integer; PlanStageCode: Code[20]; ServLedgEntry: Record "25006167")
    var
        ServicePlanManagement: Codeunit "25006103";
        StageLoc: Record "25006132";
    begin
        //StageLoc.RESET;
        IF StageLoc.GET(VehSerNo, PlanNo, Recurrence, PlanStageCode) THEN BEGIN
            StageLoc.VALIDATE(Status, StageLoc.Status::Serviced);
            StageLoc.VALIDATE("Service Date", ServicePlanManagement.GetServDateFromSLE(ServLedgEntry));
            StageLoc.Kilometrage := ServLedgEntry.Kilometrage;
            StageLoc."Variable Field Run 2" := ServLedgEntry."Variable Field Run 2";
            StageLoc."Variable Field Run 3" := ServLedgEntry."Variable Field Run 3";
            StageLoc.MODIFY(TRUE);
            StageLoc.RESET;
            StageLoc.SETRANGE("Vehicle Serial No.", VehSerNo);
            StageLoc.SETRANGE("Plan No.", PlanNo);
            StageLoc.SETRANGE(Recurrence, StageLoc.Recurrence);
            StageLoc.SETFILTER(Code, '<=%1', PlanStageCode);
            StageLoc.SETRANGE(Status, StageLoc.Status::Pending);
            StageLoc.MODIFYALL(Status, StageLoc.Status::Skipped, TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure CreateServPlansDueToSaledLine(SalesInvoiceLine: Record "113")
    var
        SalesSetup: Record "311";
        ServicePlanTemplateUsage: Record "25006156";
        VehicleLoc: Record "25006005";
        VehicleServicePlanLoc: Record "25006126";
        ServicePlanTemplateLoc: Record "25006140";
        SalesInvoiceHeaderLoc: Record "112";
    begin
        SalesSetup.GET;
        IF NOT SalesSetup."Vehicle Service Plan on Sales" THEN
            EXIT;
        IF NOT VehicleLoc.GET(SalesInvoiceLine."Vehicle Serial No.") THEN
            EXIT;
        ServicePlanTemplateUsage.SETFILTER("Make Code", '%1|%2', '', VehicleLoc."Make Code");
        ServicePlanTemplateUsage.SETFILTER("Model Code", '%1|%2', '', VehicleLoc."Model Code");
        ServicePlanTemplateUsage.SETFILTER("Model Version No.", '%1|%2', '', VehicleLoc."Model Version No.");
        ServicePlanTemplateUsage.SETFILTER("Vehicle Status", '%1|%2', '', SalesInvoiceLine."Vehicle Status Code");
        IF ServicePlanTemplateUsage.FINDFIRST THEN
            REPEAT
                VehicleServicePlanLoc.RESET;
                VehicleServicePlanLoc.SETRANGE("Vehicle Serial No.", VehicleLoc."Serial No.");
                VehicleServicePlanLoc.INIT;
                VehicleServicePlanLoc."Vehicle Serial No." := VehicleLoc."Serial No.";
                IF ServicePlanTemplateLoc.GET(ServicePlanTemplateUsage."Template Code") THEN BEGIN
                    ApplyTemplateToPlan(ServicePlanTemplateLoc, VehicleServicePlanLoc);
                    IF SalesInvoiceHeaderLoc.GET(SalesInvoiceLine."Document No.") THEN BEGIN
                        VehicleServicePlanLoc.VALIDATE("Start Date", SalesInvoiceHeaderLoc."Document Date");
                        VehicleServicePlanLoc.MODIFY(TRUE);
                    END;
                END;
            UNTIL ServicePlanTemplateUsage.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure "//--Common Use--"()
    begin
    end;

    [Scope('Internal')]
    procedure GetLastServLEntryDate(VehicleSerialNo: Code[20]; PlanNo: Code[10]; var ServVFRun1: Decimal; var ServVFRun2: Decimal; var ServVFRun3: Decimal): Date
    var
        ServLedgerEntry: Record "25006167";
        FillerStr: Text[30];
    begin
        // the main difference from GetServiceDate is that here not only documents...
        ServLedgerEntry.RESET;
        ServLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Posting Date", "Entry Type");
        ServLedgerEntry.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
        FillerStr := STRSUBSTNO('%1|%2', ServLedgerEntry."Entry Type"::Usage, ServLedgerEntry."Entry Type"::Info);
        ServLedgerEntry.SETFILTER("Entry Type", FillerStr);
        IF ServLedgerEntry.FINDLAST THEN BEGIN
            ServVFRun1 := ServLedgerEntry.Kilometrage;
            ServVFRun2 := ServLedgerEntry."Variable Field Run 2";
            ServVFRun3 := ServLedgerEntry."Variable Field Run 3";
            EXIT(GetServDateFromSLE(ServLedgerEntry));
        END ELSE BEGIN
            EXIT(0D);
        END;
    end;

    [Scope('Internal')]
    procedure GetServiceDate(VehSerNo: Code[20]; ServPlanNo: Code[10]; PlanStageRecurrence: Integer; ServPlanStageCode: Code[10]): Date
    var
        ServicePlanDocumentLink: Record "25006157";
        PostedServiceHeader: Record "25006149";
    begin
        ServicePlanDocumentLink.RESET;
        ServicePlanDocumentLink.SETRANGE("Vehicle Serial No.", VehSerNo);
        ServicePlanDocumentLink.SETRANGE("Serv. Plan No.", ServPlanNo);
        ServicePlanDocumentLink.SETRANGE("Plan Stage Recurrence", PlanStageRecurrence);
        ServicePlanDocumentLink.SETRANGE("Serv. Plan Stage Code", ServPlanStageCode);
        ServicePlanDocumentLink.SETRANGE("Document Type", ServicePlanDocumentLink."Document Type"::"Posted Order");
        IF ServicePlanDocumentLink.FINDLAST THEN
            IF PostedServiceHeader.GET(ServicePlanDocumentLink."Document No.") THEN
                EXIT(GetServDateFromPostedOrder(PostedServiceHeader));
        EXIT(0D);
    end;

    [Scope('Internal')]
    procedure GetDateOfStage(VehicleServicePlanStagePar: Record "25006132"; AdjustInfluence: Boolean): Date
    begin
        VehicleServicePlan.GET(VehicleServicePlanStagePar."Vehicle Serial No.", VehicleServicePlanStagePar."Plan No.");
        IF AdjustInfluence THEN BEGIN
            IF NOT VehicleServicePlan.Adjust THEN
                EXIT(VehicleServicePlanStagePar."Expected Service Date")
            ELSE
                IF VehicleServicePlanStagePar."Service Date" > 0D THEN
                    EXIT(VehicleServicePlanStagePar."Service Date")
                ELSE
                    EXIT(VehicleServicePlanStagePar."Expected Service Date");
        END ELSE
            IF VehicleServicePlanStagePar."Expected Service Date" > 0D THEN
                EXIT(VehicleServicePlanStagePar."Expected Service Date")
            ELSE
                EXIT(VehicleServicePlanStagePar."Service Date");
    end;

    [Scope('Internal')]
    procedure GetDateOfPrevStage(VehicleServicePlanStagePar: Record "25006132"; AdjustInfluence: Boolean): Date
    var
        VehicleServicePlanStageLoc: Record "25006132";
    begin
        VehicleServicePlan.GET(VehicleServicePlanStagePar."Vehicle Serial No.", VehicleServicePlanStagePar."Plan No.");
        VehicleServicePlanStageLoc.RESET;
        VehicleServicePlanStageLoc.ASCENDING(FALSE);
        VehicleServicePlanStageLoc.SETRANGE("Vehicle Serial No.", VehicleServicePlanStagePar."Vehicle Serial No.");
        VehicleServicePlanStageLoc.SETRANGE("Plan No.", VehicleServicePlanStagePar."Plan No.");
        VehicleServicePlanStageLoc.SETRANGE(Recurrence, VehicleServicePlanStagePar.Recurrence);
        VehicleServicePlanStageLoc.SETRANGE(Code, VehicleServicePlanStagePar.Code);
        VehicleServicePlanStageLoc.FINDFIRST;
        VehicleServicePlanStageLoc.SETRANGE(Recurrence);
        VehicleServicePlanStageLoc.SETRANGE(Code);
        IF VehicleServicePlanStageLoc.NEXT <> 0 THEN
            EXIT(GetDateOfStage(VehicleServicePlanStageLoc, AdjustInfluence))
        ELSE
            EXIT(0D);
    end;

    [Scope('Internal')]
    procedure GetServDateFromPostedOrder(PostedServiceHeader: Record "25006149"): Date
    begin
        EXIT(PostedServiceHeader."Document Date");
    end;

    [Scope('Internal')]
    procedure GetServDateFromSLE(ServLedgerEntry: Record "25006167"): Date
    begin
        EXIT(ServLedgerEntry."Document Date");
    end;

    [Scope('Internal')]
    procedure GetServDateFromServHeader(ServiceHeaderPar: Record "25006145"): Date
    begin
        EXIT(ServiceHeaderPar."Document Date");
    end;

    [Scope('Internal')]
    procedure GetServDateFromPstRetOrder(PstRetServHeader: Record "25006154"): Date
    begin
        EXIT(PstRetServHeader."Document Date");
    end;

    [Scope('Internal')]
    procedure "--SMALL TECHN--"()
    begin
    end;

    [Scope('Internal')]
    procedure CutNextBit(var Flags: Integer) RetValue: Boolean
    begin
        RetValue := ((Flags MOD 2) > 0);
        Flags := Flags DIV 2;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure AdjustFlagsToArray(Flags: Integer; var Arr: array[16] of Boolean)
    var
        i: Integer;
    begin
        FOR i := 1 TO 16 DO BEGIN
            Arr[i] := CutNextBit(Flags);
        END;
    end;

    [Scope('Internal')]
    procedure "//--Calc Expected Date--------"()
    begin
    end;

    [Scope('Internal')]
    procedure CalcExpectedServiceDate(VehSerialNo: Code[20]; PlanNo: Code[10]; RunModeFlags: Integer): Integer
    var
        FlagsArray: array[16] of Boolean;
        Stage: Record "25006132";
        StageAvgTmp: Record "25006132" temporary;
        NewExpDate: Date;
        NewExpDate1: Date;
        NewExpDate2: Date;
        NewExpDate3: Date;
        NewExpDateByInterval: Date;
        LastServDate: Date;
        ServicePlanDocumentLink: Record "25006157";
        ServiceHeader: Record "25006145";
        AdjustFlagInfluence: Boolean;
        StageRecurrence: Integer;
        StageCodeToBegin: Code[10];
    begin
        AdjustFlagsToArray(RunModeFlags, FlagsArray);
        AdjustFlagInfluence := FlagsArray[1];
        IF NOT VehicleServicePlan.GET(VehSerialNo, PlanNo) THEN
            EXIT(1);
        xVehicleServicePlanTmp := VehicleServicePlan;
        AddLogEntryForCalcESDofPlan(VehicleServicePlan, xVehicleServicePlanTmp, STRSUBSTNO(TextLog001, VehSerialNo, PlanNo), 0, 0);
        AddLogEntryForCalcESDofPlan(VehicleServicePlan, xVehicleServicePlanTmp, STRSUBSTNO(TextLog002,
          'AdjustFlagInfluence', AdjustFlagInfluence,
          VehicleServicePlan.FIELDCAPTION(Adjust), VehicleServicePlan.Adjust,
          VehicleServicePlan.FIELDCAPTION("Creation Date"), VehicleServicePlan."Creation Date",
          VehicleServicePlan.FIELDCAPTION("Start Date"), VehicleServicePlan."Start Date"),
          0, 0);

        CLEAR(StageLastTmp);
        StageLastTmp.DELETEALL;
        StageLastTmp."Vehicle Serial No." := VehSerialNo;
        StageLastTmp."Plan No." := PlanNo;
        CLEAR(StageAvgTmp);
        StageAvgTmp.DELETEALL;
        StageAvgTmp."Vehicle Serial No." := VehSerialNo;
        StageAvgTmp."Plan No." := PlanNo;

        IF ((VehicleServicePlan."Creation Date" = 0D) OR
          (VehicleServicePlan."Start Date" = 0D)) THEN BEGIN
            IF VehicleServicePlan."Creation Date" = 0D THEN BEGIN
                VehicleServicePlan."Creation Date" := WORKDATE;  // just to be filled
                AddLogEntryForCalcESDofPlan(VehicleServicePlan, xVehicleServicePlanTmp,
                  STRSUBSTNO(TextLogUpdateField, VehicleServicePlan.TABLECAPTION, VehicleServicePlan.FIELDCAPTION("Creation Date"),
                  VehicleServicePlan."Creation Date"), VehicleServicePlan.FIELDNO("Creation Date"), 0);
            END;

            IF VehicleServicePlan."Start Date" = 0D THEN BEGIN
                VehicleServicePlan."Start Date" := GetVehicleSellDate(VehSerialNo);
                AddLogEntryForCalcESDofPlan(VehicleServicePlan, xVehicleServicePlanTmp,
                  STRSUBSTNO(TextLogUpdateField, VehicleServicePlan.TABLECAPTION, VehicleServicePlan.FIELDCAPTION("Start Date"),
                  VehicleServicePlan."Start Date"), VehicleServicePlan.FIELDNO("Start Date"), 0);
            END;
            VehicleServicePlan.MODIFY(TRUE);
        END;
        IF VehicleServicePlan."Start Date" = 0D THEN BEGIN
            AddLogEntryForCalcESDofPlan(VehicleServicePlan, xVehicleServicePlanTmp, STRSUBSTNO(TextLogInterrupt, VehSerialNo, PlanNo,
              VehicleServicePlan.FIELDCAPTION("Start Date")), 0, 0);
            EXIT(1);
        END;
        Stage.RESET;
        Stage.SETRANGE("Vehicle Serial No.", VehSerialNo);
        Stage.SETRANGE("Plan No.", PlanNo);
        // find last finished stage
        Stage.SETFILTER(Status, '%1|%2', Stage.Status::"In Process", Stage.Status::Serviced);
        IF Stage.FINDFIRST THEN BEGIN
            StageRecurrence := Stage.Recurrence;
            StageCodeToBegin := Stage.Code;
            // that filter is set for meaning: not to proceed stages before Serviced (in the past)
            //Stage.SETRANGE(Recurrence, StageRecurrence);
            Stage.SETFILTER(Code, '>=%1', StageCodeToBegin);
        END;
        Stage.SETRANGE(Status);
        Stage.SETRANGE(Code);
        AddLogEntryForCalcESDofStage(Stage, Stage,
          COPYSTR(STRSUBSTNO(TextTableFilter, Stage.TABLECAPTION, Stage.GETFILTERS), 1, 250), 0, 0);

        //Stage.SETRANGE(Stage.Status,Stage.Status::Pending);
        IF Stage.FINDFIRST THEN
            REPEAT
                xVehicleServicePlanStageTmp := Stage;
                IF Stage.Status IN [Stage.Status::Serviced, Stage.Status::"In Process", Stage.Status::Skipped] THEN BEGIN
                    IF (Stage."Service Date" = 0D) AND NOT (Stage.Status = Stage.Status::Skipped) THEN BEGIN
                        Stage."Service Date" := GetServiceDate(VehSerialNo, PlanNo, Stage.Recurrence, Stage.Code);
                        AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                          STRSUBSTNO(TextLogUpdateField, Stage.TABLECAPTION, Stage.FIELDCAPTION("Service Date"),
                          Stage."Service Date"), Stage.FIELDNO("Service Date"), 0);
                    END;
                END ELSE BEGIN
                    IF (NOT AdjustFlagInfluence) OR (AdjustFlagInfluence AND (Stage."Expected Service Date" = 0D)) OR
                        (AdjustFlagInfluence AND VehicleServicePlan.Adjust) THEN BEGIN
                        NewExpDateByInterval := GetExpectedDateByInterval(Stage);
                        AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                          STRSUBSTNO(TextLogCalcByInterval, FORMAT(NewExpDateByInterval)),
                          0, 0);
                        StageLastFillByLastSLE;  //02.04.2013 EDMS P8
                        AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                          STRSUBSTNO(TextLogLastSLEValues, StageLastTmp."Service Date", StageLastTmp.Kilometrage,
                            StageLastTmp."Variable Field Run 2", StageLastTmp."Variable Field Run 3"),
                          0, 0);
                        NewExpDate := NewExpDateByInterval;
                        NewExpDate1 := 0D;
                        NewExpDate2 := 0D;
                        NewExpDate3 := 0D;
                        IF (Stage."VF Initial Run 1" > 0) OR (Stage."VF Initial Run 2" > 0) OR (Stage."VF Initial Run 3" > 0) THEN BEGIN
                            //ExpectedPerDay
                            CalcStageAvgPerDay(StageAvgTmp);
                            AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                              STRSUBSTNO(TextLogAvgValues, StageAvgTmp."Service Date", StageAvgTmp.Kilometrage,
                              StageAvgTmp."Variable Field Run 2", StageAvgTmp."Variable Field Run 3"),
                              0, 0);

                            IF NOT ((StageAvgTmp.Kilometrage = 0) AND (StageAvgTmp."Variable Field Run 2" = 0) AND
                                (StageAvgTmp."Variable Field Run 3" = 0)) THEN BEGIN
                                LastServDate := StageLastTmp."Service Date";
                                IF StageAvgTmp.Kilometrage > 0 THEN BEGIN
                                    NewExpDate1 := LastServDate +
                                      ROUND((Stage.Kilometrage - StageLastTmp.Kilometrage) /
                                        StageAvgTmp.Kilometrage, 1);
                                    AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                                      STRSUBSTNO(TextLogCalcValue, 'NewExpDate1', NewExpDate1),
                                      0, 0);
                                END;
                                IF StageAvgTmp."Variable Field Run 2" > 0 THEN BEGIN
                                    NewExpDate2 := LastServDate +
                                      ROUND((Stage."Variable Field Run 2" - StageLastTmp."Variable Field Run 2") /
                                        StageAvgTmp."Variable Field Run 2", 1);
                                    AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                                      STRSUBSTNO(TextLogCalcValue, 'NewExpDate2', NewExpDate2),
                                      0, 0);
                                END;
                                IF StageAvgTmp."Variable Field Run 3" > 0 THEN BEGIN
                                    NewExpDate3 := LastServDate +
                                      ROUND((Stage."Variable Field Run 3" - StageLastTmp."Variable Field Run 3") /
                                        StageAvgTmp."Variable Field Run 3", 1);
                                    AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                                      STRSUBSTNO(TextLogCalcValue, 'NewExpDate3', NewExpDate3),
                                      0, 0);
                                END;

                                NewExpDate := NewExpDateByInterval;
                                IF ((NewExpDate1 < NewExpDate) AND (NewExpDate1 > LastServDate)) OR (NewExpDate = 0D) THEN
                                    NewExpDate := NewExpDate1;
                                IF ((NewExpDate2 < NewExpDate) AND (NewExpDate2 > LastServDate)) OR (NewExpDate = 0D) THEN
                                    NewExpDate := NewExpDate2;
                                IF ((NewExpDate3 < NewExpDate) AND (NewExpDate3 > LastServDate)) OR (NewExpDate = 0D) THEN
                                    NewExpDate := NewExpDate3;
                            END;
                        END;
                        Stage."Expected Service Date" := NewExpDate;
                        AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                          STRSUBSTNO(TextLogUpdateField, Stage.TABLENAME, Stage.FIELDCAPTION("Expected Service Date"),
                          Stage."Expected Service Date"),
                          Stage.FIELDNO("Expected Service Date"), 0);
                    END;
                END;
                AssignStageLast(GetDateOfStage(Stage, AdjustFlagInfluence), Stage.Kilometrage,
                  Stage."Variable Field Run 2", Stage."Variable Field Run 3");
                Stage.MODIFY;

            UNTIL Stage.NEXT = 0;
        AddLogEntryForCalcESDofPlan(VehicleServicePlan, VehicleServicePlan, STRSUBSTNO(TextLogEnd, VehSerialNo, PlanNo), 0, 0);
    end;

    [Scope('Internal')]
    procedure CalcStageAvgPerDay(var StageAvg: Record "25006132" temporary)
    var
        ServLedgerEntry: Record "25006167";
        StageAvgByPlanTmp: Record "25006132" temporary;
        MinRun: Decimal;
        MinRun2: Decimal;
        MinRun3: Decimal;
        MaxRun: Decimal;
        MaxRun2: Decimal;
        MaxRun3: Decimal;
        MinDate: Date;
        MaxDate: Date;
    begin
        ServLedgerEntry.RESET;
        ServLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Posting Date", "Entry Type");
        //ServLedgerEntry.SETCURRENTKEY("Vehicle Serial No.","Entry Type","Variable Field Run 1");
        ServLedgerEntry.SETRANGE("Vehicle Serial No.", StageAvg."Vehicle Serial No.");
        ServLedgerEntry.SETFILTER("Entry Type", '%1|%2', ServLedgerEntry."Entry Type"::Usage, ServLedgerEntry."Entry Type"::Info);
        IF ServLedgerEntry.COUNT > 1 THEN BEGIN
            //Getting min values
            IF ServLedgerEntry.FINDFIRST THEN BEGIN
                MinRun := ServLedgerEntry.Kilometrage;
                MinRun2 := ServLedgerEntry."Variable Field Run 2";
                MinRun3 := ServLedgerEntry."Variable Field Run 3";
                MinDate := ServLedgerEntry."Posting Date";
            END;
            //Getting max values
            IF ServLedgerEntry.FINDLAST THEN BEGIN
                MaxRun := ServLedgerEntry.Kilometrage;
                MaxRun2 := ServLedgerEntry."Variable Field Run 2";
                MaxRun3 := ServLedgerEntry."Variable Field Run 3";
                MaxDate := ServLedgerEntry."Posting Date";
            END;
            IF MaxDate <= MinDate THEN BEGIN
                MaxDate := MinDate;
                MinDate := 0D;
                IF MaxRun <= MinRun THEN
                    MaxRun := MinRun;
                MinRun := 0;
                IF MaxRun2 <= MinRun2 THEN
                    MaxRun2 := MinRun2;
                MinRun2 := 0;
                IF MaxRun3 <= MinRun3 THEN
                    MaxRun3 := MinRun3;
                MinRun3 := 0;
            END;
        END ELSE
            IF ServLedgerEntry.COUNT = 1 THEN BEGIN
                IF ServLedgerEntry.FINDLAST THEN BEGIN
                    MaxRun := ServLedgerEntry.Kilometrage;
                    MaxRun2 := ServLedgerEntry."Variable Field Run 2";
                    MaxRun3 := ServLedgerEntry."Variable Field Run 3";
                    MaxDate := ServLedgerEntry."Posting Date";
                END;
            END;

        IF (MinDate = 0D) THEN BEGIN
            MinDate := VehicleServicePlan."Start Date";
            MinRun := GetStartRun1;
            MinRun2 := GetStartRun2;
            MinRun3 := GetStartRun3;
        END;
        IF (MaxDate = 0D) THEN BEGIN
            MaxDate := MinDate;
            MaxRun := MinRun;
            MaxRun2 := MinRun2;
            MaxRun3 := MinRun3;
        END;
        StageAvgByPlanTmp.DELETEALL;
        StageAvgByPlanTmp.TRANSFERFIELDS(StageAvg);
        CalcStageAvgByPlan(StageAvgByPlanTmp);
        IF (MaxRun - MinRun <= 0) OR (MaxDate - MinDate <= 0) THEN BEGIN
            StageAvg.Kilometrage := StageAvgByPlanTmp.Kilometrage;
            AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
              STRSUBSTNO(TextLogAvgValueOfPlan,
              StageAvg.FIELDCAPTION(Kilometrage),
              StageAvg.Kilometrage),
              0, 0);
        END ELSE BEGIN
            StageAvg.Kilometrage := (MaxRun - MinRun) / (MaxDate - MinDate);
            AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
              STRSUBSTNO(TextLogAvgCalcPars, MaxRun, MinRun, MaxDate, MinDate,
              StageAvg.FIELDCAPTION(Kilometrage)),
              0, 0);
        END;
        IF (MaxRun2 - MinRun2 <= 0) OR (MaxDate - MinDate <= 0) THEN BEGIN
            StageAvg."Variable Field Run 2" := StageAvgByPlanTmp."Variable Field Run 2";
            AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
              STRSUBSTNO(TextLogAvgValueOfPlan,
              StageAvg.FIELDCAPTION("Variable Field Run 2"),
              StageAvg."Variable Field Run 2"),
              0, 0);
        END ELSE BEGIN
            StageAvg."Variable Field Run 2" := (MaxRun2 - MinRun2) / (MaxDate - MinDate);
            AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
              STRSUBSTNO(TextLogAvgCalcPars, MaxRun2, MinRun2, MaxDate, MinDate,
              StageAvg.FIELDCAPTION("Variable Field Run 2")),
              0, 0);
        END;
        IF (MaxRun3 - MinRun3 <= 0) OR (MaxDate - MinDate <= 0) THEN BEGIN
            StageAvg."Variable Field Run 3" := StageAvgByPlanTmp."Variable Field Run 3";
            AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
              STRSUBSTNO(TextLogAvgValueOfPlan,
              StageAvg.FIELDCAPTION("Variable Field Run 3"),
              StageAvg."Variable Field Run 3"),
              0, 0);
        END ELSE BEGIN
            StageAvg."Variable Field Run 3" := (MaxRun3 - MinRun3) / (MaxDate - MinDate);
            AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
              STRSUBSTNO(TextLogAvgCalcPars, MaxRun3, MinRun3, MaxDate, MinDate,
              StageAvg.FIELDCAPTION("Variable Field Run 3")),
              0, 0);
        END;
    end;

    [Scope('Internal')]
    procedure CalcStageAvgByPlan(StageAvg: Record "25006132")
    var
        Stage: Record "25006132";
        MinRun: Decimal;
        MinRun2: Decimal;
        MinRun3: Decimal;
        MaxRun: Decimal;
        MaxRun2: Decimal;
        MaxRun3: Decimal;
        MinDate: Date;
        MaxDate: Date;
    begin
        Stage.RESET;
        Stage.SETRANGE("Vehicle Serial No.", StageAvg."Vehicle Serial No.");
        Stage.SETRANGE("Plan No.", StageAvg."Plan No.");
        Stage.SETFILTER(Status, '%1|%2', Stage.Status::Serviced, Stage.Status::"In Process");
        IF Stage.COUNT > 1 THEN BEGIN
            //Getting min values
            IF Stage.FINDFIRST THEN BEGIN
                MinRun := Stage.Kilometrage;
                MinRun2 := Stage."Variable Field Run 2";
                MinRun3 := Stage."Variable Field Run 3";
                MinDate := Stage."Service Date";
            END;
            //Getting max values
            IF Stage.FINDLAST THEN BEGIN
                MaxRun := Stage.Kilometrage;
                MaxRun2 := Stage."Variable Field Run 2";
                MaxRun3 := Stage."Variable Field Run 3";
                MaxDate := Stage."Service Date";
            END;
            IF MaxDate <= MinDate THEN BEGIN
                MaxDate := MinDate;
                MinDate := 0D;
                IF MaxRun <= MinRun THEN
                    MaxRun := MinRun;
                MinRun := 0;
                IF MaxRun2 <= MinRun2 THEN
                    MaxRun2 := MinRun2;
                MinRun2 := 0;
                IF MaxRun3 <= MinRun3 THEN
                    MaxRun3 := MinRun3;
                MinRun3 := 0;
            END;
        END ELSE
            IF Stage.COUNT = 1 THEN BEGIN
                IF Stage.FINDLAST THEN BEGIN
                    MaxRun := Stage.Kilometrage;
                    MaxRun2 := Stage."Variable Field Run 2";
                    MaxRun3 := Stage."Variable Field Run 3";
                    MaxDate := Stage."Service Date";
                END;
            END;
        IF (MinDate = 0D) THEN BEGIN
            MinDate := VehicleServicePlan."Start Date";
            MinRun := GetStartRun1;
            MinRun2 := GetStartRun2;
            MinRun3 := GetStartRun3;
        END;
        IF (MaxDate = 0D) THEN BEGIN
            MaxDate := MinDate;
            MaxRun := MinRun;
            MaxRun2 := MinRun2;
            MaxRun3 := MinRun3;
        END;
        IF MaxDate - MinDate <= 0 THEN BEGIN
            StageAvg.Kilometrage := 0;
            StageAvg."Variable Field Run 2" := 0;
            StageAvg."Variable Field Run 3" := 0;
        END;

        IF (MaxRun - MinRun <= 0) OR (MaxDate - MinDate <= 0) THEN
            StageAvg.Kilometrage := 0
        ELSE
            StageAvg.Kilometrage := (MaxRun - MinRun) / (MaxDate - MinDate);
        IF (MaxRun2 - MinRun2 <= 0) OR (MaxDate - MinDate <= 0) THEN
            StageAvg."Variable Field Run 2" := 0
        ELSE
            StageAvg."Variable Field Run 2" := (MaxRun2 - MinRun2) / (MaxDate - MinDate);
        IF (MaxRun3 - MinRun3 <= 0) OR (MaxDate - MinDate <= 0) THEN
            StageAvg."Variable Field Run 3" := 0
        ELSE
            StageAvg."Variable Field Run 3" := (MaxRun3 - MinRun3) / (MaxDate - MinDate);

        AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
  STRSUBSTNO(TextLogAvgCalcPlanPars, MaxRun, MinRun, MaxDate, MinDate,
  StageAvg.FIELDCAPTION(Kilometrage)),
  0, 0);
        AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
          STRSUBSTNO(TextLogAvgCalcPlanPars, MaxRun2, MinRun2, MaxDate, MinDate,
          StageAvg.FIELDCAPTION("Variable Field Run 2")),
          0, 0);
        AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
          STRSUBSTNO(TextLogAvgCalcPlanPars, MaxRun3, MinRun3, MaxDate, MinDate,
          StageAvg.FIELDCAPTION("Variable Field Run 3")),
          0, 0);
        AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
          STRSUBSTNO(TextLogAvgValuesPlan, StageAvg."Service Date", StageAvg.Kilometrage,
          StageAvg."Variable Field Run 2", StageAvg."Variable Field Run 3"),
          0, 0);
    end;

    [Scope('Internal')]
    procedure GetExpectedDateByInterval(VehicleServicePlanStage: Record "25006132"): Date
    var
        ServLedgerEntry: Record "25006167";
        MinRun: Integer;
        MaxRun: Integer;
        MinDate: Date;
        MaxDate: Date;
        VFRun1: Decimal;
        VFRun2: Decimal;
        VFRun3: Decimal;
        ServiceIntervalFormat: Text[30];
    begin
        ServiceIntervalFormat := FORMAT(VehicleServicePlanStage."Service Interval");
        InitialiseStageLast;
        IF (ServiceIntervalFormat = ' ') OR (ServiceIntervalFormat = '') THEN
            EXIT(0D);
        MinDate := StageLastTmp."Service Date";
        EXIT(CALCDATE(VehicleServicePlanStage."Service Interval", MinDate));
    end;

    [Scope('Internal')]
    procedure GetExpectedDateByIntervalGlob(VehicleSerialNo: Code[20]; PlanNo: Code[10]; VehicleServicePlanStage: Record "25006132") RetDate: Date
    var
        ServLedgerEntry: Record "25006167";
        MinRun: Integer;
        MaxRun: Integer;
        MinDate: Date;
        MaxDate: Date;
        VFRun1: Decimal;
        VFRun2: Decimal;
        VFRun3: Decimal;
        ServiceIntervalFormat: Text[30];
    begin
        VehicleServicePlan.GET(VehicleSerialNo, PlanNo);
        IF ((VehicleServicePlanStage."Expected Service Date" > 0D) AND (NOT VehicleServicePlan.Adjust)) THEN BEGIN
            RetDate := VehicleServicePlanStage."Expected Service Date";
        END ELSE BEGIN
            ServiceIntervalFormat := FORMAT(VehicleServicePlanStage."Service Interval");
            IF (ServiceIntervalFormat = ' ') OR (ServiceIntervalFormat = '') THEN
                EXIT(0D);
            MinDate := GetDateOfPrevStage(VehicleServicePlanStage, TRUE);
            IF (MinDate = 0D) THEN BEGIN
                VehicleServicePlan.GET(VehicleServicePlanStage."Vehicle Serial No.", VehicleServicePlanStage."Plan No.");
                MinDate := VehicleServicePlan."Start Date";
            END;
            RetDate := CALCDATE(VehicleServicePlanStage."Service Interval", MinDate);
        END;
        EXIT(RetDate);
    end;

    [Scope('Internal')]
    procedure GetStartRun1(): Decimal
    var
        Vehicle: Record "25006005";
    begin
        EXIT(VehicleServicePlan."Start Variable Field Run 1");
    end;

    [Scope('Internal')]
    procedure GetStartRun2(): Decimal
    var
        Vehicle: Record "25006005";
    begin
        EXIT(VehicleServicePlan."Start Variable Field Run 2");
    end;

    [Scope('Internal')]
    procedure GetStartRun3(): Decimal
    var
        Vehicle: Record "25006005";
    begin
        EXIT(VehicleServicePlan."Start Variable Field Run 3");
    end;

    [Scope('Internal')]
    procedure InitialiseStageLast()
    var
        ServLedgerEntry: Record "25006167";
    begin
        IF StageLastTmp."Service Date" = 0D THEN BEGIN
            StageLastTmp.Kilometrage := GetStartRun1;
            StageLastTmp."Variable Field Run 2" := GetStartRun2;
            StageLastTmp."Variable Field Run 3" := GetStartRun3;
            StageLastTmp."Service Date" := VehicleServicePlan."Start Date";
        END;
    end;

    [Scope('Internal')]
    procedure AssignStageLast(ServDate: Date; ServVFRun1: Decimal; ServVFRun2: Decimal; ServVFRun3: Decimal): Date
    var
        ServLedgerEntry: Record "25006167";
    begin
        StageLastTmp.Kilometrage := ServVFRun1;
        StageLastTmp."Variable Field Run 2" := ServVFRun2;
        StageLastTmp."Variable Field Run 3" := ServVFRun3;
        StageLastTmp."Service Date" := ServDate;
    end;

    [Scope('Internal')]
    procedure StageLastFillByLastSLE()
    var
        ServDate: Date;
        ServVFRun1: Decimal;
        ServVFRun2: Decimal;
        ServVFRun3: Decimal;
    begin
        // that function is not optimal! cause use of SLE, for future need to redo to use "Service Plan Document Link"
        ServDate := GetLastServLEntryDate(VehicleServicePlan."Vehicle Serial No.", VehicleServicePlan."No.", ServVFRun1, ServVFRun2,
          ServVFRun3);
        AssignStageLast(ServDate, ServVFRun1, ServVFRun2, ServVFRun3);
    end;

    [Scope('Internal')]
    procedure GetVehicleSellDate(VehSerialNo: Code[20]): Date
    begin
        IF Vehicle.GET(VehSerialNo) THEN;
        EXIT(Vehicle."Sales Date");
    end;

    [Scope('Internal')]
    procedure AddLogEntryForCalcESD(RecordRef: RecordRef; xRecordRef: RecordRef; FieldIDChanges: Integer; CommonLogEntryTmp: Record "25006190" temporary; RunModeFlags: Integer)
    var
        CommonLogEntry: Record "25006190";
        FieldRef: FieldRef;
        xFieldRef: FieldRef;
    begin
        //AdjustFlagsToArray(RunModeFlags, FlagsArray);
        IF FieldIDChanges > 0 THEN BEGIN
            xFieldRef := xRecordRef.FIELD(FieldIDChanges);
            FieldRef := RecordRef.FIELD(FieldIDChanges);
            RunModeFlags := 1;
        END ELSE
            RunModeFlags := 0;

        CommonLogEntry.InsertLogEntry(5, 25006103, CommonLogEntryTmp, FieldRef, xFieldRef, RecordRef,
          CommonLogEntryTmp."Type of Change"::Modification, RunModeFlags);
    end;

    [Scope('Internal')]
    procedure AddLogEntryForCalcESDofPlan(VehicleServicePlanPar: Record "25006126"; xVehicleServicePlanPar: Record "25006126"; LogText: Text[250]; FieldIDChanges: Integer; RunModeFlags: Integer)
    var
        CommonLogEntry: Record "25006190";
        CommonLogEntryTmp: Record "25006190" temporary;
        FlagsArray: array[16] of Boolean;
        RecordRef: RecordRef;
        xRecordRef: RecordRef;
        FieldRef: FieldRef;
        xFieldRef: FieldRef;
    begin
        //AdjustFlagsToArray(RunModeFlags, FlagsArray);
        ServiceSetup.GET;
        IF NOT ServiceSetup."Log Service Plan Mgt. Process" THEN
            EXIT;
        RecordRef.OPEN(DATABASE::"Vehicle Service Plan");
        RecordRef.GETTABLE(VehicleServicePlanPar);
        xRecordRef.OPEN(DATABASE::"Vehicle Service Plan");
        xRecordRef.GETTABLE(xVehicleServicePlanPar);

        CommonLogEntryTmp."Processing Info" := LogText;
        AddLogEntryForCalcESD(RecordRef, xRecordRef, FieldIDChanges, CommonLogEntryTmp, 0);
    end;

    [Scope('Internal')]
    procedure AddLogEntryForCalcESDofStage(VehicleServicePlanStagePar: Record "25006132"; xVehicleServicePlanStagePar: Record "25006132"; LogText: Text[250]; FieldIDChanges: Integer; RunModeFlags: Integer)
    var
        CommonLogEntry: Record "25006190";
        CommonLogEntryTmp: Record "25006190" temporary;
        FlagsArray: array[16] of Boolean;
        RecordRef: RecordRef;
        xRecordRef: RecordRef;
        FieldRef: FieldRef;
        xFieldRef: FieldRef;
    begin
        //AdjustFlagsToArray(RunModeFlags, FlagsArray);
        ServiceSetup.GET;
        IF NOT ServiceSetup."Log Service Plan Mgt. Process" THEN
            EXIT;
        RecordRef.OPEN(DATABASE::"Vehicle Service Plan Stage");
        RecordRef.GETTABLE(VehicleServicePlanStagePar);
        xRecordRef.OPEN(DATABASE::"Vehicle Service Plan Stage");
        xRecordRef.GETTABLE(xVehicleServicePlanStagePar);

        CommonLogEntryTmp."Processing Info" := LogText;
        AddLogEntryForCalcESD(RecordRef, xRecordRef, FieldIDChanges, CommonLogEntryTmp, 0);
    end;

    [Scope('Internal')]
    procedure "//--Universal CreateOrdersBy"()
    begin
    end;

    [Scope('Internal')]
    procedure SetVehicleG(var VehiclePar: Record "25006005")
    begin
        //VehicleGlob := VehiclePar;
        VehicleGlob.RESET;
        IF VehiclePar.GETFILTERS <> '' THEN  //25.03.2013 EDMS P8
            VehicleGlob.COPYFILTERS(VehiclePar);
    end;

    [Scope('Internal')]
    procedure SetVehicleContactG(var VehicleContactPar: Record "25006013")
    begin
        //VehicleContactGlob := VehicleContactPar;
        VehicleContactGlob.RESET;
        IF VehicleContactPar.GETFILTERS <> '' THEN
            VehicleContactGlob.COPYFILTERS(VehicleContactPar);
    end;

    [Scope('Internal')]
    procedure SetContactBusinessRelationG(var ContactBusinessRelationPar: Record "5054")
    begin
        //ContactBusinessRelationGlob := ContactBusinessRelationPar;
        ContactBusinessRelationGlob.RESET;
        IF ContactBusinessRelationPar.GETFILTERS <> '' THEN
            ContactBusinessRelationGlob.COPYFILTERS(ContactBusinessRelationPar);
    end;

    [Scope('Internal')]
    procedure SetCustomerG(var CustomerPar: Record "18")
    begin
        //CustomerGlob := CustomerPar;
        CustomerGlob.RESET;
        IF CustomerPar.GETFILTERS <> '' THEN
            CustomerGlob.COPYFILTERS(CustomerPar);
    end;

    [Scope('Internal')]
    procedure SetVehicleServicePlanG(var VehicleServicePlanPar: Record "25006126")
    begin
        //VehicleServicePlanGlob := VehicleServicePlanPar;
        VehicleServicePlanGlob.RESET;
        IF VehicleServicePlanPar.GETFILTERS <> '' THEN
            VehicleServicePlanGlob.COPYFILTERS(VehicleServicePlanPar);
    end;

    [Scope('Internal')]
    procedure SetVehicleServicePlanStageG(var VehicleServicePlanStagePar: Record "25006132")
    begin
        //VehicleServicePlanStageGlob := VehicleServicePlanStagePar;
        VehicleServicePlanStageGlob.RESET;
        IF VehicleServicePlanStagePar.GETFILTERS <> '' THEN
            VehicleServicePlanStageGlob.COPYFILTERS(VehicleServicePlanStagePar);
    end;

    [Scope('Internal')]
    procedure SetServicePackageG(var ServicePackagePar: Record "25006134")
    begin
        //ServicePackageGlob := ServicePackagePar;
        ServicePackageGlob.RESET;
        IF ServicePackagePar.GETFILTERS <> '' THEN
            ServicePackageGlob.COPYFILTERS(ServicePackagePar);
    end;

    [Scope('Internal')]
    procedure SetServicePackageVersionG(var ServicePackageVersionPar: Record "25006135")
    begin
        //ServicePackageVersionGlob := ServicePackageVersionPar;
        ServicePackageVersionGlob.RESET;
        IF ServicePackageVersionPar.GETFILTERS <> '' THEN
            ServicePackageVersionGlob.COPYFILTERS(ServicePackageVersionPar);
    end;

    [Scope('Internal')]
    procedure CreateOrdersByFiltered(OrderDate: Date; RunModeFlags: Integer) RetValue: Integer
    var
        FlagsArray: array[16] of Boolean;
        Vehicle: Record "25006005";
        VehicleContact: Record "25006013";
        ContactBusinessRelation: Record "5054";
        ServiceMgtSetup: Record "25006120";
        MarketingSetup: Record "5079";
        ServiceHeader: Record "25006145";
        ServiceHeaderTmp: Record "25006145" temporary;
        VehicleServicePlanStageTmp: Record "25006132" temporary;
        VehicleServicePlanStage: Record "25006132";
        VehicleServicePlanStage2: Record "25006132";
        VehicleServicePlanStage3: Record "25006132";
        VehicleServicePlan: Record "25006126";
        ServicePackageLoc: Record "25006134";
        ServicePackageVersionLoc: Record "25006135";
        CustomerToCurrent: Record "18";
        ServiceLedgerEntry: Record "25006167";
        ServicePlanMgt: Codeunit "25006103";
        DefContRelationshipCode: Code[10];
        FilterStr: Text[30];
        IsFound: Boolean;
        RecExists: Boolean;
        I: Integer;
        IsPlanFilter: Boolean;
        IsPlanStagesFilter: Boolean;
        DoContinue: Boolean;
        OneCarOneDoc: Boolean;
    begin
        AdjustFlagsToArray(RunModeFlags, FlagsArray);
        OneCarOneDoc := FALSE;
        IF OrderDate = 0D THEN
            OrderDate := WORKDATE;
        ServiceHeaderTmp.DELETEALL;
        VehicleServicePlanStageTmp.DELETEALL;

        ServiceMgtSetup.GET;
        MarketingSetup.GET;

        VehicleContact.RESET;
        VehicleContact.SETCURRENTKEY("Vehicle Serial No.", "Relationship Code", "Contact No.");
        VehicleContact.FILTERGROUP(2);
        VehicleContact.COPYFILTERS(VehicleContactGlob);
        IF VehicleContact.GETFILTER("Relationship Code") = '' THEN BEGIN
            VehicleContact.FILTERGROUP(0);
            VehicleContact.SETRANGE("Relationship Code", ServiceMgtSetup."Serv. Plan Cont. Relationship");
        END;

        Vehicle.RESET;
        Vehicle.FILTERGROUP(2);
        Vehicle.COPYFILTERS(VehicleGlob);
        Vehicle.FILTERGROUP(0);
        VehicleServicePlan.RESET;
        VehicleServicePlan.FILTERGROUP(2);
        VehicleServicePlan.COPYFILTERS(VehicleServicePlanGlob);
        IsPlanFilter := (VehicleServicePlan.GETFILTERS <> '');
        VehicleServicePlan.FILTERGROUP(0);
        ServicePackageLoc.RESET;
        ServicePackageLoc.FILTERGROUP(2);
        ServicePackageLoc.COPYFILTERS(ServicePackageGlob);
        ServicePackageLoc.FILTERGROUP(0);
        IF ServicePackageGlob.GETFILTERS = '' THEN
            ServicePackageLoc.RESET;
        ServicePackageVersionLoc.RESET;
        //FILTERGROUP(2);  //25.03.2013 EDMS P8
        IF ServicePackageVersionGlob.GETFILTERS <> '' THEN
            ServicePackageVersionLoc.COPYFILTERS(ServicePackageVersionGlob);
            //FILTERGROUP(0);
        ContactBusinessRelation.RESET;
        ContactBusinessRelation.FILTERGROUP(2);
        ContactBusinessRelation.COPYFILTERS(ContactBusinessRelationGlob);
        ContactBusinessRelation.FILTERGROUP(0);
        ContactBusinessRelation.SETRANGE("Business Relation Code", MarketingSetup."Bus. Rel. Code for Customers");
        CustomerToCurrent.RESET;
        CustomerToCurrent.FILTERGROUP(2);
        CustomerToCurrent.COPYFILTERS(CustomerGlob);
        CustomerToCurrent.FILTERGROUP(0);
        VehicleServicePlanStage3.RESET;
        VehicleServicePlanStage3.FILTERGROUP(2);
        VehicleServicePlanStage3.COPYFILTERS(VehicleServicePlanStageGlob);
        IsPlanStagesFilter := (VehicleServicePlanStageGlob.GETFILTERS <> '');
        VehicleServicePlanStage3.FILTERGROUP(0);


        Vehicle.FINDFIRST;
        REPEAT
            FOR I := 1 TO 4 DO BEGIN
                ServiceHeader.RESET;
                ServiceHeader.SetHideValidationDialog(TRUE);
                ServiceHeader.INIT;
                ServiceHeader."Vehicle Serial No." := Vehicle."Serial No.";
                ServiceHeader.SetDatesSchema1(OrderDate, OrderDate, 0D, 0D);
                IF I = 1 THEN BEGIN
                    ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Posting Date", "Entry Type");
                    ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", Vehicle."Serial No.");
                    FilterStr := STRSUBSTNO('%1|%2', ServiceLedgerEntry."Entry Type"::Usage, ServiceLedgerEntry."Entry Type"::Info);
                    ServiceLedgerEntry.SETFILTER("Entry Type", FilterStr);
                END;
                IF ServiceLedgerEntry.FINDLAST THEN BEGIN
                    ServiceHeader.Kilometrage := ServiceLedgerEntry.Kilometrage;
                    ServiceHeader."Variable Field Run 2" := ServiceLedgerEntry."Variable Field Run 2";
                    ServiceHeader."Variable Field Run 3" := ServiceLedgerEntry."Variable Field Run 3";
                END;
                CASE I OF
                    1:
                        BEGIN
                            IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FIELDNO(Kilometrage),
                              VehicleServicePlanStage);
                        END;
                    2:
                        BEGIN
                            IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FIELDNO("Variable Field Run 2"),
                              VehicleServicePlanStage);
                        END;
                    3:
                        BEGIN
                            IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FIELDNO("Variable Field Run 3"),
                              VehicleServicePlanStage);
                        END;
                    4:
                        BEGIN
                            IsFound := ServiceHeader.IsAchievedServStageByInterval(VehicleServicePlanStage);
                        END;
                END;
                IF IsFound THEN BEGIN
                    IsFound := VehicleServicePlanStage.FINDFIRST;
                    IF IsPlanStagesFilter THEN
                        WITH VehicleServicePlanStage3 DO BEGIN
                            VehicleServicePlanStage3.SETRANGE("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                            VehicleServicePlanStage3.SETRANGE("Plan No.", VehicleServicePlanStage."Plan No.");
                            VehicleServicePlanStage3.SETRANGE(Recurrence, VehicleServicePlanStage.Recurrence);
                            VehicleServicePlanStage3.SETRANGE(Code, VehicleServicePlanStage.Code);
                            IF NOT VehicleServicePlanStage3.FINDFIRST THEN
                                IsFound := FALSE;
                        END;
                END;
                IF IsFound THEN BEGIN
                    //VehicleServicePlanStage.FINDFIRST;
                    REPEAT
                        DoContinue := TRUE;
                        IF IsPlanFilter THEN BEGIN
                            VehicleServicePlan.SETRANGE("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                            VehicleServicePlan.SETRANGE("No.", VehicleServicePlanStage."Plan No.");
                            IF NOT VehicleServicePlan.FINDFIRST THEN
                                DoContinue := FALSE;
                        END;
                        IF DoContinue THEN BEGIN
                            // FOR now it is agreed that for one plan could be one document AT ONCE
                            VehicleServicePlanStage2.RESET;
                            VehicleServicePlanStage2.SETRANGE("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                            VehicleServicePlanStage2.SETRANGE("Plan No.", VehicleServicePlanStage."Plan No.");
                            VehicleServicePlanStage2.SETRANGE(Recurrence, VehicleServicePlanStage.Recurrence);
                            VehicleServicePlanStage2.SETRANGE(Status, VehicleServicePlanStage.Status::"In Process");
                            IF VehicleServicePlanStage2.FINDFIRST THEN
                                DoContinue := FALSE
                            ELSE BEGIN
                                VehicleServicePlanStageTmp.SETRANGE("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                                VehicleServicePlanStageTmp.SETRANGE("Plan No.", VehicleServicePlanStage."Plan No.");
                                IF VehicleServicePlanStageTmp.FINDFIRST THEN
                                    DoContinue := FALSE;
                            END;
                        END;
                        IF DoContinue THEN BEGIN
                            ServicePackageLoc.SETRANGE("No.", VehicleServicePlanStage."Package No.");
                            ServicePackageVersionLoc.SETRANGE("Package No.", VehicleServicePlanStage."Package No.");
                            IF ServicePackageLoc.FINDFIRST THEN;
                            IF ServicePackageVersionLoc.FINDFIRST THEN;
                            VehicleContact.SETRANGE("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                            IF VehicleContact.FINDFIRST THEN BEGIN
                                ContactBusinessRelation.SETRANGE("Contact No.", VehicleContact."Contact No.");
                                IF ContactBusinessRelation.FINDFIRST THEN BEGIN
                                    CustomerToCurrent.SETRANGE("No.", ContactBusinessRelation."No.");
                                    IF CustomerToCurrent.FINDFIRST THEN BEGIN
                                        ServicePlanMgt.SetVehicleServicePlanStage(VehicleServicePlanStage);
                                        ServicePlanMgt.SetSPVersion(ServicePackageVersionLoc);

                                        ServicePlanMgt.SetCustomer(CustomerToCurrent);
                                        ServiceHeader.RESET;
                                        ServiceHeaderTmp.RESET;
                                        ServiceHeaderTmp.SETRANGE("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                                        IF ServiceHeaderTmp.FINDFIRST AND OneCarOneDoc THEN BEGIN
                                            ServiceHeader.GET(ServiceHeaderTmp."Document Type", ServiceHeaderTmp."No.");
                                            RecExists := TRUE;
                                        END ELSE BEGIN
                                            RecExists := FALSE;
                                            ServiceHeader.INIT;
                                            ServiceHeader."No." := '';
                                            ServiceHeader.SetDatesSchema1(OrderDate, VehicleServicePlanStage."Expected Service Date", 0D, 0D);
                                            ServiceHeader.Kilometrage := ServiceLedgerEntry.Kilometrage;
                                            ServiceHeader."Variable Field Run 2" := ServiceLedgerEntry."Variable Field Run 2";
                                            ServiceHeader."Variable Field Run 3" := ServiceLedgerEntry."Variable Field Run 3";
                                        END;
                                        VehicleServicePlanStage3.GET(VehicleServicePlanStage."Vehicle Serial No.", VehicleServicePlanStage."Plan No.",
                                          VehicleServicePlanStage.Recurrence, VehicleServicePlanStage.Code);
                                        IF ServicePackageVersionLoc.FINDFIRST THEN
                                            ServicePlanMgt.CreateServOrderForVehBy(ServiceHeader, 41, '')
                                        ELSE
                                            ServicePlanMgt.CreateServOrderForVehBy(ServiceHeader, 9, '');
                                        IF NOT RecExists THEN BEGIN
                                            ServiceHeaderTmp.INIT;
                                            ServiceHeaderTmp.TRANSFERFIELDS(ServiceHeader);
                                            ServiceHeaderTmp.INSERT;
                                            RetValue += 1;
                                        END;
                                        VehicleServicePlanStageTmp.RESET;
                                        VehicleServicePlanStageTmp.INIT;
                                        VehicleServicePlanStageTmp.TRANSFERFIELDS(VehicleServicePlanStage);
                                        VehicleServicePlanStageTmp.INSERT;

                                    END;
                                END;  // IF ContactBusinessRelation.FINDFIRST
                            END;  // IF VehicleContact.FINDFIRST
                        END;  // IF DoContinue
                    UNTIL VehicleServicePlanStage.NEXT = 0;
                END;
            END;
        UNTIL Vehicle.NEXT = 0;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure "//--Old version"()
    begin
    end;

    [Scope('Internal')]
    procedure CreateServOrderForVehBy(var ServiceHeaderPar: Record "25006145"; RunModeFlags: Integer; RunModeSpecs: Text[30]): Integer
    var
        ServiceLine: Record "25006146";
        FlagsArray: array[16] of Boolean;
        CustNo: Code[20];
        RetStatus: Option OK,NotFoundVehicle,NotFoundCustomer,NotFoundSP,NotFoundSPVersion,UnsupportedFlagsSequence;
        ServiceHeaderTmp: Record "25006145" temporary;
        OrderDate: Date;
    begin
        // that is function for general creation/modification of service document by addding lines from service package
        // to obtain sets/parameters need to use subfunctions: SetVehicleServicePlanStage, SetVehicle etc.
        //  So it supposed that record that is given by subfunction should be filtered and general function proceed first or all records
        //   in a range.
        // RunModeFlags - full of digits integer, imitation of two bytes parameter, there 0 means "no" 1 - "yes"' from right to left:
        //   1st digit - is it customer record defined
        //   2nd - is it Vehicle record defined
        //   3rd - is it VehicleServicePlan record defined
        //   4th - is it VehicleServicePlanStage record defined
        //   5th - is it ServicePackage record defined
        //   6th - is it SPVersion record defined
        // so to call that function need carefully organize Flags = 1+2+4+8+16+0+64+0 = 95 (means in byte 01011111)
        //for now it is allowed: 41 = 1+0+0+8+0+32+0+0 (bin 00101001)
        //                       9 = 1+0+0+8+0+0+0+0 (bin 00001001)
        AdjustFlagsToArray(RunModeFlags, FlagsArray);
        IF NOT (FlagsArray[1] AND NOT FlagsArray[2] AND NOT FlagsArray[3] AND FlagsArray[4] AND
            NOT FlagsArray[5] AND NOT FlagsArray[7] AND NOT FlagsArray[8]) THEN
            EXIT(RetStatus::UnsupportedFlagsSequence);  // FIRST error

        //at first must be defined vehicle
        IF NOT FlagsArray[2] THEN BEGIN
            IF ServiceHeaderPar."Vehicle Serial No." = '' THEN BEGIN
                IF NOT FlagsArray[3] THEN BEGIN
                    IF NOT FlagsArray[4] THEN BEGIN
                        EXIT(RetStatus::NotFoundVehicle);  // FIRST error
                    END ELSE
                        Vehicle.GET(VehicleServicePlanStage."Vehicle Serial No.");
                END ELSE
                    Vehicle.GET(VehicleServicePlan."Vehicle Serial No.");
            END ELSE
                Vehicle.GET(ServiceHeaderPar."Vehicle Serial No.");
        END;
        //then define customer
        IF NOT FlagsArray[1] THEN BEGIN
            IF ServiceHeaderPar."Sell-to Customer No." = '' THEN BEGIN
                IF FlagsArray[4] THEN
                    CustNo := GetVehicleCustomer(VehicleServicePlanStage."Vehicle Serial No.");
                IF CustNo = '' THEN BEGIN
                    EXIT(RetStatus::NotFoundCustomer);  //error
                END ELSE
                    Customer.GET(CustNo);
            END ELSE
                Customer.GET(ServiceHeaderPar."Sell-to Customer No.");
        END;

        IF ServiceHeaderPar."No." = '' THEN BEGIN
            // means need create document
            ServiceHeaderTmp.TRANSFERFIELDS(ServiceHeaderPar);
            IF ServiceHeaderTmp."Order Date" > 0D THEN
                OrderDate := ServiceHeaderTmp."Order Date"
            ELSE
                IF ServiceHeaderTmp."Planned Service Date" > 0D THEN
                    OrderDate := ServiceHeaderTmp."Planned Service Date"
                ELSE
                    OrderDate := WORKDATE;
            ServiceHeaderPar.CreateServHeader(ServiceHeaderPar."Document Type"::Order, OrderDate, ServiceHeaderTmp."Planned Service Date",
              VehicleServicePlanStage.Description, Customer."No.", Customer."No.", Vehicle."Serial No.");
            //      STRSUBSTNO(Text001, VehicleServicePlanStage."Plan No."), Customer."No.", Customer."No.", Vehicle."Serial No.");
            ServiceHeaderPar.Kilometrage := ServiceHeaderTmp.Kilometrage;
            ServiceHeaderPar."Variable Field Run 2" := ServiceHeaderTmp."Variable Field Run 2";
            ServiceHeaderPar."Variable Field Run 3" := ServiceHeaderTmp."Variable Field Run 3";
            ServiceHeaderPar.MODIFY;
        END;
        IF FlagsArray[6] THEN BEGIN
            ServiceHeaderPar.SPVersionAssignFilter(SPVersion);
            IF SPVersion.FINDFIRST THEN
                ServiceHeaderPar.InsertSPVersion(SPVersion)
            ELSE
                EXIT(RetStatus::NotFoundSPVersion);  //error
        END;

        IF FlagsArray[4] THEN BEGIN
            ServiceHeaderPar.InsertServPlanDocLink(VehicleServicePlanStage);
        END;


        EXIT(RetStatus::OK);  //success
    end;
}

