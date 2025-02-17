codeunit 25006127 "Service Job Queue Process"
{
    TableNo = 472;

    trigger OnRun()
    begin
        ProceedParameters(Rec."Parameter String");
        CASE RunMode OF
            1:
                CalcPlanExpectedDate;
            2:
                //CreateOrdersBySLEntry;
                BEGIN
                    CreateOrdersByFiltered(0D, 0);
                END;
            3:
                CODEUNIT.RUN(CODEUNIT::"OriLink Auto Asignment");
        END;
    end;

    var
        RunMode: Integer;
        ServicePlanMgt: Codeunit "25006103";

    [Scope('Internal')]
    procedure ProceedParameters(ParamString: Text[1024])
    var
        ParamName: Text[30];
        ParamValue: Text[30];
    begin
        REPEAT
            ParamValue := CutNextParam(ParamString, ParamName);
            CASE UPPERCASE(ParamName) OF
                'RUNMODE':
                    EVALUATE(RunMode, ParamValue);
            END;
        UNTIL ParamString = '';
    end;

    [Scope('Internal')]
    procedure CutNextParam(var ParamString: Text[1024]; var Name: Text[30]) RetValue: Text[30]
    var
        Currpos: Integer;
        ParamStringTmp: Text[30];
    begin
        Name := '';
        Currpos := STRPOS(ParamString, ';');
        IF Currpos > 0 THEN BEGIN
            Name := COPYSTR(ParamString, 1, Currpos - 1);
            ParamString := COPYSTR(ParamString, Currpos + 1, STRLEN(ParamString) - Currpos);
        END ELSE BEGIN
            Name := ParamString;
            ParamString := '';
        END;
        Currpos := STRPOS(Name, '=');
        IF Currpos > 0 THEN BEGIN
            ParamStringTmp := Name;
            Name := COPYSTR(ParamStringTmp, 1, Currpos - 1);
            RetValue := COPYSTR(ParamStringTmp, Currpos + 1, STRLEN(ParamStringTmp) - Currpos);
        END ELSE BEGIN
            RetValue := '';
        END;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure CalcPlanExpectedDate()
    var
        CalcExpectedServiceDates: Report "25006133";
    begin
        REPORT.RUN(REPORT::"Calc. Expected Service Dates", FALSE, FALSE);
    end;

    [Scope('Internal')]
    procedure CreateOrdersByPlan()
    var
        VehicleContact: Record "25006013";
        ContactBusinessRelation: Record "5054";
        ServiceMgtSetup: Record "25006120";
        ServiceHeader: Record "25006145";
        ServiceHeaderTmp: Record "25006145" temporary;
        VehicleServicePlanStage: Record "25006132";
        ServicePackage: Record "25006134";
        ServicePackageVersion: Record "25006135";
        CustomerToCurrent: Record "18";
        ServicePlanMgt: Codeunit "25006103";
        OrderDate: Date;
        DefContRelationshipCode: Code[10];
    begin
        ServiceHeaderTmp.DELETEALL;
        ServiceMgtSetup.GET;
        VehicleContact.SETRANGE("Relationship Code", ServiceMgtSetup."Serv. Plan Cont. Relationship");
        VehicleServicePlanStage.SETCURRENTKEY(Status, "Expected Service Date");
        VehicleServicePlanStage.SETRANGE(Status, VehicleServicePlanStage.Status::Pending);
        VehicleServicePlanStage.SETRANGE("Expected Service Date", TODAY);
        REPEAT
            IF ServicePackage.GET(VehicleServicePlanStage."Package No.") THEN BEGIN
                ServicePackageVersion.SETRANGE("Package No.", ServicePackage."No.");
                IF ServicePackageVersion.FINDFIRST THEN BEGIN
                    VehicleContact.SETRANGE("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                    IF VehicleContact.FINDFIRST THEN BEGIN
                        ContactBusinessRelation.SETRANGE("Contact No.", VehicleContact."Contact No.");
                        IF ContactBusinessRelation.FINDFIRST THEN
                            IF CustomerToCurrent.GET(ContactBusinessRelation."No.") THEN BEGIN
                                CLEAR(ServicePlanMgt);
                                ServicePlanMgt.SetVehicleServicePlanStage(VehicleServicePlanStage);
                                ServicePlanMgt.SetSPVersion(ServicePackageVersion);

                                ServicePlanMgt.SetCustomer(CustomerToCurrent);
                                ServiceHeader.RESET;
                                ServiceHeaderTmp.RESET;
                                ServiceHeaderTmp.SETRANGE("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                                IF ServiceHeaderTmp.FINDFIRST THEN BEGIN
                                    ServiceHeader.GET(ServiceHeaderTmp."Document Type", ServiceHeaderTmp."No.");
                                END ELSE BEGIN
                                    ServiceHeader.INIT;
                                END;
                                ServicePlanMgt.CreateServOrderForVehBy(ServiceHeader, 41, '');
                                ServiceHeaderTmp.TRANSFERFIELDS(ServiceHeader);
                                ServiceHeaderTmp.INSERT;
                            END;
                    END;
                END;
            END;
        UNTIL VehicleServicePlanStage.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateOrdersBySLEntry()
    var
        Vehicle: Record "25006005";
        VehicleContact: Record "25006013";
        ContactBusinessRelation: Record "5054";
        ServiceMgtSetup: Record "25006120";
        MarketingSetup: Record "5079";
        ServiceHeader: Record "25006145";
        ServiceHeaderTmp: Record "25006145" temporary;
        VehicleServicePlanStage: Record "25006132";
        ServicePackage: Record "25006134";
        ServicePackageVersion: Record "25006135";
        CustomerToCurrent: Record "18";
        ServiceLedgerEntry: Record "25006167";
        ServicePlanMgt: Codeunit "25006103";
        OrderDate: Date;
        DefContRelationshipCode: Code[10];
        FilterStr: Text[30];
        IsFound: Boolean;
        RecExists: Boolean;
    begin
        OrderDate := TODAY;
        ServiceHeaderTmp.DELETEALL;

        ServiceMgtSetup.GET;
        MarketingSetup.GET;

        VehicleContact.RESET;
        VehicleContact.SETCURRENTKEY("Vehicle Serial No.", "Relationship Code", "Contact No.");
        VehicleContact.SETRANGE("Relationship Code", ServiceMgtSetup."Serv. Plan Cont. Relationship");

        ContactBusinessRelation.RESET;
        ContactBusinessRelation.SETRANGE("Business Relation Code", MarketingSetup."Bus. Rel. Code for Customers");

        Vehicle.RESET;
        Vehicle.FINDFIRST;
        REPEAT
            ServiceHeader.RESET;
            ServiceHeader.INIT;
            ServiceHeader."Vehicle Serial No." := Vehicle."Serial No.";
            ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Posting Date", "Entry Type");
            ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", Vehicle."Serial No.");
            FilterStr := STRSUBSTNO('%1|%2', ServiceLedgerEntry."Entry Type"::Usage, ServiceLedgerEntry."Entry Type"::Info);
            ServiceLedgerEntry.SETFILTER("Entry Type", FilterStr);
            IF ServiceLedgerEntry.FINDLAST THEN BEGIN
                ServiceHeader."Order Date" := OrderDate;
                ServiceHeader.Kilometrage := ServiceLedgerEntry.Kilometrage;
                ServiceHeader."Variable Field Run 2" := ServiceLedgerEntry."Variable Field Run 2";
                ServiceHeader."Variable Field Run 3" := ServiceLedgerEntry."Variable Field Run 3";
                IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FIELDNO(Kilometrage),
                  VehicleServicePlanStage);
                IF NOT IsFound THEN
                    IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FIELDNO("Variable Field Run 2"),
                      VehicleServicePlanStage);
                IF NOT IsFound THEN
                    IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FIELDNO("Variable Field Run 3"),
                      VehicleServicePlanStage);
                IF NOT IsFound THEN
                    IsFound := ServiceHeader.IsAchievedServStageByInterval(VehicleServicePlanStage);
                IF IsFound THEN BEGIN
                    VehicleServicePlanStage.FINDFIRST;
                    REPEAT
                        ServicePackageVersion.SETRANGE("Package No.", VehicleServicePlanStage."Package No.");
                        IF ServicePackageVersion.FINDFIRST THEN;
                        VehicleContact.SETRANGE("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                        IF VehicleContact.FINDFIRST THEN BEGIN
                            ContactBusinessRelation.SETRANGE("Contact No.", VehicleContact."Contact No.");
                            IF ContactBusinessRelation.FINDFIRST THEN
                                IF CustomerToCurrent.GET(ContactBusinessRelation."No.") THEN BEGIN
                                    ServicePlanMgt.SetVehicleServicePlanStage(VehicleServicePlanStage);
                                    ServicePlanMgt.SetSPVersion(ServicePackageVersion);

                                    ServicePlanMgt.SetCustomer(CustomerToCurrent);
                                    ServiceHeader.RESET;
                                    ServiceHeaderTmp.RESET;
                                    ServiceHeaderTmp.SETRANGE("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                                    IF ServiceHeaderTmp.FINDFIRST THEN BEGIN
                                        ServiceHeader.GET(ServiceHeaderTmp."Document Type", ServiceHeaderTmp."No.");
                                        RecExists := TRUE;
                                    END ELSE BEGIN
                                        RecExists := FALSE;
                                        ServiceHeader.INIT;
                                        ServiceHeader."No." := '';
                                        ServiceHeader."Order Date" := TODAY;
                                        ServiceHeader.Kilometrage := ServiceLedgerEntry.Kilometrage;
                                        ServiceHeader."Variable Field Run 2" := ServiceLedgerEntry."Variable Field Run 2";
                                        ServiceHeader."Variable Field Run 3" := ServiceLedgerEntry."Variable Field Run 3";
                                    END;
                                    IF ServicePackageVersion.FINDFIRST THEN
                                        ServicePlanMgt.CreateServOrderForVehBy(ServiceHeader, 41, '')
                                    ELSE
                                        ServicePlanMgt.CreateServOrderForVehBy(ServiceHeader, 9, '');
                                    IF NOT RecExists THEN BEGIN
                                        ServiceHeaderTmp.INIT;
                                        ServiceHeaderTmp.TRANSFERFIELDS(ServiceHeader);
                                        ServiceHeaderTmp.INSERT;
                                    END;
                                END;
                        END;
                    UNTIL VehicleServicePlanStage.NEXT = 0;
                END;
            END;
        UNTIL Vehicle.NEXT = 0;
    end;
}

